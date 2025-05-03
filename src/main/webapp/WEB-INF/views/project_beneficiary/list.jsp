<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
  <title>Project-Beneficiary Assignments</title>
  <style>
    table {
      border-collapse: collapse;
      width: 80%;
    }
    th, td {
      border: 1px solid #333;
      padding: 8px;
      text-align: left;
    }
    th {
      background-color: #eee;
    }
    a {
      text-decoration: none;
      color: blue;
    }
  </style>
</head>
<body>
<h1>Project-Beneficiary Assignments</h1>
<a href="${pageContext.request.contextPath}/project-beneficiaries?action=new">+ New Assignment</a>
<br/><br/>

<table>
  <tr>
    <th>Project Name</th>
    <th>Beneficiary Name</th>
    <th>Date Assigned</th>
    <th>Actions</th>
  </tr>
  <c:forEach var="assignment" items="${assignments}">
    <tr>
      <td>${assignment.projectName}</td>
      <td>${assignment.beneficiaryName}</td>
      <td>${assignment.dateAssigned}</td>
      <td>
        <a href="${pageContext.request.contextPath}/project-beneficiaries?action=edit&projectId=${assignment.projectId}&beneficiaryId=${assignment.beneficiaryId}">Edit</a>
        |
        <a href="${pageContext.request.contextPath}/project-beneficiaries?action=delete&projectId=${assignment.projectId}&beneficiaryId=${assignment.beneficiaryId}" onclick="return confirm('Are you sure?')">Delete</a>
      </td>
    </tr>
  </c:forEach>
</table>
</body>
</html>
