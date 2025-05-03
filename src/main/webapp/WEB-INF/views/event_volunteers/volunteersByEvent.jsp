<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Volunteers for Event ${eventId}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
  <h2 class="mb-4">Volunteers for Event ${eventId}</h2>

  <a href="${pageContext.request.contextPath}/event-volunteers" class="btn btn-secondary mb-3">Back to All Assignments</a>

  <table class="table table-striped table-hover">
    <thead class="table-dark">
    <tr>
      <th>Volunteer ID</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
<c:forEach var="volunteer" items="${volunteers}">