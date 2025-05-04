<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Login</title>
    <style>
        .error { color: red; }
        .success { color: green; }
        form { max-width: 300px; margin: 20px auto; }
        input { display: block; width: 100%; margin: 10px 0; padding: 8px; }
    </style>
</head>
<body>
<h2>Login</h2>

<%-- Show registration success message if present --%>
<c:if test="${not empty param.registration}">
    <p class="success">Registration successful! Please login.</p>
</c:if>

<%-- Show error message if present --%>
<c:if test="${not empty error}">
    <p class="error">${error}</p>
</c:if>

<form action="login" method="post">
    <input type="text" name="username" placeholder="Username" required>
    <input type="password" name="password" placeholder="Password" required>
    <button type="submit">Login</button>
    <p><a href="forgot-password">Forgot password?</a></p>
</form>

<p>Don't have an account? <a href="register">Register here</a></p>

</body>
</html>