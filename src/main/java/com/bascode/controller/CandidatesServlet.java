package com.bascode.controller;

import com.bascode.model.entity.Contester;
import com.bascode.model.enums.ContesterStatus;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/candidates")
public class CandidatesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManagerFactory emf = getEmf();
        EntityManager em = emf.createEntityManager();
        try {
            List<Contester> contesters = em.createQuery(
                            "SELECT c FROM Contester c JOIN FETCH c.user u WHERE c.status = :status ORDER BY c.position ASC, u.lastName ASC, u.firstName ASC",
                            Contester.class
                    )
                    .setParameter("status", ContesterStatus.APPROVED)
                    .getResultList();

            request.setAttribute("contesters", contesters);
            request.getRequestDispatcher("/WEB-INF/views/candidates.jsp").forward(request, response);
        } finally {
            em.close();
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
