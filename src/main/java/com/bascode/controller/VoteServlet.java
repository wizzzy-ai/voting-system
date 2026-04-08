package com.bascode.controller;

import com.bascode.model.entity.Contester;
import com.bascode.model.entity.PositionElection;
import com.bascode.model.entity.User;
import com.bascode.model.entity.Vote;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Position;
import com.bascode.util.AgeUtil;
import com.bascode.util.ContesterAccessUtil;
import com.bascode.util.ElectionAutoEndUtil;
import com.bascode.util.PositionElectionUtil;
import org.hibernate.exception.ConstraintViolationException;
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
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet("/submit-vote")
public class VoteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            // Auto-end any elections that have reached their scheduled end time
            ElectionAutoEndUtil.autoEndExpiredElections(em);

            User user = resolveUser(session, em);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            if (AgeUtil.isUnderage(user)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?type=error&msg=Underage+users+cannot+vote.");
                return;
            }

            // Determine position for voting status check
            Position targetPosition = null;
            if (ContesterAccessUtil.hasContesterProfile(em, user.getId())) {
                Contester self = ContesterAccessUtil.findContester(em, user.getId());
                if (self != null && self.getPosition() != null) {
                    targetPosition = self.getPosition();
                }
            }
            
            VotingStatus vs = resolveVotingStatus(em, targetPosition);
            if (!vs.open) {
                String reason = vs.reason != null ? vs.reason : "Voting is closed.";
                request.setAttribute("votingClosed", true);
                request.setAttribute("votingClosedReason", reason);
                request.setAttribute("candidates", java.util.Collections.emptyList());
                request.getRequestDispatcher("/WEB-INF/views/vote.jsp").forward(request, response);
                return;
            }

            // Get candidate first to check position
            String candidateIdStr = request.getParameter("candidateId");
            if (candidateIdStr == null || candidateIdStr.isEmpty()) {
                forwardToVote(request, response, em, user, "Please select a candidate.");
                return;
            }
            Long candidateId;
            try {
                candidateId = Long.valueOf(candidateIdStr);
            } catch (Exception e) {
                forwardToVote(request, response, em, user, "Invalid candidate selected.");
                return;
            }
            
            Contester candidate = em.find(Contester.class, candidateId);
            if (candidate == null || candidate.getStatus() != ContesterStatus.APPROVED) {
                forwardToVote(request, response, em, user, "Candidate not found or not approved.");
                return;
            }
            
            // Get contester info if user is a contester
            Contester userContester = null;
            Position userPosition = null;
            if (ContesterAccessUtil.hasContesterProfile(em, user.getId())) {
                userContester = ContesterAccessUtil.findContester(em, user.getId());
                if (userContester != null) {
                    userPosition = userContester.getPosition();
                }
            }
            
            // Check if contester is trying to vote for someone else in their own position
            // They can only vote for themselves in their own position
            if (userPosition != null && userPosition == candidate.getPosition()) {
                // Check if the candidate is themselves
                if (userContester == null || !userContester.getId().equals(candidate.getId())) {
                    forwardToVote(request, response, em, user, "As a contester, you can only vote for yourself in your own position.");
                    return;
                }
                // If it's themselves, allow the vote to proceed
            }
            
            // Check voting status for the candidate's specific position
            PositionElection pe = PositionElectionUtil.getOrCreate(em, candidate.getPosition());
            VotingStatus posStatus = resolveVotingStatusForPosition(pe);
            if (!posStatus.open) {
                forwardToVote(request, response, em, user, posStatus.reason != null ? posStatus.reason : "Voting is closed for this position.");
                return;
            }
            
            // Check if user already voted for this position
            long count = em.createQuery("SELECT COUNT(v) FROM Vote v WHERE v.voter.id = :voterId AND v.position = :position", Long.class)
                .setParameter("voterId", user.getId())
                .setParameter("position", candidate.getPosition())
                .getSingleResult();
            if (count > 0) {
                forwardToVote(request, response, em, user, "You have already voted for this position.");
                return;
            }

            Vote vote = new Vote();
            vote.setVoter(user);
            vote.setContester(candidate);
            vote.setPosition(candidate.getPosition());
            em.getTransaction().begin();
            em.persist(vote);
            em.getTransaction().commit();
            request.setAttribute("success", "Your vote for " + candidate.getPosition().name().replace("_", " ") + " has been cast successfully!");
            request.getRequestDispatcher("/WEB-INF/views/submit-vote.jsp").forward(request, response);
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            ex.printStackTrace();
            String errorMessage = "A system error occurred. Please try again.";
            if (isDuplicateVoteConstraint(ex)) {
                errorMessage = "You have already voted for this position.";
            }
            forwardToVote(request, response, em, resolveUser(session, em), errorMessage);
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

    private static class VotingStatus {
        final boolean open;
        final String reason;
        VotingStatus(boolean open, String reason) {
            this.open = open;
            this.reason = reason;
        }
    }

    private static VotingStatus resolveVotingStatusForPosition(PositionElection pe) {
        if (pe == null) {
            return new VotingStatus(false, "Election not configured.");
        }
        if (pe.getStatus() == com.bascode.model.enums.ElectionStatus.ENDED) {
            return new VotingStatus(false, "Election has ended.");
        }
        if (pe.getStatus() == com.bascode.model.enums.ElectionStatus.NOT_STARTED) {
            return new VotingStatus(false, "Election has not started yet.");
        }
        if (!pe.isVotingOpen()) {
            return new VotingStatus(false, "Voting is currently closed.");
        }
        if (pe.getEndTime() != null && !LocalDateTime.now().isBefore(pe.getEndTime())) {
            return new VotingStatus(false, "Voting deadline reached.");
        }
        return new VotingStatus(true, null);
    }

    private static VotingStatus resolveVotingStatus(EntityManager em, Position position) {
        // If no specific position (regular voter), check if any elections are active
        if (position == null) {
            java.util.List<PositionElection> activeElections = em.createQuery(
                            "SELECT pe FROM PositionElection pe WHERE pe.status = :activeStatus",
                            PositionElection.class)
                    .setParameter("activeStatus", com.bascode.model.enums.ElectionStatus.ACTIVE)
                    .getResultList();
            
            if (activeElections.isEmpty()) {
                return new VotingStatus(false, "No active elections found.");
            }
            
            // Check if any active election is open for voting
            for (PositionElection pe : activeElections) {
                if (pe.isVotingOpen()) {
                    if (pe.getEndTime() == null || LocalDateTime.now().isBefore(pe.getEndTime())) {
                        return new VotingStatus(true, null);
                    }
                }
            }
            return new VotingStatus(false, "Voting deadline reached.");
        }
        
        // For contesters, check their specific position
        PositionElection pe = PositionElectionUtil.getOrCreate(em, position);
        if (pe.getStatus() == com.bascode.model.enums.ElectionStatus.ENDED) {
            return new VotingStatus(false, "Election has ended.");
        }
        if (pe.getStatus() == com.bascode.model.enums.ElectionStatus.NOT_STARTED) {
            return new VotingStatus(false, "Election has not started yet.");
        }
        if (!pe.isVotingOpen()) {
            return new VotingStatus(false, "Voting is currently closed.");
        }
        if (pe.getEndTime() != null && !LocalDateTime.now().isBefore(pe.getEndTime())) {
            return new VotingStatus(false, "Voting deadline reached.");
        }
        return new VotingStatus(true, null);
    }

    private static User resolveUser(HttpSession session, EntityManager em) {
        if (session == null) {
            return null;
        }

        Object idObj = session.getAttribute("userId");
        Long userId = null;
        if (idObj instanceof Long) userId = (Long) idObj;
        else if (idObj instanceof Integer) userId = ((Integer) idObj).longValue();
        else if (idObj instanceof String) {
            try {
                userId = Long.valueOf((String) idObj);
            } catch (Exception ignored) {
                // ignore
            }
        }
        if (userId == null) return null;

        return em.find(User.class, userId);
    }

    private static boolean isDuplicateVoteConstraint(Throwable ex) {
        Throwable current = ex;
        while (current != null) {
            if (current instanceof ConstraintViolationException) {
                return true;
            }
            if (current instanceof java.sql.SQLIntegrityConstraintViolationException) {
                return true;
            }
            String message = current.getMessage();
            if (message != null && message.contains("Duplicate entry")) {
                return true;
            }
            current = current.getCause();
        }
        return false;
    }

    private static void forwardToVote(HttpServletRequest request, HttpServletResponse response, EntityManager em, User user, String errorMsg)
            throws ServletException, IOException {
        request.setAttribute("error", errorMsg);

        // Get contester info if user is a contester
        Contester userContester = null;
        Position userPosition = null;
        if (user != null && ContesterAccessUtil.hasContesterProfile(em, user.getId())) {
            userContester = ContesterAccessUtil.findContester(em, user.getId());
            if (userContester != null) {
                userPosition = userContester.getPosition();
            }
        }
        
        // Build candidates by position map (same as VotePageServlet)
        Map<Position, List<Contester>> candidatesByPosition = new LinkedHashMap<>();
        Map<Position, PositionElection> electionsByPosition = new LinkedHashMap<>();
        
        List<PositionElection> allElections = PositionElectionUtil.ensureAll(em);
        
        for (PositionElection pe : allElections) {
            Position pos = pe.getName();
            if (pos == null) continue;
            
            electionsByPosition.put(pos, pe);
            
            // For user's own position, only include themselves as a candidate (self-vote)
            if (pos == userPosition) {
                if (userContester != null && userContester.getStatus() == ContesterStatus.APPROVED) {
                    candidatesByPosition.put(pos, java.util.Collections.singletonList(userContester));
                } else {
                    candidatesByPosition.put(pos, java.util.Collections.emptyList());
                }
                continue;
            }
            
            // Only show candidates if voting is open
            boolean isActive = pe.getStatus() == com.bascode.model.enums.ElectionStatus.ACTIVE;
            boolean isVotingOpen = pe.isVotingOpen();
            boolean deadlineOk = pe.getEndTime() == null || LocalDateTime.now().isBefore(pe.getEndTime());
            
            if (isActive && isVotingOpen && deadlineOk) {
                List<Contester> candidates = em.createQuery(
                                "SELECT c FROM Contester c JOIN FETCH c.user u " +
                                        "WHERE c.status = :s AND c.position = :p " +
                                        "ORDER BY u.lastName ASC, u.firstName ASC",
                                Contester.class
                        )
                        .setParameter("s", ContesterStatus.APPROVED)
                        .setParameter("p", pos)
                        .getResultList();
                candidatesByPosition.put(pos, candidates);
            } else {
                candidatesByPosition.put(pos, java.util.Collections.emptyList());
            }
        }
        
        // Get positions user has already voted for
        Set<Position> votedPositionsSet = new HashSet<>();
        if (user != null) {
            @SuppressWarnings("unchecked")
            List<Position> votedPositions = em.createQuery("SELECT v.position FROM Vote v WHERE v.voter.id = :voterId", Position.class)
                    .setParameter("voterId", user.getId())
                    .getResultList();
            votedPositionsSet.addAll(votedPositions);
        }
        
        request.setAttribute("votedPositions", votedPositionsSet);
        request.setAttribute("userPosition", userPosition);
        request.setAttribute("isContester", userContester != null);
        request.setAttribute("candidatesByPosition", candidatesByPosition);
        request.setAttribute("electionsByPosition", electionsByPosition);

        request.getRequestDispatcher("/WEB-INF/views/vote.jsp").forward(request, response);
    }
}
