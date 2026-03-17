<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="java.time.format.DateTimeFormatter,com.bascode.model.entity.Contester,com.bascode.model.entity.PositionElection,com.bascode.model.entity.User,com.bascode.model.enums.ContesterStatus,com.bascode.model.enums.ElectionStatus" %>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
<%@ include file="/WEB-INF/views/fragment/navbar.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>Contester Dashboard - Voting System</title>
</head>
<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">

<%
  User user = (User) request.getAttribute("user");
  Contester contester = (Contester) request.getAttribute("contester");
  PositionElection pe = (PositionElection) request.getAttribute("positionElection");
  long contesterVotes = request.getAttribute("contesterVotes") != null ? (Long) request.getAttribute("contesterVotes") : 0L;
  boolean hasVoted = request.getAttribute("hasVoted") != null && (Boolean) request.getAttribute("hasVoted");

  String name = user != null ? (user.getFirstName() + " " + user.getLastName()) : "Contester";
  String position = contester != null && contester.getPosition() != null ? contester.getPosition().name().replace('_',' ') : "—";
  String status = contester != null && contester.getStatus() != null ? contester.getStatus().name() : "PENDING";
  boolean approved = "APPROVED".equalsIgnoreCase(status);
  boolean winner = contester != null && contester.isWinner();

  String electionStatus = pe != null && pe.getStatus() != null ? pe.getStatus().name() : "NOT_STARTED";
  boolean electionActive = "ACTIVE".equalsIgnoreCase(electionStatus) && pe != null && pe.isVotingOpen();

  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a");
%>

<section class="max-w-5xl mx-auto pt-28 px-4 pb-12">
  <div class="bg-white/90 backdrop-blur rounded-3xl shadow-xl p-6 md:p-8 border border-gray-100">
    <div class="flex items-start justify-between gap-4">
      <div>
        <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Welcome, <%= name %></h1>
        <p class="text-gray-600 mt-1">Track your contest status and election progress.</p>
      </div>
      <div class="hidden md:block w-12 h-12 rounded-2xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] shadow-lg"></div>
    </div>

    <div class="mt-6 grid grid-cols-1 md:grid-cols-3 gap-4">
      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5">
        <div class="text-xs font-bold tracking-widest text-gray-500">POSITION</div>
        <div class="mt-2 text-lg font-bold text-gray-900"><%= position %></div>
        <div class="mt-2">
          <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold
            <%= approved ? "text-green-800" : ("DENIED".equalsIgnoreCase(status) ? "text-red-800" : "text-amber-800") %>"
            style="background-image:<%= approved
                ? "linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85))"
                : ("DENIED".equalsIgnoreCase(status)
                    ? "linear-gradient(135deg, rgba(254,202,202,.85), rgba(255,228,230,.85))"
                    : "linear-gradient(135deg, rgba(253,230,138,.85), rgba(254,215,170,.85))") %>;">
            <%= status %>
          </span>
        </div>
      </div>
      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5">
        <div class="text-xs font-bold tracking-widest text-gray-500">ELECTION</div>
        <div class="mt-2 text-lg font-bold text-gray-900"><%= electionStatus %></div>
        <div class="mt-2">
          <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold
            <%= electionActive ? "text-green-800" : "text-red-800" %>"
            style="background-image:<%= electionActive
                ? "linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85))"
                : "linear-gradient(135deg, rgba(254,202,202,.85), rgba(255,228,230,.85))" %>;">
            <%= electionActive ? "VOTING OPEN" : "VOTING CLOSED" %>
          </span>
        </div>
      </div>
      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5">
        <div class="text-xs font-bold tracking-widest text-gray-500">YOUR VOTES</div>
        <div class="mt-2 text-3xl font-extrabold text-gray-900"><%= contesterVotes %></div>
        <div class="mt-2">
          <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold
            <%= winner ? "text-green-800" : "text-gray-700" %>"
            style="background-image:<%= winner
                ? "linear-gradient(135deg, rgba(187,247,208,.85), rgba(220,252,231,.85))"
                : "linear-gradient(135deg, rgba(229,231,235,.9), rgba(243,244,246,.9))" %>;">
            <%= winner ? "WINNER" : "IN PROGRESS" %>
          </span>
        </div>
      </div>
    </div>

    <div class="mt-6 grid grid-cols-1 md:grid-cols-3 gap-6">
      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5 hover:shadow-md transition">
        <h2 class="text-lg font-bold text-gray-900">Vote for Yourself</h2>
        <p class="mt-2 text-sm text-gray-600">As a contester, you can vote for yourself once.</p>
        <a href="<%=request.getContextPath()%>/vote"
           class="mt-4 inline-flex px-4 py-2 rounded-xl bg-[var(--green)] text-white font-semibold hover:brightness-95 transition <%= (approved && electionActive && !hasVoted) ? "" : "opacity-50 pointer-events-none" %>">
          <%= (approved && electionActive && !hasVoted) ? "Go to Voting" : "Unavailable" %>
        </a>
      </div>
      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5 hover:shadow-md transition">
        <h2 class="text-lg font-bold text-gray-900">View Results</h2>
        <p class="mt-2 text-sm text-gray-600">See the live vote breakdown.</p>
        <a href="<%=request.getContextPath()%>/results"
           class="mt-4 inline-flex px-4 py-2 rounded-xl bg-gradient-to-r from-[var(--purple-light)] to-[var(--purple)] text-white font-semibold hover:brightness-95 transition">
          View Results
        </a>
      </div>
      <div class="rounded-2xl border border-gray-100 bg-gradient-to-r from-white to-gray-50 p-5 hover:shadow-md transition">
        <h2 class="text-lg font-bold text-gray-900">Support Chat</h2>
        <p class="mt-2 text-sm text-gray-600">Message the admin anytime.</p>
        <a href="<%=request.getContextPath()%>/support"
           class="mt-4 inline-flex px-4 py-2 rounded-xl bg-white border border-gray-200 text-gray-800 font-semibold hover:shadow transition">
          Open Support Chat
        </a>
      </div>
    </div>

    <% if (pe != null && pe.getStartTime() != null) { %>
      <div class="mt-6 text-sm text-gray-500">
        Election started at <%= fmt.format(pe.getStartTime()) %>
        <% if (pe.getEndTime() != null) { %>
          and ended at <%= fmt.format(pe.getEndTime()) %>.
        <% } %>
      </div>
    <% } %>
  </div>
</section>
</body>
</html>

