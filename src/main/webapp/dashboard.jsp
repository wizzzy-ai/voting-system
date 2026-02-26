<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>
<html lang="en">
<head>
    <title>Dashboard - Voting System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tailwind.output.css">
</head>
<body class="bg-gray-100 min-h-screen">
<%-- Session validation --%>
<%
    Object user = null;
    // Try to get user object from session
    if (session.getAttribute("user") != null) {
        user = session.getAttribute("user");
    } else if (session.getAttribute("userId") != null) {
        // Optionally, fetch user from DB using userId
        // For now, just allow access if userId is present
        user = session.getAttribute("userId");
    }
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
    <section class="max-w-4xl mx-auto mt-10">
        <div class="bg-white rounded shadow p-8">
            <h1 class="text-3xl font-bold mb-4 text-center">Welcome to the Voting Dashboard</h1>
            <p class="text-center text-gray-600 mb-8">Participate in elections, view results, and learn about candidates.</p>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Voting Card -->
                <div class="bg-blue-50 rounded p-6 shadow text-center">
                    <h2 class="text-xl font-semibold mb-2">Vote Now</h2>
                    <p class="mb-4 text-gray-700">Cast your vote for your preferred candidate.</p>
                    <a href="vote.jsp" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Go to Voting</a>
                </div>
                <!-- Results Card -->
                <div class="bg-green-50 rounded p-6 shadow text-center">
                    <h2 class="text-xl font-semibold mb-2">View Results</h2>
                    <p class="mb-4 text-gray-700">See the latest election results and statistics.</p>
                    <a href="results.jsp" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">View Results</a>
                </div>
                <!-- Candidates Card -->
                <div class="bg-yellow-50 rounded p-6 shadow text-center">
                    <h2 class="text-xl font-semibold mb-2">Candidates</h2>
                    <p class="mb-4 text-gray-700">Learn more about the candidates and their profiles.</p>
                    <a href="candidates.jsp" class="bg-yellow-600 text-white px-4 py-2 rounded hover:bg-yellow-700">View Candidates</a>
                </div>
            </div>
        </div>
    </section>
</body>
</html>