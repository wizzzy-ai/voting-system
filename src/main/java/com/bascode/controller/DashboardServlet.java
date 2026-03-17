package com.bascode.controller;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.PositionElection;
import com.bascode.model.entity.User;
import com.bascode.model.enums.Role;
import com.bascode.util.PositionElectionUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String roleStr = String.valueOf(session.getAttribute("userRole"));
        if ("ADMIN".equalsIgnoreCase(roleStr)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
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

            long votedCount = em.createQuery(
                            "SELECT COUNT(v) FROM Vote v WHERE v.voter.id = :uid",
                            Long.class
                    )
                    .setParameter("uid", userId)
                    .getSingleResult();
            boolean hasVoted = votedCount > 0;
            request.setAttribute("user", user);
            request.setAttribute("hasVoted", hasVoted);

            if (user.getRole() == Role.CONTESTER) {
                List<Object[]> rows = em.createQuery(
                                "SELECT c, COUNT(v.id) " +
                                        "FROM Contester c " +
                                        "LEFT JOIN Vote v ON v.contester = c " +
                                        "WHERE c.user.id = :uid " +
                                        "GROUP BY c",
                                Object[].class
                        )
                        .setParameter("uid", userId)
                        .getResultList();
                Contester contester = rows.isEmpty() ? null : (Contester) rows.get(0)[0];
                Long contesterVotes = rows.isEmpty() ? 0L : (Long) rows.get(0)[1];

                PositionElection pe = null;
                if (contester != null && contester.getPosition() != null) {
                    pe = PositionElectionUtil.getOrCreate(em, contester.getPosition());
                }

                request.setAttribute("contester", contester);
                request.setAttribute("contesterVotes", contesterVotes != null ? contesterVotes : 0L);
                request.setAttribute("positionElection", pe);

                request.getRequestDispatcher("/WEB-INF/views/dashboard-contester.jsp").forward(request, response);
                return;
            }

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

