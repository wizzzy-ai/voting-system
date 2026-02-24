package com.bascode.controller;

import com.bascode.model.entity.User;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("VotingPU");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                .setParameter("email", email)
                .getResultStream()
                .findFirst()
                .orElse(null);
            if (user == null) {
                request.setAttribute("error", "Invalid credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            if (!user.isEmailVerified()) {
                request.setAttribute("error", "Email not verified. Please check your email for the OTP and verify your account.");
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }
            if (!BCrypt.checkpw(password, user.getPasswordHash())) {
                request.setAttribute("error", "Invalid credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole().name());
            session.setAttribute("userEmail", user.getEmail());
            response.sendRedirect("dashboard.jsp"); // Change to your dashboard page
        } catch (Exception ex) {
            ex.printStackTrace(); // Log the full stack trace to server logs
            request.setAttribute("error", "A system error occurred: " + ex.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
}