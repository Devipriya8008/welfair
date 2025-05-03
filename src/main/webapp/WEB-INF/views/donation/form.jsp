<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.welfair.model.Donation, java.time.format.DateTimeFormatter" %>
<%
    Donation donation = (Donation) request.getAttribute("donation");
    boolean isEdit = donation != null && donation.getDonationId() > 0;
    DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
    String formattedDate = isEdit ? donation.getDate().toLocalDateTime().format(formatter) : "";
%>
<html>
<head>
    <title><%= isEdit ? "Edit" : "Add" %> Donation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-container { max-width: 600px; margin: 0 auto; }
        .form-group { margin-bottom: 15px; }
        label { display: inline-block; width: 120px; font-weight: bold; }
        input[type="text"], input[type="number"], input[type="datetime-local"], select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn {
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn.cancel { background-color: #f44336; margin-left: 10px; }
        .error { color: red; margin-top: 10px; }
    </style>
</head>
<body>
<div class="form-container">
    <h2><%= isEdit ? "Edit" : "Add New" %> Donation</h2>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <p class="error"><%= request.getAttribute("errorMessage") %></p>
    <% } %>

    <form action="donations" method="post">
        <% if (isEdit) { %>
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="donation_id" value="<%= donation.getDonationId() %>">
        <% } %>

        <div class="form-group">
            <label for="donor_id">Donor ID:</label>
            <input type="number" id="donor_id" name="donor_id"
                   value="<%= isEdit ? donation.getDonorId() : "" %>" min="1" required>
        </div>

        <div class="form-group">
            <label for="project_id">Project ID:</label>
            <input type="number" id="project_id" name="project_id"
                   value="<%= isEdit ? donation.getProjectId() : "" %>" min="1" required>
        </div>

        <div class="form-group">
            <label for="amount">Amount:</label>
            <input type="text" id="amount" name="amount"
                   value="<%= isEdit ? String.format("%.2f", donation.getAmount()) : "" %>"
                   pattern="^\d+(\.\d{1,2})?$" title="Enter a valid amount (e.g., 100 or 100.50)" required>
        </div>

        <div class="form-group">
            <label for="date">Date:</label>
            <input type="datetime-local" id="date" name="date"
                   value="<%= formattedDate %>" required>
        </div>

        <div class="form-group">
            <label for="mode">Payment Mode:</label>
            <select id="mode" name="mode" required>
                <option value="">-- Select Mode --</option>
                <option value="Cash" <%= isEdit && "Cash".equals(donation.getMode()) ? "selected" : "" %>>Cash</option>
                <option value="Credit Card" <%= isEdit && "Credit Card".equals(donation.getMode()) ? "selected" : "" %>>Credit Card</option>
                <option value="Bank Transfer" <%= isEdit && "Bank Transfer".equals(donation.getMode()) ? "selected" : "" %>>Bank Transfer</option>
                <option value="Check" <%= isEdit && "Check".equals(donation.getMode()) ? "selected" : "" %>>Check</option>
                <option value="Online" <%= isEdit && "Online".equals(donation.getMode()) ? "selected" : "" %>>Online</option>
            </select>
        </div>

        <div class="form-group">
            <button type="submit" class="btn"><%= isEdit ? "Update" : "Add" %> Donation</button>
            <a href="donations" class="btn cancel">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>