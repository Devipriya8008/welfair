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
    public void init() throws ServletException {
        volunteerDAO = new VolunteerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        boolean fromAdmin = "true".equals(request.getParameter("fromAdmin"));

        try {
            if (action == null) {
                if (fromAdmin) {
                    response.sendRedirect(request.getContextPath() + "/admin-table?table=volunteers");
                } else {
                    request.setAttribute("volunteers", volunteerDAO.getAllVolunteers());
                    request.getRequestDispatcher("/WEB-INF/views/volunteer/list.jsp").forward(request, response);
                }
            } else if ("new".equals(action)) {
                request.setAttribute("formTitle", "Add New Volunteer");
                request.setAttribute("volunteer", new Volunteer());
                request.setAttribute("fromAdmin", fromAdmin);
                request.getRequestDispatcher("/WEB-INF/views/volunteer/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Volunteer volunteer = volunteerDAO.getVolunteerById(id);
                if (volunteer != null) {
                    request.setAttribute("formTitle", "Edit Volunteer");
                    request.setAttribute("volunteer", volunteer);
                    request.setAttribute("fromAdmin", fromAdmin);
                    request.getRequestDispatcher("/WEB-INF/views/volunteer/form.jsp").forward(request, response);
                } else {
                    request.getSession().setAttribute("errorMessage", "Volunteer not found with ID: " + id);
                    response.sendRedirect(request.getContextPath() + "/admin-table?table=volunteers");
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                volunteerDAO.deleteVolunteer(id);
                request.getSession().setAttribute("successMessage", "Volunteer deleted successfully");
                response.sendRedirect(request.getContextPath() + "/admin-table?table=volunteers");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
            redirectToAdminTable(request, response, fromAdmin);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        boolean fromAdmin = "true".equals(request.getParameter("fromAdmin"));

        try {
            System.out.println("=== POST PARAMETERS ===");
            System.out.println("volunteer_id: " + request.getParameter("volunteer_id"));
            System.out.println("name: " + request.getParameter("name"));
            System.out.println("phone: " + request.getParameter("phone"));
            System.out.println("email: " + request.getParameter("email"));

            Volunteer volunteer = new Volunteer();
            volunteer.setName(request.getParameter("name"));
            volunteer.setPhone(request.getParameter("phone"));
            volunteer.setEmail(request.getParameter("email"));

            String idParam = request.getParameter("volunteer_id");

            if (idParam != null && !idParam.isEmpty() && !idParam.equals("0")) {
                volunteer.setVolunteerId(Integer.parseInt(idParam));
                System.out.println("Attempting to update volunteer: " + volunteer);
                boolean updated = volunteerDAO.updateVolunteer(volunteer);
                System.out.println("Update result: " + updated);
                request.getSession().setAttribute("successMessage",
                        updated ? "Volunteer updated successfully" : "Failed to update volunteer");
            } else {
                System.out.println("Attempting to add new volunteer: " + volunteer);
                boolean added = volunteerDAO.addVolunteer(volunteer);
                System.out.println("Add result: " + added);
                request.getSession().setAttribute("successMessage",
                        added ? "Volunteer added successfully" : "Failed to add volunteer");
            }
        } catch (Exception e) {
            System.err.println("Error saving volunteer: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error saving volunteer: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin-table?table=volunteers");
    }

    private void redirectToAdminTable(HttpServletRequest request, HttpServletResponse response, boolean fromAdmin)
            throws IOException {
        if (fromAdmin) {
            response.sendRedirect(request.getContextPath() + "/admin-table?table=volunteers");
        } else {
            response.sendRedirect(request.getContextPath() + "/volunteers");
        }
    }



}