<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Reset Password</title>
  <style>
    .reset-container {
      max-width: 400px;
      margin: 50px auto;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      background: white;
    }
    .reset-title {
      text-align: center;
      margin-bottom: 20px;
      color: #2c8a8a;
    }
    .form-group {
      margin-bottom: 20px;
    }
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: 500;
    }
    .form-group input {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
    }
    .auth-btn {
      width: 100%;
      padding: 10px;
      background: #2c8a8a;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }
    .error {
      color: red;
      text-align: center;
      margin-bottom: 15px;
    }
    .success {
      color: green;
      text-align: center;
      margin-bottom: 15px;
    }
  </style>
</head>
<body>
<div class="reset-container">
  <h1 class="reset-title">Reset Your Password</h1>

  <c:if test="${not empty error}">
    <p class="error">${error}</p>
  </c:if>

  <form action="reset-password" method="post">
    <input type="hidden" name="token" value="${token}">

    <div class="form-group">
      <label>New Password:</label>
      <input type="password" name="password" required>
    </div>

    <div class="form-group">
      <label>Confirm New Password:</label>
      <input type="password" name="confirmPassword" required>
    </div>

    <button type="submit" class="auth-btn">Reset Password</button>
  </form>
</div>
</body>
</html>