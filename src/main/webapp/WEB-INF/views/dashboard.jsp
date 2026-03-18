<!DOCTYPE html>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/fragment/head.jsp"%>

<html lang="en">
<head>
<title>Dashboard - Voting System</title>
</head>
<body class="bg-gray-100 min-h-screen">
	<%-- Session validation --%>
	<%
	Object user = null;
	// Try to get user object from session
	if (session.getAttribute("user") != null) {
		user = session.getAttribute("user");
	} else if (session.getAttribute("userId") != null) {
		// Optionally, fetch user from DB using userId
		// For now, just allow access if userId is present
		user = session.getAttribute("userId");
	}
	if (user == null) {
		response.sendRedirect("login.jsp");
		return;
	}
	%>
	

	<%@ include file="/WEB-INF/views/fragment/contactButton.jsp"%>
	<%@ include file="/WEB-INF/views/fragment/bottomNavVoter.jsp"%>
	<section>

		<header
			class="bg-white px-2 py-4 flex items-center justify-between border-b border-gray-100">
			<div class="flex items-center gap-2">
				<a href="${pageContext.request.contextPath}/"> <img alt="Logo"
					class="cursor-pointer lg:h-[35px] lg:w-[200px] h-[35px] w-[130px]"
					src="${pageContext.request.contextPath}/images/logos/logoShort.png">
				</a>
			</div>

			<div class="flex items-center gap-6">
				<div class="relative group cursor-pointer">
					<div
						class="absolute -top-0.5 -right-0.5 w-3 h-3 bg-[red] rounded-full"></div>
					<svg xmlns="http://www.w3.org/2000/svg"
						class="w-8 h-8 text-gray-700"
						fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round"
							stroke-width="2"
							d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
      </svg>
				</div>

				<div class="flex items-center gap-3">
					<div class="text-right leading-none">
						<p
							class="text-[11px] font-black text-black uppercase ">
							<%=session.getAttribute("firstName")%>
							<%=session.getAttribute("lastName")%>
						</p>
						<p class="text-[10px] text-gray-400 mt-1">
							<%=session.getAttribute("userEmail")%>
						</p>
					</div>

				</div>
			</div>
		</header>

		<main class="max-w-5xl mx-auto px-8 py-10">

			<section class="mb-12 relative">
				<div
					class="absolute -top-4 -left-6 w-16 h-16 border-t-2 border-l-2 border-[#50C87820] -skew-x-12"></div>

				<p
					class="text-[#6A0DAD] text-xs font-bold uppercase tracking-[0.4em] mb-3">Session
					Active // 2026</p>
				<h1 class="text-4xl font-light text-gray-900 tracking-tight">
					Welcome,
					 <span class="font-black italic">
					 <%=session.getAttribute("firstName")%>
					</span>.
				</h1>
				<p
					class="text-gray-500 mt-3 text-lg border-l border-gray-200 pl-4 italic">
					Your dashboard is current. <span class="text-[#50C878] font-bold">3
						elections</span> require your attention.
				</p>
			</section>

			<div
				class="grid grid-cols-1 md:grid-cols-3 gap-0 border border-gray-100 rounded-sm overflow-hidden shadow-sm">

				<div
					class="p-8 bg-white border-r border-gray-100 hover:bg-gray-50 transition-colors group">
					<div class="flex items-baseline gap-2">
						<span
							class="text-4xl font-black text-gray-900 group-hover:text-[#6A0DAD] transition-colors">0</span>
						<span class="text-[10px] font-bold text-[#50C878] uppercase">
							NEW</span>
					</div>
					<p
						class="text-[11px] font-bold text-gray-400 uppercase tracking-widest mt-2">Active
						Ballots</p>
					<div
						class="w-8 h-[1px] bg-[#50C878] mt-4 transform -rotate-45 origin-left opacity-50"></div>
				</div>

				<div
					class="p-8 bg-white border-r border-gray-100 hover:bg-gray-50 transition-colors group">
					<div class="flex items-baseline gap-2">
						<span
							class="text-4xl font-black text-gray-900 group-hover:text-[#6A0DAD] transition-colors">0</span>
						<span class="text-[10px] font-bold text-gray-400 uppercase">TOTAL</span>
					</div>
					<p
						class="text-[11px] font-bold text-gray-400 uppercase tracking-widest mt-2">Votes
						Cast</p>
					<div
						class="w-8 h-[1px] bg-[#6A0DAD] mt-4 transform -rotate-45 origin-left opacity-50"></div>
				</div>

				<div class="p-8 bg-white hover:bg-gray-50 transition-colors group">
					<div class="flex items-baseline gap-2">
						<span
							class="text-4xl font-black text-gray-900 group-hover:text-red-500 transition-colors">07</span>
						<span class="text-[10px] font-bold text-red-400 uppercase">DAYS</span>
					</div>
					<p
						class="text-[11px] font-bold text-gray-400 uppercase tracking-widest mt-2">To
						Deadline</p>
					<div
						class="w-8 h-[1px] bg-red-400 mt-4 transform -rotate-45 origin-left opacity-50"></div>
				</div>
			</div>


		</main>
	</section>
</body>
</html>
