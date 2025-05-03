package com.welfair.servlet;

import com.welfair.dao.ProjectEmployeeDAO;
import com.welfair.model.ProjectEmployee;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.util.ArrayList;
import java.util.List;

import java.io.IOException;

@WebServlet(name = "ProjectEmployeeServlet", urlPatterns = {"/project-employees"})
public class ProjectEmployeeServlet extends HttpServlet {
    private ProjectEmployeeDAO projectEmployeeDAO;

    @Override
    public void init() throws ServletException {
        projectEmployeeDAO = new ProjectEmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                List<ProjectEmployee> pes = projectEmployeeDAO.getAllProjectEmployees();
                request.setAttribute("projectEmployees", pes);
                request.getRequestDispatcher("/WEB-INF/views/projectemployee/list.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.setAttribute("projectEmployee", new ProjectEmployee());
                request.getRequestDispatcher("/WEB-INF/views/projectemployee/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int empId = Integer.parseInt(request.getParameter("empId"));
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                ProjectEmployee pe = projectEmployeeDAO.getProjectEmployee(empId, projectId);
                if (pe != null) {
                    request.setAttribute("projectEmployee", pe);
                    request.getRequestDispatcher("/WEB-INF/views/projectemployee/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND,
                            "Project-Employee association not found");
                }
            } else if ("delete".equals(action)) {
                int empId = Integer.parseInt(request.getParameter("empId"));
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                projectEmployeeDAO.deleteProjectEmployee(empId, projectId);
                response.sendRedirect(request.getContextPath() + "/project-employees");
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
            ProjectEmployee pe = new ProjectEmployee();

            // Parse fields from request
            int empId = Integer.parseInt(request.getParameter("empId"));
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            String role = request.getParameter("role");

            // Validate IDs exist
            if (!projectEmployeeDAO.employeeExists(empId)) {
                request.setAttribute("errorMessage", "Employee ID " + empId + " does not exist");
                forwardToForm(request, response, pe, action);
                return;
            }

            if (!projectEmployeeDAO.projectExistsForEmployee(projectId)) {
                request.setAttribute("errorMessage", "Project ID " + projectId + " does not exist");
                forwardToForm(request, response, pe, action);
                return;
            }

            pe.setEmpId(empId);
            pe.setProjectId(projectId);
            pe.setRole(role);

            if ("update".equals(action)) {
                // Get original IDs from hidden fields
                int originalEmpId = Integer.parseInt(request.getParameter("originalEmpId"));
                int originalProjectId = Integer.parseInt(request.getParameter("originalProjectId"));

                // First delete the old association
                projectEmployeeDAO.deleteProjectEmployee(originalEmpId, originalProjectId);

                // Then add the new one (which may have different IDs)
                projectEmployeeDAO.addProjectEmployee(pe);
            } else {
                projectEmployeeDAO.addProjectEmployee(pe);
            }
            response.sendRedirect(request.getContextPath() + "/project-employees");

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing project-employee: " + e.getMessage());
            forwardToForm(request, response, new ProjectEmployee(), request.getParameter("action"));
        }
    }

    private void forwardToForm(HttpServletRequest request, HttpServletResponse response,
                               ProjectEmployee pe, String action)
            throws ServletException, IOException {
        request.setAttribute("projectEmployee", pe);
        if ("update".equals(action)) {
            request.setAttribute("originalEmpId", request.getParameter("empId"));
            request.setAttribute("originalProjectId", request.getParameter("projectId"));
        }
        request.getRequestDispatcher("/WEB-INF/views/projectemployee/form.jsp").forward(request, response);
    }
}