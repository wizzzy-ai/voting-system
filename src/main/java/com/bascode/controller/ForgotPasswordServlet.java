package com.bascode.controller;

import com.bascode.model.entity.User;
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

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("online-voting-system");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                .setParameter("email", email)
                .getResultStream()
                .findFirst()
                .orElse(null);
            if (user == null) {
                request.setAttribute("error", "No account found with that email.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
                return;
            }
            // Generate secure reset token
            SecureRandom random = new SecureRandom();
            byte[] tokenBytes = new byte[24];
            random.nextBytes(tokenBytes);
            String resetToken = Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
            em.getTransaction().begin();
            user.setResetToken(resetToken);
            em.getTransaction().commit();
            // Send reset email
            try {
                EmailUtil.sendVerificationEmail(email, resetToken); // Reuse email util, update content if needed
            } catch (MessagingException e) {
                request.setAttribute("error", "Failed to send reset email.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
                return;
            }
            request.setAttribute("success", "Password reset link sent. Please check your email.");
            request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
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
