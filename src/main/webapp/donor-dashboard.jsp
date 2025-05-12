<%@ page import="java.sql.*, com.welfair.model.User, java.util.*, java.text.*,
                 com.itextpdf.text.*, com.itextpdf.text.pdf.*,
                 jakarta.mail.*, jakarta.mail.internet.*, jakarta.activation.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.mail.util.ByteArrayDataSource" %>
<%@ page import="jakarta.activation.DataHandler" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>

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

    // Get donor ID
    int donorId = 0;
    String donorName = "";
    String donorEmail = user.getEmail();

    try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
        String donorQuery = "SELECT donor_id, name FROM donors WHERE user_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(donorQuery)) {
            pstmt.setInt(1, user.getUserId());
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                donorId = rs.getInt("donor_id");
                donorName = rs.getString("name");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp?message=Database error retrieving donor information");
        return;
    }

    // Handle donation form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String projectIdStr = request.getParameter("project_id");
        String amountStr = request.getParameter("amount");
        String mode = request.getParameter("mode");

        if (projectIdStr == null || amountStr == null || mode == null ||
                projectIdStr.isEmpty() || amountStr.isEmpty() || mode.isEmpty()) {
            response.sendRedirect("donor_dashboard.jsp?error=missing_fields");
            return;
        }

        try {
            int projectId = Integer.parseInt(projectIdStr);
            double amount = Double.parseDouble(amountStr);

            if (amount <= 0) {
                response.sendRedirect("donor_dashboard.jsp?error=invalid_amount");
                return;
            }

            try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
                conn.setAutoCommit(false); // Start transaction

                try {
                    // 1. Insert donation record
                    String insertQuery = "INSERT INTO donations (donor_id, project_id, amount, date, mode) " +
                            "VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?)";
                    try (PreparedStatement pstmt = conn.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS)) {
                        pstmt.setInt(1, donorId);
                        pstmt.setInt(2, projectId);
                        pstmt.setDouble(3, amount);
                        pstmt.setString(4, mode);

                        int affectedRows = pstmt.executeUpdate();

                        if (affectedRows == 0) {
                            conn.rollback();
                            response.sendRedirect("donor_dashboard.jsp?error=donation_failed");
                            return;
                        }

                        // Get the generated donation ID
                        int donationId = 0;
                        try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                            if (generatedKeys.next()) {
                                donationId = generatedKeys.getInt(1);
                            }
                        }

                        // 2. Get project details for receipt
                        String projectQuery = "SELECT name, description FROM projects WHERE project_id = ?";
                        String projectName = "";
                        String projectDescription = "";

                        try (PreparedStatement projectStmt = conn.prepareStatement(projectQuery)) {
                            projectStmt.setInt(1, projectId);
                            ResultSet projectRs = projectStmt.executeQuery();
                            if (projectRs.next()) {
                                projectName = projectRs.getString("name");
                                projectDescription = projectRs.getString("description");
                            }
                        }

                        // 3. Generate and send receipt
                        sendDonationReceipt(conn, donorId, donationId, donorName, donorEmail,
                                projectId, projectName, projectDescription, amount, mode);

                        conn.commit(); // Commit transaction
                        response.sendRedirect("donor_dashboard.jsp?success=true&amount=" + amount);
                    }
                } catch (Exception e) {
                    conn.rollback();
                    e.printStackTrace();
                    response.sendRedirect("donor_dashboard.jsp?error=processing_error");
                } finally {
                    conn.setAutoCommit(true);
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("donor_dashboard.jsp?error=invalid_input");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("donor_dashboard.jsp?error=database_error");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("donor_dashboard.jsp?error=unknown_error");
        }
        return;
    }
%>

<%!
    // Method to send donation receipt
    private void sendDonationReceipt(Connection conn, int donorId, int donationId,
                                     String donorName, String donorEmail,
                                     int projectId, String projectName, String projectDescription,
                                     double amount, String paymentMode)
            throws SQLException, DocumentException, MessagingException, IOException {

        // Create PDF receipt
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, baos);

        document.open();

        // Add logo and header
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.BLUE);
        Paragraph header = new Paragraph("Welfair NGO - Donation Receipt", headerFont);
        header.setAlignment(Element.ALIGN_CENTER);
        header.setSpacingAfter(20f);
        document.add(header);

        // Add receipt details
        Font boldFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12);

        // Receipt metadata
        Paragraph receiptNo = new Paragraph();
        receiptNo.add(new Chunk("Receipt Number: ", boldFont));
        receiptNo.add(new Chunk("DON-" + donationId, normalFont));
        document.add(receiptNo);

        Paragraph date = new Paragraph();
        date.add(new Chunk("Date: ", boldFont));
        date.add(new Chunk(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()), normalFont));
        document.add(date);

        document.add(new Paragraph(" ")); // Spacer

        // Donor information
        Paragraph donorHeader = new Paragraph("Donor Information", boldFont);
        donorHeader.setSpacingAfter(10f);
        document.add(donorHeader);

        Paragraph donorInfo = new Paragraph();
        donorInfo.add(new Chunk("Name: ", boldFont));
        donorInfo.add(new Chunk(donorName, normalFont));
        donorInfo.add(Chunk.NEWLINE);
        donorInfo.add(new Chunk("Email: ", boldFont));
        donorInfo.add(new Chunk(donorEmail, normalFont));
        document.add(donorInfo);

        document.add(new Paragraph(" ")); // Spacer

        // Donation details
        Paragraph donationHeader = new Paragraph("Donation Details", boldFont);
        donationHeader.setSpacingAfter(10f);
        document.add(donationHeader);

        Paragraph donationInfo = new Paragraph();
        donationInfo.add(new Chunk("Project: ", boldFont));
        donationInfo.add(new Chunk(projectName, normalFont));
        donationInfo.add(Chunk.NEWLINE);
        donationInfo.add(new Chunk("Description: ", boldFont));
        donationInfo.add(new Chunk(projectDescription, normalFont));
        donationInfo.add(Chunk.NEWLINE);
        donationInfo.add(new Chunk("Amount: ", boldFont));
        donationInfo.add(new Chunk(String.format("₹%,.2f", amount), normalFont));
        donationInfo.add(Chunk.NEWLINE);
        donationInfo.add(new Chunk("Payment Mode: ", boldFont));
        donationInfo.add(new Chunk(paymentMode, normalFont));
        document.add(donationInfo);

        document.add(new Paragraph(" ")); // Spacer

        // Thank you message
        Paragraph thanks = new Paragraph("Thank you for your generous donation to Welfair NGO. " +
                "Your contribution helps us continue our mission to create positive change in communities.",
                normalFont);
        thanks.setAlignment(Element.ALIGN_CENTER);
        document.add(thanks);

        document.close();

        // Email configuration
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("dhev2006@gmail.com", "jnvfceajdjsuuoii");
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("dhev2006@gmail.com"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(donorEmail));
            message.setSubject("Welfair NGO - Donation Receipt #DON-" + donationId);

            // Create message body
            MimeBodyPart messageBody = new MimeBodyPart();
            String emailText = "Dear " + donorName + ",\n\n" +
                    "Thank you for your generous donation of ₹" + String.format("%,.2f", amount) +
                    " to support our '" + projectName + "' project.\n\n" +
                    "Your donation receipt is attached to this email. Please keep it for your records.\n\n" +
                    "With gratitude,\n" +
                    "The Welfair Team\n" +
                    "www.welfair.org";
            messageBody.setText(emailText);

            // Create PDF attachment
            MimeBodyPart attachment = new MimeBodyPart();
            attachment.setDataHandler(new DataHandler(new ByteArrayDataSource(baos.toByteArray(), "application/pdf")));
            attachment.setFileName("Welfair_Donation_Receipt_" + donationId + ".pdf");

            // Combine parts
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBody);
            multipart.addBodyPart(attachment);

            message.setContent(multipart);
            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send email: " + e.getMessage(), e);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Active Projects - Welfair NGO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #2e59d9;
            --accent-color: #f8f9fc;
            --text-color: #5a5c69;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
        }

        body {
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            color: var(--text-color);
            background-color: #f8f9fc;
        }

        .card {
            border: none;
            border-radius: 0.35rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background-color: var(--primary-color);
            color: white;
            font-weight: 600;
            border-radius: 0.35rem 0.35rem 0 0 !important;
        }

        .progress {
            height: 1.5rem;
            border-radius: 0.35rem;
        }

        .progress-bar {
            background-color: var(--success-color);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .recommended-badge {
            position: absolute;
            top: -10px;
            right: -10px;
            background-color: var(--warning-color);
            color: white;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }

        .donation-form {
            background-color: var(--accent-color);
            border-radius: 0.35rem;
            padding: 20px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }

        .project-image {
            height: 200px;
            object-fit: cover;
            border-radius: 0.35rem 0.35rem 0 0;
        }

        .donation-stats {
            font-size: 1.1rem;
            font-weight: 600;
        }

        .donation-remaining {
            color: var(--danger-color);
            font-weight: 600;
        }

        .donation-completed {
            color: var(--success-color);
            font-weight: 600;
        }

        .modal-header {
            background-color: var(--primary-color);
            color: white;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <% if ("true".equals(request.getParameter("success"))) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i> Thank you for your donation! A receipt has been sent to your email.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>
        Error processing donation:
        <%
            String error = request.getParameter("error");
            if ("db_insert_failed".equals(error)) {
                System.out.print("Failed to save donation to database");
            } else if ("db_connection".equals(error)) {
                System.out.print("Database connection error");
            } else if ("invalid_input".equals(error)) {
                System.out.print("Invalid amount entered");
            } else if ("missing_fields".equals(error)) {
                System.out.print("Please fill all required fields");
            } else if ("processing_error".equals(error)) {
                System.out.print("Error processing your donation");
            } else {
                System.out.print("Please try again later");
            }
        %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <div class="row mb-4">
        <div class="col-12">
            <h1 class="display-4 text-center mb-4"><i class="fas fa-hands-helping me-2"></i> Active Projects</h1>
            <p class="lead text-center">Support our ongoing initiatives and make a difference today</p>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <%
                List<Map<String, Object>> projects = new ArrayList<>();
                Map<String, Object> recommendedProject = null;
                double maxRemainingPercentage = 0;

                try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
                    // Query to fetch active projects with donation and allocation data
                    String projectQuery = "SELECT p.project_id, p.name, p.description, p.start_date, p.end_date, " +
                            "COALESCE(SUM(d.amount), 0) AS donated_amount, " +
                            "(SELECT COALESCE(SUM(fa.amount), 0) FROM fund_allocation fa WHERE fa.project_id = p.project_id) AS needed_amount " +
                            "FROM projects p " +
                            "LEFT JOIN donations d ON p.project_id = d.project_id " +
                            "WHERE p.status = 'Active' AND (p.end_date >= CURRENT_DATE OR p.end_date IS NULL) " +
                            "GROUP BY p.project_id, p.name, p.description, p.start_date, p.end_date " +
                            "ORDER BY p.name";

                    try (PreparedStatement pstmt = conn.prepareStatement(projectQuery)) {
                        ResultSet rs = pstmt.executeQuery();

                        while (rs.next()) {
                            Map<String, Object> project = new HashMap<>();
                            project.put("project_id", rs.getInt("project_id"));
                            project.put("name", rs.getString("name"));
                            project.put("description", rs.getString("description"));
                            project.put("start_date", rs.getDate("start_date"));
                            project.put("end_date", rs.getDate("end_date"));

                            double donated = rs.getDouble("donated_amount");
                            double needed = rs.getDouble("needed_amount");
                            double percentage = needed > 0 ? (donated / needed) * 100 : 0;
                            double remainingPercentage = needed > 0 ? 100 - percentage : 100;

                            project.put("donated_amount", donated);
                            project.put("needed_amount", needed);
                            project.put("percentage", percentage);
                            project.put("remaining_percentage", remainingPercentage);

                            projects.add(project);

                            // Find the project with highest remaining percentage (most needed)
                            if (remainingPercentage > maxRemainingPercentage) {
                                maxRemainingPercentage = remainingPercentage;
                                recommendedProject = project;
                            }
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
            %>
            <div class="alert alert-danger">Error loading projects: <%= e.getMessage() %></div>
            <%
                }

                if (projects.isEmpty()) {
            %>
            <div class="alert alert-info">No active projects found at this time. Please check back later.</div>
            <%
            } else {
                for (Map<String, Object> project : projects) {
                    boolean isRecommended = project == recommendedProject;
            %>
            <div class="card mb-4 position-relative">
                <% if (isRecommended) { %>
                <div class="recommended-badge" title="Most Needed">
                    <i class="fas fa-star"></i>
                </div>
                <% } %>

                <div class="row g-0">
                    <div class="col-md-4">
                        <img src="https://source.unsplash.com/random/300x200/?charity,<%= ((String)project.get("name")).replace(" ", ",") %>"
                             class="img-fluid project-image w-100" alt="<%= project.get("name") %>">
                    </div>
                    <div class="col-md-8">
                        <div class="card-body">
                            <h3 class="card-title"><%= project.get("name") %></h3>
                            <p class="card-text"><%= project.get("description") %></p>

                            <div class="progress mb-3">
                                <div class="progress-bar" role="progressbar"
                                     style="width: <%= project.get("percentage") %>%"
                                     aria-valuenow="<%= project.get("percentage") %>"
                                     aria-valuemin="0" aria-valuemax="100">
                                    <%= String.format("%.0f", project.get("percentage")) %>%
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <p class="donation-stats">
                                        <i class="fas fa-rupee-sign me-2"></i>
                                        Raised: ₹<%= String.format("%,.2f", project.get("donated_amount")) %>
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <p class="donation-stats">
                                        <i class="fas fa-bullseye me-2"></i>
                                        Goal: ₹<%= String.format("%,.2f", project.get("needed_amount")) %>
                                    </p>
                                </div>
                            </div>

                            <p class="<%= (Double)project.get("remaining_percentage") > 50 ? "donation-remaining" : "donation-completed" %>">
                                <% if ((Double)project.get("needed_amount") > 0) { %>
                                <%= String.format("%.0f", project.get("remaining_percentage")) %>% still needed
                                <% } else { %>
                                Funding goal not set
                                <% } %>
                            </p>

                            <button class="btn btn-primary btn-sm" data-bs-toggle="modal"
                                    data-bs-target="#donateModal"
                                    data-project-id="<%= project.get("project_id") %>"
                                    data-project-name="<%= project.get("name") %>">
                                <i class="fas fa-donate me-1"></i> Donate Now
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>

        <div class="col-lg-4">
            <div class="card mb-4">
                <div class="card-header">
                    <i class="fas fa-lightbulb me-2"></i> Recommended Project
                </div>
                <div class="card-body">
                    <% if (recommendedProject != null) { %>
                    <h4 class="card-title"><%= recommendedProject.get("name") %></h4>
                    <p class="card-text"><%= ((String)recommendedProject.get("description")).substring(0, Math.min(100, ((String)recommendedProject.get("description")).length())) %>...</p>

                    <div class="progress mb-3">
                        <div class="progress-bar" role="progressbar"
                             style="width: <%= recommendedProject.get("percentage") %>%"
                             aria-valuenow="<%= recommendedProject.get("percentage") %>"
                             aria-valuemin="0" aria-valuemax="100">
                            <%= String.format("%.0f", recommendedProject.get("percentage")) %>%
                        </div>
                    </div>

                    <p class="donation-stats">
                        <i class="fas fa-rupee-sign me-2"></i>
                        Raised: ₹<%= String.format("%,.2f", recommendedProject.get("donated_amount")) %> of
                        ₹<%= String.format("%,.2f", recommendedProject.get("needed_amount")) %>
                    </p>

                    <p class="donation-remaining">
                        <%= String.format("%.0f", recommendedProject.get("remaining_percentage")) %>% still needed
                    </p>

                    <button class="btn btn-primary w-100" data-bs-toggle="modal"
                            data-bs-target="#donateModal"
                            data-project-id="<%= recommendedProject.get("project_id") %>"
                            data-project-name="<%= recommendedProject.get("name") %>">
                        <i class="fas fa-donate me-1"></i> Support This Project
                    </button>
                    <% } else if (!projects.isEmpty()) { %>
                    <p>All our projects are well funded at this time. Thank you for your support!</p>
                    <% } else { %>
                    <p>No recommended projects available at this time.</p>
                    <% } %>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <i class="fas fa-info-circle me-2"></i> About Welfair
                </div>
                <div class="card-body">
                    <p>Welfair is a non-profit organization dedicated to creating positive change in communities through sustainable projects.</p>
                    <p>Your donations help us:</p>
                    <ul>
                        <li>Provide education to underprivileged children</li>
                        <li>Support healthcare initiatives</li>
                        <li>Create sustainable livelihoods</li>
                        <li>Respond to emergencies</li>
                    </ul>
                    <p>100% of your donation goes directly to project implementation.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Donation Modal -->
<div class="modal fade" id="donateModal" tabindex="-1" aria-labelledby="donateModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="donateModalLabel">Make a Donation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="donationForm" method="POST" action="">
                    <input type="hidden" id="projectId" name="project_id">
                    <div class="mb-3">
                        <label for="projectName" class="form-label">Project</label>
                        <input type="text" class="form-control" id="projectName" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="amount" class="form-label">Amount (₹)</label>
                        <input type="number" class="form-control" id="amount" name="amount" min="1" required>
                    </div>
                    <div class="mb-3">
                        <label for="mode" class="form-label">Payment Method</label>
                        <select class="form-select" id="mode" name="mode" required>
                            <option value="">Select payment method</option>
                            <option value="Credit Card">Credit Card</option>
                            <option value="Debit Card">Debit Card</option>
                            <option value="Net Banking">Net Banking</option>
                            <option value="UPI">UPI</option>
                            <option value="PayPal">PayPal</option>
                        </select>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane me-1"></i> Submit Donation
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Set project details when modal is shown
    document.getElementById('donateModal').addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var projectId = button.getAttribute('data-project-id');
        var projectName = button.getAttribute('data-project-name');

        document.getElementById('projectId').value = projectId;
        document.getElementById('projectName').value = projectName;
    });
</script>

</body>
</html>