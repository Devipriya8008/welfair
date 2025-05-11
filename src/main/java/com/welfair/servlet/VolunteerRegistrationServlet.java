package com.welfair.servlet;

import com.welfair.dao.EventVolunteerDAO;
import com.welfair.dao.VolunteerDAO;
import com.welfair.model.EventVolunteer;
import com.welfair.model.User;
import com.welfair.model.Volunteer;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.welfair.dao.UserDAO;
import java.io.IOException;

@WebServlet("/register-volunteer")
public class VolunteerRegistrationServlet extends HttpServlet {
    private EventVolunteerDAO eventVolunteerDAO;
    private VolunteerDAO volunteerDAO;

    @Override
    public void init() {
        eventVolunteerDAO = new EventVolunteerDAO();
        volunteerDAO = new VolunteerDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("error", "Please login as a volunteer first");
            response.sendRedirect("login.jsp?role=volunteer");
            return;
        }

        // Track originating page
        String referer = request.getHeader("referer");
        if (referer != null && referer.contains("volunteer-dashboard")) {
            session.setAttribute("returnTo", "dashboard");
        }

        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            Volunteer volunteer = volunteerDAO.getVolunteerByUserId(user.getUserId());

            if (volunteer == null) {
                session.setAttribute("error", "Volunteer profile not found");
                response.sendRedirect("events.jsp");
                return;
            }

            if (eventVolunteerDAO.getEventVolunteerById(eventId, volunteer.getVolunteerId()) != null) {
                session.setAttribute("message", "You're already registered for this event");
            } else {
                eventVolunteerDAO.assignVolunteerToEvent(new EventVolunteer(eventId, volunteer.getVolunteerId()));
                session.setAttribute("message", "Successfully registered for the event!");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Registration failed: " + e.getMessage());
        }

        // Handle redirect after registration
        if ("dashboard".equals(session.getAttribute("returnTo"))) {
            session.removeAttribute("returnTo");
            response.sendRedirect("volunteer-dashboard.jsp");
        } else {
            response.sendRedirect("events.jsp?filter=volunteer");
        }
    }
}