<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${formTitle}</title>
    <style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background: #f4f6f9;
        color: #333;
        padding: 40px;
    }

    h1 {
        color: #2c3e50;
        text-align: center;
        margin-bottom: 30px;
    }

    form {
        background: #fff;
        padding: 30px 40px;
        max-width: 600px;
        margin: 0 auto;
        border-radius: 10px;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
    }

    .form-group {
        margin-bottom: 20px;
        display: flex;
        flex-direction: column;
    }

    label {
        font-weight: 600;
        margin-bottom: 6px;
    }

    input[type="text"],
    input[type="email"],
    input[type="tel"] {
        padding: 10px;
        border: 1px solid #dcdfe6;
        border-radius: 6px;
        font-size: 15px;
    }

    .btn {
        padding: 10px 20px;
        background-color: #3498db;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 15px;
        cursor: pointer;
        text-decoration: none;
        margin-right: 10px;
    }

    .btn:hover {
        background-color: #2980b9;
    }

    .error {
        color: red;
        text-align: center;
        margin-top: 20px;
    }
</style>
</head>
<body>
<h1>${formTitle}</h1>

<c:if test="${not empty errorMessage}">
    <div style="color:red">${errorMessage}</div>
</c:if>

<form action="${pageContext.request.contextPath}/volunteers" method="post">
    <input type="hidden" name="action" value="${empty volunteer.volunteerId ? 'add' : 'update'}">
    <input type="hidden" name="fromAdmin" value="${fromAdmin}">

    <c:if test="${not empty volunteer.volunteerId}">
        <input type="hidden" name="volunteer_id" value="${volunteer.volunteerId}">
    </c:if>

    <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="${volunteer.name}" required>
    </div>

    <div class="form-group">
        <label for="phone">Phone:</label>
        <input type="tel" id="phone" name="phone" value="${volunteer.phone}">
    </div>

    <div class="form-group">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="${volunteer.email}" required>
    </div>

    <div class="form-group">
        <button type="submit" class="btn">Save</button>
        <a href="${pageContext.request.contextPath}/admin-table?table=volunteers" class="btn">Cancel</a>
    </div>
</form>
</body>
</html>