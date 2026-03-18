package com.bascode.controller;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.ElectionSettings;
import com.bascode.model.entity.User;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Role;
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
import java.util.Collections;
import java.util.List;

@WebServlet("/vote")
public class VotePageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Long userId = toLong(session != null ? session.getAttribute("userId") : null);

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            VotingStatus vs = resolveVotingStatus(em);
            request.setAttribute("votingClosed", !vs.open);
            request.setAttribute("votingClosedReason", vs.reason);

            if (!vs.open) {
                request.setAttribute("candidates", Collections.emptyList());
                request.getRequestDispatcher("/WEB-INF/views/vote.jsp").forward(request, response);
                return;
            }

            List<Contester> candidates;

            User user = userId != null ? em.find(User.class, userId) : null;
            if (user != null && user.getRole() == Role.CONTESTER) {
                Contester self = em.createQuery(
                                "SELECT c FROM Contester c JOIN FETCH c.user u WHERE u.id = :uid",
                                Contester.class
                        )
                        .setParameter("uid", user.getId())
                        .getResultStream()
                        .findFirst()
                        .orElse(null);
                if (self != null && self.getPosition() != null) {
                    candidates = em.createQuery(
                                    "SELECT c FROM Contester c JOIN FETCH c.user u " +
                                            "WHERE c.status = :s AND c.position = :p AND c.user.id <> :uid " +
                                            "ORDER BY u.lastName ASC, u.firstName ASC",
                                    Contester.class
                            )
                            .setParameter("s", ContesterStatus.APPROVED)
                            .setParameter("p", self.getPosition())
                            .setParameter("uid", user.getId())
                            .getResultList();
                } else {
                    candidates = Collections.emptyList();
                }
                request.setAttribute("contesterRestricted", true);
            } else {
                candidates = em.createQuery(
                                "SELECT c FROM Contester c JOIN FETCH c.user u WHERE c.status = :s ORDER BY c.position ASC, u.lastName ASC, u.firstName ASC",
                                Contester.class
                        )
                        .setParameter("s", ContesterStatus.APPROVED)
                        .getResultList();
                request.setAttribute("contesterRestricted", false);
            }

            request.setAttribute("candidates", candidates);
            request.getRequestDispatcher("/WEB-INF/views/vote.jsp").forward(request, response);
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
