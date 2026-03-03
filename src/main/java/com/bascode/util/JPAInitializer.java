package com.bascode.util;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;


@WebListener
public class JPAInitializer implements ServletContextListener {
    private static EntityManagerFactory emf;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            emf = Persistence.createEntityManagerFactory("VotingPU");
            sce.getServletContext().setAttribute("emf", emf);
        } catch (Throwable t) {
            // Log the error and avoid throwing so the webapp still starts
            System.err.println("Failed to initialize EntityManagerFactory: " + t.getMessage());
            t.printStackTrace();
            sce.getServletContext().setAttribute("emf", null);
            // Also store the error message for diagnostics
            sce.getServletContext().setAttribute("emfError", t.toString());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (emf != null && emf.isOpen()) {
            emf.close(); 
        }
    }
}