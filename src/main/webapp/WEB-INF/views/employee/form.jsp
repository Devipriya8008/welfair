<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title><c:out value="${employee.empId == 0 ? 'Add New' : 'Edit'}"/> Employee</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .form-container {
      max-width: 800px;
      margin: 30px auto;
      padding: 20px;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .error-message {
      color: #dc3545;
      margin-bottom: 15px;
      padding: 10px;
      background-color: #f8d7da;
      border-radius: 4px;
    }
    .form-group {
      margin-bottom: 20px;
    }
    .form-group label {
      font-weight: 500;
      margin-bottom: 5px;
      display: block;
    }
    .form-control {
      padding: 10px;
      border-radius: 4px;
      border: 1px solid #ced4da;
      width: 100%;
    }
    .form-control.is-invalid {
      border-color: #dc3545;
    }
    .btn-group {
      margin-top: 20px;
      display: flex;
      gap: 10px;
    }
    .btn {
      padding: 10px 15px;
      border-radius: 4px;
      text-decoration: none;
      cursor: pointer;
    }
    .btn-primary {
      background-color: #0d6efd;
      color: white;
      border: none;
    }
    .btn-secondary {
      background-color: #6c757d;
      color: white;
      border: none;
    }
    .img-thumbnail {
      max-width: 100px;
      max-height: 100px;
      border: 1px solid #ddd;
      border-radius: 4px;
      padding: 5px;
    }
  </style>
</head>
<body>
<div class="form-container">
  <h1><c:out value="${employee.empId == 0 ? 'Add New' : 'Edit'}"/> Employee</h1>

  <c:if test="${not empty error}">
    <div class="error-message">${error}</div>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/employees">
    <input type="hidden" name="action" value="${action}"/>
    <input type="hidden" name="fromAdmin" value="${param.fromAdmin}"/>

    <c:if test="${not empty employee.empId}">
      <input type="hidden" name="id" value="${employee.empId}"/>
    </c:if>

    <div class="form-group">
      <label for="name">Full Name</label>
      <input type="text" id="name" name="name"
             value="${employee.name}"
             required
             class="form-control ${not empty error && empty employee.name ? 'is-invalid' : ''}"/>
      <c:if test="${not empty error && empty employee.name}">
        <div class="error-message">Name is required</div>
      </c:if>
    </div>

    <div class="form-group">
      <label for="position">Position</label>
      <input type="text" id="position" name="position"
             value="${employee.position}"
             required
             class="form-control ${not empty error && empty employee.position ? 'is-invalid' : ''}"/>
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
             class="form-control ${not empty error && empty employee.phone ? 'is-invalid' : ''}"/>
      <c:if test="${not empty error && empty employee.phone}">
        <div class="error-message">Valid phone number is required</div>
      </c:if>
    </div>

    <div class="form-group">
      <label for="email">Email Address</label>
      <input type="email" id="email" name="email"
             value="${employee.email}"
             required
             class="form-control ${not empty error && empty employee.email ? 'is-invalid' : ''}"/>
      <c:if test="${not empty error && empty employee.email}">
        <div class="error-message">Valid email is required</div>
      </c:if>
    </div>

    <div class="form-group">
      <label for="bio">Bio</label>
      <textarea id="bio" name="bio"
                class="form-control ${not empty error && empty employee.bio ? 'is-invalid' : ''}"
                rows="4">${employee.bio}</textarea>
      <c:if test="${not empty error && empty employee.bio}">
        <div class="error-message">Bio is required</div>
      </c:if>
    </div>

    <div class="form-group">
      <label for="photo_url">Photo URL</label>
      <input type="url" id="photo_url" name="photo_url"
             value="${employee.photoUrl}"
             class="form-control ${not empty error && empty employee.photoUrl ? 'is-invalid' : ''}"/>
      <c:if test="${not empty employee.photoUrl}">
        <div style="margin-top: 10px;">
          <img src="${employee.photoUrl}" class="img-thumbnail" alt="Employee Photo">
        </div>
      </c:if>
      <c:if test="${not empty error && empty employee.photoUrl}">
        <div class="error-message">Photo URL is required</div>
      </c:if>
    </div>

    <div class="btn-group">
      <button type="submit" class="btn btn-primary">
        <c:out value="${employee.empId == 0 ? 'Create' : 'Update'}"/> Employee
      </button>
      <a href="${param.fromAdmin == 'true' ?
                      pageContext.request.contextPath.concat('/admin-table?table=employees') :
                      pageContext.request.contextPath.concat('/employees')}"
         class="btn btn-secondary">Cancel</a>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Client-side validation
  document.querySelector('form').addEventListener('submit', function(e) {
    let isValid = true;
    const requiredFields = ['user_id', 'name', 'position', 'phone', 'email'];

    requiredFields.forEach(fieldId => {
      const field = document.getElementById(fieldId);
      if (!field.value.trim()) {
        field.classList.add('is-invalid');
        isValid = false;
      } else {
        field.classList.remove('is-invalid');
      }
    });

    if (!isValid) {
      e.preventDefault();
      alert('Please fill in all required fields');
    }
  });
</script>
</body>
</html>