<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Forgot Password</title>
  <style>
    .error { color: red; }
    .success { color: green; }
    form { max-width: 300px; margin: 20px auto; }
    input { display: block; width: 100%; margin: 10px 0; padding: 8px; }
  </style>
</head>
<body>
<h2>Forgot Password</h2>

<c:if test="${not empty error}">
  <p class="error">${error}</p>
</c:if>

<c:if test="${not empty message}">
  <p class="success">${message}</p>
</c:if>

<form action="forgot-password" method="post">
  <input type="email" name="email" placeholder="Enter your email" required>
  <button type="submit">Send Reset Link</button>
</form>

<p>Remember your password? <a href="login">Login here</a></p>
</body>
</html>