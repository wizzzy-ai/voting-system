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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Base64;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = null;
        try {
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
            
         // Password strength validation: must contain letters, numbers, and special characters
            String passwordPattern = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
            if (!password.matches(passwordPattern)) {
                request.setAttribute("error", "Password must be at least 8 characters long and include letters, numbers, and one special character.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            int birthYear;
            try {
            		LocalDate birthDate = LocalDate.parse(birthYearStr);
            		birthYear = birthDate.getYear();          
            } catch (DateTimeParseException e) {
                request.setAttribute("error", "Invalid birth date.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            EntityManagerFactory emf = getEmf();
            em = emf.createEntityManager();
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
         
            Role role;
            try {
                role = Role.valueOf(roleStr.toUpperCase()); 
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Invalid role selected.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            user.setRole(role);

            if (role == Role.CONTESTER) {
                if (positionStr == null || positionStr.trim().isEmpty()) {
                    request.setAttribute("error", "Please select a position to contest for.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
                try {
                    Position.valueOf(positionStr.toUpperCase());
                } catch (IllegalArgumentException e) {
                    request.setAttribute("error", "Invalid position selected.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
            }

            
            user.setEmailVerified(false);
            user.setVerificationCode(otp); // Store OTP

            em.getTransaction().begin();
            em.persist(user);

            // If Contester, create Contester entity (PENDING) or auto-decline if position is full.
            if (role == Role.CONTESTER) {
                Position position = Position.valueOf(positionStr.toUpperCase());

                long approvedCount = em.createQuery(
                                "SELECT COUNT(c) FROM Contester c WHERE c.position = :position AND c.status = :status",
                                Long.class
                        )
                        .setParameter("position", position)
                        .setParameter("status", ContesterStatus.APPROVED)
                        .getSingleResult();

                Contester contester = new Contester();
                contester.setUser(user);
                contester.setPosition(position);
                contester.setStatus(approvedCount >= 3 ? ContesterStatus.DENIED : ContesterStatus.PENDING);
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
        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            // Forward to OTP page with error and email
            request.setAttribute("error", "A system error occurred while processing your registration. Please try entering your OTP or contact support.");
            request.setAttribute("email", request.getParameter("email"));
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
        } finally {
            if (em != null) em.close();
        }
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}
