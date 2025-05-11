<%@ page import="java.sql.*, java.util.*, java.io.*, jakarta.mail.*, jakarta.mail.internet.*, com.itextpdf.text.*, com.itextpdf.text.pdf.*" %>
<%@ page import="jakarta.mail.util.ByteArrayDataSource" %>
<%@ page import="jakarta.activation.DataHandler" %>
<%@ page import="com.welfair.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Stripe API for payment processing --%>
<%@ page import="com.stripe.Stripe" %>
<%@ page import="com.stripe.model.Charge" %>
<%@ page import="com.stripe.param.ChargeCreateParams" %>

<%
    // Database connection parameters
    String dbURL = "jdbc:postgresql://localhost:5432/welfair_db";
    String dbUser = "postgres";
    String dbPassword = "@devi8008";

// Stripe API ke
    String stripeApiKey = "sk_test_your_stripe_api_key_here";
    Stripe.apiKey = stripeApiKey;

// Check if user is logged in and is a donor
    User user = (User) session.getAttribute("user");
    if (user == null || !"donor".equals(user.getRole())) {
        response.sendRedirect("login.jsp?role=donor");
        return;
    }

// Get donor_id from user_id
    int donorId = 0;
    try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
        String donorQuery = "SELECT donor_id FROM donors WHERE user_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(donorQuery)) {
            pstmt.setInt(1, user.getUserId());
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                donorId = rs.getInt("donor_id");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

// Handle donation submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String projectId = request.getParameter("project_id");
        String amountStr = request.getParameter("amount");
        String mode = request.getParameter("mode");
        String stripeToken = request.getParameter("stripeToken");

        if (projectId != null && amountStr != null && mode != null && stripeToken != null) {
            try {
                double amount = Double.parseDouble(amountStr);

                // Process payment with Stripe
                try {
                    ChargeCreateParams params = ChargeCreateParams.builder()
                            .setAmount((long)(amount * 100)) // amount in cents
                            .setCurrency("usd")
                            .setDescription("Donation for project ID: " + projectId)
                            .setSource(stripeToken)
                            .build();

                    Charge charge = Charge.create(params);

                    // Only record donation if payment was successful
                    if ("succeeded".equals(charge.getStatus())) {
                        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
                            // Record the donation
                            String donationQuery = "INSERT INTO donations (donor_id, project_id, amount, date, mode, transaction_id) " +
                                    "VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?, ?)";
                            try (PreparedStatement pstmt = conn.prepareStatement(donationQuery)) {
                                pstmt.setInt(1, donorId);
                                pstmt.setInt(2, Integer.parseInt(projectId));
                                pstmt.setDouble(3, amount);
                                pstmt.setString(4, mode);
                                pstmt.setString(5, charge.getId());
                                pstmt.executeUpdate();
                            }

                            // Get project details for receipt
                            String projectQuery = "SELECT * FROM projects WHERE project_id = ?";
                            try (PreparedStatement pstmt = conn.prepareStatement(projectQuery)) {
                                pstmt.setInt(1, Integer.parseInt(projectId));
                                ResultSet projectRs = pstmt.executeQuery();
                                if (projectRs.next()) {
                                    sendDonationReceipt(conn, user.getUserId(), projectRs, amount, mode);
                                }
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }

                        // Show success message
                        request.setAttribute("successMessage", "Thank you for your donation of $" + amount + "!");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("errorMessage", "Payment failed: " + e.getMessage());
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Invalid amount format");
            }
        }
    }
%>

<%!
    // Method to send donation receipt email with PDF attachment (same as before)
    private void sendDonationReceipt(Connection conn, int userId, ResultSet projectRs, double amount, String mode)
            throws SQLException, MessagingException, DocumentException, IOException {
        // ... (keep the existing implementation)
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donor Dashboard</title>
    <!-- Stripe.js for payment processing -->
    <script src="https://js.stripe.com/v3/"></script>
    <style>
        /* ... (keep your existing styles) ... */

        .suggested-project {
            background-color: #fffde7;
            border-left: 5px solid #ffd600;
        }

        .payment-form {
            margin-top: 15px;
        }

        .card-element {
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 10px;
        }

        .success-message {
            color: #2ecc71;
            padding: 10px;
            background-color: #e8f5e9;
            border-radius: 4px;
            margin-bottom: 15px;
        }

        .error-message {
            color: #e74c3c;
            padding: 10px;
            background-color: #ffebee;
            border-radius: 4px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Donor Dashboard</h1>
    <p>Welcome back! Thank you for supporting our causes.</p>

    <%-- Display success/error messages --%>
    <% if (request.getAttribute("successMessage") != null) { %>
    <div class="success-message">
        <%= request.getAttribute("successMessage") %>
    </div>
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <h2>Projects You Haven't Supported Yet</h2>
    <%
        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
            // Get active projects the donor hasn't contributed to
            String projectQuery = "SELECT p.*, " +
                    "COALESCE(SUM(d.amount), 0) AS donated_amount, " +
                    "(SELECT COALESCE(SUM(fa.amount), 0) FROM fund_allocation fa WHERE fa.project_id = p.project_id) AS needed_amount " +
                    "FROM projects p " +
                    "LEFT JOIN donations d ON p.project_id = d.project_id " +
                    "WHERE p.status = 'Active' AND " +
                    "(p.end_date >= CURRENT_DATE OR p.end_date IS NULL) AND " +
                    "p.project_id NOT IN ( " +
                    "    SELECT project_id FROM donations WHERE donor_id = ? " +
                    ") " +
                    "GROUP BY p.project_id " +
                    "ORDER BY p.priority DESC, (needed_amount - donated_amount) DESC " +
                    "LIMIT 5";

            try (PreparedStatement pstmt = conn.prepareStatement(projectQuery)) {
                pstmt.setInt(1, donorId);
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    double donated = rs.getDouble("donated_amount");
                    double needed = rs.getDouble("needed_amount");
                    double percentage = needed > 0 ? (donated / needed) * 100 : 0;
    %>
    <div class="project-card suggested-project">
        <h3><%= rs.getString("name") %></h3>
        <p><%= rs.getString("description") %></p>

        <div class="progress-container">
            <div class="progress-bar" style="width: <%= percentage %>%">
                <%= String.format("%.0f", percentage) %>%
            </div>
        </div>

        <p>
            <strong>$<%= String.format("%,.2f", donated) %></strong> raised of
            <strong>$<%= String.format("%,.2f", needed) %></strong> goal
        </p>

        <div class="donation-form">
            <form id="donation-form-<%= rs.getInt("project_id") %>" method="POST">
                <input type="hidden" name="project_id" value="<%= rs.getInt("project_id") %>">
                <input type="hidden" name="mode" value="Credit Card">

                <div class="form-group">
                    <label for="amount">Amount ($)</label>
                    <input type="number" id="amount" name="amount" min="1" step="0.01" required>
                </div>

                <div class="payment-form">
                    <label>Payment Details</label>
                    <div id="card-element-<%= rs.getInt("project_id") %>" class="card-element">
                        <!-- Stripe card element will be inserted here -->
                    </div>
                </div>

                <button type="submit" class="btn">Make Donation</button>
            </form>
        </div>
    </div>
    <%
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>

    <h2>Other Active Projects</h2>
    <%
        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
            // Get other active projects
            String projectQuery = "SELECT p.*, " +
                    "COALESCE(SUM(d.amount), 0) AS donated_amount, " +
                    "(SELECT COALESCE(SUM(fa.amount), 0) FROM fund_allocation fa WHERE fa.project_id = p.project_id) AS needed_amount " +
                    "FROM projects p " +
                    "LEFT JOIN donations d ON p.project_id = d.project_id " +
                    "WHERE p.status = 'active' AND " +
                    "(p.end_date >= CURRENT_DATE OR p.end_date IS NULL) " +
                    "GROUP BY p.project_id " +
                    "HAVING COALESCE(SUM(d.amount), 0) < (SELECT COALESCE(SUM(fa.amount), 0) FROM fund_allocation fa WHERE fa.project_id = p.project_id) " +
                    "OR (SELECT COALESCE(SUM(fa.amount), 0) FROM fund_allocation fa WHERE fa.project_id = p.project_id) = 0 " +
                    "ORDER BY (needed_amount - donated_amount) DESC";

            try (PreparedStatement pstmt = conn.prepareStatement(projectQuery)) {
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    double donated = rs.getDouble("donated_amount");
                    double needed = rs.getDouble("needed_amount");
                    double percentage = needed > 0 ? (donated / needed) * 100 : 0;
                    boolean isUrgent = (needed - donated) > (needed * 0.75);
    %>
    <div class="project-card <%= isUrgent ? "urgent" : "" %>">
        <h3><%= rs.getString("name") %></h3>
        <p><%= rs.getString("description") %></p>

        <div class="progress-container">
            <div class="progress-bar" style="width: <%= percentage %>%">
                <%= String.format("%.0f", percentage) %>%
            </div>
        </div>

        <p>
            <strong>$<%= String.format("%,.2f", donated) %></strong> raised of
            <strong>$<%= String.format("%,.2f", needed) %></strong> goal
        </p>

        <div class="donation-form">
            <form id="donation-form-<%= rs.getInt("project_id") %>" method="POST">
                <input type="hidden" name="project_id" value="<%= rs.getInt("project_id") %>">
                <input type="hidden" name="mode" value="Credit Card">

                <div class="form-group">
                    <label for="amount">Amount ($)</label>
                    <input type="number" id="amount" name="amount" min="1" step="0.01" required>
                </div>

                <div class="payment-form">
                    <label>Payment Details</label>
                    <div id="card-element-<%= rs.getInt("project_id") %>" class="card-element">
                        <!-- Stripe card element will be inserted here -->
                    </div>
                </div>

                <button type="submit" class="btn">Make Donation</button>
            </form>
        </div>
    </div>
    <%
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>

    <div class="donation-history">
        <h2>Your Donation History</h2>
        <table>
            <thead>
            <tr>
                <th>Date</th>
                <th>Project</th>
                <th>Amount</th>
                <th>Payment Method</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <%
                try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
                    String historyQuery = "SELECT d.date, p.name, d.amount, d.mode, d.transaction_id " +
                            "FROM donations d " +
                            "JOIN projects p ON d.project_id = p.project_id " +
                            "WHERE d.donor_id = ? " +
                            "ORDER BY d.date DESC";

                    try (PreparedStatement pstmt = conn.prepareStatement(historyQuery)) {
                        pstmt.setInt(1, donorId);
                        ResultSet rs = pstmt.executeQuery();

                        while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getTimestamp("date") %></td>
                <td><%= rs.getString("name") %></td>
                <td>$<%= String.format("%,.2f", rs.getDouble("amount")) %></td>
                <td><%= rs.getString("mode") %></td>
                <td>Completed</td>
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
    // Initialize Stripe with your publishable key
    var stripe = Stripe('pk_test_your_stripe_publishable_key_here');

    // Set up Stripe Elements for each form
    document.querySelectorAll('[id^="donation-form-"]').forEach(function(form) {
        var formId = form.id;
        var projectId = formId.replace('donation-form-', '');
        var cardElementId = 'card-element-' + projectId;

        // Create an instance of Elements
        var elements = stripe.elements();
        var cardElement = elements.create('card');
        cardElement.mount('#' + cardElementId);

        // Handle form submission
        form.addEventListener('submit', function(event) {
            event.preventDefault();

            // Disable the submit button to prevent repeated clicks
            var submitButton = form.querySelector('button[type="submit"]');
            submitButton.disabled = true;

            // Create a token for the card
            stripe.createToken(cardElement).then(function(result) {
                if (result.error) {
                    // Show error to user
                    var errorElement = document.createElement('div');
                    errorElement.className = 'error-message';
                    errorElement.textContent = result.error.message;
                    form.insertBefore(errorElement, submitButton);
                    submitButton.disabled = false;
                } else {
                    // Add the token to the form and submit
                    var tokenInput = document.createElement('input');
                    tokenInput.setAttribute('type', 'hidden');
                    tokenInput.setAttribute('name', 'stripeToken');
                    tokenInput.setAttribute('value', result.token.id);
                    form.appendChild(tokenInput);

                    // Submit the form
                    form.submit();
                }
            });
        });
    });
</script>
</body>
</html>