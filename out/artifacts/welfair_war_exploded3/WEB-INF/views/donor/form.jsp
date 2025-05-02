<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>${empty donor.donorId ? 'Add New' : 'Edit'} Donor</title>
</head>
<body>
<h1>${empty donor.donorId ? 'Add New' : 'Edit'} Donor</h1>

<form action="donors" method="post">
  <input type="hidden" name="action" value="${empty donor.donorId ? 'save' : 'update'}">
  <c:if test="${not empty donor.donorId}">
    <input type="hidden" name="donor_id" value="${donor.donorId}">
  </c:if>

  <div>
    <label>Name:</label>
    <input type="text" name="name" value="${donor.name}" required>
  </div>

  <div>
    <label>Email:</label>
    <input type="email" name="email" value="${donor.email}" required>
  </div>

  <div>
    <label>Phone:</label>
    <input type="tel" name="phone" value="${donor.phone}">
  </div>

  <div>
    <label>Address:</label>
    <textarea name="address">${donor.address}</textarea>
  </div>

  <button type="submit">Save</button>
  <a href="donors">Cancel</a>
</form>
<!-- MUST include this hidden field when editing -->
<c:if test="${not empty donor.donorId}">
  <input type="hidden" name="donor_id" value="${donor.donorId}">
</c:if>
</body>
</html>