package com.bascode.controller;

import com.bascode.model.entity.User;
import com.bascode.util.ContesterAccessUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            Long userId = toLong(session.getAttribute("userId"));
            User user = userId != null ? em.find(User.class, userId) : null;
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            if (user.getRole() != null && "ADMIN".equalsIgnoreCase(user.getRole().name())) {
                response.sendRedirect(request.getContextPath() + "/admin/contesters");
                return;
            }
            if (ContesterAccessUtil.hasContesterProfile(em, userId)) {
                response.sendRedirect(request.getContextPath() + "/contester/dashboard");
                return;
            }

            long votedCount = em.createQuery(
                            "SELECT COUNT(v) FROM Vote v WHERE v.voter.id = :uid",
                            Long.class
                    )
                    .setParameter("uid", userId)
                    .getSingleResult();
            boolean hasVoted = votedCount > 0;
            request.setAttribute("user", user);
            request.setAttribute("hasVoted", hasVoted);
            request.getRequestDispatcher("/WEB-INF/views/dashboard-voter.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    private static Long toLong(Object v) {
        if (v instanceof Long) return (Long) v;
        if (v instanceof Integer) return ((Integer) v).longValue();
        if (v instanceof String) {
            try {
                return Long.valueOf((String) v);
            } catch (Exception ignored) {
                return null;
            }
        }
        return null;
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}

