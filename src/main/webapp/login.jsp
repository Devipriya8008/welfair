<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${param.role} Login</title>
    <style>
        .login-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            background: white;
        }
        .login-title {
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
        .forgot-password {
            text-align: right;
            margin: 15px 0;
        }
        .forgot-password a {
            color: #2c8a8a;
            text-decoration: none;
            font-size: 14px;
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
        .switch-role {
            text-align: center;
            margin-top: 20px;
        }
        .switch-role a {
            color: #2c8a8a;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h1 class="login-title">${param.role} Login</h1>

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <c:if test="${not empty message}">
        <p class="success">${message}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <input type="hidden" name="role" value="${param.role}" />

        <div class="form-group">
            <label>Username:</label>
            <input type="text" name="username" required>
        </div>

        <div class="form-group">
            <label>Password:</label>
            <input type="password" name="password" required>
        </div>

        <div class="forgot-password">
            <a href="${pageContext.request.contextPath}/forgot-password?role=${param.role}">Forgot Password?</a>
        </div>

        <button type="submit" class="auth-btn">Login</button>
    </form>

    <div class="switch-role">
        <a href="${pageContext.request.contextPath}/index.jsp">Select a different role</a>
    </div>
</div>
</body>
</html>