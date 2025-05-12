package com.welfair.servlet;

import com.welfair.dao.ProjectDAO;
import com.welfair.model.Project;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "ProjectServlet", urlPatterns = {"/projects"})
public class ProjectServlet extends HttpServlet {
    private ProjectDAO projectDAO;

    @Override
    public void init() throws ServletException {
        projectDAO = new ProjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                List<Project> projects = projectDAO.getAllProjects();
                request.setAttribute("projects", projects);
                request.getRequestDispatcher("/WEB-INF/views/project/list.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.setAttribute("project", new Project());
                request.getRequestDispatcher("/WEB-INF/views/project/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Project project = projectDAO.getProjectById(id);
                if (project != null) {
                    request.setAttribute("project", project);
                    request.getRequestDispatcher("/WEB-INF/views/project/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Project not found with ID: " + id);
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                projectDAO.deleteProject(id);
                response.sendRedirect(request.getContextPath() + "/admin-table?table=projects");
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
            Project project = new Project();

            // Parse project fields from request
            project.setName(request.getParameter("name"));
            project.setDescription(request.getParameter("description"));
            project.setStartDate(Date.valueOf(request.getParameter("start_date")));
            project.setEndDate(Date.valueOf(request.getParameter("end_date")));
            project.setStatus(request.getParameter("status"));

            if ("update".equals(action)) {
                int projectId = Integer.parseInt(request.getParameter("project_id"));
                project.setProjectId(projectId);
                projectDAO.updateProject(project);
            } else {
                projectDAO.addProject(project);
            }
            response.sendRedirect(request.getContextPath() + "/admin-table?table=projects");

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing project: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/project/form.jsp").forward(request, response);
        }
    }
}
