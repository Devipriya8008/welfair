<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Project Beneficiary List</title>
</head>
<body>
<h2>Project Beneficiary List</h2>
<a href="<%= request.getContextPath() %>/project-beneficiary/new">Add New Project Beneficiary</a><br><br>
<table border="1">
  <tr>
    <th>Project ID</th>
    <th>Project Name</th>
    <th>Beneficiary ID</th>
    <th>Beneficiary Name</th>
    <th>Date Assigned</th>
    <th>Actions</th>
  </tr>
  <c:forEach var="projectBeneficiary" items="${listProjectBeneficiary}">
    <tr>
      <td>${projectBeneficiary.projectId}</td>
      <td>${projectBeneficiary.projectName}</td>
      <td>${projectBeneficiary.beneficiaryId}</td>
      <td>${projectBeneficiary.beneficiaryName}</td>
      <td>${projectBeneficiary.dateAssigned}</td>
      <td>
        <a href="<%= request.getContextPath() %>/project-beneficiary/edit?projectId=${projectBeneficiary.projectId}&beneficiaryId=${projectBeneficiary.beneficiaryId}">Edit</a>
        <a href="<%= request.getContextPath() %>/project-beneficiary/delete?projectId=${projectBeneficiary.projectId}&beneficiaryId=${projectBeneficiary.beneficiaryId}">Delete</a>
      </td>
    </tr>
  </c:forEach>
</table>
</body>
</html>
