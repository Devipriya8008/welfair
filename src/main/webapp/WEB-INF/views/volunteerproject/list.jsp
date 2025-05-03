<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Volunteer-Project Associations</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      background-color: #f5f5f5;
    }
    h2 {
      color: #2c3e50;
    }
    .btn {
      display: inline-block;
      padding: 8px 15px;
      background-color: #3498db;
      color: white;
      text-decoration: none;
      border-radius: 4px;
      margin-bottom: 20px;
    }
    .btn:hover {
      background-color: #2980b9;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
      box-shadow: 0 2px 3px rgba(0,0,0,0.1);
    }
    th, td {
      padding: 12px 15px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    th {
      background-color: #3498db;
      color: white;
    }
    tr:nth-child(even) {
      background-color: #f2f2f2;
    }
    tr:hover {
      background-color: #e3f2fd;
    }
    .action-links a {
      color: #3498db;
      text-decoration: none;
      margin-right: 10px;
    }
    .action-links a:hover {
      text-decoration: underline;
    }
    .error {
      color: #e74c3c;
      margin: 10px 0;
    }
  </style>
</head>
<body>
<h2>Volunteer-Project Associations</h2>
<a href="${pageContext.request.contextPath}/volunteer-projects?action=new" class="btn">Add New Association</a>

<table>
  <thead>
  <tr>
    <th>Volunteer ID</th>
    <th>Project ID</th>
    <th>Role</th>
    <th>Actions</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="vp" items="${volunteerProjects}">
    <tr>
      <td>${vp.volunteerId}</td>
      <td>${vp.projectId}</td>
      <td>${vp.role}</td>
      <td class="action-links">
        <a href="${pageContext.request.contextPath}/volunteer-projects?action=edit&volunteerId=${vp.volunteerId}&projectId=${vp.projectId}">Edit</a>
        <a href="${pageContext.request.contextPath}/volunteer-projects?action=delete&volunteerId=${vp.volunteerId}&projectId=${vp.projectId}"
           onclick="return confirm('Are you sure you want to delete this association?');">Delete</a>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>
</body>
</html>