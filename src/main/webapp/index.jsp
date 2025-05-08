<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welfair - Empowering Communities</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2c8a8a;
            --secondary: #f8b400;
            --tertiary: #6c5ce7;
            --quaternary: #e84393;
            --dark: #333;
            --light: #f9f9f9;
            --gray: #777;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: var(--light);
            color: var(--dark);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header Styles */
        header {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }

        nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
        }

        .logo span {
            color: var(--secondary);
        }

        .nav-links {
            display: flex;
            list-style: none;
        }

        .nav-links li {
            margin-left: 30px;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--dark);
            font-weight: 500;
            transition: color 0.3s;
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        /* Auth Buttons */
        .auth-btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: #1e6d6d;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: var(--secondary);
            color: white;
        }

        .btn-secondary:hover {
            background-color: #e0a500;
        }

        /* Hero Section */
        .hero {
            height: 100vh;
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            text-align: center;
            color: white;
            padding-top: 80px;
        }

        .hero-content {
            max-width: 800px;
            margin: 0 auto;
        }

        .hero h1 {
            font-size: 48px;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .hero p {
            font-size: 18px;
            margin-bottom: 30px;
        }

        /* Role Selection */
        .role-selection {
            margin-top: 30px;
        }

        .role-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .role-btn {
            padding: 12px 25px;
            border-radius: 5px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            color: white;
            min-width: 180px;
        }

        .btn-donor {
            background-color: var(--primary);
        }

        .btn-volunteer {
            background-color: var(--secondary);
        }

        .btn-employee {
            background-color: var(--tertiary);
        }

        .btn-admin {
            background-color: var(--quaternary);
        }

        .role-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .auth-options {
            display: none;
            background: rgba(255,255,255,0.9);
            padding: 20px;
            border-radius: 10px;
            margin: 0 auto;
            max-width: 400px;
            animation: fadeIn 0.3s ease;
        }

        .auth-options.show {
            display: block;
        }

        .auth-options h3 {
            color: var(--dark);
            margin-bottom: 15px;
            text-align: center;
        }

        .auth-btns {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .auth-option-btn {
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 14px;
            text-decoration: none;
            color: white;
            transition: all 0.3s;
        }

        .login-btn {
            background: var(--primary);
        }

        .register-btn {
            background: var(--secondary);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* About Section */
        .section {
            padding: 100px 0;
        }

        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-title h2 {
            font-size: 36px;
            color: var(--primary);
            position: relative;
            display: inline-block;
            padding-bottom: 15px;
        }

        .section-title h2::after {
            content: '';
            position: absolute;
            width: 50px;
            height: 3px;
            background-color: var(--secondary);
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
        }

        .about-content {
            display: flex;
            align-items: center;
            gap: 50px;
        }

        .about-text {
            flex: 1;
        }

        .about-image {
            flex: 1;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .about-image img {
            width: 100%;
            height: auto;
            display: block;
        }

        /* Mission Section */
        .mission {
            background-color: var(--primary);
            color: white;
        }

        .mission .section-title h2 {
            color: white;
        }

        .mission-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
        }

        .mission-card {
            background-color: white;
            color: var(--dark);
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .mission-card:hover {
            transform: translateY(-10px);
        }

        .mission-card i {
            font-size: 40px;
            color: var(--primary);
            margin-bottom: 20px;
        }

        .mission-card h3 {
            font-size: 22px;
            margin-bottom: 15px;
            color: var(--primary);
        }

        /* Impact Section */
        .impact-stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 30px;
            text-align: center;
        }

        .stat-item {
            padding: 30px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .stat-number {
            font-size: 48px;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 18px;
            color: var(--gray);
        }

        /* Events Section */
        .events {
            background-color: #f5f5f5;
        }

        .event-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
        }

        .event-card {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .event-image {
            height: 200px;
            overflow: hidden;
        }

        .event-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }

        .event-card:hover .event-image img {
            transform: scale(1.1);
        }

        .event-details {
            padding: 20px;
        }

        .event-date {
            display: inline-block;
            background-color: var(--secondary);
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .event-title {
            font-size: 20px;
            margin-bottom: 10px;
            color: var(--primary);
        }

        /* Contact Section */
        .contact-container {
            display: flex;
            gap: 50px;
        }

        .contact-info {
            flex: 1;
        }

        .contact-form {
            flex: 1;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .contact-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .contact-icon {
            font-size: 20px;
            color: var(--primary);
            margin-right: 15px;
            margin-top: 5px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        .form-group textarea {
            height: 150px;
            resize: vertical;
        }

        /* Footer */
        footer {
            background-color: var(--dark);
            color: white;
            padding: 50px 0 20px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        .footer-column h3 {
            font-size: 18px;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }

        .footer-column h3::after {
            content: '';
            position: absolute;
            width: 30px;
            height: 2px;
            background-color: var(--secondary);
            bottom: 0;
            left: 0;
        }

        .footer-column ul {
            list-style: none;
        }

        .footer-column ul li {
            margin-bottom: 10px;
        }

        .footer-column ul li a {
            color: #bbb;
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-column ul li a:hover {
            color: white;
        }

        .social-links {
            display: flex;
            gap: 15px;
        }

        .social-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background-color: rgba(255,255,255,0.1);
            border-radius: 50%;
            color: white;
            transition: all 0.3s;
        }

        .social-links a:hover {
            background-color: var(--secondary);
            transform: translateY(-3px);
        }

        .copyright {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
            color: #bbb;
            font-size: 14px;
        }

        /* Success Message */
        .success-message-container {
            position: fixed;
            top: 80px;
            left: 0;
            right: 0;
            z-index: 1000;
            text-align: center;
        }

        .success-message {
            display: inline-block;
            padding: 15px 30px;
            background: #4CAF50;
            color: white;
            border-radius: 5px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            animation: slideDown 0.5s ease;
        }

        @keyframes slideDown {
            from { transform: translateY(-100%); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }

            .hero h1 {
                font-size: 36px;
            }

            .about-content {
                flex-direction: column;
            }

            .impact-stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .contact-container {
                flex-direction: column;
            }

            .role-buttons {
                flex-direction: column;
                align-items: center;
            }

            .role-btn {
                width: 100%;
                max-width: 250px;
            }

            .auth-btns {
                flex-direction: column;
            }

            .auth-option-btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<!-- Success Message -->
<div class="success-message-container">
    <c:if test="${not empty param.registerSuccess}">
        <div class="success-message">
            Registration successful! Please login using your credentials.
        </div>
    </c:if>
</div>

<!-- Header -->
<header>
    <div class="container">
        <nav>
            <a href="index.jsp" class="logo">Welf<span>air</span></a>
            <ul class="nav-links">
                <li><a href="#home">Home</a></li>
                <li><a href="#about">About Us</a></li>
                <li><a href="#mission">Vision & Mission</a></li>
                <li><a href="#impact">Impact Stories</a></li>
                <li><a href="#events">Upcoming Events</a></li>
                <li><a href="#contact">Contact Us</a></li>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li><a href="${pageContext.request.contextPath}/dashboard.jsp" class="auth-btn btn-primary">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/logout" class="auth-btn btn-secondary">Logout</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="#" class="auth-btn btn-primary" onclick="showAuthOptionsForRole(localStorage.getItem('selectedRole') || 'donor')">Login/Register</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>
    </div>
</header>

<!-- Hero Section -->
<section class="hero" id="home">
    <div class="container">
        <div class="hero-content">
            <h1>Empowering Communities, Transforming Lives</h1>
            <p>Welfair is dedicated to creating sustainable change through education, healthcare, and community development initiatives.</p>

            <div class="role-selection">
                <div class="role-buttons">
                    <button class="role-btn btn-donor" onclick="showAuthOptionsForRole('donor')">Donor</button>
                    <button class="role-btn btn-volunteer" onclick="showAuthOptionsForRole('volunteer')">Volunteer</button>
                    <button class="role-btn btn-employee" onclick="showAuthOptionsForRole('employee')">Employee</button>
                    <button class="role-btn btn-admin" onclick="showAuthOptionsForRole('admin')">Admin</button>
                </div>

                <div id="authOptions" class="auth-options">
                    <h3 id="authRoleTitle">Select Option</h3>
                    <div class="auth-btns">
                        <a id="loginBtn" href="#" class="auth-option-btn login-btn">Login</a>
                        <a id="registerBtn" href="#" class="auth-option-btn register-btn">Register</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- About Section -->
<section class="section" id="about">
    <div class="container">
        <div class="section-title">
            <h2>About Us</h2>
        </div>
        <div class="about-content">
            <div class="about-text">
                <h3>Our Story</h3>
                <p>Founded in 2010, Welfair has been at the forefront of social change, working tirelessly to uplift underprivileged communities across the region. What began as a small group of passionate individuals has now grown into a movement of thousands.</p>
                <p>We believe in the power of collective action and sustainable solutions. Our approach combines immediate relief with long-term development programs to create lasting impact.</p>
                <a href="about.jsp" class="auth-btn btn-primary">Learn More</a>
            </div>
            <div class="about-image">
                <img src="https://images.unsplash.com/photo-1521791136064-7986c2920216?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80" alt="Welfair Team">
            </div>
        </div>
    </div>
</section>

<!-- Mission Section -->
<section class="section mission" id="mission">
    <div class="container">
        <div class="section-title">
            <h2>Our Vision & Mission</h2>
        </div>
        <div class="mission-cards">
            <div class="mission-card">
                <i class="fas fa-eye"></i>
                <h3>Our Vision</h3>
                <p>A world where every individual has equal opportunities to thrive, regardless of their background or circumstances.</p>
            </div>
            <div class="mission-card">
                <i class="fas fa-bullseye"></i>
                <h3>Our Mission</h3>
                <p>To empower marginalized communities through education, healthcare, and sustainable development programs.</p>
            </div>
            <div class="mission-card">
                <i class="fas fa-hand-holding-heart"></i>
                <h3>Our Values</h3>
                <p>Compassion, Integrity, Accountability, and Innovation guide everything we do at Welfair.</p>
            </div>
        </div>
    </div>
</section>

<!-- Impact Section -->
<section class="section" id="impact">
    <div class="container">
        <div class="section-title">
            <h2>Our Impact</h2>
        </div>
        <div class="impact-stats">
            <div class="stat-item">
                <div class="stat-number">15,000+</div>
                <div class="stat-label">Lives Impacted</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">200+</div>
                <div class="stat-label">Communities Served</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">50+</div>
                <div class="stat-label">Development Projects</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">500+</div>
                <div class="stat-label">Dedicated Volunteers</div>
            </div>
        </div>
        <div style="text-align: center; margin-top: 50px;">
            <a href="impact.jsp" class="auth-btn btn-primary">Read Impact Stories</a>
        </div>
    </div>
</section>

<!-- Events Section -->
<section class="section events" id="events">
    <div class="container">
        <div class="section-title">
            <h2>Upcoming Events</h2>
        </div>
        <div class="event-cards">
            <c:forEach items="${events}" var="event" end="2">
                <div class="event-card">
                    <div class="event-image">
                        <img src="${event.imageUrl}" alt="${event.title}">
                    </div>
                    <div class="event-details">
                        <span class="event-date"><fmt:formatDate value="${event.date}" pattern="MMMM d, yyyy" /></span>
                        <h3 class="event-title">${event.title}</h3>
                        <p>${event.shortDescription}</p>
                        <a href="event-details.jsp?id=${event.id}" class="auth-btn btn-primary" style="margin-top: 15px; display: inline-block;">Learn More</a>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div style="text-align: center; margin-top: 50px;">
            <a href="events.jsp" class="auth-btn btn-primary">View All Events</a>
        </div>
    </div>
</section>

<!-- Contact Section -->
<section class="section" id="contact">
    <div class="container">
        <div class="section-title">
            <h2>Contact Us</h2>
        </div>
        <div class="contact-container">
            <div class="contact-info">
                <h3>Get in Touch</h3>
                <p>We'd love to hear from you! Reach out for partnerships, volunteer opportunities, or any questions.</p>

                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fas fa-map-marker-alt"></i>
                    </div>
                    <div>
                        <h4>Address</h4>
                        <p>123 Social Change Avenue, Cityville, Country</p>
                    </div>
                </div>

                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fas fa-phone-alt"></i>
                    </div>
                    <div>
                        <h4>Phone</h4>
                        <p>+1 (555) 123-4567</p>
                    </div>
                </div>

                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div>
                        <h4>Email</h4>
                        <p>info@welfair.org</p>
                    </div>
                </div>

                <div class="social-links" style="margin-top: 30px;">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            <div class="contact-form">
                <form action="contact" method="post">
                    <div class="form-group">
                        <label for="name">Your Name</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <input type="text" id="subject" name="subject" required>
                    </div>
                    <div class="form-group">
                        <label for="message">Message</label>
                        <textarea id="message" name="message" required></textarea>
                    </div>
                    <button type="submit" class="auth-btn btn-primary">Send Message</button>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer>
    <div class="container">
        <div class="footer-content">
            <div class="footer-column">
                <h3>About Welfair</h3>
                <p>Empowering communities through sustainable development initiatives since 2010.</p>
            </div>
            <div class="footer-column">
                <h3>Quick Links</h3>
                <ul>
                    <li><a href="#home">Home</a></li>
                    <li><a href="#about">About Us</a></li>
                    <li><a href="#mission">Our Mission</a></li>
                    <li><a href="#impact">Impact Stories</a></li>
                    <li><a href="#events">Events</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h3>Get Involved</h3>
                <ul>
                    <li><a href="#" onclick="showAuthOptionsForRole('donor')">Donate</a></li>
                    <li><a href="#" onclick="showAuthOptionsForRole('volunteer')">Volunteer</a></li>
                    <li><a href="#" onclick="showAuthOptionsForRole('employee')">Careers</a></li>
                    <li><a href="partnerships.jsp">Partnerships</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h3>Contact</h3>
                <ul>
                    <li><a href="mailto:info@welfair.org">info@welfair.org</a></li>
                    <li><a href="tel:+15551234567">+1 (555) 123-4567</a></li>
                </ul>
                <div class="social-links" style="margin-top: 15px;">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>
        <div class="copyright">
            <p>&copy; 2023 Welfair. All Rights Reserved. | <a href="privacy.jsp" style="color: #bbb;">Privacy Policy</a> | <a href="terms.jsp" style="color: #bbb;">Terms of Service</a></p>
        </div>
    </div>
</footer>

<script>
    // Role selection functionality
    function showAuthOptionsForRole(role) {
        event.preventDefault();
        currentRole = role;

        // Store the selected role in localStorage
        localStorage.setItem('selectedRole', role);

        // Update the auth options title
        document.getElementById('authRoleTitle').textContent = role.charAt(0).toUpperCase() + role.slice(1) + ' Options';

        // Update the login and register links with context path and role parameter
        const contextPath = '${pageContext.request.contextPath}';
        document.getElementById('loginBtn').setAttribute('href', contextPath + '/login.jsp?role=' + role);
        document.getElementById('registerBtn').setAttribute('href', contextPath + '/register.jsp?role=' + role);

        // Show the auth options
        document.getElementById('authOptions').classList.add('show');
    }

    // Initialize with context path
    document.addEventListener('DOMContentLoaded', function() {
        const contextPath = '${pageContext.request.contextPath}';
        const storedRole = localStorage.getItem('selectedRole') || 'donor';

        // Set default links with stored role
        document.getElementById('loginBtn').setAttribute('href', contextPath + '/login.jsp?role=' + storedRole);
        document.getElementById('registerBtn').setAttribute('href', contextPath + '/register.jsp?role=' + storedRole);

        // Update the title if we have a stored role
        if (storedRole) {
            document.getElementById('authRoleTitle').textContent =
                storedRole.charAt(0).toUpperCase() + storedRole.slice(1) + ' Options';
        }
    });

    // Make sure the login/register buttons work when clicked
    document.getElementById('loginBtn').addEventListener('click', function(e) {
        window.location.href = this.getAttribute('href');
    });

    document.getElementById('registerBtn').addEventListener('click', function(e) {
        window.location.href = this.getAttribute('href');
    });

    // Close auth options when clicking outside
    document.addEventListener('click', function(event) {
        const authOptions = document.getElementById('authOptions');
        if (!event.target.closest('.role-selection') && authOptions.classList.contains('show')) {
            authOptions.classList.remove('show');
        }
    });

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;

            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80,
                    behavior: 'smooth'
                });
            }
        });
    });
</script>
    // Role selection functionality

</body>
</html>