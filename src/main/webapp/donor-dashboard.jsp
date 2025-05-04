<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Donor Dashboard - Welfair</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.css">
    <style>
        :root {
            --primary: #2c8a8a;
            --secondary: #f8b400;
            --light: #f8f9fa;
            --dark: #343a40;
        }

        body {
            background-color: #f5f5f5;
        }

        .sidebar {
            background-color: var(--dark);
            color: white;
            height: 100vh;
            position: fixed;
            width: 250px;
            transition: all 0.3s;
        }

        .sidebar-header {
            padding: 20px;
            background-color: rgba(0, 0, 0, 0.2);
        }

        .sidebar-menu {
            padding: 0;
            list-style: none;
        }

        .sidebar-menu li {
            padding: 10px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-menu li a {
            color: white;
            text-decoration: none;
            display: block;
        }

        .sidebar-menu li.active {
            background-color: var(--primary);
        }

        .sidebar-menu li:hover {
            background-color: rgba(0, 0, 0, 0.2);
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
        }

        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
            margin-bottom: 20px;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background-color: var(--primary);
            color: white;
            border-radius: 10px 10px 0 0 !important;
        }

        .donation-card {
            border-left: 5px solid var(--primary);
        }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }

        .badge-donor {
            background-color: var(--primary);
            color: white;
        }

        @media (max-width: 768px) {
            .sidebar {
                margin-left: -250px;
            }
            .main-content {
                margin-left: 0;
            }
            .sidebar.active {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-header">
        <h4>Welfair Donor Portal</h4>
        <p class="mb-0">Welcome, ${donor.name}</p>
    </div>
    <ul class="sidebar-menu">
        <li class="active">
            <a href="#dashboard" data-bs-toggle="tab">
                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="#donations" data-bs-toggle="tab">
                <i class="fas fa-donate me-2"></i> My Donations
            </a>
        </li>
        <li>
            <a href="#projects" data-bs-toggle="tab">
                <i class="fas fa-project-diagram me-2"></i> Supported Projects
            </a>
        </li>
        <li>
            <a href="#receipts" data-bs-toggle="tab">
                <i class="fas fa-file-invoice me-2"></i> Receipts
            </a>
        </li>
        <li>
            <a href="#analytics" data-bs-toggle="tab">
                <i class="fas fa-chart-line me-2"></i> Analytics
            </a>
        </li>
        <li>
            <a href="logout">
                <i class="fas fa-sign-out-alt me-2"></i> Logout
            </a>
        </li>
    </ul>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="container-fluid">
        <div class="tab-content">
            <!-- Dashboard Tab -->
            <div class="tab-pane fade show active" id="dashboard">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2>Donor Dashboard</h2>
                        <p class="text-muted">Overview of your contributions and impact</p>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-3">
                        <div class="card dashboard-card">
                            <div class="card-body text-center">
                                <h5 class="card-title">Total Donations</h5>
                                <h2 class="text-primary">$${totalDonations}</h2>
                                <p class="text-muted">All-time contributions</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="card dashboard-card">
                            <div class="card-body text-center">
                                <h5 class="card-title">Projects Supported</h5>
                                <h2 class="text-primary">${projectsSupported}</h2>
                                <p class="text-muted">Making a difference</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="card dashboard-card">
                            <div class="card-body text-center">
                                <h5 class="card-title">Recent Donation</h5>
                                <h2 class="text-primary">$${lastDonation.amount}</h2>
                                <p class="text-muted">${lastDonation.date}</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="card dashboard-card">
                            <div class="card-body text-center">
                                <h5 class="card-title">Recurring Donations</h5>
                                <h2 class="text-primary">${recurringDonations}</h2>
                                <p class="text-muted">Active subscriptions</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card dashboard-card">
                            <div class="card-header">
                                <h5 class="card-title text-white">Recent Donations</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Amount</th>
                                            <th>Project</th>
                                            <th>Status</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${recentDonations}" var="donation">
                                            <tr>
                                                <td>${donation.date}</td>
                                                <td>$${donation.amount}</td>
                                                <td>${donation.projectName}</td>
                                                <td><span class="badge bg-success">Completed</span></td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <a href="#donations" class="btn btn-sm btn-primary" data-bs-toggle="tab">View All</a>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card dashboard-card">
                            <div class="card-header">
                                <h5 class="card-title text-white">Supported Projects</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                        <tr>
                                            <th>Project</th>
                                            <th>Your Contribution</th>
                                            <th>Status</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${supportedProjects}" var="project">
                                            <tr>
                                                <td>${project.name}</td>
                                                <td>$${project.yourContribution}</td>
                                                <td><span class="badge bg-info">${project.status}</span></td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <a href="#projects" class="btn btn-sm btn-primary" data-bs-toggle="tab">View All</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Donations Tab -->
            <div class="tab-pane fade" id="donations">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h2>My Donations</h2>
                        <p class="text-muted">History of all your contributions</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newDonationModal">
                            <i class="fas fa-plus me-2"></i> Make New Donation
                        </button>
                    </div>
                </div>

                <div class="card dashboard-card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title text-white mb-0">Donation History</h5>
                        <div>
                            <select class="form-select form-select-sm" style="width: auto; display: inline-block;">
                                <option>All Time</option>
                                <option>This Year</option>
                                <option>Last 6 Months</option>
                                <option>Last Month</option>
                            </select>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Transaction ID</th>
                                    <th>Amount</th>
                                    <th>Project</th>
                                    <th>Payment Method</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${allDonations}" var="donation">
                                    <tr>
                                        <td>${donation.date}</td>
                                        <td>${donation.transactionId}</td>
                                        <td>$${donation.amount}</td>
                                        <td>${donation.projectName}</td>
                                        <td>${donation.paymentMethod}</td>
                                        <td>
                                                <span class="badge bg-${donation.status == 'Completed' ? 'success' : donation.status == 'Pending' ? 'warning' : 'danger'}">
                                                        ${donation.status}
                                                </span>
                                        </td>
                                        <td>
                                            <a href="#" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#receiptModal"
                                               data-receipt-id="${donation.id}">
                                                <i class="fas fa-file-invoice"></i> Receipt
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <nav aria-label="Donation pagination">
                            <ul class="pagination justify-content-center">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                                </li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item">
                                    <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>

            <!-- Projects Tab -->
            <div class="tab-pane fade" id="projects">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2>Supported Projects</h2>
                        <p class="text-muted">Projects you've contributed to and their impact</p>
                    </div>
                </div>

                <div class="row">
                    <c:forEach items="${supportedProjectsDetails}" var="project">
                        <div class="col-md-6 mb-4">
                            <div class="card dashboard-card h-100">
                                <img src="${project.imageUrl}" class="card-img-top" alt="${project.name}">
                                <div class="card-body">
                                    <h5 class="card-title">${project.name}</h5>
                                    <p class="card-text">${project.shortDescription}</p>
                                    <div class="progress mb-3">
                                        <div class="progress-bar bg-success" role="progressbar"
                                             style="width: ${project.percentComplete}%"
                                             aria-valuenow="${project.percentComplete}"
                                             aria-valuemin="0"
                                             aria-valuemax="100">
                                                ${project.percentComplete}%
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-6">
                                            <small class="text-muted">Your Contribution</small>
                                            <p class="mb-0">$${project.yourContribution}</p>
                                        </div>
                                        <div class="col-6">
                                            <small class="text-muted">Total Raised</small>
                                            <p class="mb-0">$${project.totalRaised}</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer bg-white">
                                    <a href="project-details?id=${project.id}" class="btn btn-sm btn-primary">View Details</a>
                                    <button class="btn btn-sm btn-outline-secondary float-end"
                                            data-bs-toggle="modal"
                                            data-bs-target="#projectImpactModal"
                                            data-project-id="${project.id}">
                                        <i class="fas fa-chart-pie me-1"></i> Impact
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Receipts Tab -->
            <div class="tab-pane fade" id="receipts">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2>Donation Receipts</h2>
                        <p class="text-muted">Download receipts for tax purposes</p>
                    </div>
                </div>

                <div class="card dashboard-card">
                    <div class="card-header">
                        <h5 class="card-title text-white">Available Receipts</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Receipt ID</th>
                                    <th>Amount</th>
                                    <th>Project</th>
                                    <th>Fiscal Year</th>
                                    <th>Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${receipts}" var="receipt">
                                    <tr>
                                        <td>${receipt.date}</td>
                                        <td>${receipt.receiptId}</td>
                                        <td>$${receipt.amount}</td>
                                        <td>${receipt.projectName}</td>
                                        <td>${receipt.fiscalYear}</td>
                                        <td>
                                            <a href="download-receipt?id=${receipt.id}" class="btn btn-sm btn-primary">
                                                <i class="fas fa-download me-1"></i> Download
                                            </a>
                                            <button class="btn btn-sm btn-outline-secondary"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#receiptModal"
                                                    data-receipt-id="${receipt.id}">
                                                <i class="fas fa-eye me-1"></i> Preview
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Analytics Tab -->
            <div class="tab-pane fade" id="analytics">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2>Donation Analytics</h2>
                        <p class="text-muted">Visualize your giving patterns and impact</p>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <div class="card dashboard-card h-100">
                            <div class="card-header">
                                <h5 class="card-title text-white">Donations Over Time</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="donationTimelineChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="card dashboard-card h-100">
                            <div class="card-header">
                                <h5 class="card-title text-white">Donation by Project</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="projectDistributionChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <div class="card dashboard-card h-100">
                            <div class="card-header">
                                <h5 class="card-title text-white">Payment Methods</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="paymentMethodChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="card dashboard-card h-100">
                            <div class="card-header">
                                <h5 class="card-title text-white">Yearly Comparison</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="yearlyComparisonChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- New Donation Modal -->
<div class="modal fade" id="newDonationModal" tabindex="-1" aria-labelledby="newDonationModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="newDonationModalLabel">Make a New Donation</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="donationForm" action="process-donation" method="post">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="amount" class="form-label">Amount ($)</label>
                            <input type="number" class="form-control" id="amount" name="amount" min="1" required>
                        </div>
                        <div class="col-md-6">
                            <label for="project" class="form-label">Project</label>
                            <select class="form-select" id="project" name="project" required>
                                <option value="">Select a project</option>
                                <c:forEach items="${activeProjects}" var="project">
                                    <option value="${project.id}">${project.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Donation Type</label>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="donationType" id="oneTime" value="one-time" checked>
                                <label class="form-check-label" for="oneTime">
                                    One-time donation
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="donationType" id="recurring" value="recurring">
                                <label class="form-check-label" for="recurring">
                                    Recurring donation
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6" id="recurringOptions" style="display: none;">
                            <label for="frequency" class="form-label">Frequency</label>
                            <select class="form-select" id="frequency" name="frequency">
                                <option value="monthly">Monthly</option>
                                <option value="quarterly">Quarterly</option>
                                <option value="yearly">Yearly</option>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="paymentMethod" class="form-label">Payment Method</label>
                            <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                <option value="">Select payment method</option>
                                <option value="credit-card">Credit Card</option>
                                <option value="paypal">PayPal</option>
                                <option value="bank-transfer">Bank Transfer</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="dedication" class="form-label">Dedication (Optional)</label>
                            <input type="text" class="form-control" id="dedication" name="dedication" placeholder="In memory of...">
                        </div>
                    </div>

                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="anonymous" name="anonymous">
                        <label class="form-check-label" for="anonymous">
                            Make this donation anonymously
                        </label>
                    </div>

                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="coverFees" name="coverFees">
                        <label class="form-check-label" for="coverFees">
                            I'd like to cover the processing fees so 100% of my donation goes to the cause
                        </label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" form="donationForm" class="btn btn-primary">Process Donation</button>
            </div>
        </div>
    </div>
</div>

<!-- Receipt Preview Modal -->
<div class="modal fade" id="receiptModal" tabindex="-1" aria-labelledby="receiptModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="receiptModalLabel">Donation Receipt</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="receipt-container" id="receiptContent">
                    <!-- Receipt content will be loaded via AJAX -->
                    <div class="text-center py-5">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <a href="#" class="btn btn-primary" id="downloadReceiptBtn">Download PDF</a>
            </div>
        </div>
    </div>
</div>

<!-- Project Impact Modal -->
<div class="modal fade" id="projectImpactModal" tabindex="-1" aria-labelledby="projectImpactModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="projectImpactModalLabel">Project Impact</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="projectImpactContent">
                    <!-- Project impact content will be loaded via AJAX -->
                    <div class="text-center py-5">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
<script>
    // Toggle recurring options
    document.querySelectorAll('input[name="donationType"]').forEach(radio => {
        radio.addEventListener('change', function() {
            document.getElementById('recurringOptions').style.display =
                this.value === 'recurring' ? 'block' : 'none';
        });
    });

    // Initialize charts
    document.addEventListener('DOMContentLoaded', function() {
        // Donation Timeline Chart
        const timelineCtx = document.getElementById('donationTimelineChart').getContext('2d');
        new Chart(timelineCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: 'Donations 2023',
                    data: [120, 190, 150, 200, 180, 220, 250, 210, 300, 280, 320, 400],
                    borderColor: '#2c8a8a',
                    backgroundColor: 'rgba(44, 138, 138, 0.1)',
                    tension: 0.3,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    }
                }
            }
        });

        // Project Distribution Chart
        const projectCtx = document.getElementById('projectDistributionChart').getContext('2d');
        new Chart(projectCtx, {
            type: 'doughnut',
            data: {
                labels: ['Education', 'Healthcare', 'Clean Water', 'Disaster Relief'],
                datasets: [{
                    data: [35, 25, 20, 20],
                    backgroundColor: [
                        '#2c8a8a',
                        '#f8b400',
                        '#3a9bdc',
                        '#e74c3c'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                    }
                }
            }
        });

        // Payment Method Chart
        const paymentCtx = document.getElementById('paymentMethodChart').getContext('2d');
        new Chart(paymentCtx, {
            type: 'bar',
            data: {
                labels: ['Credit Card', 'PayPal', 'Bank Transfer'],
                datasets: [{
                    label: 'Payment Methods',
                    data: [65, 25, 10],
                    backgroundColor: [
                        '#2c8a8a',
                        '#f8b400',
                        '#3a9bdc'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });

        // Yearly Comparison Chart
        const yearlyCtx = document.getElementById('yearlyComparisonChart').getContext('2d');
        new Chart(yearlyCtx, {
            type: 'bar',
            data: {
                labels: ['2021', '2022', '2023'],
                datasets: [{
                    label: 'Total Donations',
                    data: [1200, 1800, 2500],
                    backgroundColor: '#2c8a8a'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    });

    // Load receipt content via AJAX
    const receiptModal = document.getElementById('receiptModal');
    receiptModal.addEventListener('show.bs.modal', function(event) {
        const button = event.relatedTarget;
        const receiptId = button.getAttribute('data-receipt-id');
        const modal = this;

        fetch('get-receipt?id=' + receiptId)
            .then(response => response.text())
            .then(html => {
                modal.querySelector('#receiptContent').innerHTML = html;
                modal.querySelector('#downloadReceiptBtn').href = 'download-receipt?id=' + receiptId;
            });
    });

    // Load project impact via AJAX
    const projectImpactModal = document.getElementById('projectImpactModal');
    projectImpactModal.addEventListener('show.bs.modal', function(event) {
        const button = event.relatedTarget;
        const projectId = button.getAttribute('data-project-id');
        const modal = this;

        fetch('get-project-impact?projectId=' + projectId + '&donorId=${donor.id}')
            .then(response => response.text())
            .then(html => {
                modal.querySelector('#projectImpactContent').innerHTML = html;
            });
    });
</script>
</body>
</html>