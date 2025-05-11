<%@ page import="com.welfair.dao.*" %>
<%@ page import="com.welfair.model.*" %>
<%@ page import="java.util.*, com.google.gson.Gson" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    ProjectDAO projectDAO = new ProjectDAO();
    List<Project> projects = projectDAO.getAllProjects();

    ProjectBeneficiaryDAO pbDAO = new ProjectBeneficiaryDAO();
    VolunteerProjectDAO vpDAO = new VolunteerProjectDAO();
    ProjectEmployeeDAO peDAO = new ProjectEmployeeDAO();
    InventoryUsageDAO iuDAO = new InventoryUsageDAO();

    Map<String, Integer> statusMap = new HashMap<>();
    for (Project p : projects) {
        String status = p.getStatus();
        statusMap.put(status, statusMap.getOrDefault(status, 0) + 1);
    }
    String chartJson = new Gson().toJson(statusMap);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Projects Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://www.gstatic.com/charts/loader.js"></script>
    <style>
        .project-card {
            transition: transform 0.2s;
            border-radius: 15px;
            overflow: hidden;
        }
        .project-card:hover {
            transform: translateY(-5px);
        }
        .status-badge {
            position: absolute;
            right: 15px;
            top: 15px;
            z-index: 2;
        }
        .progress-bar {
            height: 8px;
            border-radius: 4px;
        }
        .team-member-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        .nav-tabs .nav-link.active {
            background: rgba(255,255,255,0.1);
            border-color: transparent;
        }
    </style>
    <script>
        google.charts.load('current', {'packages':['corechart']});
        google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
            const data = [['Status', 'Count']];
            const statusMap = <%= chartJson %>;

            for (const [status, count] of Object.entries(statusMap)) {
                data.push([status, count]);
            }

            const chartData = google.visualization.arrayToDataTable(data);
            const options = {
                title: 'Project Status Overview',
                pieHole: 0.4,
                chartArea: { width: '90%', height: '80%' },
                colors: ['#4CAF50', '#2196F3', '#FF9800', '#E91E63']
            };

            const chart = new google.visualization.PieChart(document.getElementById('chart'));
            chart.draw(chartData, options);
        }
    </script>
</head>
<body class="bg-light">
<div class="container py-5">
    <h1 class="text-center mb-5 display-4 text-primary">
        <i class="fas fa-project-diagram"></i> Projects Overview
    </h1>

    <!-- Statistics Cards -->
    <div class="row mb-5">
        <div class="col-md-3">
            <div class="card bg-primary text-white shadow">
                <div class="card-body">
                    <h5><i class="fas fa-tasks"></i> Total Projects</h5>
                    <h2 class="mb-0"><%= projects.size() %></h2>
                </div>
            </div>
        </div>
        <% for (Map.Entry<String, Integer> entry : statusMap.entrySet()) { %>
        <div class="col-md-3">
            <div class="card shadow">
                <div class="card-body">
                    <h5 class="text-muted"><%= entry.getKey() %></h5>
                    <h2 class="text-primary"><%= entry.getValue() %></h2>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <!-- Projects List -->
    <div class="row">
        <% for (Project project : projects) {
            List<ProjectBeneficiary> beneficiaries = pbDAO.getBeneficiariesByProject(project.getProjectId());
            List<VolunteerProject> volunteers = vpDAO.getVolunteersByProject(project.getProjectId());
            List<ProjectEmployee> employees = peDAO.getEmployeesByProject(project.getProjectId());
            List<InventoryUsage> inventory = iuDAO.getInventoryByProject(project.getProjectId());
        %>
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card project-card h-100 shadow">
                <span class="status-badge badge <%= getStatusBadgeClass(project.getStatus()) %>">
                    <%= project.getStatus() %>
                </span>

                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0"><%= project.getName() %></h5>
                    <small class="text-white-50">
                        <%= project.getStartDate() %> to <%= project.getEndDate() %>
                    </small>
                </div>

                <div class="card-body">
                    <!-- Progress Bar -->
                    <div class="mb-3">
                        <div class="d-flex justify-content-between small text-muted mb-2">
                            <span>Project Timeline</span>
                            <span><%= getProgressPercentage(project) %>%</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-info"
                                 style="width: <%= getProgressPercentage(project) %>%"></div>
                        </div>
                    </div>

                    <!-- Tabs -->
                    <ul class="nav nav-tabs mb-3">
                        <li class="nav-item">
                            <a class="nav-link active" data-bs-toggle="tab" href="#desc-<%= project.getProjectId() %>">
                                <i class="fas fa-info-circle"></i>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#team-<%= project.getProjectId() %>">
                                <i class="fas fa-users"></i> Team
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#beneficiaries-<%= project.getProjectId() %>">
                                <i class="fas fa-hands-helping"></i> Beneficiaries
                            </a>
                        </li>
                    </ul>

                    <!-- Tab Content -->
                    <div class="tab-content">
                        <!-- Description Tab -->
                        <div class="tab-pane fade show active" id="desc-<%= project.getProjectId() %>">
                            <p class="card-text"><%= project.getDescription() %></p>
                            <div class="row small text-muted">
                                <div class="col-6">
                                    <i class="fas fa-calendar-day"></i> Start Date<br>
                                    <strong><%= project.getStartDate() %></strong>
                                </div>
                                <div class="col-6">
                                    <i class="fas fa-calendar-check"></i> End Date<br>
                                    <strong><%= project.getEndDate() %></strong>
                                </div>
                            </div>
                        </div>

                        <!-- Team Tab -->
                        <div class="tab-pane fade" id="team-<%= project.getProjectId() %>">
                            <h6 class="text-muted mb-3">Team Members</h6>
                            <ul class="list-group list-group-flush">
                                <% for (ProjectEmployee emp : employees) { %>
                                <li class="list-group-item d-flex align-items-center">
                                    <img src="<%= emp.getEmployee().getPhotoUrl() %>"
                                         class="team-member-avatar me-2">
                                    <div>
                                        <div><%= emp.getEmployee().getName() %></div>
                                        <small class="text-muted"><%= emp.getRole() %></small>
                                    </div>
                                </li>
                                <% } %>
                            </ul>

                            <h6 class="text-muted mt-4 mb-3">Volunteers</h6>
                            <div class="row">
                                <% for (VolunteerProject vol : volunteers) { %>
                                <div class="col-6 mb-2">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-user-alt me-2 text-success"></i>
                                        <div>
                                            <div><%= vol.getVolunteer().getName() %></div>
                                            <small class="text-muted"><%= vol.getRole() %></small>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>

                        <!-- Beneficiaries Tab -->
                        <div class="tab-pane fade" id="beneficiaries-<%= project.getProjectId() %>">
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Age</th>
                                        <th>Assigned</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (ProjectBeneficiary pb : beneficiaries) { %>
                                    <tr>
                                        <td><%= pb.getBeneficiary().getName() %></td>
                                        <td><%= pb.getBeneficiary().getAge() %></td>
                                        <td><%= pb.getDateAssigned() %></td>
                                    </tr>
                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Inventory Section -->
                <% if (!inventory.isEmpty()) { %>
                <div class="card-footer bg-light">
                    <h6 class="text-muted"><i class="fas fa-box-open"></i> Inventory Used</h6>
                    <div class="d-flex flex-wrap gap-2">
                        <% for (InventoryUsage item : inventory) { %>
                        <span class="badge bg-secondary">
                            <%= item.getItem().getName() %>: <%= item.getQuantityUsed() %> <%= item.getItem().getUnit() %>
                        </span>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%!
    // Helper method to calculate progress percentage
    private int getProgressPercentage(Project project) {
        long now = System.currentTimeMillis();
        long start = project.getStartDate().getTime();
        long end = project.getEndDate().getTime();

        if (now >= end) return 100;
        if (now <= start) return 0;

        return (int) ((now - start) * 100 / (end - start));
    }

    // Helper method for status badge styling
    private String getStatusBadgeClass(String status) {
        switch(status.toLowerCase()) {
            case "completed": return "bg-success";
            case "in progress": return "bg-primary";
            case "planned": return "bg-info";
            default: return "bg-secondary";
        }
    }
%>