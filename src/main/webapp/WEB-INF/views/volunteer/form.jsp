<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${formTitle}</title>
    <style>
        /* Your existing styles */
    </style>
</head>
<body>
<div class="container">
    <h1>${formTitle}</h1>

    <c:if test="${not empty errorMessage}">
        <div class="error">${errorMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/volunteers" method="post">
        <c:if test="${not empty volunteer.volunteerId && volunteer.volunteerId != 0}">
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
            <input type="email" id="email" name="email" value="${volunteer.email}">
        </div>

        <div class="form-group">
            <button type="submit" class="btn">Save</button>
            <a href="${pageContext.request.contextPath}/volunteers" class="btn btn-cancel">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>