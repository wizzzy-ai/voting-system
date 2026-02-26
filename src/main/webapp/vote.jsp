<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>
<html lang="en">
<head>
    <title>Vote - Voting System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tailwind.output.css">
</head>
<body class="bg-gray-100 min-h-screen">
    <section class="max-w-2xl mx-auto mt-10">
        <div class="bg-white rounded shadow p-8">
            <h1 class="text-2xl font-bold mb-4 text-center">Cast Your Vote</h1>

            <%-- Show error or success messages --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="mb-4 p-3 bg-red-100 text-red-700 rounded"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="mb-4 p-3 bg-green-100 text-green-700 rounded"><%= request.getAttribute("success") %></div>
            <% } %>

            <form action="submit-vote" method="post">
                <div class="mb-6">
                    <label class="block text-lg font-semibold mb-2">Select Candidate:</label>
                    <select name="candidateId" class="w-full border border-gray-300 rounded px-4 py-2" required>
                        <option value="">-- Choose a candidate --</option>
                        <%-- Dynamically list candidates from DB --%>
                        <%
                            jakarta.persistence.EntityManagerFactory emf = (jakarta.persistence.EntityManagerFactory)application.getAttribute("emf");
                            jakarta.persistence.EntityManager em = null;
                            try {
                                em = emf.createEntityManager();
                                java.util.List<com.bascode.model.entity.Contester> candidates = em.createQuery("SELECT c FROM Contester c WHERE c.status = :status", com.bascode.model.entity.Contester.class)
                                    .setParameter("status", com.bascode.model.enums.ContesterStatus.APPROVED)
                                    .getResultList();
                                for (com.bascode.model.entity.Contester candidate : candidates) {
                                    %>
                                    <option value="<%= candidate.getId() %>"><%= candidate.getUser().getFirstName() %> <%= candidate.getUser().getLastName() %> - <%= candidate.getPosition() %></option>
                                    <%
                                }
                            } catch (Exception ex) {
                                %>
                                <option disabled>Error loading candidates</option>
                                <%
                            } finally {
                                if (em != null) em.close();
                            }
                        %>
                    </select>
                </div>
                <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700">Submit Vote</button>
            </form>
        </div>
    </section>
</body>
</html>