<%@page import="com.welfair.model.*, com.welfair.dao.*, java.util.*, java.math.BigDecimal" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welfair - Financial Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.1/chart.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --accent-color: #4895ef;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --success-color: #4cc9f0;
            --danger-color: #f72585;
        }

        body {
            background-color: #f5f7fb;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .sidebar {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            height: 100vh;
            position: fixed;
            box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .stat-card {
            border-left: 4px solid var(--primary-color);
        }

        .stat-card i {
            font-size: 2rem;
            opacity: 0.8;
        }

        .donation-card {
            border-left: 4px solid var(--success-color);
        }

        .allocation-card {
            border-left: 4px solid var(--accent-color);
        }

        .balance-card {
            border-left: 4px solid var(--danger-color);
        }

        .nav-link {
            color: rgba(255,255,255,0.8);
            border-radius: 5px;
            margin: 5px 0;
        }

        .nav-link:hover, .nav-link.active {
            background-color: rgba(255,255,255,0.1);
            color: white;
        }

        .nav-link i {
            margin-right: 10px;
        }

        .logo {
            font-weight: 700;
            font-size: 1.5rem;
            padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .user-profile {
            padding: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: white;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }

        .dataTables_wrapper .dataTables_filter input {
            border-radius: 20px;
            padding: 5px 10px;
            border: 1px solid #ddd;
        }

        .progress {
            height: 10px;
            border-radius: 5px;
        }

        .progress-bar {
            background-color: var(--primary-color);
        }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }

        .search-box {
            position: relative;
        }

        .search-box input {
            padding-left: 40px;
            border-radius: 20px;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 10px;
            color: #6c757d;
        }
    </style>
</head>
<body>
<%
    // Fetch data directly in JSP (for simplicity - in production consider using servlets)
    DonationDAO donationDAO = new DonationDAO();
    FundAllocationDAO fundAllocationDAO = new FundAllocationDAO();
    ProjectDAO projectDAO = new ProjectDAO();
    DonorDAO donorDAO = new DonorDAO();

    BigDecimal totalDonations = donationDAO.getTotalDonations();
    List<Donation> recentDonations = donationDAO.getAllDonations();
    List<FundAllocation> fundAllocations = fundAllocationDAO.getAllFundAllocations();
    List<Project> projects = projectDAO.getAllProjects();
    List<Donor> topDonors = donorDAO.getAllDonors(); // In a real app, you'd sort by donation amount

    // Calculate financial metrics
    BigDecimal totalAllocated = BigDecimal.ZERO;
    for (FundAllocation allocation : fundAllocations) {
        totalAllocated = totalAllocated.add(allocation.getAmount());
    }
    BigDecimal currentBalance = totalDonations.subtract(totalAllocated);
%>

<div class="sidebar col-md-3 col-lg-2">
    <div class="logo">Welfair</div>
    <ul class="nav flex-column px-3">
        <li class="nav-item">
            <a class="nav-link active" href="finance.jsp">
                <i class="bi bi-graph-up"></i> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">
                <i class="bi bi-cash-stack"></i> Donations
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">
                <i class="bi bi-piggy-bank"></i> Fund Allocation
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">
                <i class="bi bi-people"></i> Beneficiaries
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">
                <i class="bi bi-file-earmark-text"></i> Reports
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">
                <i class="bi bi-gear"></i> Settings
            </a>
        </li>
    </ul>

    <div class="user-profile d-flex align-items-center">
        <div class="avatar me-3">AD</div>
        <div>
            <div class="fw-bold">Admin User</div>
            <small class="text-white-50">Finance Manager</small>
        </div>
    </div>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Financial Dashboard</h2>
        <div class="d-flex">
            <div class="search-box me-3">
                <i class="bi bi-search"></i>
                <input type="text" class="form-control" placeholder="Search...">
            </div>
            <button class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> New Donation
            </button>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card stat-card p-3">
                <div class="d-flex justify-content-between">
                    <div>
                        <h6 class="text-muted mb-2">Total Donations</h6>
                        <h3 class="mb-0">₹<%= String.format("%,.2f", totalDonations) %></h3>
                    </div>
                    <div class="bg-primary bg-opacity-10 p-3 rounded">
                        <i class="bi bi-cash-stack text-primary"></i>
                    </div>
                </div>
                <div class="mt-3">
                    <span class="text-success"><i class="bi bi-arrow-up"></i> 12%</span>
                    <span class="text-muted ms-2">vs last month</span>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card donation-card p-3">
                <div class="d-flex justify-content-between">
                    <div>
                        <h6 class="text-muted mb-2">Funds Allocated</h6>
                        <h3 class="mb-0">₹<%= String.format("%,.2f", totalAllocated) %></h3>
                    </div>
                    <div class="bg-success bg-opacity-10 p-3 rounded">
                        <i class="bi bi-piggy-bank text-success"></i>
                    </div>
                </div>
                <div class="mt-3">
                    <span class="text-success"><i class="bi bi-arrow-up"></i> 8%</span>
                    <span class="text-muted ms-2">vs last month</span>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card allocation-card p-3">
                <div class="d-flex justify-content-between">
                    <div>
                        <h6 class="text-muted mb-2">Current Balance</h6>
                        <h3 class="mb-0">₹<%= String.format("%,.2f", currentBalance) %></h3>
                    </div>
                    <div class="bg-info bg-opacity-10 p-3 rounded">
                        <i class="bi bi-wallet2 text-info"></i>
                    </div>
                </div>
                <div class="mt-3">
                    <span class="text-danger"><i class="bi bi-arrow-down"></i> 4%</span>
                    <span class="text-muted ms-2">vs last month</span>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card balance-card p-3">
                <div class="d-flex justify-content-between">
                    <div>
                        <h6 class="text-muted mb-2">Active Projects</h6>
                        <h3 class="mb-0"><%= projects.size() %></h3>
                    </div>
                    <div class="bg-warning bg-opacity-10 p-3 rounded">
                        <i class="bi bi-clipboard-check text-warning"></i>
                    </div>
                </div>
                <div class="mt-3">
                    <span class="text-success"><i class="bi bi-arrow-up"></i> 3</span>
                    <span class="text-muted ms-2">new this month</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Row -->
    <div class="row mb-4">
        <div class="col-md-8">
            <div class="card p-3">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5>Donation Trends</h5>
                    <div class="btn-group">
                        <button class="btn btn-sm btn-outline-secondary active">Monthly</button>
                        <button class="btn btn-sm btn-outline-secondary">Quarterly</button>
                        <button class="btn btn-sm btn-outline-secondary">Yearly</button>
                    </div>
                </div>
                <div class="chart-container">
                    <canvas id="donationChart"></canvas>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-3">
                <h5 class="mb-3">Allocation by Project</h5>
                <div class="chart-container">
                    <canvas id="allocationChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Tables Row -->
    <div class="row">
        <div class="col-md-8">
            <div class="card p-3">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5>Recent Donations</h5>
                    <a href="#" class="btn btn-sm btn-outline-primary">View All</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover" id="donationsTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Donor</th>
                            <th>Project</th>
                            <th>Amount</th>
                            <th>Date</th>
                            <th>Mode</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Donation donation : recentDonations) { %>
                        <tr>
                            <td><%= donation.getDonationId() %></td>
                            <td>
                                <% Donor donor = donorDAO.getDonorById(donation.getDonorId()); %>
                                <%= donor != null ? donor.getName() : "Unknown" %>
                            </td>
                            <td>
                                <% Project project = projectDAO.getProjectById(donation.getProjectId()); %>
                                <%= project != null ? project.getName() : "General Fund" %>
                            </td>
                            <td>₹<%= String.format("%,.2f", donation.getAmount()) %></td>
                            <td><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(donation.getDate()) %></td>
                            <td>
                                        <span class="badge bg-<%= donation.getMode().equalsIgnoreCase("online") ? "success" : "primary" %>">
                                            <%= donation.getMode() %>
                                        </span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-receipt"></i> Receipt
                                </button>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-3">
                <h5 class="mb-3">Top Donors</h5>
                <div class="list-group">
                    <% for (int i = 0; i < Math.min(5, topDonors.size()); i++) {
                        Donor donor = topDonors.get(i);
                        BigDecimal totalGiven = donationDAO.getTotalDonationsByDonor(donor.getDonorId());
                    %>
                    <div class="list-group-item border-0 py-2 px-0">
                        <div class="d-flex align-items-center">
                            <div class="avatar me-3"><%= donor.getName().charAt(0) %></div>
                            <div class="flex-grow-1">
                                <h6 class="mb-0"><%= donor.getName() %></h6>
                                <small class="text-muted"><%= donor.getEmail() %></small>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold">₹<%= String.format("%,.2f", totalGiven) %></div>
                                <small class="text-success"><%= i+1 %> donations</small>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <a href="#" class="btn btn-sm btn-outline-primary mt-3">View All Donors</a>
            </div>

            <div class="card p-3 mt-3">
                <h5 class="mb-3">Recent Allocations</h5>
                <div class="list-group">
                    <% for (int i = 0; i < Math.min(3, fundAllocations.size()); i++) {
                        FundAllocation allocation = fundAllocations.get(i);
                        Project project = projectDAO.getProjectById(allocation.getProjectId());
                    %>
                    <div class="list-group-item border-0 py-2 px-0">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="mb-0"><%= project != null ? project.getName() : "General Fund" %></h6>
                                <small class="text-muted"><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(allocation.getDateAllocated()) %></small>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold">₹<%= String.format("%,.2f", allocation.getAmount()) %></div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <a href="#" class="btn btn-sm btn-outline-primary mt-3">View All Allocations</a>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.1/chart.min.js"></script>

<script>
    // Initialize DataTable
    $(document).ready(function() {
        $('#donationsTable').DataTable({
            responsive: true,
            order: [[4, 'desc']]
        });

        // Donation Trends Chart
        const donationCtx = document.getElementById('donationChart').getContext('2d');
        const donationChart = new Chart(donationCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                datasets: [{
                    label: 'Donations',
                    data: [12000, 19000, 15000, 22000, 18000, 25000, 30000],
                    borderColor: '#4361ee',
                    backgroundColor: 'rgba(67, 97, 238, 0.1)',
                    borderWidth: 2,
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            drawBorder: false
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });

        // Allocation Pie Chart
        const allocationCtx = document.getElementById('allocationChart').getContext('2d');
        const allocationChart = new Chart(allocationCtx, {
            type: 'doughnut',
            data: {
                labels: ['Education', 'Healthcare', 'Food', 'Shelter', 'Other'],
                datasets: [{
                    data: [35, 25, 20, 15, 5],
                    backgroundColor: [
                        '#4361ee',
                        '#3f37c9',
                        '#4895ef',
                        '#4cc9f0',
                        '#f72585'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right'
                    }
                },
                cutout: '70%'
            }
        });
    });
</script>
</body>
</html>