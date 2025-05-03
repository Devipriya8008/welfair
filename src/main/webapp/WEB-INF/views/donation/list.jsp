<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.welfair.model.Donation, java.text.SimpleDateFormat" %>
<%
  List<Donation> donations = (List<Donation>) request.getAttribute("donations");
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<html>
<head>
  <title>Donation List</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    table { border-collapse: collapse; width: 100%; margin-top: 20px; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; position: sticky; top: 0; }
    tr:nth-child(even) { background-color: #f9f9f9; }
    tr:hover { background-color: #f1f1f1; }
    .actions { white-space: nowrap; }
    a { text-decoration: none; color: #0066cc; margin: 0 5px; }
    a:hover { text-decoration: underline; }
    .add-btn {
      display: inline-block;
      padding: 8px 16px;
      background-color: #4CAF50;
      color: white;
      text-decoration: none;
      border-radius: 4px;
      margin-bottom: 20px;
    }
    .add-btn:hover { background-color: #45a049; }
  </style>
</head>
<body>
<h2>Donation Management</h2>
<a href="donations?action=new" class="add-btn">Add New Donation</a>

<% if (donations.isEmpty()) { %>
<p>No donations found.</p>
<% } else { %>
<table>
  <thead>
  <tr>
    <th>ID</th>
    <th>Donor ID</th>
    <th>Project ID</th>
    <th>Amount</th>
    <th>Date</th>
    <th>Payment Mode</th>
    <th class="actions">Actions</th>
  </tr>
  </thead>
  <tbody>
  <% for (Donation d : donations) { %>
  <tr>
    <td><%= d.getDonationId() %></td>
    <td><%= d.getDonorId() %></td>
    <td><%= d.getProjectId() %></td>
    <td>$<%= String.format("%.2f", d.getAmount()) %></td>
    <td><%= dateFormat.format(d.getDate()) %></td>
    <td><%= d.getMode() %></td>
    <td class="actions">
      <a href="donations?action=edit&id=<%= d.getDonationId() %>">Edit</a>
      <a href="donations?action=delete&id=<%= d.getDonationId() %>"
         onclick="return confirm('Are you sure you want to delete this donation?')">Delete</a>
    </td>
  </tr>
  <% } %>
  </tbody>
</table>
<% } %>
</body>
</html>