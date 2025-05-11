<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.welfair.dao.EmployeeDAO" %>
<%@ page import="com.welfair.model.Employee" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>

<%
  // Database connection and data fetching
  EmployeeDAO employeeDAO = new EmployeeDAO();
  List<Employee> employees = null;
  String error = null;

  try {
    // Get connection (EmployeeDAO will handle connection management)
    employeeDAO.setConnection(employeeDAO.getActiveConnection());

    // Fetch all employees
    employees = employeeDAO.getAllEmployees();

    // Store in request scope for JSTL
    request.setAttribute("employees", employees);

  } catch (SQLException e) {
    error = "Database error: " + e.getMessage();
    request.setAttribute("error", error);

    // For debugging, you might want to create some test data
    Employee testEmp1 = new Employee();
    testEmp1.setEmpId(1);
    testEmp1.setName("John Doe");
    testEmp1.setPosition("Manager");
    testEmp1.setEmail("john@example.com");
    testEmp1.setBio("Experienced manager with 10+ years in the industry");

    Employee testEmp2 = new Employee();
    testEmp2.setEmpId(2);
    testEmp2.setName("Jane Smith");
    testEmp2.setPosition("Field Coordinator");
    testEmp2.setEmail("jane@example.com");
    testEmp2.setBio("Passionate about community outreach programs");

    employees = List.of(testEmp1, testEmp2);
    request.setAttribute("employees", employees);
    request.setAttribute("warning", "Using test data due to database connection issues");
  }
%>

<!DOCTYPE html>
<html>
<head>
  <title>Our Team | Welfair</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    /* [Keep all your existing CSS styles] */
    /* ... your existing CSS ... */
    :root {
      --primary: #2c8a8a;
      --primary-light: #e6f2f2;
      --secondary: #f8b400;
      --dark: #2d3436;
      --light: #ffffff;
      --text: #4a4a4a;
      --text-light: #777777;
      --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
      --transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Poppins', sans-serif;
      background-color: #f9fbfc;
      color: var(--text);
      line-height: 1.6;
    }

    .team-hero {
      background: linear-gradient(135deg, var(--primary) 0%, #34a1a1 100%);
      color: white;
      padding: 80px 20px;
      text-align: center;
      position: relative;
      overflow: hidden;
    }

    .team-hero::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="none"><path fill="rgba(255,255,255,0.05)" d="M0,0 L100,0 L100,100 L0,100 Z" /></svg>');
      background-size: cover;
    }

    .team-hero-content {
      max-width: 800px;
      margin: 0 auto;
      position: relative;
      z-index: 2;
    }

    .team-hero h1 {
      font-size: 2.8rem;
      margin-bottom: 15px;
      font-weight: 700;
    }

    .team-hero p {
      font-size: 1.1rem;
      opacity: 0.9;
      margin-bottom: 30px;
    }

    .team-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 60px 20px;
    }

    .team-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 30px;
      margin-top: 40px;
    }

    .team-card {
      background: var(--light);
      border-radius: 12px;
      overflow: hidden;
      box-shadow: var(--card-shadow);
      transition: var(--transition);
      position: relative;
    }

    .team-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
    }

    .team-photo {
      height: 280px;
      overflow: hidden;
      position: relative;
    }

    .team-photo img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: var(--transition);
    }

    .team-card:hover .team-photo img {
      transform: scale(1.05);
    }

    .team-info {
      padding: 25px;
      text-align: center;
    }

    .team-name {
      font-size: 1.4rem;
      font-weight: 600;
      margin-bottom: 5px;
      color: var(--dark);
    }

    .team-position {
      color: var(--primary);
      font-weight: 500;
      margin-bottom: 15px;
      display: block;
    }

    .team-bio {
      color: var(--text-light);
      font-size: 0.95rem;
      margin-bottom: 20px;
      display: -webkit-box;
      -webkit-line-clamp: 3;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .team-contact {
      display: flex;
      justify-content: center;
      gap: 15px;
    }

    .team-contact a {
      color: var(--text-light);
      transition: var(--transition);
      width: 36px;
      height: 36px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      background: var(--primary-light);
    }

    .team-contact a:hover {
      color: white;
      background: var(--primary);
      transform: translateY(-3px);
    }

    .team-departments {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      gap: 15px;
      margin-bottom: 40px;
    }

    .department-btn {
      padding: 8px 20px;
      border-radius: 50px;
      background: white;
      border: 1px solid #e0e0e0;
      cursor: pointer;
      transition: var(--transition);
      font-size: 0.9rem;
    }

    .department-btn:hover,
    .department-btn.active {
      background: var(--primary);
      color: white;
      border-color: var(--primary);
    }

    .section-title {
      text-align: center;
      margin-bottom: 20px;
      position: relative;
    }

    .section-title h2 {
      font-size: 2rem;
      color: var(--dark);
      display: inline-block;
      position: relative;
    }

    .section-title h2::after {
      content: '';
      position: absolute;
      bottom: -10px;
      left: 50%;
      transform: translateX(-50%);
      width: 60px;
      height: 3px;
      background: var(--primary);
    }

    @media (max-width: 768px) {
      .team-grid {
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      }

      .team-hero h1 {
        font-size: 2.2rem;
      }
    }
    /* Add debug styles */
    .debug-panel {
      background: #f0f0f0;
      padding: 15px;
      margin: 20px;
      border-radius: 8px;
      border-left: 4px solid #e74c3c;
    }

    .debug-title {
      font-weight: bold;
      color: #e74c3c;
      margin-bottom: 10px;
    }

    .debug-info {
      margin-bottom: 5px;
    }

    .error-message {
      color: #e74c3c;
      background: #ffebee;
      padding: 10px;
      border-radius: 4px;
      margin: 10px 0;
    }
  </style>
</head>
<body>
<!-- Debug Panel -->
<div class="debug-panel">
  <div class="debug-title">System Information</div>
  <div class="debug-info">Employees list: ${not empty employees ? employees.size() : '0'} employees found</div>

  <c:if test="${not empty warning}">
    <div class="warning-message">⚠️ ${warning}</div>
  </c:if>

  <c:if test="${not empty error}">
    <div class="error-message">❌ ${error}</div>
  </c:if>

  <c:if test="${not empty employees}">
    <div class="debug-info">Data source: ${not empty error ? 'Test Data' : 'Database'}</div>
  </c:if>
</div>

<!-- Rest of your JSP content remains the same -->
<section class="team-hero">
  <div class="team-hero-content">
    <h1>Meet Our Team</h1>
    <p>The passionate individuals who make our mission possible every day</p>
  </div>
</section>

<!-- Main Content -->
<div class="team-container">
  <div class="section-title">
    <h2>Our Dedicated Team</h2>
  </div>

  <!-- Department Filter (optional) -->
  <div class="team-departments">
    <button class="department-btn active">All</button>
    <button class="department-btn">Management</button>
    <button class="department-btn">Field Work</button>
    <button class="department-btn">Support</button>
  </div>

  <!-- Team Grid -->
  <div class="team-grid">
    <c:forEach var="employee" items="${employees}">
      <div class="team-card">
        <div class="team-photo">
          <img src="${not empty employee.photoUrl ? employee.photoUrl : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1064&q=80'}"
               alt="${employee.name}">
        </div>
        <div class="team-info">
          <h3 class="team-name">${employee.name}</h3>
          <span class="team-position">${employee.position}</span>
          <p class="team-bio">${not empty employee.bio ? employee.bio : 'Dedicated professional committed to making a difference in our community.'}</p>
          <div class="team-contact">
            <a href="mailto:${employee.email}" title="Email"><i class="fas fa-envelope"></i></a>
            <a href="#" title="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
            <a href="#" title="Profile"><i class="fas fa-user"></i></a>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<script>
  // Enhanced department filtering with debug
  document.querySelectorAll('.department-btn').forEach(btn => {
    btn.addEventListener('click', function() {
      console.log('Department filter clicked: ' + this.textContent);
      document.querySelector('.department-btn.active').classList.remove('active');
      this.classList.add('active');
    });
  });

  // Debug output
  console.log('Team page loaded');
  console.log('Number of employees: ${not empty employees ? employees.size() : '0'}');
</script>
</body>
</html>