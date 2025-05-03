<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.welfair.model.Beneficiary" %>
<%
    Beneficiary b = (Beneficiary) request.getAttribute("beneficiary");
    boolean edit = b != null && b.getBeneficiaryId() > 0;
%>
<html>
<head>
    <title><%= edit ? "Edit" : "Add" %> Beneficiary</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        form { max-width: 500px; }
        input[type="text"], input[type="number"], select {
            width: 100%;
            padding: 8px;
            margin: 5px 0 15px;
            box-sizing: border-box;
        }
    </style>
</head>
<body>
<h2><%= edit ? "Edit" : "Add New" %> Beneficiary</h2>
<form action="beneficiaries" method="post">
    <% if (edit) { %>
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="beneficiary_id" value="<%= b.getBeneficiaryId() %>">
    <% } %>

    Name: <input type="text" name="name" value="<%= edit ? b.getName() : "" %>" required><br>

    Age: <input type="number" name="age" value="<%= edit ? b.getAge() : "" %>" min="1" required><br>

    Gender:
    <select name="gender" required>
        <option value="">-- Select Gender --</option>
        <option value="Male" <%= edit && "Male".equals(b.getGender()) ? "selected" : "" %>>Male</option>
        <option value="Female" <%= edit && "Female".equals(b.getGender()) ? "selected" : "" %>>Female</option>
        <option value="Other" <%= edit && "Other".equals(b.getGender()) ? "selected" : "" %>>Other</option>
    </select><br>

    Address: <input type="text" name="address" value="<%= edit ? b.getAddress() : "" %>" required><br>

    <input type="submit" value="<%= edit ? "Update" : "Add" %>">
    <a href="beneficiaries" style="margin-left: 10px;">Cancel</a>
</form>

<% if (request.getAttribute("errorMessage") != null) { %>
<p style="color: red;"><%= request.getAttribute("errorMessage") %></p>
<% } %>

</body>
</html>