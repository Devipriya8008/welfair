<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title><c:out value="${employee.empId == 0 ? 'Add New' : 'Edit'}"/> Employee</title>
  <style>
    /* Your existing styles remain the same */
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
      <label for="user_id">User ID:</label>
      <input type="number" id="user_id" name="user_id"
             value="${employee.userId}" required
             <c:if test="${not empty employee.userId}">readonly</c:if>>
    </div>

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