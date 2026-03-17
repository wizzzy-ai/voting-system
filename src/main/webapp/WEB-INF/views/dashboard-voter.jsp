<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="com.bascode.model.entity.User" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Voter Dashboard - Voting System</title>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">

<%
  User user = (User) request.getAttribute("user");
  boolean hasVoted = request.getAttribute("hasVoted") != null && (Boolean) request.getAttribute("hasVoted");
  String name = user != null ? (user.getFirstName() + " " + user.getLastName()) : "Voter";
%>

<section class="max-w-5xl mx-auto pt-28 px-4 pb-12">
  <div class="bg-white/90 backdrop-blur rounded-3xl shadow-xl p-6 md:p-8 border border-gray-100">
    <div class="flex items-start justify-between gap-4">
      <div>
        <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Welcome, <%= name %></h1>
        <p class="text-gray-600 mt-1">Vote, view results, and explore candidates.</p>
      </div>
      <div class="hidden md:block w-12 h-12 rounded-2xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] shadow-lg"></div>
    </div>

    <div class="mt-6 flex flex-wrap gap-2">
      <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold <%= hasVoted ? "text-green-800" : "text-amber-800" %>"
            style="background-image:<%= hasVoted ? "linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85))" : "linear-gradient(135deg, rgba(253,230,138,.85), rgba(254,215,170,.85))" %>;">
        <%= hasVoted ? "Vote submitted" : "Vote not submitted" %>
      </span>
    </div>

    <div class="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5 hover:shadow-md transition">
        <h2 class="text-lg font-bold text-gray-900">Vote Now</h2>
        <p class="mt-2 text-sm text-gray-600">Cast your vote for your preferred candidate.</p>
        <a href="<%=request.getContextPath()%>/vote"
           class="mt-4 inline-flex px-4 py-2 rounded-xl bg-[var(--green)] text-white font-semibold hover:brightness-95 transition">
          Go to Voting
        </a>
      </div>
      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5 hover:shadow-md transition">
        <h2 class="text-lg font-bold text-gray-900">View Results</h2>
        <p class="mt-2 text-sm text-gray-600">See live results and vote counts.</p>
        <a href="<%=request.getContextPath()%>/results"
           class="mt-4 inline-flex px-4 py-2 rounded-xl bg-gradient-to-r from-[var(--purple-light)] to-[var(--purple)] text-white font-semibold hover:brightness-95 transition">
          View Results
        </a>
      </div>
      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5 hover:shadow-md transition">
        <h2 class="text-lg font-bold text-gray-900">Candidates</h2>
        <p class="mt-2 text-sm text-gray-600">Learn more about the contesters and positions.</p>
        <a href="<%=request.getContextPath()%>/candidates"
           class="mt-4 inline-flex px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 font-semibold hover:shadow transition">
          View Candidates
        </a>
      </div>
    </div>

    <div class="mt-6 rounded-2xl border border-gray-100 bg-white/70 p-5 flex items-center justify-between gap-4">
      <div>
        <div class="text-sm font-semibold text-gray-900">Need help?</div>
        <div class="text-sm text-gray-600">Chat with the admin at any time.</div>
      </div>
      <a href="<%=request.getContextPath()%>/support"
         class="px-4 py-2 rounded-xl bg-[var(--purple)] text-white font-semibold hover:opacity-95 transition">
        Open Support Chat
      </a>
    </div>
  </div>
</section>
</body>
</html>

