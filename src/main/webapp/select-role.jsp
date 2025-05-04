<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Select Role</title>
  <style>
    .role-container {
      display: flex;
      flex-direction: column;
      gap: 20px;
      max-width: 500px;
      margin: 0 auto;
      padding: 20px;
    }
    .role-options {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      justify-content: center;
    }
    .role-btn {
      padding: 10px 20px;
      background: #4CAF50;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
    }
    .role-btn:hover {
      background: #45a049;
    }
    .auth-options {
      display: none;
      margin-top: 20px;
    }
    .auth-btn {
      padding: 10px 20px;
      background: #2196F3;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
      margin: 0 10px;
    }
    .auth-btn:hover {
      background: #0b7dda;
    }
  </style>
</head>
<body>
<div class="role-container">
  <h2>Select Your Role</h2>

  <div class="role-options">
    <button class="role-btn" onclick="selectRole('admin')">Admin</button>
    <button class="role-btn" onclick="selectRole('employee')">Employee</button>
    <button class="role-btn" onclick="selectRole('volunteer')">Volunteer</button>
    <button class="role-btn" onclick="selectRole('donor')">Donor</button>
  </div>

  <div id="authOptions" class="auth-options">
    <h3>Do you want to login or register?</h3>
    <button class="auth-btn" onclick="proceedToLogin()">Login</button>
    <button class="auth-btn" onclick="proceedToRegister()">Register</button>
  </div>
</div>

<script>
  let selectedRole = '';

  function selectRole(role) {
    selectedRole = role;
    document.getElementById('authOptions').style.display = 'block';
  }

  function proceedToLogin() {
    window.location.href = 'login.jsp?role=' + selectedRole;
  }

  function proceedToRegister() {
    window.location.href = 'register.jsp?role=' + selectedRole;
  }
</script>
</body>
</html>