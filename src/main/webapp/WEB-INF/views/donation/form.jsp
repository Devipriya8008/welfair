<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>${empty donation.donationId ? 'Add' : 'Edit'} Donation</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f6f9;
            color: #333;
            margin: 0;
            padding: 40px;
        }

        h2 {
            color: #2c3e50;
            font-size: 28px;
            text-align: center;
            margin-bottom: 30px;
        }

        form {
            background: #fff;
            padding: 30px 40px;
            max-width: 600px;
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

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="number"],
        input[type="datetime-local"],
        select,
        textarea {
            padding: 10px 12px;
            border: 1px solid #dcdfe6;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }

        .button {
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
            text-decoration: none;
            text-align: center;
        }

        .button:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
        }

        .cancel-button {
            background-color: #95a5a6;
        }

        .cancel-button:hover {
            background-color: #7f8c8d;
        }

        .error {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 20px;
            font-weight: 500;
        }
    </style>

</head>
<body>
<h2>${empty donation.donationId ? 'Add' : 'Edit'} Donation</h2>

<c:if test="${not empty errorMessage}">
    <div class="error">${errorMessage}</div>
</c:if>

<form method="post">
    <input type="hidden" name="action" value="${empty donation.donationId ? 'add' : 'update'}">
    <input type="hidden" name="fromAdmin" value="${param.fromAdmin}">

    <c:if test="${not empty donation.donationId}">
        <input type="hidden" name="donation_id" value="${donation.donationId}">
    </c:if>

    <div>
        <label>Donor ID:</label>
        <input type="number" name="donor_id" value="${donation.donorId}" required>
    </div>

    <div>
        <label>Project ID:</label>
        <input type="number" name="project_id" value="${donation.projectId}" required>
    </div>

    <div>
        <label>Amount:</label>
        <input type="number" step="0.01" name="amount"
               value="<fmt:formatNumber value='${donation.amount}' pattern='0.00'/>" required>
    </div>

    <div>
        <label>Date:</label>
        <input type="datetime-local" name="date"
               value="<fmt:formatDate value='${donation.date}' pattern="yyyy-MM-dd'T'HH:mm"/>" required>
    </div>

    <div>
        <label>Payment Mode:</label>
        <select name="mode" required>
            <option value="">Select mode</option>
            <option value="Cash" ${donation.mode eq 'Cash' ? 'selected' : ''}>Cash</option>
            <option value="Bank Transfer" ${donation.mode eq 'Bank Transfer' ? 'selected' : ''}>Bank Transfer</option>
            <option value="Cheque" ${donation.mode eq 'Cheque' ? 'selected' : ''}>Cheque</option>
            <option value="Online" ${donation.mode eq 'Online' ? 'selected' : ''}>Online</option>
        </select>
    </div>

    <button type="submit">Save</button>
    <a href="${pageContext.request.contextPath}/admin-table?table=donations">Cancel</a>
</form>
</body>
</html>