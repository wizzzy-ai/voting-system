package com.bascode.util;

import jakarta.persistence.EntityManager;
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
            migrateAdminAuditActionType();
            migrateVoteUniqueConstraint();
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

    private static void migrateAdminAuditActionType() {
        if (emf == null || !emf.isOpen()) return;

        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.createNativeQuery(
                    "ALTER TABLE admin_audit_logs " +
                    "MODIFY COLUMN actionType VARCHAR(64) NOT NULL"
            ).executeUpdate();
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("Admin audit log migration skipped: " + ex.getMessage());
        } finally {
            em.close();
        }
    }

    private static void migrateVoteUniqueConstraint() {
        if (emf == null || !emf.isOpen()) return;

        EntityManager em = emf.createEntityManager();
        try {
            @SuppressWarnings("unchecked")
            java.util.List<String> legacyIndexes = em.createNativeQuery(
                    "SELECT s.index_name " +
                    "FROM information_schema.statistics s " +
                    "WHERE s.table_schema = DATABASE() " +
                    "AND s.table_name = 'votes' " +
                    "AND s.non_unique = 0 " +
                    "AND s.index_name <> 'PRIMARY' " +
                    "GROUP BY s.index_name " +
                    "HAVING SUM(CASE WHEN s.column_name = 'voter_id' THEN 1 ELSE 0 END) > 0 " +
                    "AND SUM(CASE WHEN s.column_name = 'position' THEN 1 ELSE 0 END) = 0"
            ).getResultList();

            @SuppressWarnings("unchecked")
            java.util.List<String> compositeIndexes = em.createNativeQuery(
                    "SELECT s.index_name " +
                    "FROM information_schema.statistics s " +
                    "WHERE s.table_schema = DATABASE() " +
                    "AND s.table_name = 'votes' " +
                    "AND s.non_unique = 0 " +
                    "GROUP BY s.index_name " +
                    "HAVING SUM(CASE WHEN s.column_name = 'voter_id' THEN 1 ELSE 0 END) > 0 " +
                    "AND SUM(CASE WHEN s.column_name = 'position' THEN 1 ELSE 0 END) > 0"
            ).getResultList();

            if (legacyIndexes.isEmpty() && !compositeIndexes.isEmpty()) {
                return;
            }

            em.getTransaction().begin();
            for (String indexName : legacyIndexes) {
                em.createNativeQuery("ALTER TABLE votes DROP INDEX " + indexName).executeUpdate();
            }
            if (compositeIndexes.isEmpty()) {
                em.createNativeQuery(
                        "ALTER TABLE votes " +
                        "ADD CONSTRAINT uk_votes_voter_position UNIQUE (voter_id, position)"
                ).executeUpdate();
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("Vote constraint migration skipped: " + ex.getMessage());
        } finally {
            em.close();
        }
    }
}
