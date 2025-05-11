<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>${tableName} Management</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
  <style>
    :root {
      --primary: #4361ee;
      --secondary: #3f37c9;
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

    .table-container {
      background: white;
      border-radius: 10px;
      box-shadow: 0 0 20px rgba(0,0,0,0.05);
      padding: 20px;
      margin-top: 20px;
    }

    .page-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
      padding-bottom: 15px;
      border-bottom: 1px solid #eee;
    }
  </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>

<div class="main-content">
  <div class="container-fluid">
    <div class="page-header">
      <h2><i class="bi bi-table me-2"></i>${tableName} Management</h2>
      <div>
        <a href="admin-dashboard" class="btn btn-outline-secondary me-2">
          <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
        <!-- Update the Add New link to match your donor list pattern -->
        <a href="${tableId}?action=new" class="btn btn-primary">
          <i class="bi bi-plus-lg"></i> Add New
        </a>
      </div>
    </div>

    <div class="table-container">
      <div class="table-responsive">
        <table class="table table-hover align-middle">
          <thead class="table-light">
          <tr>
            <c:choose>
              <c:when test="${tableId == 'donors'}">
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Address</th>
                <th>Actions</th>
              </c:when>
              <c:when test="${tableId == 'donations'}">
                <th>ID</th>
                <th>Amount</th>
                <th>Date</th>
                <th>Payment Mode</th>
                <th>Donor</th>
                <th>Project</th>
                <th>Actions</th>
              </c:when>
              <c:when test="${tableId == 'projects'}">
                <th>ID</th>
                <th>Name</th>
                <th>Description</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Status</th>
                <th>Actions</th>
              </c:when>
              <c:when test="${tableId == 'beneficiaries'}">
                <th>ID</th>
                <th>Name</th>
                <th>Age</th>
                <th>Gender</th>
                <th>Address</th>
                <th>Actions</th>
              </c:when>
              <c:when test="${tableId == 'employees'}">
                <th>ID</th>
                <th>Name</th>
                <th>Position</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Actions</th>
              </c:when>
              <c:when test="${tableId == 'volunteers'}">
                <th>ID</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Actions</th>
              </c:when>
              <c:when test="${tableId == 'events'}">
                <th>ID</th>
                <th>Name</th>
                <th>Date</th>
                <th>Location</th>
                <th>Organizer</th>
                <th>Actions</th>
              </c:when>
              <c:when test="${tableId == 'inventory'}">
                <th>ID</th>
                <th>Name</th>
                <th>Quantity</th>
                <th>Unit</th>
                <th>Actions</th>
              </c:when>
              <c:when test="${tableId == 'inventory_usage'}">
                <th>Item ID</th>
                <th>Project ID</th>
                <th>Quantity Used</th>
                <th>Actions</th>
              </c:when>
              <c:when test="${tableId == 'fund_allocation'}">
                <th>ID</th>
                <th>Project</th>
                <th>Amount</th>
                <th>Date Allocated</th>
                <th>Actions</th>
              </c:when>
              <c:otherwise>
                <th>ID</th>
                <th>Details</th>
                <th>Actions</th>
              </c:otherwise>
            </c:choose>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="item" items="${tableData}">
            <tr>
              <c:choose>
                <c:when test="${tableId == 'donors'}">
                  <td>${item.donorId}</td>
                  <td>${item.name}</td>
                  <td>${item.email}</td>
                  <td>${item.phone}</td>
                  <td>${item.address}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="${tableId}?action=edit&id=${item.donorId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="${tableId}?action=delete&id=${item.donorId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>
                <%-- Previous code remains the same until the donations table section --%>

                <c:when test="${tableId == 'donations'}">
                  <td>${item.donationId}</td>
                  <td>${item.amount}</td>
                  <td>${item.date}</td>
                  <td>${item.mode}</td>
                  <td>${item.donorId} </td>
                  <td>${item.projectId} </td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="donations?action=edit&id=${item.donationId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="donations?action=delete&id=${item.donationId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>

                <%-- Rest of the code remains the same --%>
                <c:when test="${tableId == 'projects'}">
                  <td>${item.projectId}</td>
                  <td>${item.name}</td>
                  <td>${item.description}</td>
                  <td>${item.startDate}</td>
                  <td>${item.endDate}</td>
                  <td>${item.status}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="projects?action=edit&id=${item.projectId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="projects?action=delete&id=${item.projectId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>
                <c:when test="${tableId == 'beneficiaries'}">
                  <td>${item.beneficiaryId}</td>
                  <td>${item.name}</td>
                  <td>${item.age}</td>
                  <td>${item.gender}</td>
                  <td>${item.address}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="beneficiaries?action=edit&id=${item.beneficiaryId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="beneficiaries?action=delete&id=${item.beneficiaryId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>
                <c:when test="${tableId == 'employees'}">
                  <td>${item.empId}</td>
                  <td>${item.name}</td>
                  <td>${item.position}</td>
                  <td>${item.phone}</td>
                  <td>${item.email}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="employees?action=edit&id=${item.empId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="employees?action=delete&id=${item.empId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>
                <c:when test="${tableId == 'volunteers'}">
                  <td>${item.volunteerId}</td>
                  <td>${item.name}</td>
                  <td>${item.phone}</td>
                  <td>${item.email}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="volunteers?action=edit&id=${item.volunteerId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="volunteers?action=delete&id=${item.volunteerId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>

                <c:when test="${tableId == 'event_volunteers'}">
                  <td>${item.eventId}</td>
                  <td>${item.volunteerId}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="/event_volunteers?action=edit&eventId=${item.eventId}&volunteerId=${item.volunteerId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="/event_volunteers?action=delete&eventId=${item.eventId}&volunteerId=${item.volunteerId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>



                <c:when test="${tableId == 'inventory_usage'}">
                  <td>${item.itemId}</td>
                  <td>${item.projectId}</td>
                  <td>${item.quantityUsed}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="/inventory_usage?action=edit&item_id=${item.itemId}&project_id=${item.projectId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="/inventory_usage?action=delete&item_id=${item.itemId}&project_id=${item.projectId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>


                <c:when test="${tableId == 'events'}">
                  <td>${item.eventId}</td>
                  <td>${item.name}</td>
                  <td>${item.date}</td>
                  <td>${item.location}</td>
                  <td>${item.organizer}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="/events/edit?id=${item.eventId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="/events/delete?id=${item.eventId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>
                <c:when test="${tableId == 'inventory'}">
                  <td>${item.itemId}</td>
                  <td>${item.name}</td>
                  <td>${item.quantity}</td>
                  <td>${item.unit}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="inventory?action=edit&item_id=${item.itemId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="inventory?action=delete&item_id=${item.itemId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>

                <c:when test="${tableId == 'fund_allocation'}">
                  <td>${item.fundId}</td>
                  <td>${item.projectName}</td>
                  <td>$${item.amount}</td>
                  <td>${item.dateAllocated}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="/fund_allocation/edit?id=${item.fundId}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="/fund_allocation/delete?id=${item.fundId}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>

                <c:when test="${tableId == 'project_beneficiaries'}">
                  <td>${item.projectId}</td>
                  <td>${item.beneficiaryId}</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <!-- Special handling for composite key -->
                      <a href="admin-edit?table=${tableId}&projectId=${item.projectId}&beneficiaryId=${item.beneficiaryId}"
                         class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="admin-delete?table=${tableId}&projectId=${item.projectId}&beneficiaryId=${item.beneficiaryId}"
                         class="btn btn-outline-danger"
                         onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:when>

                <c:otherwise>
                  <td>${item[idFieldName]}</td>
                  <td>View Details</td>
                  <td>
                    <div class="btn-group btn-group-sm">
                      <a href="admin-edit?table=${tableId}&id=${item[idFieldName]}" class="btn btn-outline-warning">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a href="admin-delete?table=${tableId}&id=${item[idFieldName]}" class="btn btn-outline-danger" onclick="return confirm('Are you sure?')">
                        <i class="bi bi-trash"></i>
                      </a>
                    </div>
                  </td>
                </c:otherwise>
              </c:choose>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Mobile sidebar toggle
  document.addEventListener('DOMContentLoaded', function() {
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

    // Prevent default anchor behavior to maintain scroll position
    document.querySelectorAll('.sidebar a').forEach(link => {
      link.addEventListener('click', function(e) {
        // Save scroll position before navigation
        const sidebarContent = document.querySelector('.sidebar-content');
        sessionStorage.setItem('sidebarScroll', sidebarContent.scrollTop);
      });
    });

    // Restore scroll position after page load
    const savedScroll = sessionStorage.getItem('sidebarScroll');
    if (savedScroll) {
      const sidebarContent = document.querySelector('.sidebar-content');
      sidebarContent.scrollTop = savedScroll;
    }
  });
</script>
</body>
</html>