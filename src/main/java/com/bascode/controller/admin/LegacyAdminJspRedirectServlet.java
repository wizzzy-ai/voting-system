package com.bascode.controller.admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Backwards-compatible redirects for old /admin/*.jsp URLs.
 */
@WebServlet(urlPatterns = {
        "/admin/dashboard.jsp",
        "/admin/contesters.jsp",
        "/admin/users.jsp",
        "/admin/results.jsp",
        "/admin/audit.jsp"
})
public class LegacyAdminJspRedirectServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String uri = request.getRequestURI();
        String ctx = request.getContextPath();

        String target;
        if (uri.endsWith("/admin/dashboard.jsp")) target = "/admin/dashboard";
        else if (uri.endsWith("/admin/contesters.jsp")) target = "/admin/contesters";
        else if (uri.endsWith("/admin/users.jsp")) target = "/admin/users";
        else if (uri.endsWith("/admin/results.jsp")) target = "/admin/results";
        else if (uri.endsWith("/admin/audit.jsp")) target = "/admin/audit";
        else target = "/admin/dashboard";

        response.sendRedirect(ctx + target);
    }
}

