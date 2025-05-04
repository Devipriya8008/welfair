<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Volunteer List</title>
    <style>
        /* Your existing styles */
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        .btn { padding: 5px 10px; background-color: #4CAF50; color: white; text-decoration: none; }
    </style>
</head>
<body>
<h1>Volunteer Management</h1>

<a href="volunteers?action=new" class="btn">Add New Volunteer</a>

<table>
    <thead>
    <tr>
        <th>User ID</th>
        <th>Volunteer ID</th>
        <th>Name</th>
        <th>Phone</th>
        <th>Email</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${volunteers}" var="volunteer">
        <tr>
            <td>${volunteer.userId}</td>
            <td>${volunteer.volunteerId}</td>
            <td>${volunteer.name}</td>
            <td>${volunteer.phone}</td>
            <td>${volunteer.email}</td>
            <td>
                <a href="volunteers?action=edit&id=${volunteer.volunteerId}">Edit</a>
                <a href="volunteers?action=delete&id=${volunteer.volunteerId}"
                   onclick="return confirm('Are you sure?')">Delete</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>