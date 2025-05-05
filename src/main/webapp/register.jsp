<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>${not empty param.role ? param.role : 'User'} Registration</title>
  <!-- ... (keep your existing styles) ... -->
  <style>
    .register-container {
      max-width: 500px;
      margin: 50px auto;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      background: white;
    }

    .register-title {
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

    .role-specific {
      margin: 20px 0;
      padding: 15px;
      background: #f5f5f5;
      border-radius: 5px;
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
<div class="register-container">
  <h1 class="register-title">${not empty param.role ? param.role : 'User'} Registration</h1>

  <c:if test="${not empty error}">
    <p class="error">${error}</p>
  </c:if>

  <form action="${pageContext.request.contextPath}/register" method="post">
    <input type="hidden" name="role" value="${param.role}" />

    <!-- ... (keep your existing form fields) ... -->

    <button type="submit" class="auth-btn">Register</button>
  </form>

  <div class="login-link">
    Already have an account?
    <a href="${pageContext.request.contextPath}/login?role=${param.role}">Login here</a>
  </div>
</div>
</body>
</html>