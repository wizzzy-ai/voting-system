package com.bascode.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Backwards-compatible redirects for old direct-JSP URLs after moving views under WEB-INF.
 * Keeps bookmarks/old links working without exposing JSPs directly.
 */
@WebServlet(urlPatterns = {
        "/dashboard.jsp",
        "/vote.jsp",
        "/results.jsp",
        "/profile.jsp",
        "/candidates.jsp",
        "/submit-vote.jsp"
})
public class LegacyJspRedirectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String uri = request.getRequestURI();
        String ctx = request.getContextPath();

        String target;
        if (uri.endsWith("/dashboard.jsp")) target = "/dashboard";
        else if (uri.endsWith("/vote.jsp")) target = "/vote";
        else if (uri.endsWith("/results.jsp")) target = "/results";
        else if (uri.endsWith("/profile.jsp")) target = "/profile";
        else if (uri.endsWith("/candidates.jsp")) target = "/candidates";
        else if (uri.endsWith("/submit-vote.jsp")) target = "/dashboard";
        else target = "/";

        response.sendRedirect(ctx + target);
    }
}

