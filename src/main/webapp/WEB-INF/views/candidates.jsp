<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.bascode.model.entity.Contester,com.bascode.model.entity.User" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<html lang="en">
<head>
    <title>Candidates - Voting System</title>
    <style>
      @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
      .fade-up { animation: fadeUp .5s ease-out both; }
    </style>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">
<%
  @SuppressWarnings("unchecked")
  List<Contester> contesters = (List<Contester>) request.getAttribute("contesters");
  if (contesters == null) contesters = Collections.emptyList();
%>

    <section class="max-w-3xl mx-auto pt-28 px-4 pb-14">
        <div class="fade-up bg-white/90 backdrop-blur rounded-3xl shadow-xl p-6 md:p-8 border border-gray-100">
            <div class="flex items-start justify-between gap-4">
              <div>
                <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Approved Contesters</h1>
                <p class="text-gray-600 mt-1">Browse contesters and the positions they are contesting for.</p>
              </div>
              <img alt="logo" src="${pageContext.request.contextPath}/images/logos/fingerPrint.png" class="justify-center w-12 h-12">
            </div>

            <div class="mt-6 space-y-4">
              <%
                int i = 0;
                for (Contester c : contesters) {
                  i++;
                  User u = c.getUser();
                  String fullName = (u != null ? (u.getFirstName() + " " + u.getLastName()) : "(no user)");
                  String position = (c.getPosition() != null ? c.getPosition().name().replace('_',' ') : "");
              %>
                <div class="fade-up rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5 hover:shadow-md transition duration-200"
                     style="animation-delay:<%= Math.min(0.7, i * 0.04) %>s;">
                  <div class="flex items-start justify-between gap-4">
                    <div>
                      <h2 class="text-lg font-bold text-gray-900"><%= fullName %></h2>
                      <p class="text-gray-600 mt-1">Position: <span class="font-semibold text-gray-800"><%= position %></span></p>
                    </div>
                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold text-white"
                          style="background: linear-gradient(135deg, var(--purple), var(--green));">
                      Candidate
                    </span>
                  </div>
                </div>
              <%
                }
                if (contesters.isEmpty()) {
              %>
                <div class="fade-up rounded-2xl border border-gray-100 bg-gray-50 p-6 text-center text-gray-700">
                  No approved contesters yet.
                  <div class="text-sm text-gray-500 mt-2">If you are an admin, approve contesters in the admin dashboard.</div>
                </div>
              <%
                }
              %>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/fragment/bottomNavVoter.jsp" %>
    </section>
</body>
</html>
