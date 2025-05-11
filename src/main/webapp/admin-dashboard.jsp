<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <title>Admin Dashboard</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary: #4361ee;
      --secondary: #3f37c9;
      --success: #4cc9f0;
      --info: #4895ef;
      --warning: #f72585;
      --light: #f8f9fa;
      --dark: #212529;
    }

    body {
      padding-left: 250px;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f5f7fb;
    }

    @media (max-width: 768px) {
      body {
        padding-left: 0;
      }
    }

    .main-content {
      padding: 20px;
    }

    .dashboard-header {
      margin-bottom: 30px;
    }

    .dashboard-header h2 {
      color: var(--dark);
      font-weight: 600;
    }

    .stats-card {
      border-radius: 10px;
      border: none;
      box-shadow: 0 4px 20px rgba(0,0,0,0.05);
      transition: transform 0.3s;
      height: 100%;
    }

    .stats-card:hover {
      transform: translateY(-5px);
    }

    .card-donations {
      background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
      color: white;
    }

    .card-projects {
      background: linear-gradient(135deg, #4cc9f0 0%, #4895ef 100%);
      color: white;
    }

    .card-beneficiaries {
      background: linear-gradient(135deg, #f72585 0%, #b5179e 100%);
      color: white;
    }

    .card-inventory {
      background: linear-gradient(135deg, #7209b7 0%, #560bad 100%);
      color: white;
    }

    .card-body {
      padding: 20px;
    }

    .card-icon {
      font-size: 2rem;
      margin-bottom: 15px;
    }

    .card-title {
      font-size: 1rem;
      opacity: 0.9;
      margin-bottom: 5px;
    }

    .card-value {
      font-size: 2rem;
      font-weight: 700;
      margin-bottom: 0;
    }

    .rupee-symbol {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
  </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>

<div class="main-content">
  <div class="dashboard-header">
    <h2><i class="bi bi-speedometer2 me-2"></i>Admin Dashboard</h2>
  </div>

  <div class="row">
    <div class="col-md-6 col-lg-3 mb-4">
      <div class="stats-card card-donations">
        <div class="card-body">
          <i class="bi bi-cash-coin card-icon"></i>
          <h5 class="card-title">Total Donations</h5>
          <h2 class="card-value">
            <c:choose>
              <c:when test="${not empty totalDonations}">
                <span class="rupee-symbol">₹</span>
                <fmt:formatNumber value="${totalDonations/100}"
                                  type="number"
                                  minFractionDigits="2"
                                  maxFractionDigits="2"/>
              </c:when>
              <c:otherwise>
                <span class="rupee-symbol">₹</span>0.00
              </c:otherwise>
            </c:choose>
          </h2>
        </div>
      </div>
    </div>

    <div class="col-md-6 col-lg-3 mb-4">
      <div class="stats-card card-projects">
        <div class="card-body">
          <i class="bi bi-kanban card-icon"></i>
          <h5 class="card-title">Total Projects</h5>
          <h2 class="card-value">${totalProjects}</h2>
        </div>
      </div>
    </div>

    <div class="col-md-6 col-lg-3 mb-4">
      <div class="stats-card card-beneficiaries">
        <div class="card-body">
          <i class="bi bi-heart card-icon"></i>
          <h5 class="card-title">Total Beneficiaries</h5>
          <h2 class="card-value">${totalBeneficiaries}</h2>
        </div>
      </div>
    </div>

    <div class="col-md-6 col-lg-3 mb-4">
      <div class="stats-card card-inventory">
        <div class="card-body">
          <i class="bi bi-box-seam card-icon"></i>
          <h5 class="card-title">Inventory Items</h5>
          <h2 class="card-value">${totalInventoryItems}</h2>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Counter animation
  document.addEventListener('DOMContentLoaded', function() {
    const counters = document.querySelectorAll('.card-value');
    const speed = 200;

    counters.forEach(counter => {
      const target = +counter.innerText.replace(/\D/g, '');
      const increment = target / speed;
      let current = 0;

      const updateCount = () => {
        current += increment;
        if (current < target) {
          counter.innerText = counter.innerText.startsWith('$')
                  ? '$' + Math.ceil(current)
                  : Math.ceil(current);
          setTimeout(updateCount, 1);
        } else {
          counter.innerText = counter.innerText.startsWith('$')
                  ? '$' + target
                  : target;
        }
      };

      updateCount();
    });

    // Mobile sidebar toggle
    const sidebar = document.querySelector('.sidebar');
    const toggleBtn = document.createElement('button');
    toggleBtn.className = 'btn btn-primary d-md-none position-fixed';
    toggleBtn.style.zIndex = '1050';
    toggleBtn.style.bottom = '20px';
    toggleBtn.style.right = '20px';
    toggleBtn.innerHTML = '<i class="bi bi-list"></i>';

    toggleBtn.addEventListener('click', function() {
      sidebar.classList.toggle('active');
    });

    document.body.appendChild(toggleBtn);
  });
</script>
</body>
</html>