<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/fragment/head.jsp" %>
</head>
<body>
<div class="container mt-5">
  <h2 class="mb-4">Forgot Password</h2>
  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
  <% } %>
  <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
  <% } %>
  <form action="forgot-password" method="post">
    <div class="form-group mb-3">
      <label for="email">Email</label>
      <input type="email" class="form-control" id="email" name="email" required>
    </div>
    <button type="submit" class="btn btn-primary">Send Reset Link</button>
  </form>
</div>
</body>
</html>
