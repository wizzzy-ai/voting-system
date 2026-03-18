<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.bascode.model.entity.ElectionSettings,java.time.LocalDateTime,java.time.ZoneId,java.time.format.DateTimeFormatter" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Admin - Election Settings</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">

<%
  ElectionSettings s = (ElectionSettings) request.getAttribute("settings");
  if (s == null) s = new ElectionSettings();

  String msg = request.getParameter("msg");
  String type = request.getParameter("type");
  String err = (String) request.getAttribute("error");
  LocalDateTime serverNow = LocalDateTime.now();
  String serverTz = ZoneId.systemDefault().getId();
  DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
%>

<header class="sticky top-0 z-10">
  <div class="glass">
    <div class="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] soft-glow"></div>
        <div>
          <h1 class="text-xl md:text-2xl font-extrabold text-gray-900 tracking-tight">Election Settings</h1>
          <p class="text-sm text-gray-600">Open/close voting and set an optional deadline.</p>
        </div>
      </div>
      <div class="flex items-center gap-2">
        <a href="<%=request.getContextPath()%>/admin/dashboard"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Admin Dashboard
        </a>
        <a href="<%=request.getContextPath()%>/logout"
           class="px-4 py-2 rounded-xl bg-gradient-to-r from-[var(--purple-light)] to-[var(--purple)] text-white hover:scale-[1.02] transition duration-200">
          Logout
        </a>
      </div>
    </div>
  </div>
</header>

<main class="max-w-6xl mx-auto px-4 py-8">

  <% if (err != null && !err.trim().isEmpty()) { %>
    <div class="rise-in mb-6 rounded-2xl p-4 border bg-red-50 border-red-200 text-red-800">
      <div class="font-semibold"><%= err %></div>
    </div>
  <% } %>

  <% if (msg != null && !msg.trim().isEmpty()) { %>
    <div class="rise-in mb-6 rounded-2xl p-4 border
      <%= "success".equalsIgnoreCase(type) ? "bg-green-50 border-green-200 text-green-800" : "bg-red-50 border-red-200 text-red-800" %>">
      <div class="font-semibold"><%= msg %></div>
    </div>
  <% } %>

  <section class="rise-in glass rounded-3xl p-5 md:p-6 soft-glow">
    <div class="flex items-start justify-between gap-4">
      <div>
        <h2 class="text-lg font-bold text-gray-900">Voting Status</h2>
        <p class="text-sm text-gray-600">When voting is closed, voters cannot submit ballots.</p>
      </div>
      <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold <%= s.isVotingOpen() ? "text-green-800" : "text-red-800" %>"
            style="background-image:<%= s.isVotingOpen() ? "linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85))" : "linear-gradient(135deg, rgba(254,202,202,.85), rgba(255,228,230,.85))" %>;">
        <%= s.isVotingOpen() ? "OPEN" : "CLOSED" %>
      </span>
    </div>

    <form class="mt-6 space-y-6" method="post" action="<%=request.getContextPath()%>/admin/election">
      <div class="flex items-center justify-between rounded-2xl bg-white/70 border border-gray-100 p-4">
        <div>
          <div class="font-semibold text-gray-900">Voting Open</div>
          <div class="text-sm text-gray-600">Toggle to open/close voting immediately.</div>
        </div>
        <label class="inline-flex items-center gap-3">
          <input type="checkbox" name="votingOpen" class="h-5 w-5" <%= s.isVotingOpen() ? "checked" : "" %> />
          <span class="text-sm font-semibold text-gray-800">Enabled</span>
        </label>
      </div>

      <div class="rounded-2xl bg-white/70 border border-gray-100 p-4">
        <div class="font-semibold text-gray-900">Optional Deadline</div>
        <div class="text-sm text-gray-600">
          If set, voting will be considered closed after this time.
          Server time: <%= dtf.format(serverNow) %> (<%= serverTz %>).
        </div>
        <div class="mt-3">
          <input type="datetime-local" name="votingClosesAt"
                 value="<%= s.getVotingClosesAt() != null ? dtf.format(s.getVotingClosesAt()) : "" %>"
                 class="w-full px-4 py-3 rounded-2xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] transition" />
        </div>
      </div>

      <div class="flex flex-wrap gap-3">
        <button type="submit"
                class="px-6 py-3 rounded-2xl bg-gradient-to-r from-[var(--green)] to-emerald-600 text-white font-semibold hover:brightness-95 hover:shadow transition duration-200">
          Save Settings
        </button>
        <a href="<%=request.getContextPath()%>/admin/election"
           class="px-6 py-3 rounded-2xl bg-white border border-gray-200 text-gray-800 font-semibold hover:shadow transition duration-200">
          Refresh
        </a>
      </div>
    </form>
  </section>
</main>

</body>
</html>

