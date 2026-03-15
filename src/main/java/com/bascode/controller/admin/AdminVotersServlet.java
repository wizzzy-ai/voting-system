package com.bascode.controller.admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Alias endpoint in case the UI/spec refers to a separate "voters" page.
 * We currently implement this via the users list filtered to role=VOTER.
 */
@WebServlet("/admin/voters")
public class AdminVotersServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/users?role=VOTER");
    }
}

