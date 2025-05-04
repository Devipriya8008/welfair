<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Donor List</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        tr:hover { background-color: #f5f5f5; }
        .button {
            text-decoration: none;
            padding: 5px 10px;
            background-color: #007BFF;
            color: white;
            border-radius: 4px;
            margin-right: 5px;
        }
        .button:hover { background-color: #0056b3; }
        .button.delete { background-color: #dc3545; }
        .button.delete:hover { background-color: #c82333; }
    </style>
</head>
<body>
<h1>Donor Management</h1>

<a class="button" href="${pageContext.request.contextPath}/donors?action=new">Add New Donor</a>

<table>
    <thead>
    <tr>
        <th>User ID</th>
        <th>Donor ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${donors}" var="donor">
        <tr>
            <td><c:out value="${donor.userId}"/></td>
            <td><c:out value="${donor.donorId}"/></td>
            <td><c:out value="${donor.name}"/></td>
            <td><c:out value="${donor.email}"/></td>
            <td><c:out value="${donor.phone}"/></td>
            <td>
                <a class="button" href="${pageContext.request.contextPath}/donors?action=edit&id=${donor.donorId}">Edit</a>
                <a class="button delete" href="${pageContext.request.contextPath}/donors?action=delete&id=${donor.donorId}"
                   onclick="return confirm('Are you sure you want to delete this donor?');">Delete</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>