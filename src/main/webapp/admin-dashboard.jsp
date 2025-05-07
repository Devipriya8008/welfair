<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        /* Keep all existing CSS styles */
        .dashboard-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin: 20px;
        }
        .stat-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            margin-top: 0;
            color: #495057;
        }
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
        }
        .error-message {
            color: red;
            padding: 20px;
        }

        /* Add these new styles without modifying existing ones */
        .auth-forms {
            margin: 30px auto;
            max-width: 500px;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .auth-forms h2 {
            margin-top: 0;
            color: #2c3e50;
        }
        .form-toggle {
            margin-top: 15px;
            text-align: center;
        }
        .form-toggle a {
            color: #3498db;
            cursor: pointer;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
<h1>Welcome, Admin</h1>

<c:if test="${not empty error}">
    <div class="error-message">${error}</div>
</c:if>

<c:if test="${not empty message}">
    <div class="success-message">${message}</div>
</c:if>

<!-- Add these forms to the dashboard -->
<div class="auth-forms">
    <!-- Registration Form -->
    <div id="register-form">
        <h2>Register New Admin</h2>
        <form action="dashboard" method="post">
            <input type="hidden" name="action" value="register">
            <input type="text" name="username" placeholder="Username" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Register</button>
        </form>
        <div class="form-toggle">
            <a onclick="showForgotPassword()">Forgot Password?</a>
        </div>
    </div>

    <!-- Forgot Password Form (hidden by default) -->
    <div id="forgot-password-form" class="hidden">
        <h2>Reset Password</h2>
        <form action="dashboard" method="post">
            <input type="hidden" name="action" value="forgot-password">
            <input type="email" name="email" placeholder="Enter your email" required>
            <button type="submit">Send Reset Link</button>
        </form>
        <div class="form-toggle">
            <a onclick="showRegisterForm()">Back to Registration</a>
        </div>
    </div>
</div>

<div class="dashboard-container">
    <!-- Keep all existing stat cards -->
    <div class="stat-card">
        <h3>Total Donations</h3>
        <div class="stat-value">
            ₹<c:out value="${totalDonations != null ? totalDonations : 'N/A'}" />
        </div>
    </div>

    <div class="stat-card">
        <h3>Active Projects</h3>
        <div class="stat-value">
            <c:out value="${activeProjects != null ? activeProjects : 'N/A'}" />
        </div>
    </div>

    <div class="stat-card">
        <h3>Inventory Items</h3>
        <div class="stat-value">
            <c:out value="${inventoryItems != null ? inventoryItems : 'N/A'}" />
        </div>
    </div>

    <div class="stat-card">
        <h3>Beneficiaries</h3>
        <div class="stat-value">
            <c:out value="${beneficiaryCount != null ? beneficiaryCount : 'N/A'}" />
        </div>
    </div>
</div>

<script>
    function showForgotPassword() {
        document.getElementById('register-form').classList.add('hidden');
        document.getElementById('forgot-password-form').classList.remove('hidden');
    }

    function showRegisterForm() {
        document.getElementById('forgot-password-form').classList.add('hidden');
        document.getElementById('register-form').classList.remove('hidden');
    }
</script>
</body>
</html>