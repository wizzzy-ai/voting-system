package com.bascode.controller;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Properties;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            String msg = "EMF not available (likely DB initialization failed).";
            getServletContext().setAttribute("lastForgotError", msg);
            System.err.println(msg);
            request.setAttribute("error", "Service temporarily unavailable. Please try again later.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        EntityManager em = null;
        try {
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email is required.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            em = emf.createEntityManager();

            // Check if a user exists with that email using a native SQL count query
            Number cnt = (Number) em.createNativeQuery("SELECT COUNT(*) FROM users WHERE email = ?")
                    .setParameter(1, email)
                    .getSingleResult();
            long count = (cnt == null) ? 0L : cnt.longValue();

            if (count == 0L) {
                request.setAttribute("error", "No account found with that email.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            // Generate secure reset token
            SecureRandom random = new SecureRandom();
            byte[] tokenBytes = new byte[24];
            random.nextBytes(tokenBytes);
            String resetToken = Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);

            // Update the user's resetToken using native SQL — try common column name variants
            try {
                em.getTransaction().begin();
                int updated = 0;
                try {
                    updated = em.createNativeQuery("UPDATE users SET reset_token = ? WHERE email = ?")
                            .setParameter(1, resetToken)
                            .setParameter(2, email)
                            .executeUpdate();
                } catch (Exception ignore) {
                    // try alternative column name
                }
                if (updated == 0) {
                    updated = em.createNativeQuery("UPDATE users SET resetToken = ? WHERE email = ?")
                            .setParameter(1, resetToken)
                            .setParameter(2, email)
                            .executeUpdate();
                }
                em.getTransaction().commit();
                if (updated == 0) {
                    String msg = "Unable to set reset token for email=" + email;
                    getServletContext().setAttribute("lastForgotError", msg);
                    System.err.println(msg);
                    request.setAttribute("error", "Unable to set reset token. Please try again later.");
                    request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    return;
                }
            } catch (Exception txEx) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                getServletContext().setAttribute("lastForgotError", txEx.toString());
                txEx.printStackTrace();
                request.setAttribute("error", "Service temporarily unavailable. Please try again later.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            // Send reset email inline (avoids dependency on EmailUtil)
            try {
                String absoluteResetLink = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                        + request.getContextPath() + "/reset_password.jsp?token=" + resetToken;
                // Expose an absolute reset link for debugging so clicks use the same host/port the server used
                String contextResetPath = request.getContextPath() + "/reset_password.jsp?token=" + resetToken;
                request.setAttribute("debugResetLink", absoluteResetLink);
                sendPasswordResetEmail(email, absoluteResetLink);
            } catch (MessagingException e) {
                getServletContext().setAttribute("lastForgotError", e.toString());
                e.printStackTrace();
                request.setAttribute("error", "Failed to send reset email.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            request.setAttribute("success", "Password reset link sent. Please check your email.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);

        } catch (Exception e) {
            getServletContext().setAttribute("lastForgotError", e.toString());
            e.printStackTrace();
            request.setAttribute("error", "Service temporarily unavailable. Please try again later.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // Inline email sending to avoid referencing project EmailUtil which had unresolved compilation in the runtime environment
    private void sendPasswordResetEmail(String to, String resetLink) throws MessagingException {
        String host = "smtp.gmail.com";
        String from = "chisomwork17@email.com";
        final String username = "chisomwork17";
        final String password = "jyfsxbpbqkyfofhi";

        String subject = "Password Reset Request";
        String content = "We received a request to reset your password.\n\n"
                + "Use the link below to set a new password:\n"
                + resetLink + "\n\n"
                + "If you didn't request this, you can ignore this email.";

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(content);

        Transport.send(message);
    }
}