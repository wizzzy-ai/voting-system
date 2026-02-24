package com.bascode.controller;

import com.bascode.model.entity.User;
import com.bascode.model.entity.Contester;
import com.bascode.model.enums.Role;
import com.bascode.model.enums.Position;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.util.EmailUtil;
import jakarta.mail.MessagingException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("VotingPU");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String birthYearStr = request.getParameter("birthYear");
        String state = request.getParameter("state");
        String country = request.getParameter("country");
        String roleStr = request.getParameter("role");
        String positionStr = request.getParameter("position");

        // Input validation
        if (firstName == null || lastName == null || email == null || password == null || confirmPassword == null || birthYearStr == null || state == null || country == null || roleStr == null) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        int birthYear;
        try {
            birthYear = Integer.parseInt(birthYearStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid birth year.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        EntityManager em = emf.createEntityManager();
        try {
            // Check for duplicate email
            long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                .setParameter("email", email)
                .getSingleResult();
            if (count > 0) {
                request.setAttribute("error", "Email already registered.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Hash password
            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

            // Generate 6-digit numeric OTP
            String otp = String.format("%06d", new java.util.Random().nextInt(1000000));

            // Create User entity
            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPasswordHash(passwordHash);
            user.setBirthYear(birthYear);
            user.setState(state);
            user.setCountry(country);
            user.setRole(Role.valueOf(roleStr));
            user.setEmailVerified(false);
            user.setVerificationCode(otp); // Store OTP

            em.getTransaction().begin();
            em.persist(user);

            // If Contester, create Contester entity
            if (roleStr.equals("CONTESTER") && positionStr != null && !positionStr.isEmpty()) {
                // Check max 3 contesters per position
                long contesterCount = em.createQuery("SELECT COUNT(c) FROM Contester c WHERE c.position = :position AND c.status = :status", Long.class)
                    .setParameter("position", Position.valueOf(positionStr))
                    .setParameter("status", ContesterStatus.APPROVED)
                    .getSingleResult();
                if (contesterCount >= 3) {
                    em.getTransaction().rollback();
                    request.setAttribute("error", "Maximum contesters for this position reached.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
                Contester contester = new Contester();
                contester.setUser(user);
                contester.setPosition(Position.valueOf(positionStr));
                contester.setStatus(ContesterStatus.PENDING);
                em.persist(contester);
            }
            em.getTransaction().commit();

            // Send OTP email
            try {
                EmailUtil.sendVerificationEmail(email, otp);
            } catch (MessagingException e) {
                request.setAttribute("error", "Registration succeeded, but failed to send OTP email.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            // Redirect to OTP verification page with email as parameter
            response.sendRedirect("verify-otp.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
        } finally {
            em.close();
        }
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
}