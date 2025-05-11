<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Inventory Usage List</title>
</head>
<body>
<h2>Inventory Usage Records</h2>

<a href="${pageContext.request.contextPath}/inventory_usage?action=add">Add New Usage</a>
<br><br>

<table border="1" cellpadding="10">
  <thead>
  <tr>
    <th>Item ID</th>
    <th>Project ID</th>
    <th>Quantity Used</th>
    <th>Actions</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="u" items="${usages}">
    <tr>
      <td>${u.itemId}</td>
      <td>${u.projectId}</td>
      <td>${u.quantityUsed}</td>
      <td>
        <a href="${pageContext.request.contextPath}/inventory_usage?action=edit&item_id=${u.itemId}&project_id=${u.projectId}">Edit</a>
        |
        <a href="${pageContext.request.contextPath}/inventory_usage?action=delete&item_id=${u.itemId}&project_id=${u.projectId}" onclick="return confirm('Are you sure?')">Delete</a>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>
</body>
</html>
