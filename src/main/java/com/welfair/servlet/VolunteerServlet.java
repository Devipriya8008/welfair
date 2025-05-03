package com.welfair.servlet;

import com.welfair.dao.VolunteerDAO;
import com.welfair.model.Volunteer;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "VolunteerServlet", urlPatterns = {"/volunteers"})
public class VolunteerServlet extends HttpServlet {
    private VolunteerDAO volunteerDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                // List all volunteers
                request.setAttribute("volunteers", volunteerDAO.getAllVolunteers());
                request.getRequestDispatcher("/WEB-INF/views/volunteer/list.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                // Show empty form for new volunteer
                request.setAttribute("formTitle", "Add New Volunteer");
                request.setAttribute("volunteer", new Volunteer());
                request.getRequestDispatcher("/WEB-INF/views/volunteer/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                // Show form with existing volunteer data
                int id = Integer.parseInt(request.getParameter("id"));
                Volunteer volunteer = volunteerDAO.getVolunteerById(id);
                if (volunteer != null) {
                    request.setAttribute("formTitle", "Edit Volunteer");
                    request.setAttribute("volunteer", volunteer);
                    request.getRequestDispatcher("/WEB-INF/views/volunteer/form.jsp").forward(request, response);
                } else {
                    request.getSession().setAttribute("errorMessage", "Volunteer not found with ID: " + id);
                    response.sendRedirect(request.getContextPath() + "/volunteers");
                }
            } else if ("delete".equals(action)) {
                // Handle delete
                int id = Integer.parseInt(request.getParameter("id"));
                volunteerDAO.deleteVolunteer(id);
                request.getSession().setAttribute("successMessage", "Volunteer deleted successfully");
                response.sendRedirect(request.getContextPath() + "/volunteers");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/volunteers");
        }
    }

    @Override
    public void init() throws ServletException {
        try {
            volunteerDAO = new VolunteerDAO();
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize VolunteerDAO", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            Volunteer volunteer = new Volunteer();
            volunteer.setName(request.getParameter("name"));
            volunteer.setPhone(request.getParameter("phone"));
            volunteer.setEmail(request.getParameter("email"));

            String idParam = request.getParameter("volunteer_id");

            if (idParam != null && !idParam.isEmpty() && !idParam.equals("0")) {
                // Update existing volunteer
                volunteer.setVolunteerId(Integer.parseInt(idParam));
                volunteerDAO.updateVolunteer(volunteer);
                request.getSession().setAttribute("successMessage", "Volunteer updated successfully");
            } else {
                // Add new volunteer
                volunteerDAO.addVolunteer(volunteer);
                request.getSession().setAttribute("successMessage", "Volunteer added successfully");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error saving volunteer: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/volunteers");
    }
}