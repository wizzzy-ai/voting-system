package com.bascode.util;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;

@WebServlet("/dev-files")
public class DevFilesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.println("<html><head><title>Dev Files</title></head><body>");
        out.println("<h2>Dev Files Probe</h2>");
        String ctx = req.getContextPath();
        out.println("<p>Context path: <strong>" + ctx + "</strong></p>");

        String[] paths = new String[]{"/forgot-password.jsp", "/check-emf.jsp", "/reset_password.jsp", "/WEB-INF/views/error/404.jsp"};
        out.println("<ul>");
        for (String p : paths) {
            URL r = getServletContext().getResource(p);
            out.println("<li>" + p + " - ");
            if (r != null) {
                out.println("<strong>FOUND</strong> (" + r.toString() + ")");
            } else {
                out.println("<strong>NOT FOUND</strong>");
            }
            out.println("</li>");
        }
        out.println("</ul>");
        out.println("<p>Try visiting the pages below (adjust context path above):</p>");
        out.println("<ul>");
        out.println("<li><a href='" + ctx + "/forgot-password.jsp'>forgot-password.jsp</a></li>");
        out.println("<li><a href='" + ctx + "/check-emf.jsp'>check-emf.jsp</a></li>");
        out.println("<li><a href='" + ctx + "/reset_password.jsp'>reset_password.jsp</a></li>");
        out.println("</ul>");
        out.println("</body></html>");
    }
}
