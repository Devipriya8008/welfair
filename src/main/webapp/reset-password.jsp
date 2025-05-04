<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Reset Password</title>
  <style>
    .error { color: red; }
    .success { color: green; }
    form { max-width: 300px; margin: 20px auto; }
    input { display: block; width: 100%; margin: 10px 0; padding: 8px; }
  </style>
</head>
<body>
<h2>Reset Password</h2>

<c:if test="${not empty error}">
  <p class="error">${error}</p>
</c:if>

<form action="reset-password" method="post">
  <input type="hidden" name="token" value="${token}">
  <input type="password" name="password" placeholder="New Password" required>
  <input type="password" name="confirmPassword" placeholder="Confirm New Password" required>
  <button type="submit">Reset Password</button>
</form>
</body>
</html>