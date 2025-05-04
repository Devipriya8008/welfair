<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Register</title>
  <style>
    .error { color: red; }
    form { max-width: 300px; margin: 20px auto; }
    input { display: block; width: 100%; margin: 10px 0; padding: 8px; }
  </style>
</head>
<body>
<h2>Register</h2>

<%-- Show error message if present --%>
<c:if test="${not empty error}">
  <p class="error">${error}</p>
</c:if>

<form action="register" method="post">
  <input type="text" name="username" placeholder="Username" required>
  <input type="email" name="email" placeholder="Email" required>
  <input type="password" name="password" placeholder="Password" required>
  <button type="submit">Register</button>
</form>

<p>Already have an account? <a href="login">Login here</a></p>
</body>
</html>