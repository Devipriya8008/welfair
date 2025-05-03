<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${empty event ? 'Add New Event' : 'Edit Event'}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    .form-container {
      max-width: 800px;
      margin: 2rem auto;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 0 20px rgba(0,0,0,0.1);
      background-color: white;
    }
    .form-header {
      border-bottom: 1px solid #eee;
      padding-bottom: 1rem;
      margin-bottom: 2rem;
    }
  </style>
</head>
<body class="bg-light">
<div class="container">
  <div class="form-container">
    <div class="form-header">
      <h2><i class="bi bi-calendar-event"></i> ${empty event ? 'Add New Event' : 'Edit Event'}</h2>
    </div>

    <form action="${pageContext.request.contextPath}/events" method="post">
      <input type="hidden" name="id" value="${event.eventId}">

      <div class="row mb-3">
        <div class="col-md-6">
          <label class="form-label">Event Name <span class="text-danger">*</span></label>
          <input type="text" name="name" value="${event.name}"
                 class="form-control" required placeholder="Enter event name">
        </div>
        <div class="col-md-6">
          <label class="form-label">Date <span class="text-danger">*</span></label>
          <input type="date" name="date"
                 value="${not empty event ? event.date : ''}"
                 class="form-control" required>
        </div>
      </div>

      <div class="row mb-3">
        <div class="col-md-6">
          <label class="form-label">Location <span class="text-danger">*</span></label>
          <input type="text" name="location" value="${event.location}"
                 class="form-control" required placeholder="Enter location">
        </div>
        <div class="col-md-6">
          <label class="form-label">Organizer <span class="text-danger">*</span></label>
          <input type="text" name="organizer" value="${event.organizer}"
                 class="form-control" required placeholder="Enter organizer name">
        </div>
      </div>

      <div class="d-flex justify-content-between mt-4">
        <a href="${pageContext.request.contextPath}/events/list" class="btn btn-outline-secondary">
          <i class="bi bi-arrow-left"></i> Back to List
        </a>
        <button type="submit" class="btn btn-primary">
          <i class="bi bi-save"></i> ${empty event ? 'Create Event' : 'Update Event'}
        </button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>