package com.bascode.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/dashboard"})
public class VoterDashboardFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userRole") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        String role = String.valueOf(session.getAttribute("userRole"));
        if (!"VOTER".equals(role)) {
            if ("CONTESTER".equals(role)) {
                res.sendRedirect(req.getContextPath() + "/contester/dashboard");
            } else if ("ADMIN".equals(role)) {
                res.sendRedirect(req.getContextPath() + "/admin/contesters");
            } else {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
            }
            return;
        }
        chain.doFilter(request, response);
    }
}
