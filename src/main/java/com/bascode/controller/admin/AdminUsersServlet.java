package com.bascode.controller.admin;

import com.bascode.model.entity.User;
import com.bascode.model.enums.Role;
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

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roleParam = trimToNull(request.getParameter("role"));
        String verifiedParam = trimToNull(request.getParameter("verified")); // true|false
        String search = trimToNull(request.getParameter("q"));
        int page = parsePositiveInt(request.getParameter("page"), 1);
        int pageSize = 12;

        Role role = null;
        if (roleParam != null) {
            try {
                role = Role.valueOf(roleParam.toUpperCase());
            } catch (IllegalArgumentException ignored) {
                // ignore invalid filter
            }
        }
        Boolean verified = null;
        if (verifiedParam != null) {
            if ("true".equalsIgnoreCase(verifiedParam)) verified = Boolean.TRUE;
            else if ("false".equalsIgnoreCase(verifiedParam)) verified = Boolean.FALSE;
        }

        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            StringBuilder from = new StringBuilder(" FROM User u WHERE 1=1");
            Map<String, Object> params = new HashMap<>();

            if (role != null) {
                from.append(" AND u.role = :role");
                params.put("role", role);
            }
            if (verified != null) {
                from.append(" AND u.emailVerified = :verified");
                params.put("verified", verified);
            }
            if (search != null) {
                from.append(" AND (LOWER(u.firstName) LIKE :q OR LOWER(u.lastName) LIKE :q OR LOWER(u.email) LIKE :q)");
                params.put("q", "%" + search.toLowerCase() + "%");
            }

            var countQuery = em.createQuery("SELECT COUNT(u)" + from, Long.class);
            for (var e : params.entrySet()) {
                countQuery.setParameter(e.getKey(), e.getValue());
            }
            long totalCount = countQuery.getSingleResult();
            int totalPages = (int) Math.max(1, Math.ceil(totalCount / (double) pageSize));
            if (page > totalPages) page = totalPages;

            String jpql = "SELECT u" + from + " ORDER BY u.role ASC, u.lastName ASC, u.firstName ASC";
            var q = em.createQuery(jpql, User.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize);
            for (var e : params.entrySet()) q.setParameter(e.getKey(), e.getValue());

            List<User> users = q.getResultList();

            request.setAttribute("users", users);
            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("selectedRole", roleParam == null ? "" : roleParam);
            request.setAttribute("selectedVerified", verifiedParam == null ? "" : verifiedParam);
            request.setAttribute("searchQuery", search == null ? "" : search);
            request.getRequestDispatcher("/WEB-INF/admin/users.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private static int parsePositiveInt(String s, int fallback) {
        if (s == null) return fallback;
        try {
            int value = Integer.parseInt(s.trim());
            return value > 0 ? value : fallback;
        } catch (Exception ignored) {
            return fallback;
        }
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}
