package com.bascode.controller.contester;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/contester/vote-self")
public class ContesterSelfVoteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect to main vote page - contesters now vote through the standard voting flow
        response.sendRedirect(request.getContextPath() + "/vote");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Also redirect GET requests to main vote page
        response.sendRedirect(request.getContextPath() + "/vote");
    }
}
