<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Donor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .project-card {
            transition: transform 0.3s;
            height: 100%;
        }
        .project-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h1>Welcome, ${donor.name}!</h1>
        <form action="logout" method="post">
            <button type="submit" class="btn btn-outline-danger">Logout</button>
        </form>
    </div>

    <!-- Debug Message -->
    <c:if test="${empty activeProjects}">
        <div class="alert alert-warning">
            No active projects found. Please contact administrator.
        </div>
    </c:if>

    <div class="row mb-4">
        <div class="col-md-6">
            <div class="stats-card">
                <h3>Total Donations</h3>
                <h2 class="text-primary">$${totalDonations}</h2>
            </div>
        </div>
        <div class="col-md-6">
            <div class="stats-card">
                <h3>Projects Supported</h3>
                <h2 class="text-primary">${projectsSupported}</h2>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-5">
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h3>Make a Donation</h3>
                </div>
                <div class="card-body">
                    <form action="make-donation" method="post">
                        <div class="mb-3">
                            <label class="form-label">Select Project</label>
                            <select class="form-select" name="projectId" required>
                                <option value="">Choose a project...</option>
                                <c:forEach var="project" items="${activeProjects}">
                                    <option value="${project.projectId}">${project.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Amount ($)</label>
                            <input type="number" class="form-control" name="amount" min="1" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Donate Now</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-7">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h3>Active Projects</h3>
                </div>
                <div class="card-body">
                    <div class="row row-cols-1 row-cols-md-2 g-4">
                        <c:forEach var="project" items="${activeProjects}">
                            <div class="col">
                                <div class="card project-card h-100">
                                    <img src="${not empty project.imageUrl ? project.imageUrl : 'https://via.placeholder.com/300x200'}"
                                         class="card-img-top" alt="${project.name}">
                                    <div class="card-body">
                                        <h5 class="card-title">${project.name}</h5>
                                        <p class="card-text">${project.description}</p>
                                        <span class="badge bg-info">${project.category}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>