<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.User,com.bascode.model.enums.Role" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Admin - Users</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">

<%
  @SuppressWarnings("unchecked")
  List<User> users = (List<User>) request.getAttribute("users");
  if (users == null) users = Collections.emptyList();

  String selectedRole = (String) request.getAttribute("selectedRole");
  String selectedVerified = (String) request.getAttribute("selectedVerified");
  if (selectedRole == null) selectedRole = "";
  if (selectedVerified == null) selectedVerified = "";
%>

<header class="sticky top-0 z-10">
  <div class="glass">
    <div class="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] soft-glow"></div>
        <div>
          <h1 class="text-xl md:text-2xl font-extrabold text-gray-900 tracking-tight">User Management</h1>
          <p class="text-sm text-gray-600">View registered voters, contesters, and admins.</p>
        </div>
      </div>
      <div class="flex items-center gap-2">
        <a href="<%=request.getContextPath()%>/admin/dashboard"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Admin Dashboard
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

  <section class="rise-in glass rounded-3xl p-5 md:p-6 soft-glow">
    <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
      <div>
        <h2 class="text-lg font-bold text-gray-900">Filters</h2>
        <p class="text-sm text-gray-600">Narrow by role or verification status.</p>
      </div>
      <form method="get" action="<%=request.getContextPath()%>/admin/users" class="flex flex-col sm:flex-row gap-3">
        <div class="flex flex-col">
          <label class="text-xs font-semibold text-gray-700 mb-1">Role</label>
          <select name="role"
                  class="px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] transition">
            <option value="" <%= selectedRole.isEmpty() ? "selected" : "" %>>All</option>
            <%
              for (Role r : Role.values()) {
                String v = r.name();
            %>
              <option value="<%= v %>" <%= v.equalsIgnoreCase(selectedRole) ? "selected" : "" %>><%= v %></option>
            <%
              }
            %>
          </select>
        </div>
        <div class="flex flex-col">
          <label class="text-xs font-semibold text-gray-700 mb-1">Verified</label>
          <select name="verified"
                  class="px-4 py-2 rounded-xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] transition">
            <option value="" <%= selectedVerified.isEmpty() ? "selected" : "" %>>All</option>
            <option value="true" <%= "true".equalsIgnoreCase(selectedVerified) ? "selected" : "" %>>Verified</option>
            <option value="false" <%= "false".equalsIgnoreCase(selectedVerified) ? "selected" : "" %>>Not verified</option>
          </select>
        </div>
        <div class="flex items-end gap-2">
          <button type="submit"
                  class="px-5 py-2 rounded-xl bg-gradient-to-r from-[var(--green)] to-emerald-600 text-white font-semibold hover:brightness-95 hover:shadow transition duration-200">
            Apply
          </button>
          <a href="<%=request.getContextPath()%>/admin/users"
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
        <h2 class="text-lg font-bold text-gray-900">Users</h2>
        <p class="text-sm text-gray-600"><%= users.size() %> record(s)</p>
      </div>
      <div class="flex gap-2">
        <a href="<%=request.getContextPath()%>/admin/contesters"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Contesters
        </a>
        <a href="<%=request.getContextPath()%>/admin/results"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Results
        </a>
      </div>
    </div>

    <div class="mt-5 overflow-x-auto">
      <table class="w-full text-sm">
        <thead>
          <tr class="text-left text-gray-600">
            <th class="py-3 pr-4">Name</th>
            <th class="py-3 pr-4">Email</th>
            <th class="py-3 pr-4">Role</th>
            <th class="py-3 pr-4">Verified</th>
            <th class="py-3 pr-4">Location</th>
          </tr>
        </thead>
        <tbody>
        <%
          int i = 0;
          for (User u : users) {
            i++;
            String fullName = (u.getFirstName() + " " + u.getLastName());
            String email = u.getEmail();
            String role = u.getRole() != null ? u.getRole().name() : "";
            boolean verified = u.isEmailVerified();
            String location = (u.getState() != null ? u.getState() : "") + (u.getCountry() != null ? (", " + u.getCountry()) : "");

            String rolePillClass = "text-gray-800";
            String rolePillGrad = "linear-gradient(135deg, rgba(229,231,235,.9), rgba(243,244,246,.9))";
            if ("ADMIN".equalsIgnoreCase(role)) {
              rolePillClass = "text-white";
              rolePillGrad = "linear-gradient(135deg, var(--purple), rgba(106,13,173,.75))";
            } else if ("CONTESTER".equalsIgnoreCase(role)) {
              rolePillClass = "text-white";
              rolePillGrad = "linear-gradient(135deg, var(--green), rgba(16,185,129,.75))";
            }
        %>
          <tr class="rise-in border-t border-gray-100 hover:bg-white/60 transition"
              style="animation-delay: <%= Math.min(0.6, i * 0.02) %>s;">
            <td class="py-4 pr-4 font-semibold text-gray-900"><%= fullName %></td>
            <td class="py-4 pr-4 text-gray-700"><%= email %></td>
            <td class="py-4 pr-4">
              <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold <%= rolePillClass %>"
                    style="background-image:<%= rolePillGrad %>;">
                <%= role %>
              </span>
            </td>
            <td class="py-4 pr-4">
              <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold <%= verified ? "text-green-800" : "text-red-800" %>"
                    style="background-image:<%= verified ? "linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85))"
                                                   : "linear-gradient(135deg, rgba(254,202,202,.85), rgba(255,228,230,.85))" %>;">
                <%= verified ? "VERIFIED" : "NOT VERIFIED" %>
              </span>
            </td>
            <td class="py-4 pr-4 text-gray-700"><%= location %></td>
          </tr>
        <%
          }
          if (users.isEmpty()) {
        %>
          <tr class="border-t border-gray-100">
            <td colspan="5" class="py-8 text-center text-gray-600">
              No users found for the selected filters.
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
