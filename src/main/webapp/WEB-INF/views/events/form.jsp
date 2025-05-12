<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>${empty event.eventId ? 'Add New' : 'Edit'} Event</title>
  <!-- Include your CSS/JS links here -->
</head>
<body>
<form action="${pageContext.request.contextPath}/events${empty event.eventId ? '' : '/update'}" method="post">
  <input type="hidden" name="id" value="${event.eventId}">
  <input type="hidden" name="fromAdmin" value="${fromAdmin}">

  <!-- Your form fields here -->

  <div class="form-actions">
    <a href="${fromAdmin ? pageContext.request.contextPath.concat('/admin-table?table=events') :
                                  pageContext.request.contextPath.concat('/events/list')}"
       class="btn btn-secondary">Cancel</a>
    <button type="submit" class="btn btn-primary">
      ${empty event.eventId ? 'Create' : 'Update'} Event
    </button>
  </div>
</form>
</body>
</html>