<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Forgot Password</title>
  <style>
    .forgot-container {
      max-width: 400px;
      margin: 50px auto;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      background: white;
    }
    .forgot-title {
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
    .login-link {
      text-align: center;
      margin-top: 20px;
    }
    .login-link a {
      color: #2c8a8a;
      text-decoration: none;
    }
  </style>
</head>
<body>
<div class="forgot-container">
  <h1 class="forgot-title">Forgot Password</h1>

  <c:if test="${not empty error}">
    <p class="error">${error}</p>
  </c:if>

  <c:if test="${not empty message}">
    <p class="success">${message}</p>
  </c:if>

  <form action="forgot-password" method="post">
    <div class="form-group">
      <label>Email:</label>
      <input type="email" name="email" required>
    </div>

    <button type="submit" class="auth-btn">Send Reset Link</button>
  </form>

  <div class="login-link">
    Remember your password? <a href="login">Login here</a>
  </div>
</div>
</body>
</html>