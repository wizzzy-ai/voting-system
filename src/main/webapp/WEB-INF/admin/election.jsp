<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.bascode.model.entity.ElectionSettings,java.time.LocalDateTime,java.time.ZoneId,java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp"%>
  <title>Admin - Election Settings</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="admin-app">
<%
  ElectionSettings s = (ElectionSettings) request.getAttribute("settings");
  if (s == null) s = new ElectionSettings();
  String msg = request.getParameter("msg");
  String type = request.getParameter("type");
  String err = (String) request.getAttribute("error");
  LocalDateTime serverNow = LocalDateTime.now();
  DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

  request.setAttribute("adminPageTitle", "Election Settings");
  request.setAttribute("adminPageSubtitle", "Control whether voting is open and set a closing deadline.");
  request.setAttribute("activeAdminPage", "election");
%>
<%@ include file="/WEB-INF/admin/fragments/shellStart.jspf" %>

<% if (err != null && !err.trim().isEmpty()) { %>
  <div class="admin-toast error"><div class="font-semibold"><%= err %></div></div>
<% } %>
<% if (msg != null && !msg.trim().isEmpty()) { %>
  <div class="admin-toast <%= "success".equalsIgnoreCase(type) ? "success" : "error" %>"><div class="font-semibold"><%= msg %></div></div>
<% } %>

<section class="admin-grid grid lg:grid-cols-[1.1fr_.9fr] gap-4">
  <div class="admin-card p-5 rise-in">
    <div class="admin-section-head">
      <div>
        <div class="admin-section-title">Voting State</div>
        <div class="admin-section-note">Open or close ballot submission immediately.</div>
      </div>
      <span class="admin-badge <%= s.isVotingOpen() ? "approved" : "denied" %>"><%= s.isVotingOpen() ? "OPEN" : "CLOSED" %></span>
    </div>
    <form method="post" action="<%=request.getContextPath()%>/admin/election" onsubmit="return confirm('Apply these election settings?');" class="space-y-5">
      <label class="flex items-center justify-between rounded-lg border border-slate-200 bg-slate-50 px-4 py-4">
        <div>
          <div class="font-semibold text-slate-900">Enable voting</div>
          <div class="mt-1 text-sm text-slate-500">When disabled, no new votes can be submitted.</div>
        </div>
        <span class="relative inline-flex items-center">
          <input type="checkbox" name="votingOpen" class="peer sr-only" <%= s.isVotingOpen() ? "checked" : "" %>>
          <span class="h-7 w-12 rounded-full bg-slate-300 transition peer-checked:bg-emerald-600"></span>
          <span class="absolute left-1 h-5 w-5 rounded-full bg-white transition peer-checked:translate-x-5"></span>
        </span>
      </label>

      <div class="rounded-lg border border-slate-200 bg-white p-4">
        <label class="block text-sm font-semibold text-slate-700">Voting deadline</label>
        <input type="datetime-local" name="votingClosesAt"
               value="<%= s.getVotingClosesAt() != null ? dtf.format(s.getVotingClosesAt()) : "" %>"
               class="mt-2 w-full rounded-lg border border-slate-200 px-4 py-3 outline-none focus:border-emerald-500 focus:ring-4 focus:ring-emerald-100">
        <div class="mt-2 text-xs text-slate-500">Server time: <%= dtf.format(serverNow) %> (<%= ZoneId.systemDefault().getId() %>)</div>
      </div>

      <div class="flex items-center gap-3">
        <button type="submit" class="admin-button px-5 py-3">Save Settings</button>
        <a href="<%=request.getContextPath()%>/admin/election" class="admin-button-subtle px-5 py-3">Refresh</a>
      </div>
    </form>
  </div>

  <div class="admin-card p-5 rise-in">
    <div class="admin-section-head">
      <div>
        <div class="admin-section-title">Countdown</div>
        <div class="admin-section-note">Election timing at a glance.</div>
      </div>
    </div>
    <% if (s.getVotingClosesAt() != null) { %>
      <div class="rounded-lg border border-slate-200 bg-slate-50 p-4">
        <div class="text-sm text-slate-500">Voting closes at</div>
        <div class="mt-2 text-xl font-black text-slate-900"><%= s.getVotingClosesAt() %></div>
        <div class="mt-3 text-sm text-slate-600" data-relative-time="<%= s.getVotingClosesAt().toString() %>"><%= s.getVotingClosesAt() %></div>
      </div>
    <% } else { %>
      <div class="admin-empty">
        <div class="admin-empty-illustration">🗓</div>
        No voting deadline is currently set.
      </div>
    <% } %>
  </div>
</section>

<%@ include file="/WEB-INF/admin/fragments/shellEnd.jspf" %>
</body>
</html>
