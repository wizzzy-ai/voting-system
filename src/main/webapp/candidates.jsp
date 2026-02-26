<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>
<html lang="en">
<head>
    <title>Candidates - Voting System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tailwind.output.css">
</head>
<body class="bg-gray-100 min-h-screen">
    <section class="max-w-2xl mx-auto mt-10">
        <div class="bg-white rounded shadow p-8">
            <h1 class="text-2xl font-bold mb-4 text-center">Candidates</h1>
            <div class="space-y-6">
                <!-- Example candidates, replace with dynamic list -->
                <div class="bg-gray-50 rounded p-4">
                    <h2 class="text-lg font-semibold">Candidate A</h2>
                    <p class="text-gray-700">Platform: Education, Healthcare, Jobs</p>
                </div>
                <div class="bg-gray-50 rounded p-4">
                    <h2 class="text-lg font-semibold">Candidate B</h2>
                    <p class="text-gray-700">Platform: Infrastructure, Security, Economy</p>
                </div>
                <div class="bg-gray-50 rounded p-4">
                    <h2 class="text-lg font-semibold">Candidate C</h2>
                    <p class="text-gray-700">Platform: Environment, Technology, Youth</p>
                </div>
            </div>
        </div>
    </section>
</body>
</html>
