package com.bascode.controller.admin;

import com.bascode.model.entity.PositionElection;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.ElectionStatus;
import com.bascode.model.enums.Position;
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
import java.time.LocalDateTime;

@WebServlet("/admin/start-election")
public class AdminStartElectionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request.getSession(false))) {
            request.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(request, response);
            return;
        }

        Position pos;
        try {
            pos = Position.valueOf(request.getParameter("position"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Invalid%20position&type=error");
            return;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            long approvedCount = em.createQuery(
                            "SELECT COUNT(c) FROM Contester c WHERE c.position = :p AND c.status = :s",
                            Long.class
                    )
                    .setParameter("p", pos)
                    .setParameter("s", ContesterStatus.APPROVED)
                    .getSingleResult();
            if (approvedCount < 2) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Need%20at%20least%202%20approved%20contesters&type=error");
                return;
            }

            PositionElection pe = PositionElectionUtil.getOrCreate(em, pos);
            if (pe.getStatus() == ElectionStatus.ACTIVE) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Election%20already%20active&type=error");
                return;
            }
            if (pe.getStatus() == ElectionStatus.ENDED) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Election%20already%20ended&type=error");
                return;
            }

            em.getTransaction().begin();
            pe.setStatus(ElectionStatus.ACTIVE);
            pe.setVotingOpen(true);
            pe.setStartTime(LocalDateTime.now());
            pe.setEndTime(null);
            em.merge(pe);
            em.getTransaction().commit();

            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Election%20started%20successfully&type=success");
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=Failed%20to%20start%20election&type=error");
        } finally {
            em.close();
        }
    }

    private static boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        Object role = session.getAttribute("userRole");
        return role != null && "ADMIN".equalsIgnoreCase(String.valueOf(role));
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}

