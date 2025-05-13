<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.welfair.model.Beneficiary" %>
<%
    Beneficiary b = (Beneficiary) request.getAttribute("beneficiary");
    boolean edit = b != null && b.getBeneficiaryId() > 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= edit ? "Edit" : "Add New" %> Beneficiary</title>
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
        input[type="number"],
        select {
            padding: 10px 12px;
            border: 1px solid #dcdfe6;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input:focus,
        select:focus {
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
            margin-top: 20px;
            font-weight: 500;
        }
    </style>
</head>
<body>
<h2><%= edit ? "Edit" : "Add New" %> Beneficiary</h2>

<form action="beneficiaries" method="post">
    <% if (edit) { %>
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="beneficiary_id" value="<%= b.getBeneficiaryId() %>">
    <% } else { %>
    <input type="hidden" name="action" value="create">
    <% } %>

    <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<%= edit ? b.getName() : "" %>" required>
    </div>

    <div class="form-group">
        <label for="age">Age:</label>
        <input type="number" id="age" name="age" value="<%= edit ? b.getAge() : "" %>" min="1" required>
    </div>

    <div class="form-group">
        <label for="gender">Gender:</label>
        <select id="gender" name="gender" required>
            <option value="">-- Select Gender --</option>
            <option value="Male" <%= edit && "Male".equals(b.getGender()) ? "selected" : "" %>>Male</option>
            <option value="Female" <%= edit && "Female".equals(b.getGender()) ? "selected" : "" %>>Female</option>
            <option value="Other" <%= edit && "Other".equals(b.getGender()) ? "selected" : "" %>>Other</option>
        </select>
    </div>

    <div class="form-group">
        <label for="address">Address:</label>
        <input type="text" id="address" name="address" value="<%= edit ? b.getAddress() : "" %>" required>
    </div>

    <div class="button-group">
        <button type="submit" class="button"><%= edit ? "Update" : "Add" %></button>
        <a href="beneficiaries" class="button cancel-button">Cancel</a>
    </div>
</form>

<% if (request.getAttribute("errorMessage") != null) { %>
<p class="error"><%= request.getAttribute("errorMessage") %></p>
<% } %>

</body>
</html>
