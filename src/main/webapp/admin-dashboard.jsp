<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
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
    </style>
</head>
<body>
<h1>Welcome, Admin</h1>

<c:if test="${not empty error}">
    <div class="error-message">${error}</div>
</c:if>

<div class="dashboard-container">
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
</body>
</html>