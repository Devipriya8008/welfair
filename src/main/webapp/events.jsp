<%@ page import="com.welfair.dao.EventDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.welfair.model.Event" %>
<%@ page import="java.util.Date" %>

<%
    // Get only upcoming events (date >= today)
    EventDAO eventDAO = new EventDAO();
    List<Event> allEvents = eventDAO.getAllEvents();
    Date today = new Date();
    List<Event> upcomingEvents = allEvents.stream()
            .filter(event -> !event.getDate().before(today))
            .collect(java.util.stream.Collectors.toList());
    request.setAttribute("events", upcomingEvents);
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Upcoming Events</title>
    <style>
        :root {
            --primary: #2c8a8a;
            --secondary: #f8b400;
            --light: #f9f9f9;
            --dark: #333;
            --gray: #777;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light);
            padding: 20px;
        }

        .events-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .event-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .event-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            padding: 15px;
        }

        .event-title {
            font-size: 18px;
            color: var(--primary);
            margin-bottom: 10px;
        }

        .event-date {
            color: var(--gray);
            font-size: 14px;
            margin-bottom: 10px;
        }

        .event-location {
            color: var(--gray);
            font-size: 14px;
            margin-bottom: 15px;
        }

        .btn-volunteer {
            display: inline-block;
            padding: 8px 15px;
            background: var(--secondary);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            transition: background 0.3s;
        }

        .btn-volunteer:hover {
            background: #e0a500;
        }

        .no-events {
            text-align: center;
            padding: 40px;
            color: var(--gray);
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
</head>
<body>
<div class="events-container">
    <div class="event-cards">
        <c:choose>
            <c:when test="${not empty events}">
                <c:forEach items="${events}" var="event">
                    <div class="event-card">
                        <h3 class="event-title">${event.name}</h3>
                        <div class="event-date">
                            <fmt:formatDate value="${event.date}" pattern="MMMM d, yyyy" />
                            at <fmt:formatDate value="${event.time}" type="time" timeStyle="short"/>
                        </div>
                        <div class="event-location">
                                ${event.location}
                        </div>
                        <a href="register.jsp?role=volunteer&eventId=${event.eventId}" class="btn-volunteer">
                            Register as Volunteer
                        </a>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="no-events">
                    <h3>No upcoming events scheduled</h3>
                    <p>Please check back later for new volunteer opportunities</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>