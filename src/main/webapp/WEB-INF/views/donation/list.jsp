<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.welfair.model.Donation, java.util.Collections" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  @SuppressWarnings("unchecked")
  List<Donation> list = (List<Donation>) request.getAttribute("donations");
  if (list == null) list = Collections.emptyList();
  request.setAttribute("donationList", list); // For JSTL access
%>
<html>
<head>
  <title>Donation List</title>
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
<h2>Donations</h2>
<a href="donations?action=new">Add New Donation</a><br><br>

<c:choose>
  <c:when test="${empty donationList}">
    <p>No donations found.</p>
  </c:when>
  <c:otherwise>
    <table>
      <tr>
        <th>ID</th>
        <th>Donor ID</th>
        <th>Project ID</th>
        <th>Amount</th>
        <th>Date</th>
        <th>Mode</th>
        <th>Actions</th>
      </tr>
      <c:forEach items="${donationList}" var="d">
        <tr>
          <td>${d.donationId}</td>
          <td>${d.donorId}</td>
          <td>${d.projectId}</td>
          <td>${d.amount}</td>
          <td>${d.date}</td>
          <td>${d.mode}</td>
          <td>
            <a href="donations?action=edit&id=${d.donationId}">Edit</a> |
            <a href="donations?action=delete&id=${d.donationId}"
               onclick="return confirm('Are you sure you want to delete this donation?')">Delete</a>
          </td>
        </tr>
      </c:forEach>
    </table>
  </c:otherwise>
</c:choose>
</body>
</html>