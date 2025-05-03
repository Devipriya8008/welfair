<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Inventory Usage Form</title>
</head>
<body>
<h2>
    <c:choose>
        <c:when test="${not empty usage}">Edit Inventory Usage</c:when>
        <c:otherwise>Add Inventory Usage</c:otherwise>
    </c:choose>
</h2>

<form action="${pageContext.request.contextPath}/inventory-usage" method="post">
    <label for="item_id">Item ID:</label>
    <input type="number" id="item_id" name="item_id"
           value="${usage.itemId}" <c:if test="${not empty usage}">readonly</c:if> required><br><br>

    <label for="project_id">Project ID:</label>
    <input type="number" id="project_id" name="project_id"
           value="${usage.projectId}" <c:if test="${not empty usage}">readonly</c:if> required><br><br>

    <label for="quantity_used">Quantity Used:</label>
    <input type="number" id="quantity_used" name="quantity_used" value="${usage.quantityUsed}" required><br><br>

    <input type="submit" value="Submit">
    <a href="${pageContext.request.contextPath}/inventory-usage">Cancel</a>
</form>
</body>
</html>
