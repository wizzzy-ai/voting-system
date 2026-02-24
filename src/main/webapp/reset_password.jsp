<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>
<body>
<div class="container mt-5">
  <h2 class="mb-4">Reset Password</h2>
  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
  <% } %>
  <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
  <% } %>
  <form action="reset-password" method="post">
    <input type="hidden" name="token" value="<%= request.getParameter("token") %>">
    <div class="form-group mb-3">
      <label for="password">New Password</label>
      <input type="password" class="form-control" id="password" name="password" required>
    </div>
    <div class="form-group mb-3">
      <label for="confirmPassword">Confirm Password</label>
      <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
    </div>
    <button type="submit" class="btn btn-primary">Reset Password</button>
  </form>
</div>
</body>
</html>
