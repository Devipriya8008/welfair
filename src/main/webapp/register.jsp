<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
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

<c:if test="${not empty error}">
  <p class="error">${error}</p>
</c:if>

<form action="register" method="post">
  <input type="text" name="username" placeholder="Username" required>
  <input type="password" name="password" placeholder="Password" required>
  <input type="email" name="email" placeholder="Email" required>
  <select name="role" required>
    <option value="">Select Role</option>
    <option value="admin">Admin</option>
    <option value="employee">Employee</option>
    <option value="volunteer">Volunteer</option>
    <option value="donor">Donor</option>
  </select>
  <button type="submit">Register</button>
</form>

<p>Already have an account? <a href="login">Login here</a></p>
</body>
</html>
