<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>About Welfair - Our Impact</title>
  <style>
    /* Add to your existing CSS */
    .about-details {
      padding: 60px 0;
      background: #f9f9f9;
    }
    .tab-container {
      display: flex;
      margin-bottom: 30px;
      border-bottom: 1px solid #ddd;
    }
    .tab-btn {
      padding: 12px 24px;
      background: none;
      border: none;
      cursor: pointer;
      font-weight: 500;
      color: #777;
      position: relative;
    }
    .tab-btn.active {
      color: #2c8a8a;
    }
    .tab-btn.active::after {
      content: '';
      position: absolute;
      bottom: -1px;
      left: 0;
      right: 0;
      height: 3px;
      background: #2c8a8a;
    }
    .tab-content {
      display: none;
      animation: fadeIn 0.5s;
    }
    .tab-content.active {
      display: block;
    }
    .team-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 30px;
    }
    .team-card {
      background: white;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 3px 10px rgba(0,0,0,0.1);
      transition: transform 0.3s;
    }
    .team-card:hover {
      transform: translateY(-5px);
    }
    .team-photo {
      height: 200px;
      background: #eee;
      overflow: hidden;
    }
    .team-photo img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .team-info {
      padding: 20px;
    }
    .timeline {
      position: relative;
      max-width: 1200px;
      margin: 0 auto;
    }
    .timeline::after {
      content: '';
      position: absolute;
      width: 6px;
      background: #2c8a8a;
      top: 0;
      bottom: 0;
      left: 50%;
      margin-left: -3px;
    }
    .timeline-item {
      padding: 10px 40px;
      position: relative;
      width: 50%;
      box-sizing: border-box;
    }
    .timeline-item::after {
      content: '';
      position: absolute;
      width: 25px;
      height: 25px;
      background: #f8b400;
      border: 4px solid #2c8a8a;
      border-radius: 50%;
      top: 15px;
      z-index: 1;
    }
    .left {
      left: 0;
    }
    .right {
      left: 50%;
    }
    .right::after {
      left: -12px;
    }
    .left::after {
      right: -12px;
    }
    .timeline-content {
      padding: 20px;
      background: white;
      border-radius: 8px;
      box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    }
    .partner-logos {
      display: flex;
      flex-wrap: wrap;
      gap: 30px;
      justify-content: center;
      align-items: center;
    }
    .partner-logo {
      height: 80px;
      filter: grayscale(100%);
      opacity: 0.7;
      transition: all 0.3s;
    }
    .partner-logo:hover {
      filter: grayscale(0);
      opacity: 1;
    }
    .stats-highlight {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
      margin: 30px 0;
    }
    .stat-box {
      background: white;
      padding: 30px;
      border-radius: 8px;
      text-align: center;
      box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    }
    .stat-number {
      font-size: 2.5rem;
      color: #2c8a8a;
      font-weight: 700;
      margin-bottom: 10px;
    }
    .finance-table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
    }
    .finance-table th, .finance-table td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    .finance-table th {
      background: #2c8a8a;
      color: white;
    }
    .finance-table tr:hover {
      background: #f5f5f5;
    }
  </style>
</head>
<body>

<div class="about-details">
  <div class="container">
    <h2>Our Impact in Detail</h2>

    <!-- Tab Navigation -->
    <div class="tab-container">
      <button class="tab-btn active" onclick="openTab('team')">Our Team</button>
      <button class="tab-btn" onclick="openTab('projects')">Projects</button>
      <button class="tab-btn" onclick="openTab('impact')">Impact Stats</button>
      <button class="tab-btn" onclick="openTab('stories')">Success Stories</button>
      <button class="tab-btn" onclick="openTab('finance')">Financials</button>
      <button class="tab-btn" onclick="openTab('partners')">Partners</button>
      <button class="tab-btn" onclick="openTab('volunteers')">Volunteers</button>
    </div>

    <!-- Team Tab -->
    <div id="team" class="tab-content active">
      <h3>Meet Our Team</h3>
      <div class="team-grid" id="teamContainer">
        <!-- Filled by JavaScript -->
      </div>
    </div>

    <!-- Projects Tab -->
    <div id="projects" class="tab-content">
      <h3>Our Project Timeline</h3>
      <div class="timeline" id="timelineContainer">
        <!-- Filled by JavaScript -->
      </div>
    </div>

    <!-- Impact Stats Tab -->
    <div id="impact" class="tab-content">
      <h3>By The Numbers</h3>
      <div class="stats-highlight">
        <div class="stat-box">
          <div class="stat-number" id="totalBeneficiaries">0</div>
          <div class="stat-label">Lives Impacted</div>
        </div>
        <div class="stat-box">
          <div class="stat-number" id="totalProjects">0</div>
          <div class="stat-label">Projects Completed</div>
        </div>
        <div class="stat-box">
          <div class="stat-number" id="totalFunds">$0</div>
          <div class="stat-label">Funds Raised</div>
        </div>
      </div>
      <canvas id="impactChart" height="100"></canvas>
    </div>

    <!-- Success Stories Tab -->
    <div id="stories" class="tab-content">
      <h3>Transformation Stories</h3>
      <div class="story-carousel" id="storiesCarousel">
        <!-- Filled by JavaScript -->
      </div>
    </div>

    <!-- Financials Tab -->
    <div id="finance" class="tab-content">
      <h3>Financial Transparency</h3>
      <h4>Recent Donations</h4>
      <table class="finance-table" id="donationsTable">
        <thead>
        <tr>
          <th>Donor</th>
          <th>Amount</th>
          <th>Project</th>
          <th>Date</th>
        </tr>
        </thead>
        <tbody>
        <!-- Filled by JavaScript -->
        </tbody>
      </table>
      <h4>Fund Allocation</h4>
      <canvas id="financeChart" height="100"></canvas>
    </div>

    <!-- Partners Tab -->
    <div id="partners" class="tab-content">
      <h3>Our Valued Partners</h3>
      <div class="partner-logos" id="partnerLogos">
        <!-- Filled by JavaScript -->
      </div>
    </div>

    <!-- Volunteers Tab -->
    <div id="volunteers" class="tab-content">
      <h3>Volunteer Spotlight</h3>
      <div class="team-grid" id="volunteersContainer">
        <!-- Filled by JavaScript -->
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
  // Tab functionality
  function openTab(tabId) {
    document.querySelectorAll('.tab-content').forEach(tab => {
      tab.classList.remove('active');
    });
    document.querySelectorAll('.tab-btn').forEach(btn => {
      btn.classList.remove('active');
    });
    document.getElementById(tabId).classList.add('active');
    event.currentTarget.classList.add('active');

    // Load data when tab is opened
    if(tabId === 'team' && !teamLoaded) loadTeam();
    if(tabId === 'projects' && !projectsLoaded) loadProjects();
    // Add similar checks for other tabs
  }

  // Track loaded states
  let teamLoaded = false, projectsLoaded = false, impactLoaded = false;

  // Load Team Data
  function loadTeam() {
    fetch('/api/about?type=team')
            .then(res => res.json())
            .then(team => {
              const container = document.getElementById('teamContainer');
              container.innerHTML = team.map(member => `
                <div class="team-card">
                    <div class="team-photo">
                        <img src="/images/team/${member.id}.jpg" alt="${member.name}">
                    </div>
                    <div class="team-info">
                        <h4>${member.name}</h4>
                        <p class="position">${member.position}</p>
                        <p class="bio">${member.bio || 'Dedicated to making a difference'}</p>
                        <p class="email">${member.email}</p>
                    </div>
                </div>
            `).join('');
              teamLoaded = true;
            });
  }

  // Load Projects Timeline
  function loadProjects() {
    fetch('/api/about?type=projects')
            .then(res => res.json())
            .then(projects => {
              const container = document.getElementById('timelineContainer');
              container.innerHTML = projects.map((project, index) => `
                <div class="timeline-item ${index % 2 == 0 ? 'left' : 'right'}">
                    <div class="timeline-content">
                        <h4>${project.name}</h4>
                        <p><strong>Status:</strong> ${project.status}</p>
                        <p>${project.start_date} to ${project.end_date}</p>
                        <p>${project.description || 'Making a positive impact'}</p>
                    </div>
                </div>
            `).join('');
              projectsLoaded = true;
            });
  }

  // Load Impact Stats
  function loadImpactStats() {
    fetch('/api/about?type=impact')
            .then(res => res.json())
            .then(data => {
              document.getElementById('totalBeneficiaries').textContent = data.beneficiaries_served;
              document.getElementById('totalProjects').textContent = data.projects_completed;
              document.getElementById('totalFunds').textContent = `$${data.total_funds_raised.toLocaleString()}`;

              // Impact Chart
              new Chart(document.getElementById('impactChart'), {
                type: 'bar',
                data: {
                  labels: ['Beneficiaries', 'Projects', 'Funds Raised'],
                  datasets: [{
                    label: 'Our Impact',
                    data: [data.beneficiaries_served, data.projects_completed, data.total_funds_raised/1000],
                    backgroundColor: ['#2c8a8a', '#f8b400', '#6c5ce7']
                  }]
                },
                options: {
                  scales: {
                    y: {
                      beginAtZero: true
                    }
                  }
                }
              });
            });
  }

  // Initialize first tab
  window.addEventListener('DOMContentLoaded', () => {
    loadTeam();
    loadImpactStats();
  });
</script>
</body>
</html>