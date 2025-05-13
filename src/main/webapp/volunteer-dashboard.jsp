<%@ page import="java.sql.*, java.util.*, java.io.*, jakarta.mail.*, jakarta.mail.internet.*, com.itextpdf.text.*, com.itextpdf.text.pdf.*" %>
<%@ page import="jakarta.mail.util.ByteArrayDataSource" %>
<%@ page import="jakarta.activation.DataHandler" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  // Database connection parameters
  String dbURL = "jdbc:postgresql://localhost:5432/welfair_db";
  String dbUser = "postgres";
  String dbPassword = "@devi8008";

  // Assume user is already logged in and session contains user_id
  Integer userId = (Integer) session.getAttribute("user_id");
  if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  // Handle registration for projects or events
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String projectId = request.getParameter("project_id");
    String eventId = request.getParameter("event_id");

    try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
      // Get volunteer_id from user_id
      int volunteerId = 0;
      String volunteerQuery = "SELECT volunteer_id FROM volunteers WHERE user_id = ?";
      try (PreparedStatement pstmt = conn.prepareStatement(volunteerQuery)) {
        pstmt.setInt(1, userId);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
          volunteerId = rs.getInt("volunteer_id");
        }
      }

      if (projectId != null && !projectId.isEmpty()) {
        // Register for project
        String registerQuery = "INSERT INTO volunteer_projects (project_id, volunteer_id, role) VALUES (?, ?, 'Volunteer')";
        try (PreparedStatement pstmt = conn.prepareStatement(registerQuery)) {
          pstmt.setInt(1, Integer.parseInt(projectId));
          pstmt.setInt(2, volunteerId);
          pstmt.executeUpdate();

          // Get project details for email
          String projectQuery = "SELECT * FROM projects WHERE project_id = ?";
          try (PreparedStatement projectStmt = conn.prepareStatement(projectQuery)) {
            projectStmt.setInt(1, Integer.parseInt(projectId));
            ResultSet projectRs = projectStmt.executeQuery();
            if (projectRs.next()) {
              sendConfirmationEmail(conn, userId, "project", projectRs);
            }
          }
        }
      } else if (eventId != null && !eventId.isEmpty()) {
        // Register for event
        String registerQuery = "INSERT INTO event_volunteers (event_id, volunteer_id) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(registerQuery)) {
          pstmt.setInt(1, Integer.parseInt(eventId));
          pstmt.setInt(2, volunteerId);
          pstmt.executeUpdate();

          // Get event details for email
          String eventQuery = "SELECT * FROM events WHERE event_id = ?";
          try (PreparedStatement eventStmt = conn.prepareStatement(eventQuery)) {
            eventStmt.setInt(1, Integer.parseInt(eventId));
            ResultSet eventRs = eventStmt.executeQuery();
            if (eventRs.next()) {
              sendConfirmationEmail(conn, userId, "event", eventRs);
            }
          }
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
%>

<%!
  // Method to send confirmation email with PDF attachment
  private void sendConfirmationEmail(Connection conn, int userId, String type, ResultSet rs)
          throws SQLException, MessagingException, DocumentException, IOException {

    // Get user email
    String email = "";
    String userQuery = "SELECT email FROM users WHERE user_id = ?";
    try (PreparedStatement pstmt = conn.prepareStatement(userQuery)) {
      pstmt.setInt(1, userId);
      ResultSet userRs = pstmt.executeQuery();
      if (userRs.next()) {
        email = userRs.getString("email");
      }
    }

    // Create PDF
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    Document document = new Document();
    PdfWriter.getInstance(document, baos);
    document.open();

    Paragraph title = new Paragraph();
    title.add(new Chunk("Registration Confirmation", new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD)));
    document.add(title);

    document.add(new Paragraph(" "));

    if ("project".equals(type)) {
      Paragraph projectTitle = new Paragraph();
      projectTitle.add(new Chunk("Project: " + rs.getString("name"), new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD)));
      document.add(projectTitle);

      document.add(new Paragraph("Description: " + rs.getString("description")));
      document.add(new Paragraph("Start Date: " + rs.getDate("start_date")));
      document.add(new Paragraph("End Date: " + rs.getDate("end_date")));
      document.add(new Paragraph("Status: " + rs.getString("status")));
    } else {
      Paragraph eventTitle = new Paragraph();
      eventTitle.add(new Chunk("Event: " + rs.getString("name"), new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD)));
      document.add(eventTitle);

      document.add(new Paragraph("Date: " + rs.getDate("date")));
      document.add(new Paragraph("Location: " + rs.getString("location")));
      document.add(new Paragraph("Time: " + rs.getTime("time")));
      document.add(new Paragraph("Description: " + rs.getString("short_description")));
    }

    document.close();

    // Email setup
    Properties props = new Properties();
    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.port", "587");
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.starttls.enable", "true");

    Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
      protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication("welfairngo@gmail.com", "vkxiaumhynijumuy");
      }
    });

    try {
      Message message = new MimeMessage(session);
      message.setFrom(new InternetAddress("welfairngo@gmail.com"));
      message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
      message.setSubject("Registration Confirmation");

      // Create the message part
      MimeBodyPart messageBodyPart = new MimeBodyPart();
      messageBodyPart.setText("Thank you for registering. Please find attached your confirmation details.");

      // Create attachment part
      MimeBodyPart attachmentPart = new MimeBodyPart();
      attachmentPart.setDataHandler(new DataHandler(new ByteArrayDataSource(baos.toByteArray(), "application/pdf")));
      attachmentPart.setFileName("registration_confirmation.pdf");

      // Create multipart message
      Multipart multipart = new MimeMultipart();
      multipart.addBodyPart(messageBodyPart);
      multipart.addBodyPart(attachmentPart);

      message.setContent(multipart);
      Transport.send(message);
    } catch (MessagingException e) {
      throw new RuntimeException(e);
    }
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Volunteer Dashboard</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 20px;
      background-color: #f5f5f5;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      background-color: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    h1, h2 {
      color: #2c3e50;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }
    th, td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    th {
      background-color: #3498db;
      color: white;
    }
    tr:hover {
      background-color: #f5f5f5;
    }
    .btn {
      background-color: #2ecc71;
      color: white;
      border: none;
      padding: 8px 16px;
      text-align: center;
      text-decoration: none;
      display: inline-block;
      font-size: 14px;
      margin: 4px 2px;
      cursor: pointer;
      border-radius: 4px;
    }
    .btn:hover {
      background-color: #27ae60;
    }
    .tabs {
      overflow: hidden;
      border: 1px solid #ccc;
      background-color: #f1f1f1;
      border-radius: 4px;
    }
    .tab {
      background-color: inherit;
      float: left;
      border: none;
      outline: none;
      cursor: pointer;
      padding: 14px 16px;
      transition: 0.3s;
    }
    .tab:hover {
      background-color: #ddd;
    }
    .tab.active {
      background-color: #3498db;
      color: white;
    }
    .tabcontent {
      display: none;
      padding: 20px 0;
      border-top: none;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>Volunteer Dashboard</h1>

  <div class="tabs">
    <button class="tab active" onclick="openTab(event, 'projects')">Projects</button>
    <button class="tab" onclick="openTab(event, 'events')">Events</button>
  </div>

  <div id="projects" class="tabcontent" style="display: block;">
    <h2>Available Projects</h2>
    <table>
      <thead>
      <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Start Date</th>
        <th>End Date</th>
        <th>Status</th>
        <th>Action</th>
      </tr>
      </thead>
      <tbody>
      <%
        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
          // Get volunteer_id from user_id
          int volunteerId = 0;
          String volunteerQuery = "SELECT volunteer_id FROM volunteers WHERE user_id = ?";
          try (PreparedStatement pstmt = conn.prepareStatement(volunteerQuery)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
              volunteerId = rs.getInt("volunteer_id");
            }
          }

          // Get all projects
          String projectQuery = "SELECT p.*, " +
                  "CASE WHEN vp.project_id IS NOT NULL THEN true ELSE false END AS is_registered " +
                  "FROM projects p " +
                  "LEFT JOIN volunteer_projects vp ON p.project_id = vp.project_id AND vp.volunteer_id = ? " +
                  "WHERE p.end_date >= CURRENT_DATE OR p.end_date IS NULL";

          try (PreparedStatement pstmt = conn.prepareStatement(projectQuery)) {
            pstmt.setInt(1, volunteerId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
              boolean isRegistered = rs.getBoolean("is_registered");
      %>
      <tr>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("description") %></td>
        <td><%= rs.getDate("start_date") %></td>
        <td><%= rs.getDate("end_date") %></td>
        <td><%= rs.getString("status") %></td>
        <td>
          <% if (!isRegistered) { %>
          <form method="POST" style="display: inline;">
            <input type="hidden" name="project_id" value="<%= rs.getInt("project_id") %>">
            <button type="submit" class="btn">Register Now</button>
          </form>
          <% } else { %>
          <span>Already Registered</span>
          <% } %>
        </td>
      </tr>
      <%
            }
          }
        } catch (SQLException e) {
          e.printStackTrace();
        }
      %>
      </tbody>
    </table>
  </div>

  <div id="events" class="tabcontent">
    <h2>Upcoming Events</h2>
    <table>
      <thead>
      <tr>
        <th>Name</th>
        <th>Date</th>
        <th>Location</th>
        <th>Time</th>
        <th>Description</th>
        <th>Action</th>
      </tr>
      </thead>
      <tbody>
      <%
        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
          // Get volunteer_id from user_id
          int volunteerId = 0;
          String volunteerQuery = "SELECT volunteer_id FROM volunteers WHERE user_id = ?";
          try (PreparedStatement pstmt = conn.prepareStatement(volunteerQuery)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
              volunteerId = rs.getInt("volunteer_id");
            }
          }

          // Get all events
          String eventQuery = "SELECT e.*, " +
                  "CASE WHEN ev.event_id IS NOT NULL THEN true ELSE false END AS is_registered " +
                  "FROM events e " +
                  "LEFT JOIN event_volunteers ev ON e.event_id = ev.event_id AND ev.volunteer_id = ? " +
                  "WHERE e.date >= CURRENT_DATE";

          try (PreparedStatement pstmt = conn.prepareStatement(eventQuery)) {
            pstmt.setInt(1, volunteerId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
              boolean isRegistered = rs.getBoolean("is_registered");
      %>
      <tr>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getDate("date") %></td>
        <td><%= rs.getString("location") %></td>
        <td><%= rs.getTime("time") %></td>
        <td><%= rs.getString("short_description") %></td>
        <td>
          <% if (!isRegistered) { %>
          <form method="POST" style="display: inline;">
            <input type="hidden" name="event_id" value="<%= rs.getInt("event_id") %>">
            <button type="submit" class="btn">Register Now</button>
          </form>
          <% } else { %>
          <span>Already Registered</span>
          <% } %>
        </td>
      </tr>
      <%
            }
          }
        } catch (SQLException e) {
          e.printStackTrace();
        }
      %>
      </tbody>
    </table>
  </div>
</div>

<script>
  function openTab(evt, tabName) {
    var i, tabcontent, tablinks;

    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }

    tablinks = document.getElementsByClassName("tab");
    for (i = 0; i < tablinks.length; i++) {
      tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
  }
</script>
</body>
</html>