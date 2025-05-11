<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>${empty donation.donationId ? 'Add' : 'Edit'} Donation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <h2>${empty donation.donationId ? 'Add' : 'Edit'} Donation</h2>

    <form method="post" action="${pageContext.request.contextPath}/donations">
        <input type="hidden" name="action" value="${empty donation.donationId ? 'add' : 'update'}">
        <c:if test="${not empty donation.donationId}">
            <input type="hidden" name="donation_id" value="${donation.donationId}">
        </c:if>

        <div class="mb-3">
            <label for="donor_id" class="form-label">Donor ID</label>
            <input type="number" class="form-control" id="donor_id" name="donor_id"
                   value="${donation.donorId}" required>
        </div>

        <div class="mb-3">
            <label for="project_id" class="form-label">Project ID</label>
            <input type="number" class="form-control" id="project_id" name="project_id"
                   value="${donation.projectId}" required>
        </div>

        <div class="mb-3">
            <label for="amount" class="form-label">Amount (₹)</label>
            <input type="number" step="0.01" class="form-control" id="amount" name="amount"
                   value="<fmt:formatNumber value='${donation.amount}' pattern='0.00'/>" required>
        </div>

        <div class="mb-3">
            <label for="date" class="form-label">Date</label>
            <input type="date" class="form-control" id="date" name="date"
                   value="<fmt:formatDate value='${donation.date}' pattern='yyyy-MM-dd'/>" required>
        </div>

        <div class="mb-3">
            <label for="mode" class="form-label">Payment Mode</label>
            <select class="form-select" id="mode" name="mode" required>
                <option value="">Select payment mode</option>
                <option value="Cash" ${donation.mode eq 'Cash' ? 'selected' : ''}>Cash</option>
                <option value="Bank Transfer" ${donation.mode eq 'Bank Transfer' ? 'selected' : ''}>Bank Transfer</option>
                <option value="Cheque" ${donation.mode eq 'Cheque' ? 'selected' : ''}>Cheque</option>
                <option value="Online" ${donation.mode eq 'Online' ? 'selected' : ''}>Online</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Save</button>
        <a href="${pageContext.request.contextPath}/donations" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>