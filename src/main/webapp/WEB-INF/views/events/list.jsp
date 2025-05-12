<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Event Management System</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
  <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
  <style>
    .card-header {
      background-color: #f8f9fa;
    }
    .action-btns .btn {
      padding: 0.25rem 0.5rem;
      font-size: 0.875rem;
    }
    .dataTables_wrapper .row:first-child,
    .dataTables_wrapper .row:last-child {
      padding: 1rem 0;
    }
  </style>
</head>
<body class="bg-light">
<div class="container py-4">
  <div class="card shadow">
    <div class="card-header d-flex justify-content-between align-items-center">
      <h2 class="mb-0"><i class="bi bi-calendar3"></i> Event Management</h2>
      <a href="${pageContext.request.contextPath}/events/new${fromAdmin ? '?fromAdmin=true' : ''}"
         class="btn btn-primary">
        <i class="bi bi-plus"></i> Add New Event
      </a>
    </div>
    <div class="card-body">
      <table id="eventsTable" class="table table-striped table-hover">
        <thead class="table-light">
        <tr>
          <th>ID</th>
          <th>Event Name</th>
          <th>Date</th>
          <th>Location</th>
          <th>Organizer</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${events}" var="event">
          <tr>
            <td>${event.eventId}</td>
            <td>${event.name}</td>
            <td>${event.date}</td>
            <td>${event.location}</td>
            <td>${event.organizer}</td>
            <td class="action-btns">
              <a href="${pageContext.request.contextPath}/events/edit?id=${event.eventId}"
                 class="btn btn-sm btn-outline-primary">
                <i class="bi bi-pencil"></i> Edit
              </a>
              <a href="${pageContext.request.contextPath}/events/delete?id=${event.eventId}"
                 class="btn btn-sm btn-outline-danger"
                 onclick="return confirm('Are you sure you want to delete this event?')">
                <i class="bi bi-trash"></i> Delete
              </a>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
  $(document).ready(function() {
    $('#eventsTable').DataTable({
      responsive: true,
      columnDefs: [
        { orderable: false, targets: [5] }
      ]
    });
  });
</script>
</body>
</html>