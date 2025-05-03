<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title><c:out value="${employee.empId == 0 ? 'Add New' : 'Edit'}"/> Employee</title>
  <style>
    :root {
      --primary: #3498db;
      --danger: #e74c3c;
      --light: #ecf0f1;
      --dark: #34495e;
      --gray: #95a5a6;
    }
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      line-height: 1.6;
      margin: 0;
      padding: 20px;
      background-color: #f5f7fa;
      color: #333;
    }
    .form-container {
      max-width: 600px;
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
    .form-group {
      margin-bottom: 20px;
    }
    label {
      display: block;
      margin-bottom: 5px;
      font-weight: 600;
      color: var(--dark);
    }
    input[type="text"],
    input[type="email"],
    input[type="tel"],
    select,
    textarea {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-family: inherit;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }
    input:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
    }
    .btn {
      display: inline-block;
      padding: 10px 20px;
      border-radius: 4px;
      text-decoration: none;
      font-weight: 500;
      transition: all 0.3s ease;
      border: none;
      cursor: pointer;
      font-size: 1rem;
    }
    .btn-primary {
      background-color: var(--primary);
      color: white;
    }
    .btn-primary:hover {
      background-color: #2980b9;
    }
    .btn-secondary {
      background-color: var(--gray);
      color: white;
    }
    .btn-secondary:hover {
      background-color: #7f8c8d;
    }
    .btn-group {
      margin-top: 30px;
    }
    .error-message {
      color: var(--danger);
      font-size: 0.875rem;
      margin-top: 5px;
    }
    .is-invalid {
      border-color: var(--danger);
    }
  </style>
</head>
<body>
<div class="form-container">
  <h1><c:out value="${employee.empId == 0 ? 'Add New' : 'Edit'}"/> Employee</h1>

  <c:if test="${not empty error}">
    <div class="error-message">${error}</div>
  </c:if>

  <form action="employees" method="post">
    <input type="hidden" name="action" value="${action}"/>
    <c:if test="${employee.empId != 0}">
      <input type="hidden" name="id" value="${employee.empId}"/>
    </c:if>

    <div class="form-group">
      <label for="name">Full Name</label>
      <input type="text" id="name" name="name"
             value="${employee.name}"
             required
             class="${not empty error && empty employee.name ? 'is-invalid' : ''}"/>
      <c:if test="${not empty error && empty employee.name}">
        <div class="error-message">Name is required</div>
      </c:if>
    </div>

    <div class="form-group">
      <label for="position">Position</label>
      <input type="text" id="position" name="position"
             value="${employee.position}"
             required
             class="${not empty error && empty employee.position ? 'is-invalid' : ''}"/>
      <c:if test="${not empty error && empty employee.position}">
        <div class="error-message">Position is required</div>
      </c:if>
    </div>

    <div class="form-group">
      <label for="phone">Phone Number</label>
      <input type="tel" id="phone" name="phone"
             value="${employee.phone}"
             required
             pattern="[0-9]{10,15}"
             class="${not empty error && empty employee.phone ? 'is-invalid' : ''}"/>
      <c:if test="${not empty error && empty employee.phone}">
        <div class="error-message">Valid phone number is required</div>
      </c:if>
    </div>

    <div class="form-group">
      <label for="email">Email Address</label>
      <input type="email" id="email" name="email"
             value="${employee.email}"
             required
             class="${not empty error && empty employee.email ? 'is-invalid' : ''}"/>
      <c:if test="${not empty error && empty employee.email}">
        <div class="error-message">Valid email is required</div>
      </c:if>
    </div>

    <div class="btn-group">
      <button type="submit" class="btn btn-primary">
        <c:out value="${employee.empId == 0 ? 'Create' : 'Update'}"/> Employee
      </button>
      <a href="employees" class="btn btn-secondary">Cancel</a>
    </div>
  </form>
</div>
</body>
</html>