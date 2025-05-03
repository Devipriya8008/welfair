<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>${empty employee.empId ? 'Add New' : 'Edit'} Employee</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      line-height: 1.6;
    }
    .container {
      max-width: 600px;
      margin: 0 auto;
    }
    .form-group {
      margin-bottom: 15px;
    }
    label {
      display: block;
      margin-bottom: 5px;
      font-weight: 600;
    }
    input[type="text"],
    input[type="email"],
    input[type="tel"],
    select,
    textarea {
      width: 100%;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
      box-sizing: border-box;
    }
    .btn {
      display: inline-block;
      padding: 8px 16px;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      text-decoration: none;
    }
    .btn:hover {
      background-color: #45a049;
    }
    .btn-cancel {
      background-color: #6c757d;
      margin-left: 10px;
    }
    .btn-cancel:hover {
      background-color: #5a6268;
    }
    .error {
      color: #dc3545;
      font-size: 14px;
      margin-top: 5px;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>${empty employee.empId ? 'Add New' : 'Edit'} Employee</h1>

  <c:if test="${not empty errorMessage}">
    <div class="error">${errorMessage}</div>
  </c:if>

  <form action="employees" method="post">
    <input type="hidden" name="action" value="${empty employee.empId ? 'save' : 'update'}">
    <c:if test="${not empty employee.empId}">
      <input type="hidden" name="emp_id" value="${employee.empId}">
    </c:if>

    <div class="form-group">
      <label for="name">Name:</label>
      <input type="text" id="name" name="name" value="${employee.name}" required>
    </div>

    <div class="form-group">
      <label for="position">Position:</label>
      <input type="text" id="position" name="position" value="${employee.position}" required>
    </div>

    <div class="form-group">
      <label for="phone">Phone:</label>
      <input type="tel" id="phone" name="phone" value="${employee.phone}">
    </div>

    <div class="form-group">
      <label for="email">Email:</label>
      <input type="email" id="email" name="email" value="${employee.email}">
    </div>

    <div class="form-group">
      <button type="submit" class="btn">Save</button>
      <a href="employees" class="btn btn-cancel">Cancel</a>
    </div>
  </form>
</div>
</body>
</html>