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
    employeeDAO.setConnection(employeeDAO.getActiveConnection());
    employees = employeeDAO.getAllEmployees();
    request.setAttribute("employees", employees);
  } catch (SQLException e) {
    error = "Database error: " + e.getMessage();
    request.setAttribute("error", error);

    // Create test data
    Employee testEmp1 = new Employee();
    testEmp1.setEmpId(1);
    testEmp1.setName("John Doe");
    testEmp1.setPosition("Project Manager");
    testEmp1.setEmail("john@welfair.org");
    testEmp1.setBio("10+ years experience in social project management");

    Employee testEmp2 = new Employee();
    testEmp2.setEmpId(2);
    testEmp2.setName("Sarah Wilson");
    testEmp2.setPosition("Field Coordinator");
    testEmp2.setEmail("sarah@welfair.org");
    testEmp2.setBio("Passionate about community development initiatives");

    employees = List.of(testEmp1, testEmp2);
    request.setAttribute("employees", employees);
    request.setAttribute("warning", "Showing sample data due to temporary system issues");
  }
%>

<!DOCTYPE html>
<html>
<head>
  <title>Our Team | Welfair</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
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
      padding: 5rem 1rem;
      text-align: center;
      position: relative;
      overflow: hidden;
    }

    .team-hero h1 {
      font-size: 2.8rem;
      margin-bottom: 1.2rem;
      font-weight: 700;
      letter-spacing: -0.5px;
    }

    .team-hero p {
      font-size: 1.1rem;
      opacity: 0.9;
      max-width: 600px;
      margin: 0 auto;
      line-height: 1.7;
    }

    .team-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 4rem 1rem;
    }

    .team-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 2rem;
      margin-top: 3rem;
    }

    .team-card {
      background: var(--light);
      border-radius: 1rem;
      overflow: hidden;
      box-shadow: var(--card-shadow);
      transition: var(--transition);
    }

    .team-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
    }

    .team-photo {
      height: 260px;
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
      transform: scale(1.03);
    }

    .team-info {
      padding: 1.8rem;
      text-align: center;
    }

    .team-name {
      font-size: 1.3rem;
      font-weight: 600;
      margin-bottom: 0.5rem;
      color: var(--dark);
    }

    .team-position {
      color: var(--primary);
      font-weight: 500;
      font-size: 0.95rem;
      margin-bottom: 1.2rem;
      display: block;
    }

    .team-bio {
      color: var(--text-light);
      font-size: 0.9rem;
      margin-bottom: 1.5rem;
      line-height: 1.6;
      display: -webkit-box;
      -webkit-line-clamp: 3;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .team-contact {
      display: flex;
      justify-content: center;
      gap: 1rem;
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
      transform: translateY(-2px);
    }

    .section-title {
      text-align: center;
      margin-bottom: 3rem;
    }

    .section-title h2 {
      font-size: 2rem;
      color: var(--dark);
      position: relative;
      display: inline-block;
    }

    .section-title h2::after {
      content: '';
      position: absolute;
      bottom: -0.8rem;
      left: 50%;
      transform: translateX(-50%);
      width: 50px;
      height: 3px;
      background: var(--primary);
    }

    @media (max-width: 768px) {
      .team-hero {
        padding: 3rem 1rem;
      }

      .team-hero h1 {
        font-size: 2.2rem;
      }

      .team-hero p {
        font-size: 1rem;
      }

      .team-grid {
        grid-template-columns: 1fr;
        max-width: 400px;
        margin: 2rem auto;
      }
    }

    .system-notice {
      background: #fff9e6;
      color: #856404;
      padding: 1rem;
      border-radius: 4px;
      margin: 1rem auto;
      max-width: 800px;
      text-align: center;
      border-left: 4px solid #ffd700;
    }
  </style>
</head>
<body>
<section class="team-hero">
  <h1>Our Exceptional Team</h1>
  <p>Meet the dedicated professionals driving positive change through innovation and compassion</p>
</section>

<c:if test="${not empty warning}">
  <div class="system-notice">
    ⚠️ ${warning}
  </div>
</c:if>

<div class="team-container">
  <div class="section-title">
    <h2>Team Members</h2>
  </div>

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
          <p class="team-bio">${not empty employee.bio ? employee.bio : 'Committed to excellence in social welfare and community development.'}</p>
          <div class="team-contact">
            <a href="mailto:${employee.email}" title="Email">
              <i class="fas fa-envelope"></i>
            </a>
            <a href="#" title="LinkedIn">
              <i class="fab fa-linkedin-in"></i>
            </a>
            <a href="#" title="Profile">
              <i class="fas fa-user"></i>
            </a>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<script>
  // Add smooth hover effects
  document.querySelectorAll('.team-card').forEach(card => {
    card.addEventListener('mouseenter', () => {
      card.style.transition = 'transform 0.3s ease, box-shadow 0.3s ease';
    });
  });

  // Handle system notices
  const notice = document.querySelector('.system-notice');
  if (notice) {
    setTimeout(() => {
      notice.style.opacity = '0.9';
      notice.style.transition = 'opacity 0.3s ease';
    }, 5000);
  }
</script>
</body>
</html>