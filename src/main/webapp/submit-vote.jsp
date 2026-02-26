<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>
<html lang="en">
<head>
    <title>Vote Submission</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tailwind.output.css">
</head>
<body class="bg-gray-100 min-h-screen">
    <section class="max-w-2xl mx-auto mt-10">
        <div class="bg-white rounded shadow p-8 text-center">
            <h1 class="text-2xl font-bold mb-4">Vote Submission</h1>
            <p class="text-lg text-gray-700 mb-6">Your vote has been submitted successfully!</p>
            <a href="dashboard.jsp" class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700">Back to Dashboard</a>
        </div>
    </section>
</body>
</html>
