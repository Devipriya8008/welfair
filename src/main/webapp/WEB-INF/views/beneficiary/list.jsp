<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.welfair.model.Beneficiary" %>
<%
  List<Beneficiary> list = (List<Beneficiary>) request.getAttribute("beneficiaries");
%>
<html>
<head>
  <title>Beneficiary List</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    table { border-collapse: collapse; width: 100%; margin-top: 20px; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; }
    tr:nth-child(even) { background-color: #f9f9f9; }
    a { text-decoration: none; color: #0066cc; }
    a:hover { text-decoration: underline; }
  </style>
</head>
<body>
<h2>Beneficiaries</h2>
<a href="beneficiaries?action=new">Add New Beneficiary</a><br><br>

<% if (list.isEmpty()) { %>
<p>No beneficiaries found.</p>
<% } else { %>
<table>
  <tr>
    <th>ID</th>
    <th>Name</th>
    <th>Age</th>
    <th>Gender</th>
    <th>Address</th>
    <th>Actions</th>
  </tr>
  <% for (Beneficiary b : list) { %>
  <tr>
    <td><%= b.getBeneficiaryId() %></td>
    <td><%= b.getName() %></td>
    <td><%= b.getAge() %></td>
    <td><%= b.getGender() %></td>
    <td><%= b.getAddress() %></td>
    <td>
      <a href="beneficiaries?action=edit&id=<%= b.getBeneficiaryId() %>">Edit</a> |
      <a href="beneficiaries?action=delete&id=<%= b.getBeneficiaryId() %>"
         onclick="return confirm('Are you sure you want to delete this beneficiary?')">Delete</a>
    </td>
  </tr>
  <% } %>
</table>
<% } %>
</body>
</html>