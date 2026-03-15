<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>
<html lang="en">
<head>
    <title>Vote - Voting System</title>
    <style>
      @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
      .fade-up { animation: fadeUp .5s ease-out both; }
    </style>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">
    <section class="max-w-3xl mx-auto pt-28 px-4 pb-14">
        <div class="fade-up bg-white/90 backdrop-blur rounded-3xl shadow-xl p-6 md:p-8 border border-gray-100">
            <div class="flex items-start justify-between gap-4">
              <div>
                <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Cast Your Vote</h1>
                <p class="text-gray-600 mt-1">You can vote only once. Choose carefully.</p>
              </div>
              <div class="hidden md:block w-12 h-12 rounded-2xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] shadow-lg"></div>
            </div>

            <%-- Show error or success messages --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="mt-6 rounded-2xl p-4 border bg-red-50 border-red-200 text-red-800">
                  <div class="font-semibold"><%= request.getAttribute("error") %></div>
                </div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="mt-6 rounded-2xl p-4 border bg-green-50 border-green-200 text-green-800">
                  <div class="font-semibold"><%= request.getAttribute("success") %></div>
                </div>
            <% } %>
            <%
              Object selfVote = request.getAttribute("isContesterSelfVote");
              if (Boolean.TRUE.equals(selfVote)) {
            %>
              <div class="mt-6 rounded-2xl p-4 border bg-amber-50 border-amber-200 text-amber-800">
                As a contester, you can only vote for yourself (once).
              </div>
            <%
              }
            %>

            <form action="<%=request.getContextPath()%>/submit-vote" method="post" class="mt-8">
                <div class="mb-6">
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Select Candidate</label>
                    <select name="candidateId"
                            class="w-full px-4 py-3 rounded-2xl border border-gray-200 bg-white focus:outline-none focus:ring-2 focus:ring-[var(--purple-light)] transition"
                            required>
                        <option value="">-- Choose a candidate --</option>
                        <%-- Dynamically list candidates from servlet (MVC) --%>
                        <%
                            @SuppressWarnings("unchecked")
                            java.util.List<com.bascode.model.entity.Contester> candidates =
                                    (java.util.List<com.bascode.model.entity.Contester>) request.getAttribute("candidates");
                            if (candidates != null) {
                                for (com.bascode.model.entity.Contester candidate : candidates) {
                        %>
                                    <option value="<%= candidate.getId() %>"><%= candidate.getUser().getFirstName() %> <%= candidate.getUser().getLastName() %> - <%= candidate.getPosition() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <%
                      if (candidates == null || candidates.isEmpty()) {
                    %>
                      <div class="mt-3 text-sm text-gray-600">
                        No candidates available right now.
                      </div>
                    <%
                      }
                    %>
                </div>
                <div class="flex flex-wrap gap-3">
                  <button type="submit"
                          class="px-6 py-3 rounded-2xl bg-gradient-to-r from-[var(--green)] to-emerald-600 text-white font-semibold hover:brightness-95 hover:shadow transition duration-200 disabled:opacity-50"
                          <%= (request.getAttribute("candidates") == null || ((java.util.List)request.getAttribute("candidates")).isEmpty()) ? "disabled" : "" %>>
                    Submit Vote
                  </button>
                  <a href="<%=request.getContextPath()%>/results"
                     class="px-6 py-3 rounded-2xl bg-white border border-gray-200 text-gray-800 font-semibold hover:shadow transition duration-200">
                    View Results
                  </a>
                </div>
            </form>
        </div>
    </section>
</body>
</html>
