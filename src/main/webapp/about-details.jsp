<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>About Welfair - Our Impact</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root {
      --primary: #2c8a8a;
      --secondary: #f8b400;
      --accent: #6c5ce7;
      --dark: #2d3436;
      --light: #f9f9f9;
      --text: #333333;
      --paper: #f5f5f5;
      --gold: #d4af37;
    }

    body {
      font-family: 'Georgia', serif;
      background-color: var(--paper);
      color: var(--text);
      margin: 0;
      padding: 0;
    }

    .about-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 40px 20px;
    }

    .page-header {
      text-align: center;
      margin-bottom: 50px;
      position: relative;
    }

    .page-header h1 {
      font-size: 3rem;
      color: var(--dark);
      margin-bottom: 20px;
      font-weight: 700;
      letter-spacing: 1px;
    }

    .page-header::after {
      content: '';
      display: block;
      width: 100px;
      height: 4px;
      background: linear-gradient(90deg, var(--primary), var(--secondary));
      margin: 20px auto;
    }

    .nav-tabs {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      gap: 20px;
      margin-bottom: 60px;
    }

    .nav-tab {
      position: relative;
      padding: 18px 30px;
      background: white;
      border: none;
      border-radius: 8px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      font-size: 1.1rem;
      font-weight: 600;
      color: var(--dark);
      cursor: pointer;
      transition: all 0.3s ease;
      min-width: 200px;
      text-align: center;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .nav-tab:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 20px rgba(0,0,0,0.15);
    }

    .nav-tab i {
      font-size: 1.8rem;
      margin-bottom: 10px;
      color: var(--primary);
    }

    .nav-tab::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      border: 2px solid var(--gold);
      border-radius: 8px;
      opacity: 0;
      transition: all 0.3s ease;
    }

    .nav-tab:hover::before {
      opacity: 1;
      transform: scale(1.05);
    }

    .nav-tab:nth-child(1) { background: linear-gradient(135deg, #f5f7fa 0%, #e4e8ed 100%); }
    .nav-tab:nth-child(2) { background: linear-gradient(135deg, #fdfcfb 0%, #e9e5e1 100%); }
    .nav-tab:nth-child(3) { background: linear-gradient(135deg, #f3f9fb 0%, #d8e9ec 100%); }
    .nav-tab:nth-child(4) { background: linear-gradient(135deg, #fef9f8 0%, #ece0dd 100%); }
    .nav-tab:nth-child(5) { background: linear-gradient(135deg, #f8f9fa 0%, #e2e6ea 100%); }
    .nav-tab:nth-child(6) { background: linear-gradient(135deg, #f5fbf8 0%, #ddebe4 100%); }
    .nav-tab:nth-child(7) { background: linear-gradient(135deg, #f9f8fe 0%, #e5e2f0 100%); }

    .nav-tab:nth-child(1) i { color: #2c8a8a; }
    .nav-tab:nth-child(2) i { color: #e17055; }
    .nav-tab:nth-child(3) i { color: #00b894; }
    .nav-tab:nth-child(4) i { color: #d63031; }
    .nav-tab:nth-child(5) i { color: #0984e3; }
    .nav-tab:nth-child(6) i { color: #00cec9; }
    .nav-tab:nth-child(7) i { color: #6c5ce7; }

    .nav-tab:hover i {
      animation: bounce 0.5s;
    }

    @keyframes bounce {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-5px); }
    }

    .ornament {
      position: absolute;
      width: 150px;
      height: 150px;
      opacity: 0.1;
      z-index: -1;
    }

    .ornament-1 {
      top: 50px;
      left: 50px;
      background: radial-gradient(circle, var(--primary) 0%, transparent 70%);
    }

    .ornament-2 {
      bottom: 30px;
      right: 50px;
      background: radial-gradient(circle, var(--secondary) 0%, transparent 70%);
    }

    .footer-note {
      text-align: center;
      margin-top: 80px;
      font-style: italic;
      color: var(--dark);
      position: relative;
    }

    .footer-note::before, .footer-note::after {
      content: "❧";
      color: var(--gold);
      padding: 0 15px;
      font-size: 1.2rem;
    }

    @media (max-width: 768px) {
      .nav-tabs {
        flex-direction: column;
        align-items: center;
      }

      .nav-tab {
        width: 80%;
      }

      .page-header h1 {
        font-size: 2.2rem;
      }
    }
  </style>
</head>
<body>
<div class="about-container">
  <div class="ornament ornament-1"></div>
  <div class="ornament ornament-2"></div>

  <div class="page-header">
    <h1>Discover Welfair's Impact</h1>
    <p>Explore our organization's journey, achievements, and the dedicated people behind our mission</p>
  </div>

  <div class="nav-tabs">
    <a href="team.jsp" class="nav-tab">
      <i class="fas fa-users"></i>
      Our Team
    </a>

    <a href="projects.jsp" class="nav-tab">
      <i class="fas fa-project-diagram"></i>
      Our Projects
    </a>


    <a href="finance.jsp" class="nav-tab">
      <i class="fas fa-file-invoice-dollar"></i>
      Financial Transparency
    </a>

    <a href="founders.jsp" class="nav-tab">
      <i class="fas fa-user-tie"></i>
      From Founders' Desk
    </a>

    <a href="volunteerspotlight.jsp" class="nav-tab">
      <i class="fas fa-hands-helping"></i>
      Volunteer Spotlight
    </a>
  </div>

  <div class="footer-note">
    Together, we're building a better tomorrow through compassion and action
  </div>
</div>
</body>
</html>