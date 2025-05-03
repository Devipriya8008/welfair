<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List, com.welfair.model.Inventory" %>
<html>
<head>
    <title>Inventory List</title>
</head>
<body>
<h2>Inventory List</h2>
<a href="inventory?action=new">Add Item</a>
<table border="1">
    <tr>
        <th>ID</th><th>Name</th><th>Quantity</th><th>Unit</th><th>Actions</th>
    </tr>
    <c:forEach var="item" items="${items}">
        <tr>
            <td>${item.itemId}</td>
            <td>${item.name}</td>
            <td>${item.quantity}</td>
            <td>${item.unit}</td>
            <td>
                <a href="inventory?action=edit&item_id=${item.itemId}">Edit</a> |
                <a href="inventory?action=delete&item_id=${item.itemId}" onclick="return confirm('Delete this item?')">Delete</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
