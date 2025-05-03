package com.welfair.servlet;

import com.welfair.dao.VolunteerProjectDAO;
import com.welfair.model.VolunteerProject;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.util.ArrayList;
import java.util.List;

import java.io.IOException;

@WebServlet(name = "VolunteerProjectServlet", urlPatterns = {"/volunteer-projects"})
public class VolunteerProjectServlet extends HttpServlet {
    private VolunteerProjectDAO volunteerProjectDAO;

    @Override
    public void init() throws ServletException {
        volunteerProjectDAO = new VolunteerProjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                List<VolunteerProject> vps = volunteerProjectDAO.getAllVolunteerProjects();
                request.setAttribute("volunteerProjects", vps);
                request.getRequestDispatcher("/WEB-INF/views/volunteerproject/list.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.setAttribute("volunteerProject", new VolunteerProject());
                request.getRequestDispatcher("/WEB-INF/views/volunteerproject/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                VolunteerProject vp = volunteerProjectDAO.getVolunteerProject(volunteerId, projectId);
                if (vp != null) {
                    request.setAttribute("volunteerProject", vp);
                    request.getRequestDispatcher("/WEB-INF/views/volunteerproject/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND,
                            "Volunteer-Project association not found");
                }
            } else if ("delete".equals(action)) {
                int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                volunteerProjectDAO.deleteVolunteerProject(volunteerId, projectId);
                response.sendRedirect(request.getContextPath() + "/volunteer-projects");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");
            VolunteerProject vp = new VolunteerProject();
            VolunteerProjectDAO vpDAO = new VolunteerProjectDAO();

            // Parse fields from request
            int volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            String role = request.getParameter("role");

            // Validate IDs exist
            if (!vpDAO.volunteerExists(volunteerId)) {
                request.setAttribute("errorMessage", "Volunteer ID " + volunteerId + " does not exist");
                forwardToForm(request, response, vp, action);
                return;
            }

            if (!vpDAO.projectExists(projectId)) {
                request.setAttribute("errorMessage", "Project ID " + projectId + " does not exist");
                forwardToForm(request, response, vp, action);
                return;
            }

            vp.setVolunteerId(volunteerId);
            vp.setProjectId(projectId);
            vp.setRole(role);

            if ("update".equals(action)) {
                // Get original IDs from hidden fields
                int originalVolunteerId = Integer.parseInt(request.getParameter("originalVolunteerId"));
                int originalProjectId = Integer.parseInt(request.getParameter("originalProjectId"));

                // First delete the old association
                vpDAO.deleteVolunteerProject(originalVolunteerId, originalProjectId);

                // Then add the new one (which may have different IDs)
                vpDAO.addVolunteerProject(vp);
            } else {
                vpDAO.addVolunteerProject(vp);
            }
            response.sendRedirect(request.getContextPath() + "/volunteer-projects");

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing volunteer-project: " + e.getMessage());
            forwardToForm(request, response, new VolunteerProject(), request.getParameter("action"));
        }
    }

    private void forwardToForm(HttpServletRequest request, HttpServletResponse response,
                               VolunteerProject vp, String action)
            throws ServletException, IOException {
        request.setAttribute("volunteerProject", vp);
        if ("update".equals(action)) {
            request.setAttribute("originalVolunteerId", request.getParameter("volunteerId"));
            request.setAttribute("originalProjectId", request.getParameter("projectId"));
        }
        request.getRequestDispatcher("/WEB-INF/views/volunteerproject/form.jsp").forward(request, response);
    }
}