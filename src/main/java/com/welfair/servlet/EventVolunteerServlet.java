package com.welfair.servlet;

import com.welfair.dao.EventVolunteerDAO;
import com.welfair.model.EventVolunteer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/event_volunteers")
public class EventVolunteerServlet extends HttpServlet {
    private EventVolunteerDAO eventVolunteerDAO;

    @Override
    public void init() {
        eventVolunteerDAO = new EventVolunteerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                listAssignments(request, response);
            } else if ("new".equals(action)) {
                showAssignmentForm(request, response, null);
            } else if ("edit".equals(action)) {
                showEditForm(request, response);
            } else if ("listByEvent".equals(action)) {
                listVolunteersForEvent(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                addAssignment(request, response);
            } else if ("update".equals(action)) {
                updateAssignment(request, response);
            } else if ("delete".equals(action)) {
                deleteAssignment(request, response);
            } else {
                listAssignments(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request", e);
        }
    }

    private void listAssignments(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setAttribute("assignments", eventVolunteerDAO.getAllEventVolunteers());
        request.getRequestDispatcher("/WEB-INF/views/event_volunteers/list.jsp").forward(request, response);
    }

    private void showAssignmentForm(HttpServletRequest request, HttpServletResponse response,
                                    EventVolunteer assignment) throws ServletException, IOException {
        request.setAttribute("assignment", assignment);
        request.getRequestDispatcher("/WEB-INF/views/event_volunteers/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
        EventVolunteer assignment = eventVolunteerDAO.getEventVolunteerById(eventId, volunteerId);
        showAssignmentForm(request, response, assignment);
    }

    private void listVolunteersForEvent(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        request.setAttribute("volunteers", eventVolunteerDAO.getVolunteersByEventId(eventId));
        request.setAttribute("eventId", eventId);
        request.getRequestDispatcher("/WEB-INF/views/event_volunteers/volunteersByEvent.jsp").forward(request, response);
    }

    private void addAssignment(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));

        EventVolunteer ev = new EventVolunteer(eventId, volunteerId);
        eventVolunteerDAO.assignVolunteerToEvent(ev);
        response.sendRedirect(request.getContextPath() + "/event_volunteers");
    }

    private void updateAssignment(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int oldEventId = Integer.parseInt(request.getParameter("oldEventId"));
        int oldVolunteerId = Integer.parseInt(request.getParameter("oldVolunteerId"));
        int newEventId = Integer.parseInt(request.getParameter("eventId"));
        int newVolunteerId = Integer.parseInt(request.getParameter("volunteerId"));

        eventVolunteerDAO.updateAssignment(oldEventId, oldVolunteerId, newEventId, newVolunteerId);
        response.sendRedirect(request.getContextPath() + "/event_volunteers");
    }

    private void deleteAssignment(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));

        eventVolunteerDAO.removeVolunteerFromEvent(eventId, volunteerId);
        response.sendRedirect(request.getContextPath() + "/event_volunteers");
    }
}