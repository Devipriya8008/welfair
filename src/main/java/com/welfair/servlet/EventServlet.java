package com.welfair.servlet;

import com.welfair.dao.EventDAO;
import com.welfair.model.Event;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
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
        boolean fromAdmin = "true".equals(request.getParameter("fromAdmin"));

        try {
            switch (action) {
                case "/new":
                    showNewForm(request, response, fromAdmin);
                    break;
                case "/edit":
                    showEditForm(request, response, fromAdmin);
                    break;
                case "/delete":
                    deleteEvent(request, response, fromAdmin);
                    break;
                case "/list":
                default:
                    listEvents(request, response, fromAdmin);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response, boolean fromAdmin)
            throws ServletException, IOException {
        request.setAttribute("event", new Event());
        request.setAttribute("fromAdmin", fromAdmin);
        request.getRequestDispatcher("/WEB-INF/views/events/form.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean fromAdmin = "true".equals(request.getParameter("fromAdmin"));

        try {
            Event event = new Event();

            // Set event properties from request parameters
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                event.setEventId(Integer.parseInt(idParam));
            }

            // Required fields
            event.setName(request.getParameter("name"));
            event.setDate(Date.valueOf(LocalDate.parse(request.getParameter("date"))));
            event.setLocation(request.getParameter("location"));
            event.setOrganizer(request.getParameter("organizer"));

            // Optional fields
            String timeParam = request.getParameter("time");
            if (timeParam != null && !timeParam.isEmpty()) {
                event.setTime(Time.valueOf(LocalTime.parse(timeParam)));
            }

            event.setShortDescription(request.getParameter("short_description"));
            event.setImageUrl(request.getParameter("image_url"));
            event.setCategory(request.getParameter("category"));

            // Save or update event
            if (event.getEventId() > 0) {
                eventDAO.updateEvent(event);
            } else {
                eventDAO.addEvent(event);
            }

            response.sendRedirect(request.getContextPath() + "/admin-table?table=events");

        } catch (Exception e) {
            request.setAttribute("error", "Error processing event: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Event event, boolean fromAdmin)
            throws ServletException, IOException {
        request.setAttribute("event", event);
        request.setAttribute("fromAdmin", fromAdmin);
        request.getRequestDispatcher("/WEB-INF/views/events/form.jsp").forward(request, response);
    }

    private void redirectToAdminTable(HttpServletRequest request, HttpServletResponse response, boolean fromAdmin)
            throws IOException {
        if (fromAdmin) {
            response.sendRedirect(request.getContextPath() + "/admin-table?table=events");
        } else {
            response.sendRedirect(request.getContextPath() + "/events/list");
        }
    }
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, boolean fromAdmin)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Event event = eventDAO.getEventById(id);

            if (event != null) {
                request.setAttribute("event", event);
                request.setAttribute("fromAdmin", fromAdmin);
                request.getRequestDispatcher("/WEB-INF/views/events/form.jsp").forward(request, response);
            } else {
                String errorMsg = "Event not found with ID: " + id;
                if (fromAdmin) {
                    request.getSession().setAttribute("errorMessage", errorMsg);
                    response.sendRedirect(request.getContextPath() + "/admin-table?table=events");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, errorMsg);
                }
            }
        } catch (NumberFormatException e) {
            handleError(request, response, "Invalid event ID format", fromAdmin);
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage(), fromAdmin);
        }
    }
    private void handleError(HttpServletRequest request, HttpServletResponse response,
                             String errorMessage, boolean fromAdmin)
            throws ServletException, IOException {
        if (fromAdmin) {
            request.getSession().setAttribute("errorMessage", errorMessage);
            response.sendRedirect(request.getContextPath() + "/admin-table?table=events");
        } else {
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    private void deleteEvent(HttpServletRequest request, HttpServletResponse response, boolean fromAdmin)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean deleted = eventDAO.deleteEvent(id);

            if (deleted) {
                String successMsg = "Event deleted successfully";
                if (fromAdmin) {
                    request.getSession().setAttribute("successMessage", successMsg);
                    response.sendRedirect(request.getContextPath() + "/admin-table?table=events");
                } else {
                    request.getSession().setAttribute("successMessage", successMsg);
                    response.sendRedirect(request.getContextPath() + "/events/list");
                }
            } else {
                handleError(request, response, "Failed to delete event", fromAdmin);
            }
        } catch (NumberFormatException e) {
            handleError(request, response, "Invalid event ID format", fromAdmin);
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage(), fromAdmin);
        }
    }
    private void listEvents(HttpServletRequest request, HttpServletResponse response, boolean fromAdmin)
            throws ServletException, IOException {
        try {
            List<Event> events = eventDAO.getAllEvents();
            request.setAttribute("events", events);

            if (fromAdmin) {
                response.sendRedirect(request.getContextPath() + "/admin-table?table=events");
            } else {
                request.getRequestDispatcher("/WEB-INF/views/events/list.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage(), fromAdmin);
        }
    }
}