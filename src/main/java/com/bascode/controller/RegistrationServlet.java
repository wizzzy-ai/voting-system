package com.bascode.controller;

import com.bascode.model.entity.User;
import com.bascode.model.enums.Role;
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
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("VotingPU");
    }

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

            // Input validation
            if (firstName == null || lastName == null || email == null || password == null || confirmPassword == null || birthYearStr == null || state == null || country == null || roleStr == null) {
                request.setAttribute("error", "All fields are required.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            int birthYear;
            try {
            		LocalDate birthDate = LocalDate.parse(birthYearStr);
            		birthYear = birthDate.getYear();          
            } catch (DateTimeParseException e) {
                request.setAttribute("error", "Invalid birth date.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            em = emf.createEntityManager();
            // Check for duplicate email
            long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                .setParameter("email", email)
                .getSingleResult();
            if (count > 0) {
                request.setAttribute("error", "Email already registered.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
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
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            if (role == Role.CONTESTER) {
                request.setAttribute("error", "Contestant accounts are created by an admin.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            if (role == Role.ADMIN) {
                long adminCount = em.createQuery(
                    "SELECT COUNT(u) FROM User u WHERE u.role = :role", Long.class)
                    .setParameter("role", Role.ADMIN)
                    .getSingleResult();
                if (adminCount > 0) {
                    request.setAttribute("error", "Admin self-registration is disabled after initial setup.");
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                    return;
                }
            }
            user.setRole(role);

            
            user.setEmailVerified(false);
            user.setVerificationCode(otp); // Store OTP

            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();

            // Send OTP email
            try {
                EmailUtil.sendVerificationEmail(email, otp);
            } catch (MessagingException e) {
                request.setAttribute("error", "Registration succeeded, but failed to send OTP email.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
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

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
}
