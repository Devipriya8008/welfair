<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>${empty fund ? 'Add New Fund Allocation' : 'Edit Fund Allocation'}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
  <h2>${empty fund ? 'Add New Fund Allocation' : 'Edit Fund Allocation'}</h2>
  <form action="${pageContext.request.contextPath}/fund_allocated" method="post">
    <input type="hidden" name="id" value="${fund.fundId}"/>

    <div class="mb-3">
      <label>Project ID</label>
      <input type="number" name="projectId" value="${fund.projectId}" class="form-control" required/>
    </div>

    <div class="mb-3">
      <label>Amount</label>
      <input type="text" name="amount" value="${fund.amount}" class="form-control" required pattern="^\d+(\.\d{1,2})?$"/>
    </div>

    <div class="mb-3">
      <label>Date Allocated</label>
      <input type="date" name="dateAllocated"
             value="<fmt:formatDate value='${fund.dateAllocated}' pattern='yyyy-MM-dd'/>"
             class="form-control" required/>
    </div>

    <div class="d-flex justify-content-between">
      <a href="${pageContext.request.contextPath}/funds/list" class="btn btn-secondary">Back</a>
      <button type="submit" class="btn btn-primary">${empty fund ? 'Create' : 'Update'}</button>
    </div>
  </form>
</div>
</body>
</html>
