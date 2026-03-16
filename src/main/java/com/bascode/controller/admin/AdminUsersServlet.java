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
            StringBuilder jpql = new StringBuilder("SELECT u FROM User u WHERE 1=1");
            Map<String, Object> params = new HashMap<>();

            if (role != null) {
                jpql.append(" AND u.role = :role");
                params.put("role", role);
            }
            if (verified != null) {
                jpql.append(" AND u.emailVerified = :verified");
                params.put("verified", verified);
            }

            jpql.append(" ORDER BY u.role ASC, u.lastName ASC, u.firstName ASC");

            var q = em.createQuery(jpql.toString(), User.class);
            for (var e : params.entrySet()) q.setParameter(e.getKey(), e.getValue());

            List<User> users = q.getResultList();

            request.setAttribute("users", users);
            request.setAttribute("selectedRole", roleParam == null ? "" : roleParam);
            request.setAttribute("selectedVerified", verifiedParam == null ? "" : verifiedParam);
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

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}
