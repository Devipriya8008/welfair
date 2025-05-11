<%@ page import="com.welfair.dao.*, com.welfair.model.*, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Volunteer Spotlight</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .volunteer-card {
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        .volunteer-card:hover {
            transform: translateY(-5px);
        }
        .activity-item {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .activity-item:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <h1 class="text-center mb-5">Volunteer Spotlight</h1>

    <div class="row" id="volunteerContainer">
        <%
            VolunteerDAO volunteerDAO = new VolunteerDAO();
            EventVolunteerDAO eventDAO = new EventVolunteerDAO();
            VolunteerProjectDAO projectDAO = new VolunteerProjectDAO();

            List<Volunteer> volunteers = volunteerDAO.getAllVolunteers();
            request.setAttribute("volunteers", volunteers);

            Map<Integer, List<EventVolunteer>> volunteerEvents = new HashMap<>();
            Map<Integer, List<VolunteerProject>> volunteerProjects = new HashMap<>();
            for (Volunteer v : volunteers) {
                volunteerEvents.put(v.getVolunteerId(), eventDAO.getEventsByVolunteerId(v.getVolunteerId()));
                volunteerProjects.put(v.getVolunteerId(), projectDAO.getProjectsByVolunteerId(v.getVolunteerId()));
            }
            request.setAttribute("volunteerEvents", volunteerEvents);
            request.setAttribute("volunteerProjects", volunteerProjects);
        %>

        <c:forEach items="${volunteers}" var="volunteer">
            <div class="col-md-6 col-lg-4 volunteer-item">
                <div class="card volunteer-card h-100">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">${volunteer.name}</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Email:</strong> ${volunteer.email}</p>
                        <p><strong>Phone:</strong> ${volunteer.phone}</p>

                        <h6 class="mt-4">Volunteer Activities</h6>
                        <div class="activities-list">
                            <c:forEach var="event" items="${volunteerEvents[volunteer.volunteerId]}">
                                <div class="activity-item">
                                    <strong>${event.name}</strong><br>
                                    <small class="text-muted">${event.date}</small>
                                </div>
                            </c:forEach>

                            <c:forEach var="project" items="${volunteerProjects[volunteer.volunteerId]}">
                                <div class="activity-item">
                                    <strong>${project.projectName}</strong><br>
                                    <small class="text-muted">${project.startDate} to ${project.endDate}</small>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>