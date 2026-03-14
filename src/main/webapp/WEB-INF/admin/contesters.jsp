<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.Contester,com.bascode.model.entity.User,com.bascode.model.enums.ContesterStatus,com.bascode.model.enums.Position" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Admin - Contester Management</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">

<%
  @SuppressWarnings("unchecked")
  List<Contester> contesters = (List<Contester>) request.getAttribute("contesters");
  if (contesters == null) contesters = Collections.emptyList();

  String msg = request.getParameter("msg");
  String type = request.getParameter("type");

  String selectedStatus = (String) request.getAttribute("selectedStatus");
  String selectedPosition = (String) request.getAttribute("selectedPosition");
  if (selectedStatus == null) selectedStatus = "";
  if (selectedPosition == null) selectedPosition = "";
%>

<header class="sticky top-0 z-10">
  <div class="glass">
    <div class="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] soft-glow"></div>
        <div>
          <h1 class="text-xl md:text-2xl font-extrabold text-gray-900 tracking-tight">Contester Management</h1>
          <p class="text-sm text-gray-600">Approve or deny contesters. Max 3 approved per position.</p>
        </div>
      </div>
      <div class="flex items-center gap-2">
        <a href="<%=request.getContextPath()%>/admin/dashboard"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Admin Dashboard
        </a>
        <a href="<%=request.getContextPath()%>/admin/users"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Users
        </a>
        <a href="<%=request.getContextPath()%>/admin/results"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Results
        </a>
        <a href="<%=request.getContextPath()%>/admin/audit"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Activity
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

  <% if (msg != null && !msg.trim().isEmpty()) { %>
    <div class="rise-in mb-6 rounded-2xl p-4 border
      <%= "success".equalsIgnoreCase(type) ? "bg-green-50 border-green-200 text-green-800" : "bg-red-50 border-red-200 text-red-800" %>">
      <div class="font-semibold"><%= msg %></div>
    </div>
  <% } %>

  <section class="rise-in glass rounded-3xl p-5 md:p-6 soft-glow">
    <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
      <div>
        <h2 class="text-lg font-bold text-gray-900">Filters</h2>
        <p class="text-sm text-gray-600">Narrow by status or position.</p>
      </div>
      <form method="get" action="<%=request.getContextPath()%>/admin/contesters" class="flex flex-col sm:flex-row gap-3">
        <div class="flex flex-col">
          <label class="text-xs font-semibold text-gray-700 mb-1">Status</label>
          <select name="status"
                  class="px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] transition">
            <option value="" <%= selectedStatus.isEmpty() ? "selected" : "" %>>All</option>
            <option value="PENDING" <%= "PENDING".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Pending</option>
            <option value="APPROVED" <%= "APPROVED".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Approved</option>
            <option value="DENIED" <%= "DENIED".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Denied</option>
          </select>
        </div>
        <div class="flex flex-col">
          <label class="text-xs font-semibold text-gray-700 mb-1">Position</label>
          <select name="position"
                  class="px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] transition">
            <option value="" <%= selectedPosition.isEmpty() ? "selected" : "" %>>All</option>
            <%
              for (Position p : Position.values()) {
                String v = p.name();
            %>
              <option value="<%= v %>" <%= v.equalsIgnoreCase(selectedPosition) ? "selected" : "" %>><%= v.replace('_',' ') %></option>
            <%
              }
            %>
          </select>
        </div>
        <div class="flex items-end gap-2">
          <button type="submit"
                  class="px-5 py-2 rounded-xl bg-[var(--green)] text-white font-semibold hover:brightness-95 hover:shadow transition duration-200">
            Apply
          </button>
          <a href="<%=request.getContextPath()%>/admin/contesters"
             class="px-5 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
            Reset
          </a>
        </div>
      </form>
    </div>
  </section>

  <section class="mt-6">
    <div class="rise-in glass rounded-3xl p-5 md:p-6 soft-glow">
      <div class="flex items-center justify-between gap-4">
        <div>
          <h2 class="text-lg font-bold text-gray-900">Contesters</h2>
          <p class="text-sm text-gray-600"><%= contesters.size() %> record(s)</p>
        </div>
      </div>

      <div class="mt-5 overflow-x-auto">
        <table class="w-full text-sm">
          <thead>
            <tr class="text-left text-gray-600">
              <th class="py-3 pr-4">Name</th>
              <th class="py-3 pr-4">Email</th>
              <th class="py-3 pr-4">Position</th>
              <th class="py-3 pr-4">Status</th>
              <th class="py-3 pr-4">Actions</th>
            </tr>
          </thead>
          <tbody>
          <%
            int i = 0;
            for (Contester c : contesters) {
              i++;
              User u = c.getUser();
              String fullName = (u != null ? (u.getFirstName() + " " + u.getLastName()) : "(no user)");
              String email = (u != null ? u.getEmail() : "");
              String pos = (c.getPosition() != null ? c.getPosition().name().replace('_',' ') : "");
              ContesterStatus st = c.getStatus();

              String pillClass = "bg-gray-100 text-gray-700";
              String pillGrad = "linear-gradient(135deg, rgba(229,231,235,.9), rgba(243,244,246,.9))";
              if (st == ContesterStatus.PENDING) {
                pillClass = "text-amber-800";
                pillGrad = "linear-gradient(135deg, rgba(253,230,138,.85), rgba(254,215,170,.85))";
              } else if (st == ContesterStatus.APPROVED) {
                pillClass = "text-green-800";
                pillGrad = "linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85))";
              } else if (st == ContesterStatus.DENIED) {
                pillClass = "text-red-800";
                pillGrad = "linear-gradient(135deg, rgba(254,202,202,.85), rgba(255,228,230,.85))";
              }
          %>
            <tr class="rise-in border-t border-gray-100 hover:bg-white/60 transition"
                style="animation-delay: <%= Math.min(0.6, i * 0.03) %>s;">
              <td class="py-4 pr-4 font-semibold text-gray-900"><%= fullName %></td>
              <td class="py-4 pr-4 text-gray-700"><%= email %></td>
              <td class="py-4 pr-4 text-gray-700"><%= pos %></td>
              <td class="py-4 pr-4">
                <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold <%= pillClass %>"
                      style="background-image:<%= pillGrad %>;">
                  <%= st != null ? st.name() : "" %>
                </span>
              </td>
              <td class="py-4 pr-4">
                <div class="flex flex-wrap gap-2">
                  <form method="post" action="<%=request.getContextPath()%>/admin/contesters/status">
                    <input type="hidden" name="contesterId" value="<%= c.getId() %>"/>
                    <input type="hidden" name="action" value="approve"/>
                    <button type="submit"
                            class="px-4 py-2 rounded-xl bg-[var(--green)] text-white font-semibold disabled:opacity-40 hover:brightness-95 hover:shadow transition duration-200"
                            <%= (st == ContesterStatus.APPROVED) ? "disabled" : "" %>>
                      Approve
                    </button>
                  </form>
                  <form method="post" action="<%=request.getContextPath()%>/admin/contesters/status">
                    <input type="hidden" name="contesterId" value="<%= c.getId() %>"/>
                    <input type="hidden" name="action" value="deny"/>
                    <button type="submit"
                            class="px-4 py-2 rounded-xl bg-white border border-red-200 text-red-700 font-semibold hover:bg-red-50 hover:shadow transition duration-200"
                            <%= (st == ContesterStatus.DENIED) ? "disabled" : "" %>>
                      Deny
                    </button>
                  </form>
                </div>
              </td>
            </tr>
          <%
            }
            if (contesters.isEmpty()) {
          %>
            <tr class="border-t border-gray-100">
              <td colspan="5" class="py-8 text-center text-gray-600">
                No contesters found for the selected filters.
              </td>
            </tr>
          <%
            }
          %>
          </tbody>
        </table>
      </div>
    </div>
  </section>
</main>

</body>
</html>
