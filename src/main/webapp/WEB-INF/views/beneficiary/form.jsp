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