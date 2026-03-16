<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.AdminAuditLog,com.bascode.model.entity.User,com.bascode.model.enums.AdminActionType" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Admin - Activity Log</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">

<%
  @SuppressWarnings("unchecked")
  List<AdminAuditLog> logs = (List<AdminAuditLog>) request.getAttribute("logs");
  if (logs == null) logs = Collections.emptyList();

  String selectedAction = (String) request.getAttribute("selectedAction");
  if (selectedAction == null) selectedAction = "";
%>

<header class="sticky top-0 z-10">
  <div class="glass">
    <div class="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] soft-glow"></div>
        <div>
          <h1 class="text-xl md:text-2xl font-extrabold text-gray-900 tracking-tight">Activity Log</h1>
          <p class="text-sm text-gray-600">Recent admin actions.</p>
        </div>
      </div>
      <div class="flex items-center gap-2">
        <a href="<%=request.getContextPath()%>/admin/dashboard"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Admin Dashboard
        </a>
        <a href="<%=request.getContextPath()%>/admin/contesters"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Contesters
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
        <h2 class="text-lg font-bold text-gray-900">Filters</h2>
        <p class="text-sm text-gray-600">Filter by action type.</p>
      </div>
      <form method="get" action="<%=request.getContextPath()%>/admin/audit" class="flex flex-col sm:flex-row gap-3">
        <div class="flex flex-col">
          <label class="text-xs font-semibold text-gray-700 mb-1">Action</label>
          <select name="action"
                  class="px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] transition">
            <option value="" <%= selectedAction.isEmpty() ? "selected" : "" %>>All</option>
            <%
              for (AdminActionType t : AdminActionType.values()) {
                String v = t.name();
            %>
              <option value="<%= v %>" <%= v.equalsIgnoreCase(selectedAction) ? "selected" : "" %>><%= v %></option>
            <%
              }
            %>
          </select>
        </div>
        <div class="flex items-end gap-2">
          <button type="submit"
                  class="px-5 py-2 rounded-xl bg-gradient-to-r from-[var(--green)] to-emerald-600 text-white font-semibold hover:brightness-95 hover:shadow transition duration-200">
            Apply
          </button>
          <a href="<%=request.getContextPath()%>/admin/audit"
             class="px-5 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
            Reset
          </a>
        </div>
      </form>
    </div>
  </section>

  <section class="mt-6 rise-in glass rounded-3xl p-5 md:p-6 soft-glow" style="animation-delay:.05s;">
    <div class="flex items-center justify-between gap-4">
      <div>
        <h2 class="text-lg font-bold text-gray-900">Recent Activity</h2>
        <p class="text-sm text-gray-600"><%= logs.size() %> record(s) shown (max 250)</p>
      </div>
      <a href="<%=request.getContextPath()%>/admin/audit"
         class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
        Refresh
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
          <th class="py-3 pr-4">Message</th>
          <th class="py-3 pr-4">IP</th>
        </tr>
        </thead>
        <tbody>
        <%
          int i = 0;
          for (AdminAuditLog l : logs) {
            i++;
            User admin = l.getAdminUser();
            String adminName = admin != null ? (admin.getFirstName() + " " + admin.getLastName()) : "(unknown)";
        %>
          <tr class="rise-in border-t border-gray-100 hover:bg-white/60 transition"
              style="animation-delay: <%= Math.min(0.6, i * 0.02) %>s;">
            <td class="py-4 pr-4 text-gray-700"><%= l.getCreatedAt() %></td>
            <td class="py-4 pr-4 font-semibold text-gray-900"><%= adminName %></td>
            <td class="py-4 pr-4">
              <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-white"
                    style="background-image:linear-gradient(135deg, var(--purple), var(--green));">
                <%= l.getActionType() %>
              </span>
            </td>
            <td class="py-4 pr-4 text-gray-700"><%= l.getTargetType() %>#<%= l.getTargetId() %></td>
            <td class="py-4 pr-4 text-gray-700"><%= l.getMessage() != null ? l.getMessage() : "" %></td>
            <td class="py-4 pr-4 text-gray-700"><%= l.getIpAddress() != null ? l.getIpAddress() : "" %></td>
          </tr>
        <%
          }
          if (logs.isEmpty()) {
        %>
          <tr class="border-t border-gray-100">
            <td colspan="6" class="py-8 text-center text-gray-600">
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

