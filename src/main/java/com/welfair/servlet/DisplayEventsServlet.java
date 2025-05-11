package com.welfair.servlet;

import com.welfair.dao.EventDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "DisplayEventsServlet", value = "/events-display")
public class DisplayEventsServlet extends HttpServlet {
    private EventDAO eventDAO;

    @Override
    public void init() {
        eventDAO = new EventDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("events", eventDAO.getAllEvents());
        request.getRequestDispatcher("/events.jsp").forward(request, response);
    }
}