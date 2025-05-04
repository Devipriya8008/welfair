<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${empty donor.donorId || donor.donorId == 0}">Add New Donor</c:when>
            <c:otherwise>Edit Donor</c:otherwise>
        </c:choose>
    </title>
    <style>
        .form-group { margin-bottom: 15px; }
        label { display: inline-block; width: 100px; }
        input[type="text"], input[type="email"], input[type="tel"], input[type="number"] { width: 300px; }
        textarea { width: 300px; height: 100px; }
        .button-group { margin-top: 20px; }
        .error { color: red; }
        .button {
            padding: 5px 10px;
            background-color: #007BFF;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

<h2>
    <c:choose>
        <c:when test="${empty donor.donorId || donor.donorId == 0}">Add New Donor</c:when>
        <c:otherwise>Edit Donor</c:otherwise>
    </c:choose>
</h2>

<c:if test="${not empty errorMessage}">
    <p class="error"><c:out value="${errorMessage}"/></p>
</c:if>

<form action="${pageContext.request.contextPath}/donors" method="post">
    <input type="hidden" name="action" value="${empty donor.donorId || donor.donorId == 0 ? 'save' : 'update'}"/>

    <c:if test="${not empty donor.donorId && donor.donorId != 0}">
        <input type="hidden" name="donor_id" value="${donor.donorId}"/>
    </c:if>

    <div class="form-group">
        <label for="user_id">User ID:</label>
        <input type="number" id="user_id" name="user_id"
               value="<c:out value='${donor.userId}'/>" required
               <c:if test="${not empty donor.userId && donor.userId != 0}">readonly</c:if>/>
    </div>

    <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<c:out value='${donor.name}'/>" required/>
    </div>

    <div class="form-group">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<c:out value='${donor.email}'/>" required/>
    </div>

    <div class="form-group">
        <label for="phone">Phone:</label>
        <input type="tel" id="phone" name="phone" value="<c:out value='${donor.phone}'/>"/>
    </div>

    <div class="form-group">
        <label for="address">Address:</label>
        <textarea id="address" name="address"><c:out value='${donor.address}'/></textarea>
    </div>

    <div class="button-group">
        <button type="submit" class="button">Save</button>
        <a href="${pageContext.request.contextPath}/donors" class="button">Cancel</a>
    </div>
</form>

</body>
</html>