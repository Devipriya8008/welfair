<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Inventory Form</title>
</head>
<body>
<h2>${item != null ? "Edit" : "Add"} Inventory Item</h2>
<form action="inventory" method="post">
    <c:if test="${item != null}">
        <input type="hidden" name="item_id" value="${item.itemId}"/>
    </c:if>
    <label>Name:</label>
    <input type="text" name="name" value="${item != null ? item.name : ''}" required/><br>
    <label>Quantity:</label>
    <input type="number" name="quantity" value="${item != null ? item.quantity : ''}" required/><br>
    <label>Unit:</label>
    <input type="text" name="unit" value="${item != null ? item.unit : ''}" required/><br>
    <input type="submit" value="Save"/>
</form>
<a href="inventory">Back to list</a>
</body>
</html>
