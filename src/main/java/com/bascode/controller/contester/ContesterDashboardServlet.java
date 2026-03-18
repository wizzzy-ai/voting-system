package com.bascode.controller.contester;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.ElectionSettings;
import com.bascode.model.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/contester/dashboard")
public class ContesterDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            HttpSession session = request.getSession(false);
            User user = requireUser(session, em);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            Contester contester = em.createQuery(
                            "SELECT c FROM Contester c JOIN FETCH c.user u WHERE u.id = :userId",
                            Contester.class
                    )
                    .setParameter("userId", user.getId())
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            long voteCount = 0L;
            if (contester != null && contester.getId() != null) {
                voteCount = em.createQuery(
                                "SELECT COUNT(v) FROM Vote v WHERE v.contester.id = :contesterId",
                                Long.class
                        )
                        .setParameter("contesterId", contester.getId())
                        .getSingleResult();
            }

            long selfVoted = em.createQuery(
                            "SELECT COUNT(v) FROM Vote v WHERE v.voter.id = :uid",
                            Long.class
                    )
                    .setParameter("uid", user.getId())
                    .getSingleResult();

            VotingStatus vs = resolveVotingStatus(em);

            request.setAttribute("user", user);
            request.setAttribute("contester", contester);
            request.setAttribute("voteCount", voteCount);
            request.setAttribute("hasVoted", selfVoted > 0);
            request.setAttribute("votingOpen", vs.open);
            request.setAttribute("votingClosedReason", vs.reason);
            request.getRequestDispatcher("/WEB-INF/contester/contester.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }

    private static User requireUser(HttpSession session, EntityManager em) {
        if (session == null) return null;
        Object idObj = session.getAttribute("userId");
        if (idObj == null) return null;
        Long id = toLong(idObj);
        if (id == null) return null;
        return em.find(User.class, id);
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

    private static class VotingStatus {
        final boolean open;
        final String reason;
        VotingStatus(boolean open, String reason) {
            this.open = open;
            this.reason = reason;
        }
    }

    private static VotingStatus resolveVotingStatus(EntityManager em) {
        ElectionSettings settings = em.createQuery(
                        "SELECT s FROM ElectionSettings s ORDER BY s.id ASC",
                        ElectionSettings.class
                )
                .setMaxResults(1)
                .getResultStream()
                .findFirst()
                .orElse(null);

        if (settings == null) {
            return new VotingStatus(true, null);
        }
        boolean closedByToggle = !settings.isVotingOpen();
        boolean closedByDeadline = settings.getVotingClosesAt() != null &&
                !LocalDateTime.now().isBefore(settings.getVotingClosesAt());
        if (closedByDeadline) {
            return new VotingStatus(false, "Voting deadline reached.");
        }
        if (closedByToggle) {
            return new VotingStatus(false, "Voting is currently closed by the admin.");
        }
        return new VotingStatus(true, null);
    }
}
