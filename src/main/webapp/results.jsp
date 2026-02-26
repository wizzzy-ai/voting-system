<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>
<html lang="en">
<head>
    <title>Results - Voting System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tailwind.output.css">
</head>
<body class="bg-gray-100 min-h-screen">
    <section class="max-w-2xl mx-auto mt-10">
        <div class="bg-white rounded shadow p-8">
            <h1 class="text-2xl font-bold mb-4 text-center">Election Results</h1>
            <table class="w-full border-collapse">
                <thead>
                    <tr>
                        <th class="border-b p-2 text-left">Candidate</th>
                        <th class="border-b p-2 text-left">Votes</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Example results, replace with dynamic data -->
                    <tr><td class="p-2">Candidate A</td><td class="p-2">120</td></tr>
                    <tr><td class="p-2">Candidate B</td><td class="p-2">95</td></tr>
                    <tr><td class="p-2">Candidate C</td><td class="p-2">60</td></tr>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
