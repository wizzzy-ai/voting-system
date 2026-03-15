<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.AdminAuditLog,com.bascode.model.entity.User" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Admin - Dashboard</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">

<%
  long totalUsers = request.getAttribute("totalUsers") != null ? (Long) request.getAttribute("totalUsers") : 0L;
  long totalVoters = request.getAttribute("totalVoters") != null ? (Long) request.getAttribute("totalVoters") : 0L;
  long totalAdmins = request.getAttribute("totalAdmins") != null ? (Long) request.getAttribute("totalAdmins") : 0L;
  long totalContesterUsers = request.getAttribute("totalContesterUsers") != null ? (Long) request.getAttribute("totalContesterUsers") : 0L;

  long contesterApps = request.getAttribute("contesterApps") != null ? (Long) request.getAttribute("contesterApps") : 0L;
  long pendingApps = request.getAttribute("pendingApps") != null ? (Long) request.getAttribute("pendingApps") : 0L;
  long approvedApps = request.getAttribute("approvedApps") != null ? (Long) request.getAttribute("approvedApps") : 0L;
  long deniedApps = request.getAttribute("deniedApps") != null ? (Long) request.getAttribute("deniedApps") : 0L;

  long totalVotes = request.getAttribute("totalVotes") != null ? (Long) request.getAttribute("totalVotes") : 0L;

  @SuppressWarnings("unchecked")
  List<AdminAuditLog> recentActivity = (List<AdminAuditLog>) request.getAttribute("recentActivity");
  if (recentActivity == null) recentActivity = Collections.emptyList();
%>

<header class="sticky top-0 z-10">
  <div class="glass">
    <div class="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] soft-glow"></div>
        <div>
          <h1 class="text-xl md:text-2xl font-extrabold text-gray-900 tracking-tight">Admin Panel</h1>
          <p class="text-sm text-gray-600">Overview, contesters, users, and results.</p>
        </div>
      </div>
      <div class="flex items-center gap-2">
        <a href="<%=request.getContextPath()%>/dashboard"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Back to Dashboard
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
  <section class="rise-in glass rounded-3xl p-5 md:p-6 soft-glow">
    <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
      <div>
        <h2 class="text-lg font-bold text-gray-900">Quick Actions</h2>
        <p class="text-sm text-gray-600">Jump to the key admin areas.</p>
      </div>
      <div class="flex flex-wrap gap-2">
        <a href="<%=request.getContextPath()%>/admin/contesters"
           class="px-5 py-2 rounded-xl bg-gradient-to-r from-[var(--green)] to-emerald-600 text-white font-semibold hover:brightness-95 hover:shadow transition duration-200">
          Manage Contesters
        </a>
        <a href="<%=request.getContextPath()%>/admin/users"
           class="px-5 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 font-semibold hover:shadow transition duration-200">
          Manage Users
        </a>
        <a href="<%=request.getContextPath()%>/admin/results"
           class="px-5 py-2 rounded-xl bg-gradient-to-r from-[var(--purple-light)] to-[var(--purple)] text-white font-semibold hover:brightness-95 hover:shadow transition duration-200">
          View Results
        </a>
        <a href="<%=request.getContextPath()%>/admin/audit"
           class="px-5 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 font-semibold hover:shadow transition duration-200">
          Activity Log
        </a>
      </div>
    </div>
  </section>

  <section class="mt-6 grid grid-cols-1 md:grid-cols-3 gap-4">
    <div class="rise-in glass rounded-3xl p-5 md:p-6 soft-glow" style="animation-delay:.02s;">
      <div class="flex items-center justify-between gap-4">
        <div>
          <div class="text-xs font-bold tracking-widest text-gray-500">USERS</div>
          <div class="mt-2 text-3xl font-extrabold text-gray-900"><%= totalUsers %></div>
          <div class="mt-1 text-sm text-gray-600">All accounts</div>
        </div>
        <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-gray-800"
              style="background-image:linear-gradient(135deg, rgba(229,231,235,.9), rgba(243,244,246,.9));">
          Live
        </span>
      </div>
      <div class="mt-4 grid grid-cols-3 gap-2 text-sm">
        <div class="rounded-2xl bg-white/70 border border-gray-100 p-3">
          <div class="text-xs text-gray-500 font-semibold">Voters</div>
          <div class="text-lg font-bold text-gray-900"><%= totalVoters %></div>
        </div>
        <div class="rounded-2xl bg-white/70 border border-gray-100 p-3">
          <div class="text-xs text-gray-500 font-semibold">Contesters</div>
          <div class="text-lg font-bold text-gray-900"><%= totalContesterUsers %></div>
        </div>
        <div class="rounded-2xl bg-white/70 border border-gray-100 p-3">
          <div class="text-xs text-gray-500 font-semibold">Admins</div>
          <div class="text-lg font-bold text-gray-900"><%= totalAdmins %></div>
        </div>
      </div>
    </div>

    <div class="rise-in glass rounded-3xl p-5 md:p-6 soft-glow" style="animation-delay:.05s;">
      <div class="flex items-center justify-between gap-4">
        <div>
          <div class="text-xs font-bold tracking-widest text-gray-500">CONTESTER APPS</div>
          <div class="mt-2 text-3xl font-extrabold text-gray-900"><%= contesterApps %></div>
          <div class="mt-1 text-sm text-gray-600">Applications total</div>
        </div>
        <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-amber-800"
              style="background-image:linear-gradient(135deg, rgba(253,230,138,.85), rgba(254,215,170,.85));">
          Review
        </span>
      </div>
      <div class="mt-4 grid grid-cols-3 gap-2 text-sm">
        <div class="rounded-2xl bg-white/70 border border-gray-100 p-3">
          <div class="text-xs text-gray-500 font-semibold">Pending</div>
          <div class="text-lg font-bold text-gray-900"><%= pendingApps %></div>
        </div>
        <div class="rounded-2xl bg-white/70 border border-gray-100 p-3">
          <div class="text-xs text-gray-500 font-semibold">Approved</div>
          <div class="text-lg font-bold text-gray-900"><%= approvedApps %></div>
        </div>
        <div class="rounded-2xl bg-white/70 border border-gray-100 p-3">
          <div class="text-xs text-gray-500 font-semibold">Denied</div>
          <div class="text-lg font-bold text-gray-900"><%= deniedApps %></div>
        </div>
      </div>
      <div class="mt-4">
        <a href="<%=request.getContextPath()%>/admin/contesters?status=PENDING"
           class="inline-flex items-center gap-2 text-sm font-semibold text-[var(--purple)] hover:underline">
          Review pending contesters
        </a>
      </div>
    </div>

    <div class="rise-in glass rounded-3xl p-5 md:p-6 soft-glow" style="animation-delay:.08s;">
      <div class="flex items-center justify-between gap-4">
        <div>
          <div class="text-xs font-bold tracking-widest text-gray-500">VOTES</div>
          <div class="mt-2 text-3xl font-extrabold text-gray-900"><%= totalVotes %></div>
          <div class="mt-1 text-sm text-gray-600">Votes cast</div>
        </div>
        <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-green-800"
              style="background-image:linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85));">
          Counted
        </span>
      </div>
      <div class="mt-4">
        <a href="<%=request.getContextPath()%>/admin/results"
           class="inline-flex items-center gap-2 text-sm font-semibold text-[var(--green)] hover:underline">
          View live results breakdown
        </a>
      </div>
    </div>
  </section>

  <section class="mt-6 rise-in glass rounded-3xl p-5 md:p-6 soft-glow" style="animation-delay:.11s;">
    <div class="flex items-center justify-between gap-4">
      <div>
        <h2 class="text-lg font-bold text-gray-900">Recent Activity</h2>
        <p class="text-sm text-gray-600">Latest admin actions.</p>
      </div>
      <a href="<%=request.getContextPath()%>/admin/audit"
         class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
        View all
      </a>
    </div>

    <div class="mt-5 overflow-x-auto">
      <table class="w-full text-sm">
        <thead>
          <tr class="text-left text-gray-600">
            <th class="py-3 pr-4">Time</th>
            <th class="py-3 pr-4">Admin</th>
            <th class="py-3 pr-4">Action</th>
            <th class="py-3 pr-4">Target</th>
          </tr>
        </thead>
        <tbody>
        <%
          int i = 0;
          for (AdminAuditLog l : recentActivity) {
            i++;
            User au = l.getAdminUser();
            String adminName = au != null ? (au.getFirstName() + " " + au.getLastName()) : "(unknown)";
        %>
          <tr class="rise-in border-t border-gray-100 hover:bg-white/60 transition"
              style="animation-delay: <%= Math.min(0.6, i * 0.02) %>s;">
            <td class="py-4 pr-4 text-gray-700"><%= l.getCreatedAt() %></td>
            <td class="py-4 pr-4 font-semibold text-gray-900"><%= adminName %></td>
            <td class="py-4 pr-4 text-gray-700"><%= l.getActionType() %></td>
            <td class="py-4 pr-4 text-gray-700"><%= l.getTargetType() %>#<%= l.getTargetId() %></td>
          </tr>
        <%
          }
          if (recentActivity.isEmpty()) {
        %>
          <tr class="border-t border-gray-100">
            <td colspan="4" class="py-6 text-center text-gray-600">
              No activity yet.
            </td>
          </tr>
        <%
          }
        %>
        </tbody>
      </table>
    </div>
  </section>
</main>

</body>
</html>
