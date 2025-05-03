<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>Fund Allocations</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Fund Allocations</h2>
    <a href="${pageContext.request.contextPath}/funds/new" class="btn btn-success">+ New Allocation</a>
  </div>

  <table class="table table-bordered table-striped">
    <thead class="table-light">
    <tr>
      <th>ID</th>
      <th>Project ID</th>
      <th>Amount</th>
      <th>Date Allocated</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="fund" items="${funds}">
      <tr>
        <td>${fund.fundId}</td>
        <td>${fund.projectId}</td>
        <td><fmt:formatNumber value="${fund.amount}" type="currency" currencySymbol="$"/></td>
        <td><fmt:formatDate value="${fund.dateAllocated}" pattern="yyyy-MM-dd"/></td>
        <td>
          <a href="${pageContext.request.contextPath}/funds/edit?id=${fund.fundId}" class="btn btn-sm btn-primary">Edit</a>
          <a href="${pageContext.request.contextPath}/funds/delete?id=${fund.fundId}"
             onclick="return confirm('Are you sure you want to delete this allocation?');"
             class="btn btn-sm btn-danger">Delete</a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>
</body>
</html>
