<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Volunteer-Project Form</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      background-color: #f5f5f5;
    }
    h2 {
      color: #2c3e50;
      margin-bottom: 20px;
    }
    .form-container {
      background-color: white;
      padding: 20px;
      border-radius: 5px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      max-width: 500px;
    }
    .form-group {
      margin-bottom: 15px;
    }
    label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
      color: #2c3e50;
    }
    input[type="text"],
    input[type="number"],
    input[type="date"],
    textarea,
    select {
      width: 100%;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
      box-sizing: border-box;
    }
    .btn-group {
      margin-top: 20px;
    }
    .btn {
      padding: 8px 15px;
      background-color: #3498db;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
    }
    .btn:hover {
      background-color: #2980b9;
    }
    .btn-cancel {
      background-color: #95a5a6;
      margin-left: 10px;
    }
    .btn-cancel:hover {
      background-color: #7f8c8d;
    }
    .error {
      color: #e74c3c;
      margin: 10px 0;
    }
    .error-text {
      color: #e74c3c;
      font-size: 0.8em;
      display: block;
      margin-top: 5px;
    }
    .form-footer {
      margin-top: 20px;
      padding-top: 15px;
      border-top: 1px solid #eee;
    }
  </style>
</head>
<body>
<div class="form-container">
  <h2>${volunteerProject.volunteerId == 0 ? "Add New Association" : "Edit Association"}</h2>

  <c:if test="${not empty errorMessage && !errorMessage.contains('Volunteer ID') && !errorMessage.contains('Project ID')}">
    <p class="error">${errorMessage}</p>
  </c:if>

  <form action="${pageContext.request.contextPath}/volunteer-projects" method="post">
    <input type="hidden" name="action" value="${volunteerProject.volunteerId == 0 ? 'create' : 'update'}"/>

    <c:if test="${volunteerProject.volunteerId != 0}">
      <input type="hidden" name="originalVolunteerId" value="${volunteerProject.volunteerId}"/>
      <input type="hidden" name="originalProjectId" value="${volunteerProject.projectId}"/>
    </c:if>

    <div class="form-group">
      <label for="volunteerId">Volunteer ID:</label>
      <input type="number" id="volunteerId" name="volunteerId"
             value="${not empty param.volunteerId ? param.volunteerId : volunteerProject.volunteerId}"
             required min="1"/>
      <c:if test="${not empty errorMessage && errorMessage.contains('Volunteer ID')}">
        <span class="error-text">${errorMessage}</span>
      </c:if>
    </div>

    <div class="form-group">
      <label for="projectId">Project ID:</label>
      <input type="number" id="projectId" name="projectId"
             value="${not empty param.projectId ? param.projectId : volunteerProject.projectId}"
             required min="1"/>
      <c:if test="${not empty errorMessage && errorMessage.contains('Project ID')}">
        <span class="error-text">${errorMessage}</span>
      </c:if>
    </div>

    <div class="form-group">
      <label for="role">Role:</label>
      <input type="text" id="role" name="role"
             value="${not empty param.role ? param.role : volunteerProject.role}"
             required/>
    </div>

    <div class="form-footer">
      <div class="btn-group">
        <input type="submit" value="Save" class="btn"/>
        <a href="${pageContext.request.contextPath}/volunteer-projects" class="btn btn-cancel">Cancel</a>
      </div>
    </div>
  </form>
</div>
</body>
</html>