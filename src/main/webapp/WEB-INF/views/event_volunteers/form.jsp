<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Event Volunteer Assignments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Event Volunteer Assignments</h2>

    <div class="d-flex justify-content-between mb-3">
        <a href="${pageContext.request.contextPath}/event-volunteers?action=new"
           class="btn btn-success">New Assignment</a>
        <form action="${pageContext.request.contextPath}/event-volunteers" method="get" class="d-flex">
            <input type="hidden" name="action" value="listByEvent">
            <input type="number" name="eventId" class="form-control me-2" placeholder="Event ID" required>
            <button type="submit" class="btn btn-info">View by Event</button>
        </form>
    </div>

    <table class="table table-striped table-hover">
        <thead class="table-dark">
        <tr>
            <th>Event ID</th>
            <th>Volunteer ID</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="assignment" items="${assignments}">
            <tr>
                <td>${assignment.eventId}</td>
                <td>${assignment.volunteerId}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/event-volunteers?action=edit&eventId=${assignment.eventId}&volunteerId=${assignment.volunteerId}"
                       class="btn btn-warning btn-sm me-2">Edit</a>
                    <form action="${pageContext.request.contextPath}/event-volunteers"
                          method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="eventId" value="${assignment.eventId}">
                        <input type="hidden" name="volunteerId" value="${assignment.volunteerId}">
                        <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>