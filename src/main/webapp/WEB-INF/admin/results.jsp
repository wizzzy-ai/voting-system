<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.bascode.model.entity.Contester,com.bascode.model.entity.User" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Admin - Results</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css">
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">

<%
  @SuppressWarnings("unchecked")
  List<Object[]> rows = (List<Object[]>) request.getAttribute("rows");
  if (rows == null) rows = Collections.emptyList();

  long totalVotes = request.getAttribute("totalVotes") != null ? (Long) request.getAttribute("totalVotes") : 0L;
  long approvedCandidates = request.getAttribute("approvedCandidates") != null ? (Long) request.getAttribute("approvedCandidates") : 0L;
%>

<header class="sticky top-0 z-10">
  <div class="glass">
    <div class="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] soft-glow"></div>
        <div>
          <h1 class="text-xl md:text-2xl font-extrabold text-gray-900 tracking-tight">Results</h1>
          <p class="text-sm text-gray-600">Approved candidates and current vote counts.</p>
        </div>
      </div>
      <div class="flex items-center gap-2">
        <a href="<%=request.getContextPath()%>/admin/dashboard"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Admin Dashboard
        </a>
        <a href="<%=request.getContextPath()%>/admin/messages"
           class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
          Messages
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
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
      <div>
        <h2 class="text-lg font-bold text-gray-900">Summary</h2>
        <p class="text-sm text-gray-600">Votes update as users submit ballots.</p>
      </div>
      <div class="flex flex-wrap gap-2">
        <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-green-800"
              style="background-image:linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85));">
          Total votes: <%= totalVotes %>
        </span>
        <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-gray-800"
              style="background-image:linear-gradient(135deg, rgba(229,231,235,.9), rgba(243,244,246,.9));">
          Approved candidates: <%= approvedCandidates %>
        </span>
      </div>
    </div>
  </section>

  <section class="mt-6 rise-in glass rounded-3xl p-5 md:p-6 soft-glow" style="animation-delay:.05s;">
    <div class="flex items-center justify-between gap-4">
      <div>
        <h2 class="text-lg font-bold text-gray-900">Vote Counts</h2>
        <p class="text-sm text-gray-600">Sorted by position, then votes (desc).</p>
      </div>
      <a href="<%=request.getContextPath()%>/admin/results"
         class="px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 hover:shadow transition duration-200">
        Refresh
      </a>
    </div>

    <div class="mt-5 overflow-x-auto">
      <table class="admin-table w-full text-sm">
        <thead>
          <tr class="text-left text-gray-600">
            <th class="py-3 pr-4">Candidate</th>
            <th class="py-3 pr-4">Position</th>
            <th class="py-3 pr-4">Votes</th>
          </tr>
        </thead>
        <tbody>
        <%
          int i = 0;
          for (Object[] r : rows) {
            i++;
            Contester c = (Contester) r[0];
            Long votes = (Long) r[1];
            User u = c != null ? c.getUser() : null;
            String fullName = (u != null ? (u.getFirstName() + " " + u.getLastName()) : "(no user)");
            String pos = (c != null && c.getPosition() != null) ? c.getPosition().name().replace('_',' ') : "";
        %>
          <tr class="rise-in border-t border-gray-100 hover:bg-white/60 transition"
              style="animation-delay: <%= Math.min(0.6, i * 0.02) %>s;">
            <td class="py-4 pr-4 font-semibold text-gray-900"><%= fullName %></td>
            <td class="py-4 pr-4 text-gray-700"><%= pos %></td>
            <td class="py-4 pr-4">
              <span class="pill inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-white"
                    style="background-image:linear-gradient(135deg, var(--purple), var(--green));">
                <%= votes != null ? votes : 0 %>
              </span>
            </td>
          </tr>
        <%
          }
          if (rows.isEmpty()) {
        %>
          <tr class="border-t border-gray-100">
            <td colspan="3" class="py-8 text-center text-gray-600">
              No approved candidates yet.
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
