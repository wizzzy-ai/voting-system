<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
    <title>Login - WeVote</title>
</head>
<body class="min-h-screen bg-slate-50 text-slate-900">
<%@ include file="/WEB-INF/views/fragment/backToHome.jsp" %>

<main class="relative min-h-screen overflow-hidden px-4 py-10">
  <div class="absolute inset-0 bg-[radial-gradient(circle_at_top_right,_rgba(5,150,105,0.14),_transparent_28rem),radial-gradient(circle_at_bottom_left,_rgba(99,102,241,0.12),_transparent_30rem)]"></div>
  <div class="relative mx-auto flex min-h-[calc(100vh-5rem)] max-w-6xl items-center justify-center">
    <div class="grid w-full max-w-5xl overflow-hidden rounded-[28px] border border-slate-200 bg-white shadow-2xl lg:grid-cols-[1.05fr_.95fr]">
      <section class="hidden lg:flex flex-col justify-between bg-slate-900 px-10 py-12 text-white">
        <div>
          <div class="inline-flex items-center gap-3 rounded-full border border-white/10 bg-white/5 px-4 py-2 text-sm font-semibold tracking-[0.22em] text-emerald-200">
            WEVOTE ACCESS
          </div>
          <h1 class="mt-8 max-w-md text-4xl font-black leading-tight">Secure admin and voter access for your election workspace.</h1>
          <p class="mt-4 max-w-lg text-sm leading-7 text-slate-300">
            Session-based login, verified accounts, and role-aware access to ballots, approvals, results, and support threads.
          </p>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div class="rounded-3xl border border-white/10 bg-white/5 p-5">
            <div class="text-3xl font-black text-white">1 vote</div>
            <div class="mt-1 text-sm text-slate-300">Per voter, enforced by the system.</div>
          </div>
          <div class="rounded-3xl border border-white/10 bg-white/5 p-5">
            <div class="text-3xl font-black text-white">3 slots</div>
            <div class="mt-1 text-sm text-slate-300">Maximum approved contesters per position.</div>
          </div>
        </div>
      </section>

      <section class="px-6 py-8 sm:px-10 sm:py-10">
        <div class="mx-auto max-w-md">
          <div class="flex items-center justify-between gap-4">
            <div>
              <div class="text-sm font-semibold uppercase tracking-[0.18em] text-emerald-700">Account Sign In</div>
              <h2 class="mt-2 text-3xl font-black text-slate-900">Welcome back</h2>
              <p class="mt-2 text-sm text-slate-500">Use your verified account to continue.</p>
            </div>
            <div class="hidden h-12 w-12 rounded-2xl bg-emerald-100 sm:flex items-center justify-center text-2xl text-emerald-700">✓</div>
          </div>

          <div class="mt-6 space-y-3">
            <c:if test="${not empty error}">
              <div class="rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">${error}</div>
            </c:if>
            <c:if test="${param.success == '1'}">
              <div class="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-semibold text-emerald-700">
                Email verified successfully. Please sign in.
              </div>
            </c:if>
            <c:if test="${param.suspended == '1'}">
              <div class="rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                Your account has been suspended. Contact the admin for access.
              </div>
            </c:if>
            <c:if test="${param.deleted == '1'}">
              <div class="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-semibold text-emerald-700">
                Your account was deleted successfully.
              </div>
            </c:if>
          </div>

          <form class="mt-6 space-y-5" action="login" method="post">
            <div>
              <label for="email" class="mb-2 block text-sm font-semibold text-slate-700">Email address</label>
              <input type="email" id="email" name="email" required
                     class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-emerald-500 focus:ring-4 focus:ring-emerald-100"
                     placeholder="name@example.com" />
            </div>

            <div>
              <div class="mb-2 flex items-center justify-between gap-3">
                <label for="password" class="block text-sm font-semibold text-slate-700">Password</label>
                <a href="${pageContext.request.contextPath}/forgot-password" class="text-sm font-semibold text-indigo-600 hover:text-indigo-700 hover:underline">Forgot password?</a>
              </div>
              <div class="relative">
                <input type="password" id="password" name="password" required
                       class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 pr-12 text-slate-900 outline-none transition focus:border-emerald-500 focus:ring-4 focus:ring-emerald-100"
                       placeholder="Enter your password" />
                <button type="button"
                        class="absolute right-3 top-1/2 -translate-y-1/2 rounded-lg p-1 text-slate-500 transition hover:bg-slate-100 hover:text-slate-800 focus:outline-none focus:ring-2 focus:ring-emerald-400"
                        aria-label="Show or hide password"
                        data-password-toggle data-target="password">
                  <svg data-icon="show" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="hidden h-5 w-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7z"/>
                    <circle cx="12" cy="12" r="3"/>
                  </svg>
                  <svg data-icon="hide" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M10.7 10.7a3 3 0 0 0 4.24 4.24"/>
                    <path d="M9.88 5.09A10.94 10.94 0 0 1 12 5c6.5 0 10 7 10 7a18.3 18.3 0 0 1-2.32 3.19"/>
                    <path d="M6.61 6.61A16.8 16.8 0 0 0 2 12s3.5 7 10 7a10.6 10.6 0 0 0 4.12-.82"/>
                    <line x1="2" y1="2" x2="22" y2="22"/>
                  </svg>
                </button>
              </div>
            </div>

            <div class="flex items-center justify-between gap-4">
              <label class="inline-flex items-center gap-3 text-sm text-slate-600">
                <input type="checkbox" name="rememberMe" class="h-4 w-4 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500">
                Remember me
              </label>
              <span class="text-xs text-slate-400">Protected session login</span>
            </div>

            <button type="submit"
                    class="w-full rounded-2xl bg-emerald-600 px-5 py-3 text-base font-bold text-white shadow-sm transition hover:bg-emerald-700 focus:outline-none focus:ring-4 focus:ring-emerald-200">
              Sign In
            </button>
          </form>

          <div class="mt-6">
            <div class="relative">
              <div class="absolute inset-0 flex items-center"><div class="w-full border-t border-slate-200"></div></div>
              <div class="relative flex justify-center text-xs font-semibold uppercase tracking-[0.18em] text-slate-400">
                <span class="bg-white px-3">Secondary options</span>
              </div>
            </div>
            <div class="mt-4 w-full">
              <button type="button" class="flex w-full items-center justify-center gap-3 rounded-2xl border border-slate-200 px-4 py-3 text-base font-semibold text-slate-700 transition hover:border-slate-300 hover:bg-slate-50">
                <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-white text-lg font-bold text-slate-700 shadow-sm">G</span>
                <span>Continue with Google</span>
              </button>
            </div>
          </div>

          <p class="mt-8 text-center text-sm text-slate-600">
            Don’t have an account?
            <a href="${pageContext.request.contextPath}/register.jsp" class="font-semibold text-indigo-600 hover:text-indigo-700 hover:underline">Create one</a>
          </p>
        </div>
      </section>
    </div>
  </div>
</main>
</body>
</html>
