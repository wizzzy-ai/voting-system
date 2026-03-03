<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>EMF Diagnostic</title>
  <%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>
<body class="p-6">
  <h1 class="text-2xl font-bold mb-4">EntityManagerFactory Diagnostic</h1>
  <div class="mb-4">
    <strong>EMF available:</strong>
    <%= (application.getAttribute("emf") != null) ? "Yes" : "No" %>
  </div>
  <c:if test="${not empty applicationScope.emfError}">
    <div class="p-4 bg-red-50 border border-red-200 text-red-700 rounded mb-4">
      <strong>Error during EMF initialization:</strong>
      <pre><%= application.getAttribute("emfError") %></pre>
    </div>
  </c:if>
  <c:if test="${not empty applicationScope.lastForgotError}">
    <div class="p-4 bg-red-50 border border-red-200 text-red-700 rounded mb-4">
      <strong>Last forgot-password error (server):</strong>
      <pre><%= application.getAttribute("lastForgotError") %></pre>
    </div>
  </c:if>
  <p class="mt-4">Open <a href="${pageContext.request.contextPath}/forgot-password.jsp">Forgot Password</a> to test the flow.</p>
</body>
</html>