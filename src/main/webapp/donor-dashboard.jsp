<!-- Update donation form -->
<form action="donations" method="post">
    <input type="hidden" name="action" value="create">

    <div class="mb-3">
        <label class="form-label">Project</label>
        <select class="form-select" name="projectId" required>
            <c:forEach items="${activeProjects}" var="project">
                <option value="${project.projectId}">${project.title}</option>
            </c:forEach>
        </select>
    </div>

    <div class="mb-3">
        <label class="form-label">Amount</label>
        <input type="number" class="form-control" name="amount" min="1" required>
    </div>

    <div class="mb-3">
        <label class="form-label">Payment Method</label>
        <select class="form-select" name="paymentMethod" required>
            <option value="Credit Card">Credit Card</option>
            <option value="PayPal">PayPal</option>
            <option value="Bank Transfer">Bank Transfer</option>
        </select>
    </div>

    <button type="submit" class="btn btn-primary">Donate</button>
</form>

<!-- Update donations table -->
<c:forEach items="${donations}" var="donation">
    <tr>
        <td><fmt:formatDate value="${donation.date}" pattern="yyyy-MM-dd"/></td>
        <td>${donation.donationId}</td>
        <td>$${donation.amount}</td>
        <td>${donation.projectTitle}</td>
        <td>${donation.mode}</td>
        <td>
            <a href="#" class="btn btn-sm btn-primary"
               data-bs-toggle="modal"
               data-bs-target="#receiptModal"
               data-receipt-id="${donation.donationId}">
                View Receipt
            </a>
        </td>
    </tr>
</c:forEach>