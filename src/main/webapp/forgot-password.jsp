<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>
<body class="bg-gray-100">
<main id="content" role="main" class="w-full max-w-md mx-auto p-6">
    <div class="mt-7 bg-white rounded-xl shadow-lg dark:bg-gray-800 dark:border-gray-700 border-2 border-indigo-300">
      <div class="p-4 sm:p-7">
        <div class="text-center">
          <h1 class="block text-2xl font-bold text-gray-800 dark:text-white">Forgot password?</h1>
          <p class="mt-2 text-sm text-gray-600 dark:text-gray-400">
            Remember your password?
            <a class="text-blue-600 decoration-2 hover:underline font-medium" href="${pageContext.request.contextPath}/login.jsp">
              Login here
            </a>
          </p>
        </div>

        <div class="mt-5">
          <form action="forgot-password" method="post">
            <div class="grid gap-y-4">
              <div>
                <label for="email" class="block text-sm font-bold ml-1 mb-2 dark:text-white">Email address</label>
                <div class="relative">
                  <input type="email" id="email" name="email" value="${param.email}" class="py-3 px-4 block w-full border-2 border-gray-200 rounded-md text-sm focus:border-blue-500 focus:ring-blue-500 shadow-sm" required aria-describedby="email-error">
                </div>
                <p class="hidden text-xs text-red-600 mt-2" id="email-error">Please include a valid email address so we can get back to you</p>
              </div>
              <button type="submit" class="py-3 px-4 inline-flex justify-center items-center gap-2 rounded-md border border-transparent font-semibold bg-blue-500 text-white hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm dark:focus:ring-offset-gray-800">Reset password</button>
            </div>
          </form>
        </div>

        <!-- server messages inside the card -->
        <c:if test="${not empty error}">
          <div class="mt-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded">
            ${error}
          </div>
        </c:if>
        <c:if test="${not empty success}">
          <div class="mt-4 p-3 bg-green-50 border border-green-200 text-green-700 rounded">
            ${success}
          </div>
        </c:if>

        <!-- debug reset link (development only) -->
        <c:if test="${not empty debugResetLink}">
          <div class="mt-4 p-3 bg-yellow-50 border border-yellow-200 text-yellow-800 rounded">
            <strong>Development reset link (copy and paste in browser):</strong>
            <div class="break-words mt-2"><a class="text-blue-600 hover:underline" href="${debugResetLink}">${debugResetLink}</a></div>
          </div>
        </c:if>

        <!-- show server-side last error for quick debugging -->
        <c:if test="${not empty applicationScope.lastForgotError}">
          <div class="mt-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded">
            <strong>Last server error:</strong>
            <pre class="whitespace-pre-wrap mt-2">${applicationScope.lastForgotError}</pre>
          </div>
        </c:if>

      </div>
    </div>

    <p class="mt-3 flex justify-center items-center text-center divide-x divide-gray-300 dark:divide-gray-700">
      <a class="pr-3.5 inline-flex items-center gap-x-2 text-sm text-gray-600 decoration-2 hover:underline hover:text-blue-600 dark:text-gray-500 dark:hover:text-gray-200" href="#" target="_blank">
        View Github
      </a>
      <a class="pl-3 inline-flex items-center gap-x-2 text-sm text-gray-600 decoration-2 hover:underline hover:text-blue-600 dark:text-gray-500 dark:hover:text-gray-200" href="#">
        Contact us!
      </a>
    </p>
  </main>

</body>
</html>