<%@ page import="java.sql.*, com.welfair.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Database configuration
    String dbURL = "jdbc:postgresql://localhost:5432/welfair_db";
    String dbUser = "postgres";
    String dbPassword = "@devi8008";

// Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null || !"donor".equals(user.getRole())) {
        response.sendRedirect("login.jsp?role=donor");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Active Projects</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .project-card {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .progress-container {
            width: 100%;
            background-color: #f1f1f1;
            border-radius: 5px;
            margin: 10px 0;
        }
        .progress-bar {
            height: 20px;
            background-color: #4CAF50;
            border-radius: 5px;
            text-align: center;
            line-height: 20px;
            color: white;
        }
    </style>
</head>
<body>
<h1>Active Projects</h1>

<%
    try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
        // Simple query to fetch only active projects
        String projectQuery = "SELECT p.project_id, p.name, p.description, " +
                "COALESCE(SUM(d.amount), 0) AS donated_amount, " +
                "(SELECT COALESCE(SUM(fa.amount), 0) FROM fund_allocation fa WHERE fa.project_id = p.project_id) AS needed_amount " +
                "FROM projects p " +
                "LEFT JOIN donations d ON p.project_id = d.project_id " +
                "WHERE p.status = 'Active' AND (p.end_date >= CURRENT_DATE OR p.end_date IS NULL) " +
                "GROUP BY p.project_id, p.name, p.description " +
                "ORDER BY p.name";

        try (PreparedStatement pstmt = conn.prepareStatement(projectQuery)) {
            ResultSet rs = pstmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                System.out.println("<p>No active projects found.</p>");
            }

            while (rs.next()) {
                double donated = rs.getDouble("donated_amount");
                double needed = rs.getDouble("needed_amount");
                double percentage = needed > 0 ? (donated / needed) * 100 : 0;
%>
<div class="project-card">
    <h3><%= rs.getString("name") %></h3>
    <p><%= rs.getString("description") %></p>

    <div class="progress-container">
        <div class="progress-bar" style="width: <%= percentage %>%">
            <%= String.format("%.0f", percentage) %>%
        </div>
    </div>

    <p>Raised: $<%= String.format("%,.2f", donated) %> of $<%= String.format("%,.2f", needed) %></p>
</div>
<%
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        System.out.println("<p style='color:red'>Error loading projects: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>