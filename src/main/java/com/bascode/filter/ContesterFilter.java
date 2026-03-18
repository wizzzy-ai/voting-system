package com.bascode.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/contester/*"})
public class ContesterFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userRole") == null || !"CONTESTER".equals(session.getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        chain.doFilter(request, response);
    }
}

