<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Donor Dashboard</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<h1>Welcome, ${donor.name}!</h1>

<c:if test="${not empty activeProjects}">
    <h2>Active Projects</h2>
    <div class="project-list">
        <c:forEach var="project" items="${activeProjects}">
            <div class="project-card">
                <h3>${project.name}</h3>
                <p>${project.description}</p>
                <p><b>Start Date:</b> ${project.startDate}</p>
                <p><b>End Date:</b> ${project.endDate}</p>
                <form action="donate" method="post">
                    <input type="hidden" name="projectId" value="${project.projectId}" />
                    <button type="submit">Donate</button>
                </form>
            </div>
        </c:forEach>
    </div>
</c:if>

<c:if test="${empty activeProjects}">
    <p>No active projects available for donation at this time.</p>
</c:if>
</body>
</html>