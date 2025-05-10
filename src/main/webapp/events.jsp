<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upcoming Events | Welfair</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            /* Color Variables */
            --primary: #2c8a8a;
            --primary-light: #3da8a8; /* Added lighter variant */
            --primary-dark: #1e6d6d;
            --secondary: #f8b400;
            --secondary-light: #ffc730;
            --secondary-dark: #e0a500;
            --tertiary: #6c5ce7;
            --quaternary: #e84393;
            --dark: #333;
            --light: #f9f9f9;
            --gray: #777;
            --light-gray: #eaeaea;
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

        /* Button Styles */
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
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: var(--secondary);
            color: white;
        }

        .btn-secondary:hover {
            background-color: var(--secondary-dark);
        }

        /* Events Page Specific Styles */
        .events-header {
            background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)),
            url('https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 150px 0 80px; /* Increased top padding to account for fixed header */
            text-align: center;
            margin-bottom: 60px;
        }

        .events-header h1 {
            font-size: 42px;
            margin-bottom: 20px;
        }

        .events-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px 60px;
        }

        .events-filter {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .filter-group {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 8px 16px;
            border-radius: 5px;
            background: white;
            border: 1px solid var(--light-gray);
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

        .filter-btn.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .filter-btn:hover {
            background: var(--primary-light);
            color: white;
        }

        .search-box {
            position: relative;
            flex-grow: 1;
            max-width: 300px;
        }

        .search-box input {
            width: 100%;
            padding: 10px 15px 10px 40px;
            border: 1px solid var(--light-gray);
            border-radius: 5px;
            font-size: 14px;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
        }

        .event-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }

        .event-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
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
            background: var(--secondary);
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 14px;
            margin-bottom: 10px;
            font-weight: 500;
        }

        .event-title {
            font-size: 20px;
            margin-bottom: 10px;
            color: var(--primary);
        }

        .event-description {
            margin-bottom: 15px;
            color: var(--gray);
            font-size: 15px;
        }

        .event-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            font-size: 14px;
            color: var(--gray);
        }

        .event-location {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 40px;
        }

        .pagination-btn {
            padding: 8px 15px;
            border: 1px solid var(--light-gray);
            border-radius: 5px;
            background: white;
            cursor: pointer;
            transition: all 0.3s;
        }

        .pagination-btn.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .pagination-btn:hover:not(.active) {
            background: var(--light-gray);
        }

        .no-events {
            text-align: center;
            padding: 50px;
            grid-column: 1 / -1;
        }

        .no-events h3 {
            color: var(--primary);
            margin-bottom: 15px;
        }

        /* Footer Styles */
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

        .copyright {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
            color: #bbb;
            font-size: 14px;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }

            .events-header {
                padding: 120px 0 60px;
            }

            .events-header h1 {
                font-size: 36px;
            }

            .events-filter {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-group {
                justify-content: center;
            }

            .search-box {
                max-width: 100%;
            }

            .event-cards {
                grid-template-columns: 1fr;
            }

            .event-card {
                max-width: 100%;
            }
        }

        @media (max-width: 480px) {
            .events-header {
                padding: 100px 0 40px;
            }

            .events-header h1 {
                font-size: 28px;
            }

            .filter-group {
                flex-direction: column;
            }

            .filter-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<!-- Header (same as index.jsp) -->
<header>
    <div class="container">
        <nav>
            <a href="index.jsp" class="logo">Welf<span>air</span></a>
            <ul class="nav-links">
                <li><a href="index.jsp#home">Home</a></li>
                <li><a href="index.jsp#about">About Us</a></li>
                <li><a href="index.jsp#mission">Vision & Mission</a></li>
                <li><a href="index.jsp#impact">Impact Stories</a></li>
                <li><a href="events.jsp">Upcoming Events</a></li>
                <li><a href="index.jsp#contact">Contact Us</a></li>
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

<!-- Events Header -->
<div class="events-header">
    <h1>Upcoming Events</h1>
    <p>Join us in making a difference through our community events</p>
</div>

<!-- Events Container -->
<div class="events-container">
    <!-- Events Filter -->
    <div class="events-filter">
        <div class="filter-group">
            <button class="filter-btn active" data-filter="all">All Events</button>
            <button class="filter-btn" data-filter="upcoming">Upcoming</button>
            <button class="filter-btn" data-filter="past">Past Events</button>
            <button class="filter-btn" data-filter="volunteer">Volunteer Opportunities</button>
            <button class="filter-btn" data-filter="fundraiser">Fundraisers</button>
        </div>
        <div class="search-box">
            <i class="fas fa-search"></i>
            <input type="text" id="eventSearch" placeholder="Search events...">
        </div>
    </div>

    <!-- Event Cards -->
    <div class="event-cards">
        <c:choose>
            <c:when test="${not empty events}">
                <c:forEach items="${events}" var="event">
                    <div class="event-card" data-category="${event.category}" data-date="${event.date}">
                        <div class="event-image">
                            <img src="${event.imageUrl}" alt="${event.title}">
                        </div>
                        <div class="event-details">
                                <span class="event-date">
                                    <fmt:formatDate value="${event.date}" pattern="MMMM d, yyyy" />
                                </span>
                            <h3 class="event-title">${event.title}</h3>
                            <p class="event-description">${event.shortDescription}</p>
                            <div class="event-meta">
                                    <span class="event-location">
                                        <i class="fas fa-map-marker-alt"></i> ${event.location}
                                    </span>
                                <span class="event-time">
                                        <i class="far fa-clock"></i> ${event.time}
                                    </span>
                            </div>
                            <a href="event-details.jsp?id=${event.id}" class="auth-btn btn-primary" style="margin-top: 15px; display: inline-block;">View Details</a>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="no-events">
                    <h3>No events currently scheduled</h3>
                    <p>Check back later or subscribe to our newsletter to stay updated</p>
                    <a href="index.jsp#contact" class="auth-btn btn-primary">Contact Us</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pagination -->
    <div class="pagination">
        <button class="pagination-btn"><i class="fas fa-chevron-left"></i></button>
        <button class="pagination-btn active">1</button>
        <button class="pagination-btn">2</button>
        <button class="pagination-btn">3</button>
        <button class="pagination-btn"><i class="fas fa-chevron-right"></i></button>
    </div>
</div>

<!-- Footer (same as index.jsp) -->
<footer>
    <!-- Your existing footer content -->
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
    // Filter functionality
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            const filter = this.dataset.filter;
            filterEvents(filter);
        });
    });

    // Search functionality
    document.getElementById('eventSearch').addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        const eventCards = document.querySelectorAll('.event-card');

        eventCards.forEach(card => {
            const title = card.querySelector('.event-title').textContent.toLowerCase();
            const description = card.querySelector('.event-description').textContent.toLowerCase();

            if (title.includes(searchTerm) || description.includes(searchTerm)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    });

    // Filter events by category
    function filterEvents(filter) {
        const eventCards = document.querySelectorAll('.event-card');
        const currentDate = new Date();

        eventCards.forEach(card => {
            const eventDate = new Date(card.dataset.date);
            const category = card.dataset.category;

            let showCard = true;

            switch(filter) {
                case 'upcoming':
                    showCard = eventDate >= currentDate;
                    break;
                case 'past':
                    showCard = eventDate < currentDate;
                    break;
                case 'volunteer':
                    showCard = category === 'volunteer';
                    break;
                case 'fundraiser':
                    showCard = category === 'fundraiser';
                    break;
                // 'all' shows all cards
            }

            card.style.display = showCard ? 'block' : 'none';
        });
    }

    // Pagination functionality (would need server-side implementation)
    document.querySelectorAll('.pagination-btn:not(:first-child):not(:last-child)').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.pagination-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            // In a real implementation, this would fetch new page data from the server
            console.log('Loading page ' + this.textContent);
        });
    });
</script>
</body>
</html>