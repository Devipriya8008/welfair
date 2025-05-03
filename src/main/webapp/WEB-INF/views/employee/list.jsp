<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Employee List</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      line-height: 1.6;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
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
      background-color: #f8f9fa;
      font-weight: 600;
    }
    tr:hover {
      background-color: #f5f5f5;
    }
    .btn {
      display: inline-block;
      padding: 8px 12px;
      background-color: #4CAF50;
      color: white;
      text-decoration: none;
      border-radius: 4px;
      margin-bottom: 20px;
    }
    .btn:hover {
      background-color: #45a049;
    }
    .action-links a {
      color: #007bff;
      text-decoration: none;
      margin-right: 10px;
    }
    .action-links a:hover {
      text-decoration: underline;
    }
    .message {
      padding: 10px;
      margin-bottom: 20px;
      border-radius: 4px;
    }
    .success {
      background-color: #d4edda;
      color: #155724;
    }
    .error {
      background-color: #f8d7da;
      color: #721c24;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>Employee Management</h1>

  <%-- Success/Error Messages --%>
  <c:if test="${not empty sessionScope.successMessage}">
    <div class="message success">${sessionScope.successMessage}</div>
    <c:remove var="successMessage" scope="session"/>
  </c:if>
  <c:if test="${not empty sessionScope.errorMessage}">
    <div class="message error">${sessionScope.errorMessage}</div>
    <c:remove var="errorMessage" scope="session"/>
  </c:if>

  <a href="employees?action=new" class="btn">Add New Employee</a>

  <table>
    <thead>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Position</th>
      <th>Phone</th>
      <th>Email</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${employees}" var="employee">
      <tr>
        <td>${employee.empId}</td>
        <td>${employee.name}</td>
        <td>${employee.position}</td>
        <td>${employee.phone}</td>
        <td>${employee.email}</td>
        <td class="action-links">
          <a href="employees?action=edit&id=${employee.empId}">Edit</a>
          <a href="employees?action=delete&id=${employee.empId}"
             onclick="return confirm('Are you sure you want to delete this employee?')">Delete</a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>
</body>
</html>