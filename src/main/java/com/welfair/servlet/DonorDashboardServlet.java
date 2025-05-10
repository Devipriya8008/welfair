package com.welfair.servlet;

import com.welfair.dao.ProjectDAO;
import com.welfair.model.Project;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/donor-dashboard")
public class DonorDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch active projects
            List<Project> activeProjects = ProjectDAO.getActiveProjects();

            // Set active projects as a request attribute
            request.setAttribute("activeProjects", activeProjects);

            // Forward to donor dashboard
            request.getRequestDispatcher("/donor-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            // Log the error and show an error message
            e.printStackTrace();
            request.setAttribute("error", "Unable to load active projects. Please try again later.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}