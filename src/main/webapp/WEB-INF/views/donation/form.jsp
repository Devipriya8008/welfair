<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>${empty donation.donationId ? 'Add' : 'Edit'} Donation</title>
    <style>
        .error { color: red; }
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