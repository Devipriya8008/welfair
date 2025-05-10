<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Volunteer Dashboard</title>
  <!-- Include your existing styles -->
</head>
<body>
<header>
  <!-- Your existing header -->
</header>

<div class="container">
  <h1>Welcome, ${sessionScope.user.username}</h1>

  <div class="dashboard-section">
    <h2>Event Registration</h2>
    <a href="events.jsp?source=dashboard&filter=volunteer" class="auth-btn btn-primary">
      View Volunteer Opportunities
    </a>
  </div>

  <!-- Add other dashboard sections as needed -->
</div>

<!-- Include your existing footer -->
</body>
</html>