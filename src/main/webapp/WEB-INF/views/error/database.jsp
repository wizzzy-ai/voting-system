<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>
<body class="bg-white text-gray-900">

<section id="db-error" class="py-20">
  <div class="container-custom text-center">
    <h1 class="text-5xl font-extrabold mb-6 text-red-500">Database Error</h1>
    <p class="text-lg text-gray-600 mb-8">
      A system error occurred while processing your request.<br>
      Please contact the administrator.
    </p>


    <!-- Action buttons -->
    <div class="space-x-4">
      <a href="${pageContext.request.contextPath}/"
         class="inline-block bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg transition-colors">
        Back to Home
      </a>
      <a href="mailto:support@mysite.com"
         class="inline-block bg-purple-600 hover:bg-purple-700 text-white font-bold py-3 px-6 rounded-lg transition-colors">
        Contact Support
      </a>
    </div>
  </div>
</section>

</body>
</html>