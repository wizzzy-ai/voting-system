package com.bascode.controller;

import com.bascode.model.entity.Contester;
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
            List<Contester> candidates;

            User user = userId != null ? em.find(User.class, userId) : null;
            if (user != null && user.getRole() == Role.CONTESTER) {
                // Contesters are only allowed to vote for themselves once.
                Contester self = em.createQuery(
                                "SELECT c FROM Contester c JOIN FETCH c.user u WHERE u.id = :uid AND c.status = :s",
                                Contester.class
                        )
                        .setParameter("uid", user.getId())
                        .setParameter("s", ContesterStatus.APPROVED)
                        .getResultStream()
                        .findFirst()
                        .orElse(null);
                candidates = self != null ? List.of(self) : Collections.emptyList();
                request.setAttribute("isContesterSelfVote", true);
            } else {
                candidates = em.createQuery(
                                "SELECT c FROM Contester c JOIN FETCH c.user u WHERE c.status = :s ORDER BY c.position ASC, u.lastName ASC, u.firstName ASC",
                                Contester.class
                        )
                        .setParameter("s", ContesterStatus.APPROVED)
                        .getResultList();
                request.setAttribute("isContesterSelfVote", false);
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
}
