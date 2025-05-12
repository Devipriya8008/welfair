package com.welfair.servlet;

import com.welfair.dao.EventDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "DisplayEventsServlet", value = "/events-display")
public class DisplayEventsServlet extends HttpServlet {
    private EventDAO eventDAO;

    @Override
    public void init() {
        eventDAO = new EventDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("events", eventDAO.getAllEvents());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        request.getRequestDispatcher("/events1.jsp").forward(request, response);
    }
}