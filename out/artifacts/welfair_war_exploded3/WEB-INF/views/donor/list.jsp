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
    </style>
</head>
<body>
<h1>Donor Management</h1>
<a href="donors?action=new">Add New Donor</a>

<table>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Actions</th>
    </tr>
    <c:forEach items="${donors}" var="donor">
        <tr>
            <td>${donor.donorId}</td>
            <td>${donor.name}</td>
            <td>${donor.email}</td>
            <td>${donor.phone}</td>
            <td>
                <a href="donors?action=edit&id=${donor.donorId}">Edit</a>
                <a href="donors?action=delete&id=${donor.donorId}"
                   onclick="return confirm('Are you sure?')">Delete</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>