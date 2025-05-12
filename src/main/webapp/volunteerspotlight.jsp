<%@ page import="com.welfair.dao.*, com.welfair.model.*, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Volunteer Associations</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .volunteer-card {
            transition: transform 0.3s ease;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }
        .volunteer-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.2);
        }
        .card-header {
            border-radius: 15px 15px 0 0 !important;
            background: #2c3e50 !important;
        }
        .association-badge {
            background: #3498db;
            color: white;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.9em;
        }
        .section-title {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 5px;
            margin-bottom: 15px;
            font-size: 1.1rem;
        }
        .info-icon {
            color: #3498db;
            margin-right: 8px;
        }
        .association-details {
            font-size: 0.9rem;
            color: #6c757d;
        }
    </style>
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="text-center mb-5">
        <h1 class="display-4 text-primary"><i class="fas fa-users"></i> Volunteer Associations</h1>
        <p class="lead text-muted">Volunteer engagements with Events and Projects</p>
    </div>

    <div class="row">
        <%
            // Initialize DAOs
            VolunteerDAO volunteerDAO = new VolunteerDAO();
            EventVolunteerDAO eventAssociationDAO = new EventVolunteerDAO();
            VolunteerProjectDAO projectAssociationDAO = new VolunteerProjectDAO();
            EventDAO eventDAO = new EventDAO();
            ProjectDAO projectDAO = new ProjectDAO();

            // Get all volunteers
            List<Volunteer> volunteers = volunteerDAO.getAllVolunteers();

            // Prepare data maps
            Map<Integer, List<EventVolunteer>> volunteerEvents = new HashMap<>();
            Map<Integer, List<VolunteerProject>> volunteerProjects = new HashMap<>();
            Map<Integer, String> eventNames = new HashMap<>();
            Map<Integer, String> projectNames = new HashMap<>();

            // Fetch event names
            List<Event> allEvents = eventDAO.getAllEvents();
            for (Event event : allEvents) {
                eventNames.put(event.getEventId(), event.getName());
            }

            // Fetch project names
            List<Project> allProjects = projectDAO.getAllProjects();
            for (Project project : allProjects) {
                projectNames.put(project.getProjectId(), project.getName());
            }

            // Process volunteers
            for (Volunteer v : volunteers) {
                volunteerEvents.put(v.getVolunteerId(), eventAssociationDAO.getEventsByVolunteerId(v.getVolunteerId()));
                volunteerProjects.put(v.getVolunteerId(), projectAssociationDAO.getProjectsByVolunteerId(v.getVolunteerId()));
            }

            // Set request attributes
            request.setAttribute("volunteers", volunteers);
            request.setAttribute("volunteerEvents", volunteerEvents);
            request.setAttribute("volunteerProjects", volunteerProjects);
            request.setAttribute("eventNames", eventNames);
            request.setAttribute("projectNames", projectNames);
        %>

        <c:forEach items="${volunteers}" var="volunteer">
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card volunteer-card h-100">
                    <div class="card-header text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-user"></i>
                                ${volunteer.name}
                            <small class="d-block">ID: ${volunteer.volunteerId}</small>
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-4">
                            <p class="mb-2">
                                <i class="fas fa-envelope info-icon"></i>
                                    ${volunteer.email}
                            </p>
                            <p class="mb-0">
                                <i class="fas fa-phone info-icon"></i>
                                    ${volunteer.phone}
                            </p>
                        </div>

                        <c:if test="${not empty volunteerEvents[volunteer.volunteerId]}">
                            <h6 class="section-title"><i class="fas fa-calendar-alt"></i> Event Engagements</h6>
                            <div class="association-list">
                                <c:forEach var="event" items="${volunteerEvents[volunteer.volunteerId]}">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div>
                                            <strong>${eventNames[event.eventId]}</strong>
                                        </div>
                                        <span class="association-badge">Event</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <c:if test="${not empty volunteerProjects[volunteer.volunteerId]}">
                            <h6 class="section-title mt-4"><i class="fas fa-project-diagram"></i> Project Involvements</h6>
                            <div class="association-list">
                                <c:forEach var="project" items="${volunteerProjects[volunteer.volunteerId]}">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div>
                                            <strong>${projectNames[project.projectId]}</strong>
                                        </div>
                                        <span class="association-badge" style="background: #27ae60;">Project</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
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