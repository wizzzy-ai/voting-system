package com.bascode.controller;

import com.bascode.model.entity.User;
import com.bascode.model.entity.Vote;
import com.bascode.model.entity.Contester;
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

@WebServlet("/submit-vote")
public class VoteServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("VotingPU");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        String candidateIdStr = request.getParameter("candidateId");
        if (candidateIdStr == null || candidateIdStr.isEmpty()) {
            request.setAttribute("error", "Please select a candidate.");
            request.getRequestDispatcher("vote.jsp").forward(request, response);
            return;
        }
        int candidateId;
        try {
            candidateId = Integer.parseInt(candidateIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid candidate selected.");
            request.getRequestDispatcher("vote.jsp").forward(request, response);
            return;
        }
        EntityManager em = emf.createEntityManager();
        try {
            // Check if user already voted
            long count = em.createQuery("SELECT COUNT(v) FROM Vote v WHERE v.voter.id = :voterId", Long.class)
                .setParameter("voterId", user.getId())
                .getSingleResult();
            if (count > 0) {
                request.setAttribute("error", "You have already voted.");
                request.getRequestDispatcher("vote.jsp").forward(request, response);
                return;
            }
            Contester candidate = em.find(Contester.class, candidateId);
            if (candidate == null) {
                request.setAttribute("error", "Candidate not found.");
                request.getRequestDispatcher("vote.jsp").forward(request, response);
                return;
            }
            Vote vote = new Vote();
            vote.setVoter(user);
            vote.setContester(candidate);
            em.getTransaction().begin();
            em.persist(vote);
            em.getTransaction().commit();
            request.setAttribute("success", "Your vote has been cast successfully!");
            request.getRequestDispatcher("submit-vote.jsp").forward(request, response);
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            request.setAttribute("error", "A system error occurred. Please try again.");
            request.getRequestDispatcher("vote.jsp").forward(request, response);
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