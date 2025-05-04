<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>Employee Management</title>
  <style>
    /* Your existing styles remain the same */
  </style>
</head>
<body>
<div class="container">
  <h1>Employee Management</h1>

  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <a href="employees?action=new" class="btn btn-primary">Add New Employee</a>

  <table>
    <thead>
    <tr>
      <th>User ID</th> <!-- NEW column -->
      <th>Employee ID</th>
      <th>Name</th>
      <th>Position</th>
      <th>Phone</th>
      <th>Email</th>
      <th class="actions">Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="emp" items="${employees}">
      <tr>
        <td>${emp.userId}</td> <!-- NEW column -->
        <td>${emp.empId}</td>
        <td>${emp.name}</td>
        <td>${emp.position}</td>
        <td>${emp.phone}</td>
        <td>${emp.email}</td>
        <td class="actions">
          <a href="employees?action=edit&id=${emp.empId}"
             class="btn btn-primary btn-sm">Edit</a>
          <a href="employees?action=delete&id=${emp.empId}"
             class="btn btn-danger btn-sm"
             onclick="return confirm('Are you sure you want to delete this employee?')">Delete</a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>
</body>
</html>