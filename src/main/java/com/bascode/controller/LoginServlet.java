 package com.bascode.controller;

import com.bascode.model.entity.User;
import com.bascode.model.enums.Role;
import com.bascode.util.ContesterAccessUtil;
import com.bascode.util.AgeUtil;

import org.mindrot.jbcrypt.BCrypt;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                .setParameter("email", email)
                .getResultStream()
                .findFirst()
                .orElse(null);
            if (user == null) {
                request.setAttribute("error", "Invalid credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            if (!user.isEmailVerified()) {
                request.setAttribute("error", "Email not verified. Please check your email for the OTP and verify your account.");
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            }
            if (user.isSuspended()) {
                request.setAttribute("error", "Your account has been suspended. Please contact the admin.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            if (!BCrypt.checkpw(password, user.getPasswordHash())) {
                request.setAttribute("error", "Invalid credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            boolean isContester = user.getRole() != Role.ADMIN && ContesterAccessUtil.hasContesterProfile(em, user.getId());

            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole() == Role.ADMIN ? Role.ADMIN.name() : (isContester ? Role.CONTESTER.name() : Role.VOTER.name()));
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("firstName", user.getFirstName());
            session.setAttribute("lastName", user.getLastName());
            // Some pages/servlets still expect a "user" session attribute.
            session.setAttribute("user", user);
            boolean underage = AgeUtil.isUnderage(user);
            session.setAttribute("underage", underage);
            if (underage) {
                response.sendRedirect(request.getContextPath() + "/underage.jsp");
                return;
            }
            if (user.getRole() == Role.ADMIN) {
                response.sendRedirect(request.getContextPath() + "/admin/contesters");
            } else if (isContester) {
                response.sendRedirect(request.getContextPath() + "/contester/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } catch (Exception ex) {
            ex.printStackTrace(); // Log the full stack trace to server logs
            request.setAttribute("error", "A system error occurred: " + ex.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    private EntityManagerFactory getEmf() {
        EntityManagerFactory emf = (EntityManagerFactory) getServletContext().getAttribute("emf");
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not found in ServletContext. Ensure JPAInitializer is registered.");
        }
        return emf;
    }
}


