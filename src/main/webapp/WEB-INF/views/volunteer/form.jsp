<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${formTitle}</title>
    <style>
        .form-group { margin-bottom: 15px; }
        label { display: inline-block; width: 100px; }
        input, textarea { width: 300px; }
        .btn { padding: 5px 10px; background-color: #4CAF50; color: white; }
    </style>
</head>
<body>
<h1>${formTitle}</h1>

<c:if test="${not empty errorMessage}">
    <div style="color:red">${errorMessage}</div>
</c:if>

<form action="${pageContext.request.contextPath}/volunteers" method="post">
    <input type="hidden" name="action" value="${empty volunteer.volunteerId ? 'add' : 'update'}">

    <c:if test="${not empty volunteer.volunteerId}">
        <input type="hidden" name="volunteer_id" value="${volunteer.volunteerId}">
    </c:if>

    <div class="form-group">
        <label for="user_id">User ID:</label>
        <input type="number" id="user_id" name="user_id"
               value="${volunteer.userId}" required
               <c:if test="${not empty volunteer.userId}">readonly</c:if>>
    </div>

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
        <input type="email" id="email" name="email" value="${volunteer.email}">
    </div>

    <div class="form-group">
        <button type="submit" class="btn">Save</button>
        <a href="${pageContext.request.contextPath}/volunteers" class="btn">Cancel</a>
    </div>
</form>
</body>
</html>