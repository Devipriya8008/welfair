<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.welfair.model.Donation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Donation d = (Donation) request.getAttribute("donation");
    boolean edit = d != null && d.getDonationId() > 0;
    String errorMessage = (String) request.getAttribute("errorMessage");
    String formattedDate = "";
    if (edit && d.getDate() != null) {
        formattedDate = d.getDate().toLocalDateTime().toLocalDate().toString();
    }
%>
<html>
<head>
    <title><%= edit ? "Edit" : "Add" %> Donation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        form { max-width: 500px; }
        input[type="text"], input[type="number"], select, input[type="date"] {
            width: 100%;
            padding: 8px;
            margin: 5px 0 15px;
            box-sizing: border-box;
        }
        .error { color: red; }
    </style>
</head>
<body>
<h2><%= edit ? "Edit" : "Add New" %> Donation</h2>

<% if (errorMessage != null) { %>
<p class="error"><%= errorMessage %></p>
<% } %>

<form action="donations" method="post">
    <% if (edit) { %>
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="donation_id" value="<%= d.getDonationId() %>">
    <% } %>

    Donor ID:
    <input type="number" name="donor_id" value="<%= edit ? d.getDonorId() : "" %>" min="1" required><br>

    Project ID:
    <input type="number" name="project_id" value="<%= edit ? d.getProjectId() : "" %>" min="1" required><br>

    Amount:
    <input type="text" name="amount" value="<%= edit ? d.getAmount() : "" %>" required><br>

    Date (YYYY-MM-DD):
    <input type="date" name="date" value="<%= formattedDate %>" required><br>

    Payment Mode:
    <select name="mode" required>
        <option value="">-- Select Mode --</option>
        <option value="Cash" <%= edit && "Cash".equals(d.getMode()) ? "selected" : "" %>>Cash</option>
        <option value="Credit Card" <%= edit && "Credit Card".equals(d.getMode()) ? "selected" : "" %>>Credit Card</option>
        <option value="Bank Transfer" <%= edit && "Bank Transfer".equals(d.getMode()) ? "selected" : "" %>>Bank Transfer</option>
        <option value="Check" <%= edit && "Check".equals(d.getMode()) ? "selected" : "" %>>Check</option>
    </select><br>

    <input type="submit" value="<%= edit ? "Update" : "Add" %>">
    <a href="donations" style="margin-left: 10px;">Cancel</a>
</form>
</body>
</html>