package com.welfair.servlet;

import com.welfair.dao.EventDAO;
import com.welfair.model.Event;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/events/*")
public class EventServlet extends HttpServlet {
    private EventDAO eventDAO;

    @Override
    public void init() {
        eventDAO = new EventDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo() == null ? "/list" : request.getPathInfo();

        try {
            switch (action) {
                case "/new":
                    showForm(request, response, null);
                    break;
                case "/edit":
                    int editId = Integer.parseInt(request.getParameter("id"));
                    Event editEvent = eventDAO.getEventById(editId);
                    showForm(request, response, editEvent);
                    break;
                case "/delete":
                    int delId = Integer.parseInt(request.getParameter("id"));
                    eventDAO.deleteEvent(delId);
                    response.sendRedirect(request.getContextPath() + "/events/list");
                    break;
                    // Change this in your EventServlet
                case "/list":
                default:
                    List<Event> events = eventDAO.getAllEvents();
                    request.setAttribute("events", events);
                    request.getRequestDispatcher("/WEB-INF/views/events/form.jsp").forward(request, response);
                    // Changed path
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Event event = new Event();

        // Set event properties from request parameters
        if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
            event.setEventId(Integer.parseInt(request.getParameter("id")));
        }
        event.setName(request.getParameter("name"));
        event.setDate(Date.valueOf(LocalDate.parse(request.getParameter("date"))));
        event.setLocation(request.getParameter("location"));
        event.setOrganizer(request.getParameter("organizer"));

        // Save or update event
        if (event.getEventId() > 0) {
            eventDAO.updateEvent(event);
        } else {
            eventDAO.addEvent(event);
        }

        response.sendRedirect(request.getContextPath() + "/events/list");
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Event event)
            throws ServletException, IOException {
        request.setAttribute("event", event);
        request.getRequestDispatcher("/WEB-INF/views/events/form.jsp").forward(request, response);
    }
}