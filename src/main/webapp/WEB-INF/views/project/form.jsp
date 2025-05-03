<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Project Form</title>
</head>
<body>
<h2>${project.projectId == 0 ? "Add New Project" : "Edit Project"}</h2>

<form action="${pageContext.request.contextPath}/projects" method="post">
    <input type="hidden" name="action" value="${project.projectId == 0 ? "create" : "update"}"/>
    <c:if test="${project.projectId != 0}">
        <input type="hidden" name="project_id" value="${project.projectId}"/>
    </c:if>

    <label for="name">Name:</label><br/>
    <input type="text" id="name" name="name" value="${project.name}" required/><br/><br/>

    <label for="description">Description:</label><br/>
    <textarea id="description" name="description" required>${project.description}</textarea><br/><br/>

    <label for="start_date">Start Date:</label><br/>
    <input type="date" id="start_date" name="start_date" value="${project.startDate}" required/><br/><br/>

    <label for="end_date">End Date:</label><br/>
    <input type="date" id="end_date" name="end_date" value="${project.endDate}" required/><br/><br/>

    <label for="status">Status:</label><br/>
    <input type="text" id="status" name="status" value="${project.status}" required/><br/><br/>

    <input type="submit" value="Save"/>
    <a href="${pageContext.request.contextPath}/projects">Cancel</a>
</form>

<c:if test="${not empty errorMessage}">
    <p style="color:red;">${errorMessage}</p>
</c:if>
</body>
</html>
