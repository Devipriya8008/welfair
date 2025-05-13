<%@page import="com.welfair.model.*, com.welfair.dao.*, java.util.*, java.math.BigDecimal" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welfair - Donation Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4361ee;
            --accent-color: #4895ef;
            --success-color: #4cc9f0;
        }

        body {
            background-color: #f5f7fb;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        .main-content {
            padding: 20px;
            width: 100%;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            background-color: white;
            height: 100%;
        }

        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }

        .badge-online {
            background-color: var(--success-color);
        }

        .badge-offline {
            background-color: var(--accent-color);
        }

        .amount-display {
            font-weight: 600;
            color: var(--primary-color);
        }

        .section-title {
            position: relative;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .section-title:after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 50px;
            height: 3px;
            background: var(--primary-color);
        }

        .donor-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.9rem;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .top-donor-item {
            transition: all 0.2s ease;
        }

        .top-donor-item:hover {
            background-color: rgba(67, 97, 238, 0.05);
        }
    </style>
</head>
<body>
<%
    DonationDAO donationDAO = new DonationDAO();
    DonorDAO donorDAO = new DonorDAO();
    ProjectDAO projectDAO = new ProjectDAO();

    List<Donation> recentDonations = donationDAO.getAllDonations();

    // Get top donors with valid donations only
    List<Donor> allDonors = donorDAO.getAllDonors();
    Map<Donor, BigDecimal> donorAmounts = new HashMap<>();

    for (Donor donor : allDonors) {
        BigDecimal total = donationDAO.getTotalDonationsByDonor(donor.getDonorId());
        if (total != null && total.compareTo(BigDecimal.ZERO) > 0) {
            donorAmounts.put(donor, total);
        }
    }

    // Sort donors by donation amount (descending)
    List<Map.Entry<Donor, BigDecimal>> sortedDonors = new ArrayList<>(donorAmounts.entrySet());
    sortedDonors.sort((a, b) -> b.getValue().compareTo(a.getValue()));
%>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold section-title">Donation Stats</h2>
        <button class="btn btn-primary" onclick="window.location.href='register.jsp?role=donor'">
            <i class="bi bi-plus-circle"></i> New Donation
        </button>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card p-4">
                <h5 class="section-title">All Donations</h5>
                <div class="table-responsive">
                    <table class="table table-hover" id="donationsTable">
                        <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Donor</th>
                            <th>Project</th>
                            <th>Amount</th>
                            <th>Date</th>
                            <th>Mode</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Donation donation : recentDonations) { %>
                        <tr>
                            <td><%= donation.getDonationId() %></td>
                            <td>
                                <% Donor donor = donorDAO.getDonorById(donation.getDonorId()); %>
                                <div class="d-flex align-items-center">
                                    <div class="donor-avatar me-2"><%= donor != null ? donor.getName().charAt(0) : "?" %></div>
                                    <div><%= donor != null ? donor.getName() : "Unknown" %></div>
                                </div>
                            </td>
                            <td>
                                <% Project project = projectDAO.getProjectById(donation.getProjectId()); %>
                                <%= project != null ? project.getName() : "General Fund" %>
                            </td>
                            <td class="amount-display">₹<%= String.format("%,.2f", donation.getAmount()) %></td>
                            <td><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(donation.getDate()) %></td>
                            <td>
                                <span class="badge <%= donation.getMode().equalsIgnoreCase("online") ? "badge-online" : "badge-offline" %>">
                                    <%= donation.getMode() %>
                                </span>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4">
                <h5 class="section-title">Top Donors</h5>
                <div class="list-group">
                    <% for (int i = 0; i < Math.min(10, sortedDonors.size()); i++) {
                        Map.Entry<Donor, BigDecimal> entry = sortedDonors.get(i);
                        Donor donor = entry.getKey();
                        BigDecimal totalGiven = entry.getValue();
                    %>
                    <div class="list-group-item border-0 py-3 px-0 top-donor-item">
                        <div class="d-flex align-items-center">
                            <div class="donor-avatar me-3"><%= donor.getName().charAt(0) %></div>
                            <div class="flex-grow-1">
                                <h6 class="mb-0"><%= donor.getName() %></h6>
                                <small class="text-muted"><%= donor.getEmail() %></small>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold">₹<%= String.format("%,.2f", totalGiven) %></div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function() {
        $('#donationsTable').DataTable({
            responsive: true,
            order: [[4, 'desc']],
            searching: false // Disable the search box
        });
    });
</script>
</body>
</html>