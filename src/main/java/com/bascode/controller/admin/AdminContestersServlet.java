package com.bascode.controller.admin;

import com.bascode.model.entity.Contester;
import com.bascode.model.enums.ContesterStatus;
import com.bascode.model.enums.Position;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/contesters")
public class AdminContestersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String statusParam = trimToNull(request.getParameter("status"));
        String positionParam = trimToNull(request.getParameter("position"));

        ContesterStatus status = null;
        if (statusParam != null) {
            try {
                status = ContesterStatus.valueOf(statusParam.toUpperCase());
            } catch (IllegalArgumentException ignored) {
                // ignore invalid filters
            }
        }

        Position position = null;
        if (positionParam != null) {
            try {
                position = Position.valueOf(positionParam.toUpperCase());
            } catch (IllegalArgumentException ignored) {
                // ignore invalid filters
            }
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            StringBuilder jpql = new StringBuilder(
                    "SELECT c FROM Contester c " +
                    "JOIN FETCH c.user u " +
                    "WHERE 1=1"
            );
            Map<String, Object> params = new HashMap<>();

            if (status != null) {
                jpql.append(" AND c.status = :status");
                params.put("status", status);
            }
            if (position != null) {
                jpql.append(" AND c.position = :position");
                params.put("position", position);
            }

            jpql.append(" ORDER BY c.status ASC, c.position ASC, u.lastName ASC, u.firstName ASC");

            var q = em.createQuery(jpql.toString(), Contester.class);
            for (var e : params.entrySet()) {
                q.setParameter(e.getKey(), e.getValue());
            }

            List<Contester> contesters = q.getResultList();

            request.setAttribute("contesters", contesters);
            request.setAttribute("selectedStatus", statusParam);
            request.setAttribute("selectedPosition", positionParam);
            request.getRequestDispatcher("/WEB-INF/admin/contesters.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}
