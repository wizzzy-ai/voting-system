<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.bascode.model.entity.Contester, com.bascode.model.enums.Position, com.bascode.model.entity.PositionElection, com.bascode.model.enums.ElectionStatus" %>
<html lang="en">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
    <title>Vote - WeVote</title>
    <style>
      @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
      .fade-up { animation: fadeUp .5s ease-out both; }
      .position-card { transition: all 0.3s ease; }
      .position-card:hover { transform: translateY(-2px); }
      .candidate-card { transition: all 0.2s ease; }
      .candidate-card:hover { background-color: rgba(124, 58, 237, 0.05); }
      .candidate-radio:checked + .candidate-card { background-color: rgba(124, 58, 237, 0.1); border-color: var(--purple); }
      .candidate-radio:checked + .candidate-card .check-icon { opacity: 1; }
      .position-card.is-disabled { opacity: 0.58; background: linear-gradient(180deg, rgba(243, 244, 246, 0.92), rgba(229, 231, 235, 0.92)); }
      .position-card.is-disabled:hover { transform: none; }
      .position-card.is-disabled .candidate-card { cursor: not-allowed; background-color: rgba(243, 244, 246, 0.9); border-color: #d1d5db; }
      .position-card.is-disabled .candidate-card:hover { background-color: rgba(243, 244, 246, 0.9); }
    </style>
</head>

<body class="min-h-screen bg-gradient-to-b from-gray-50 via-white to-gray-100">
    <%@ include file="/WEB-INF/views/fragment/quickNav.jsp" %>
    <% 
      @SuppressWarnings("unchecked")
      Map<Position, List<Contester>> candidatesByPosition = (Map<Position, List<Contester>>) request.getAttribute("candidatesByPosition");
      @SuppressWarnings("unchecked")
      Map<Position, PositionElection> electionsByPosition = (Map<Position, PositionElection>) request.getAttribute("electionsByPosition");
      @SuppressWarnings("unchecked")
      Map<Position, String> deadlineInfo = (Map<Position, String>) request.getAttribute("deadlineInfo");
      @SuppressWarnings("unchecked")
      Set<Position> votedPositions = (Set<Position>) request.getAttribute("votedPositions");
      if (votedPositions == null) votedPositions = new HashSet<>();
      Position userPosition = (Position) request.getAttribute("userPosition");
      Boolean isContester = (Boolean) request.getAttribute("isContester");
      String error = (String) request.getAttribute("error");
      String success = (String) request.getAttribute("success");
    %>
    <section class="max-w-5xl mx-auto pt-28 px-4 pb-14">
        <div class="fade-up bg-white/90 backdrop-blur rounded-3xl shadow-xl p-6 md:p-8 border border-gray-100">
            <div class="flex items-start justify-between gap-4">
              <div>
                <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 tracking-tight">Cast Your Vote</h1>
                <p class="text-gray-600 mt-1">You can vote once per position. Select your preferred candidate for each position.</p>
              </div>
              <div class="hidden md:block w-12 h-12 rounded-2xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] shadow-lg"></div>
            </div>

            <% if (error != null) { %>
                <div class="mt-6 rounded-2xl p-4 border bg-red-50 border-red-200 text-red-800">
                  <div class="font-semibold"><%= error %></div>
                </div>
            <% } %>
            <% if (success != null) { %>
                <div class="mt-6 rounded-2xl p-4 border bg-green-50 border-green-200 text-green-800">
                  <div class="font-semibold"><%= success %></div>
                </div>
            <% } %>
            
            <% if (isContester != null && isContester) { %>
              <div class="mt-6 rounded-2xl p-4 border bg-blue-50 border-blue-200 text-blue-800">
                <div class="font-semibold mb-1">Contester Voting Rights</div>
                <div class="text-sm">
                  As a contester for <strong><%= userPosition != null ? userPosition.name().replace("_", " ") : "your position" %></strong>, 
                  you can vote once in every position, and for your own position you can only vote for yourself.
                </div>
              </div>
            <% } %>

            <form action="<%=request.getContextPath()%>/submit-vote" method="post" class="mt-8 space-y-6">
                <% if (candidatesByPosition != null && !candidatesByPosition.isEmpty()) {
                    boolean hasVotablePosition = false;
                    for (Map.Entry<Position, List<Contester>> entry : candidatesByPosition.entrySet()) {
                        Position pos = entry.getKey();
                        List<Contester> candidates = entry.getValue();
                        PositionElection election = electionsByPosition != null ? electionsByPosition.get(pos) : null;
                        String posName = pos.name().replace("_", " ");
                        String deadline = deadlineInfo != null ? deadlineInfo.get(pos) : null;
                        boolean isActive = election != null && election.getStatus() == ElectionStatus.ACTIVE;
                        boolean isVotingOpen = election != null && election.isVotingOpen();
                        boolean isEnded = election != null && election.getStatus() == ElectionStatus.ENDED;
                        boolean isNotStarted = election != null && election.getStatus() == ElectionStatus.NOT_STARTED;
                        boolean isUserOwnPosition = pos == userPosition;
                        boolean hasVotedForPosition = votedPositions.contains(pos);
                        boolean canVote = isActive && isVotingOpen && !candidates.isEmpty() && !hasVotedForPosition;
                        if (canVote) hasVotablePosition = true;
                %>
                <div class="position-card <%= hasVotedForPosition ? "is-disabled" : "bg-gray-50/80" %> rounded-2xl border border-gray-200 overflow-hidden">
                    <div class="px-5 py-4 bg-white border-b border-gray-200 flex flex-wrap items-center justify-between gap-3">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-[var(--purple)] to-[var(--green)] flex items-center justify-center text-white font-bold text-sm"><%= posName.substring(0, Math.min(2, posName.length())).toUpperCase() %></div>
                            <div>
                                <h3 class="font-bold text-gray-900 text-lg"><%= posName %></h3>
                                <% if (deadline != null && isActive && isVotingOpen) { %><p class="text-sm text-amber-600 font-medium"><%= deadline %></p><% } %>
                            </div>
                        </div>
                        <div class="flex items-center gap-2">
                            <% if (hasVotedForPosition) { %><span class="px-3 py-1 rounded-full text-xs font-semibold bg-slate-200 text-slate-700 border border-slate-300">Voted</span>
                            <% } %>
                            <% if (isUserOwnPosition) { %><span class="px-3 py-1 rounded-full text-xs font-semibold bg-gray-100 text-gray-600 border border-gray-300">Your Position</span>
                            <% } else if (isEnded) { %><span class="px-3 py-1 rounded-full text-xs font-semibold bg-gray-100 text-gray-600 border border-gray-300">Ended</span>
                            <% } else if (isNotStarted) { %><span class="px-3 py-1 rounded-full text-xs font-semibold bg-amber-50 text-amber-700 border border-amber-200">Not Started</span>
                            <% } else if (!isVotingOpen) { %><span class="px-3 py-1 rounded-full text-xs font-semibold bg-red-50 text-red-700 border border-red-200">Closed</span>
                            <% } else if (isActive && isVotingOpen) { %><span class="px-3 py-1 rounded-full text-xs font-semibold bg-green-50 text-green-700 border border-green-200">Open</span><% } %>
                        </div>
                    </div>
                    <div class="p-5">
                        <%
                            Contester selfCandidate = null;
                            if (isUserOwnPosition && candidates != null) {
                                Object sessionUserId = session != null ? session.getAttribute("userId") : null;
                                for (Contester c : candidates) {
                                    if (c.getUser() != null && c.getUser().getId() != null && c.getUser().getId().equals(sessionUserId)) {
                                        selfCandidate = c;
                                        break;
                                    }
                                }
                            }
                        %>
                        <% if (isUserOwnPosition && selfCandidate != null) {
                            String initials = "";
                            if (selfCandidate.getUser() != null) {
                                String firstName = selfCandidate.getUser().getFirstName();
                                String lastName = selfCandidate.getUser().getLastName();
                                if (firstName != null && !firstName.isEmpty()) initials += firstName.charAt(0);
                                if (lastName != null && !lastName.isEmpty()) initials += lastName.charAt(0);
                            }
                            initials = initials.toUpperCase();
                        %>
                            <div class="max-w-md mx-auto">
                                <p class="text-sm text-gray-600 mb-4 text-center">
                                    <%= hasVotedForPosition ? "You have already used your vote for this position." : "You are contesting for this position. You can only vote for yourself." %>
                                </p>
                                <label class="<%= hasVotedForPosition ? "cursor-not-allowed" : "cursor-pointer" %> block">
                                    <input type="radio" name="candidateId" value="<%= selfCandidate.getId() %>" class="candidate-radio sr-only" <%= hasVotedForPosition ? "disabled" : "required" %>>
                                    <div class="candidate-card flex items-center gap-3 p-4 bg-white rounded-xl border-2 border-[var(--purple)] hover:border-[var(--purple-dark)] transition-all">
                                        <div class="w-12 h-12 rounded-full bg-gradient-to-br from-[var(--purple)] to-[var(--green)] flex items-center justify-center text-white font-bold text-sm shrink-0"><%= initials.isEmpty() ? "?" : initials %></div>
                                        <div class="flex-1 min-w-0">
                                            <p class="font-semibold text-gray-900 truncate"><%= selfCandidate.getUser() != null ? selfCandidate.getUser().getFirstName() + " " + selfCandidate.getUser().getLastName() : "Unknown" %></p>
                                            <p class="text-xs text-[var(--purple)] font-medium mt-0.5"><%= hasVotedForPosition ? "Vote already used" : "Vote for Yourself" %></p>
                                        </div>
                                        <div class="check-icon opacity-0 transition-opacity text-[var(--purple)]">
                                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                                        </div>
                                    </div>
                                </label>
                            </div>
                        <% } else if (isUserOwnPosition) { %>
                            <div class="text-center py-8 text-gray-500"><p class="text-sm">You are contesting for this position but are not an approved candidate. Self-voting is unavailable.</p></div>
                        <% } else if (hasVotedForPosition) { %>
                            <div class="text-center py-8 text-gray-500">
                                <p class="text-sm font-medium text-gray-700">You have already voted for this position.</p>
                                <p class="text-xs text-gray-500 mt-1">This section is now locked to prevent duplicate votes.</p>
                            </div>
                        <% } else if (!isActive || !isVotingOpen) { %>
                            <div class="text-center py-8 text-gray-500"><p class="text-sm">Voting is currently not available for this position.</p></div>
                        <% } else if (candidates == null || candidates.isEmpty()) { %>
                            <div class="text-center py-8 text-gray-500"><p class="text-sm">No approved candidates available.</p></div>
                        <% } else { %>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <% for (Contester candidate : candidates) { 
                                    String initials = "";
                                    if (candidate.getUser() != null) {
                                        String firstName = candidate.getUser().getFirstName();
                                        String lastName = candidate.getUser().getLastName();
                                        if (firstName != null && !firstName.isEmpty()) initials += firstName.charAt(0);
                                        if (lastName != null && !lastName.isEmpty()) initials += lastName.charAt(0);
                                    }
                                    initials = initials.toUpperCase();
                                %>
                                <label class="<%= hasVotedForPosition ? "cursor-not-allowed" : "cursor-pointer" %> block">
                                    <input type="radio" name="candidateId" value="<%= candidate.getId() %>" class="candidate-radio sr-only" <%= hasVotedForPosition ? "disabled" : "required" %>>
                                    <div class="candidate-card flex items-center gap-3 p-4 bg-white rounded-xl border border-gray-200 hover:border-[var(--purple-light)] transition-all">
                                        <div class="w-12 h-12 rounded-full bg-gradient-to-br from-[var(--purple)] to-[var(--green)] flex items-center justify-center text-white font-bold text-sm shrink-0"><%= initials.isEmpty() ? "?" : initials %></div>
                                        <div class="flex-1 min-w-0">
                                            <p class="font-semibold text-gray-900 truncate"><%= candidate.getUser() != null ? candidate.getUser().getFirstName() + " " + candidate.getUser().getLastName() : "Unknown" %></p>
                                            <% if (candidate.getManifesto() != null && !candidate.getManifesto().trim().isEmpty()) { %><p class="text-xs text-gray-500 truncate mt-0.5"><%= candidate.getManifesto() %></p><% } %>
                                        </div>
                                        <div class="check-icon opacity-0 transition-opacity text-[var(--purple)]">
                                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                                        </div>
                                    </div>
                                </label>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                </div>
                <% } if (hasVotablePosition) { %>
                <div class="flex flex-wrap gap-3 pt-4">
                  <button type="submit" class="px-8 py-4 rounded-2xl bg-gradient-to-r from-[var(--green)] to-emerald-600 text-white font-bold text-lg hover:brightness-95 hover:shadow-lg transition duration-200">Submit Vote</button>
                  <a href="<%=request.getContextPath()%>/results" class="px-6 py-4 rounded-2xl bg-white border border-gray-200 text-gray-800 font-semibold hover:shadow transition duration-200 flex items-center">View Results</a>
                </div>
                <% } else { %>
                <div class="text-center py-8"><p class="text-gray-600 mb-4">No positions are currently available for voting.</p><a href="<%=request.getContextPath()%>/results" class="inline-flex px-6 py-3 rounded-2xl bg-white border border-gray-200 text-gray-800 font-semibold hover:shadow transition duration-200">View Results</a></div>
                <% } } else { %>
                <div class="text-center py-12"><p class="text-gray-600">No election positions configured.</p></div>
                <% } %>
            </form>
        </div>
        <% String role = session != null ? (String) session.getAttribute("userRole") : null;
           if ("CONTESTER".equalsIgnoreCase(role)) { %><%@ include file="/WEB-INF/views/fragment/bottomNavContester.jsp" %><% } else { %><%@ include file="/WEB-INF/views/fragment/bottomNavVoter.jsp" %><% } %>
    </section>
</body>
</html>
