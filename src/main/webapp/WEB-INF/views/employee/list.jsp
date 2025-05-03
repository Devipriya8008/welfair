<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>Employee Management</title>
  <style>
    :root {
      --primary: #3498db;
      --success: #2ecc71;
      --warning: #f39c12;
      --danger: #e74c3c;
      --light: #ecf0f1;
      --dark: #34495e;
    }
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      line-height: 1.6;
      margin: 0;
      padding: 20px;
      background-color: #f5f7fa;
      color: #333;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
      background: white;
      box-shadow: 0 0 20px rgba(0,0,0,0.1);
      border-radius: 8px;
    }
    h1 {
      color: var(--dark);
      border-bottom: 2px solid var(--primary);
      padding-bottom: 10px;
      margin-top: 0;
    }
    .btn {
      display: inline-block;
      padding: 8px 16px;
      border-radius: 4px;
      text-decoration: none;
      font-weight: 500;
      transition: all 0.3s ease;
      border: none;
      cursor: pointer;
    }
    .btn-primary {
      background-color: var(--primary);
      color: white;
    }
    .btn-primary:hover {
      background-color: #2980b9;
    }
    .btn-success {
      background-color: var(--success);
      color: white;
    }
    .btn-danger {
      background-color: var(--danger);
      color: white;
    }
    .btn-sm {
      padding: 5px 10px;
      font-size: 0.875rem;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      padding: 12px 15px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    th {
      background-color: var(--primary);
      color: white;
      font-weight: 600;
    }
    tr:nth-child(even) {
      background-color: #f8f9fa;
    }
    tr:hover {
      background-color: #e9ecef;
    }
    .actions {
      white-space: nowrap;
    }
    .alert {
      padding: 10px 15px;
      border-radius: 4px;
      margin-bottom: 20px;
    }
    .alert-danger {
      background-color: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }
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
      <th>ID</th>
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