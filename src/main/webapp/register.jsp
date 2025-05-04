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
    .role-specific {
      margin-top: 15px;
      padding: 10px;
      background-color: #f5f5f5;
      border-radius: 5px;
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

    <c:if test="${param.role eq 'admin'}">
      <div class="role-specific">
        <h3>Admin Details</h3>
        <div class="form-group">
          <label>Full Name:</label>
          <input type="text" name="fullName" required>
        </div>
        <div class="form-group">
          <label>Phone:</label>
          <input type="tel" name="phone" required>
        </div>
        <div class="form-group">
          <label>Department:</label>
          <input type="text" name="department" required>
        </div>
      </div>
    </c:if>

    <button type="submit" class="auth-btn">Register</button>
  </form>

  <p>Already have an account? <a href="login.jsp?role=${param.role}">Login here</a></p>
</div>
</body>
</html>