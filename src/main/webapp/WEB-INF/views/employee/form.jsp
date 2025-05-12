<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title><c:out value="${employee.empId == 0 ? 'Add New' : 'Edit'}"/> Employee</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f4f6f9;
      color: #333;
      margin: 0;
      padding: 40px;
    }

    h1 {
      color: #2c3e50;
      font-size: 28px;
      text-align: center;
      margin-bottom: 30px;
    }

    .form-container {
      background: #fff;
      padding: 30px 40px;
      max-width: 700px;
      margin: 0 auto;
      border-radius: 10px;
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
    }

    .form-group {
      margin-bottom: 20px;
      display: flex;
      flex-direction: column;
    }

    label {
      margin-bottom: 6px;
      font-weight: 600;
      color: #34495e;
    }

    .form-control {
      padding: 10px 12px;
      border: 1px solid #dcdfe6;
      border-radius: 6px;
      font-size: 15px;
      transition: border-color 0.3s, box-shadow 0.3s;
    }

    .form-control:focus {
      border-color: #3498db;
      outline: none;
      box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
    }

    textarea.form-control {
      resize: vertical;
      min-height: 80px;
    }

    .form-control.is-invalid {
      border-color: #e74c3c;
      box-shadow: none;
    }

    .error-message {
      color: #e74c3c;
      background-color: #fcebea;
      padding: 10px;
      border-radius: 5px;
      margin-top: 5px;
      font-size: 14px;
    }

    .btn-group {
      display: flex;
      justify-content: center;
      gap: 15px;
      margin-top: 30px;
    }

    .btn {
      padding: 10px 20px;
      border-radius: 6px;
      font-size: 15px;
      cursor: pointer;
      transition: background-color 0.3s, transform 0.2s;
      text-align: center;
      text-decoration: none;
      border: none;
    }

    .btn-primary {
      background-color: #3498db;
      color: white;
    }

    .btn-primary:hover {
      background-color: #2980b9;
      transform: translateY(-2px);
    }

    .btn-secondary {
      background-color: #95a5a6;
      color: white;
    }

    .btn-secondary:hover {
      background-color: #7f8c8d;
      transform: translateY(-2px);
    }

    .img-thumbnail {
      max-width: 100px;
      max-height: 100px;
      border: 1px solid #ddd;
      border-radius: 4px;
      padding: 5px;
      margin-top: 10px;
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