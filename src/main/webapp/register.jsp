<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>${param.role} Registration</title>
  <style>
    .error { color: red; }
    .register-container {
      max-width: 400px;
      margin: 20px auto;
      padding: 20px;
      border: 1px solid #ddd;
      border-radius: 5px;
    }
    .form-group {
      margin-bottom: 15px;
    }
    label {
      display: block;
      margin-bottom: 5px;
    }
    input {
      width: 100%;
      padding: 8px;
      box-sizing: border-box;
    }
  </style>
</head>
<body>
<div class="register-container">
  <h2>${param.role} Registration</h2>

  <c:if test="${not empty error}">
    <p class="error">${error}</p>
  </c:if>

  <form action="register" method="post">
    <input type="hidden" name="role" value="${param.role}" />

    <div class="form-group">
      <label>Username:</label>
      <input type="text" name="username" required>
    </div>

    <div class="form-group">
      <label>Email:</label>
      <input type="email" name="email" required>
    </div>

    <div class="form-group">
      <label>Password:</label>
      <input type="password" name="password" required>
    </div>

    <div class="form-group">
      <label>Confirm Password:</label>
      <input type="password" name="confirmPassword" required>
    </div>

    <button type="submit" class="auth-btn">Register</button>
  </form>

  <p>Already have an account? <a href="login.jsp?role=${param.role}">Login here</a></p>
</div>
</body>
</html>