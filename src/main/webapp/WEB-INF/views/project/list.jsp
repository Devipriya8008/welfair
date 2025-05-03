<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Projects List</title>
</head>
<body>
<h2>Project List</h2>
<a href="${pageContext.request.contextPath}/projects?action=new">Add New Project</a>
<br/><br/>

<table border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Description</th>
        <th>Start Date</th>
        <th>End Date</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    <c:forEach var="project" items="${projects}">
        <tr>
            <td>${project.projectId}</td>
            <td>${project.name}</td>
            <td>${project.description}</td>
            <td>${project.startDate}</td>
            <td>${project.endDate}</td>
            <td>${project.status}</td>
            <td>
                <a href="${pageContext.request.contextPath}/projects?action=edit&id=${project.projectId}">Edit</a> |
                <a href="${pageContext.request.contextPath}/projects?action=delete&id=${project.projectId}"
                   onclick="return confirm('Are you sure you want to delete this project?');">Delete</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
