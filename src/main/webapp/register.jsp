<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Admin Registration</title>
  <style>
    :root {
      --primary: #2c8a8a;
      --secondary: #f8b400;
      --light: #f9f9f9;
      --dark: #333;
      --error: #e74c3c;
      --success: #2ecc71;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: 'Poppins', sans-serif;
    }

    body {
      background-color: var(--light);
      color: var(--dark);
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      padding: 20px;
    }

    .register-container {
      width: 100%;
      max-width: 500px;
      background: white;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      padding: 40px;
      animation: fadeIn 0.5s ease;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .register-title {
      text-align: center;
      color: var(--primary);
      margin-bottom: 30px;
      font-size: 28px;
      font-weight: 600;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      margin-bottom: 8px;
      font-weight: 500;
      color: var(--dark);
    }

    .form-group input {
      width: 100%;
      padding: 12px 15px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 16px;
      transition: border 0.3s;
    }

    .form-group input:focus {
      border-color: var(--primary);
      outline: none;
    }

    .auth-btn {
      width: 100%;
      padding: 14px;
      background: var(--primary);
      color: white;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      font-weight: 500;
      cursor: pointer;
      transition: background 0.3s, transform 0.2s;
      margin-top: 10px;
    }

    .auth-btn:hover {
      background: #1e6d6d;
      transform: translateY(-2px);
    }

    .auth-btn:active {
      transform: translateY(0);
    }

    .error {
      color: var(--error);
      background: #fdecea;
      padding: 12px;
      border-radius: 5px;
      margin-bottom: 20px;
      text-align: center;
      font-size: 14px;
    }

    .success {
      color: var(--success);
      background: #e8f8f0;
      padding: 12px;
      border-radius: 5px;
      margin-bottom: 20px;
      text-align: center;
      font-size: 14px;
    }

    .switch-role {
      text-align: center;
      margin-top: 25px;
      font-size: 14px;
      color: #666;
    }

    .switch-role a {
      color: var(--primary);
      text-decoration: none;
      font-weight: 500;
      transition: color 0.3s;
    }

    .switch-role a:hover {
      color: #1e6d6d;
      text-decoration: underline;
    }

    .role-fields {
      background: #f5f9fa;
      padding: 20px;
      border-radius: 8px;
      margin: 25px 0;
      border-left: 4px solid var(--primary);
    }

    .role-fields h3 {
      color: var(--primary);
      margin-bottom: 15px;
      font-size: 18px;
    }
  </style>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="register-container">
  <h1 class="register-title">Admin Registration</h1>

  <c:if test="${not empty error}">
    <div class="error">${error}</div>
  </c:if>

  <c:if test="${not empty message}">
    <div class="success">${message}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/register" method="post">
    <input type="hidden" name="role" value="admin">

    <div class="form-group">
      <label for="username">Username</label>
      <input type="text" id="username" name="username" value="${param.username}" required>
    </div>

    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" value="${param.email}" required>
    </div>

    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" required>
    </div>

    <div class="form-group">
      <label for="confirmPassword">Confirm Password</label>
      <input type="password" id="confirmPassword" name="confirmPassword" required>
    </div>

    <div class="role-fields">
      <h3>Admin Information</h3>
      <div class="form-group">
        <label for="fullName">Full Name</label>
        <input type="text" id="fullName" name="fullName" value="${param.fullName}" required>
      </div>
      <div class="form-group">
        <label for="phone">Phone Number</label>
        <input type="tel" id="phone" name="phone" value="${param.phone}" required>
      </div>
      <div class="form-group">
        <label for="department">Department</label>
        <input type="text" id="department" name="department" value="${param.department}" required>
      </div>
    </div>

    <button type="submit" class="auth-btn">Register as Admin</button>
  </form>

  <div class="switch-role">
    Need a different role? <a href="${pageContext.request.contextPath}/login">Switch Role</a>
  </div>
</div>
</body>
</html>