package com.welfair.servlet;

import com.welfair.dao.DonationDAO;
import com.welfair.dao.ProjectDAO;
import com.welfair.model.Donation;
import com.welfair.model.Donor;
import com.welfair.model.Project;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/donor-dashboard")
public class DonorDashboardServlet extends HttpServlet {
    private DonationDAO donationDAO;
    private ProjectDAO projectDAO;

    @Override
    public void init() throws ServletException {
        donationDAO = new DonationDAO();
        projectDAO = new ProjectDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("donor") == null) {
            response.sendRedirect(request.getContextPath() + "/login?role=donor");
            return;
        }

        Donor donor = (Donor) session.getAttribute("donor");

        try {
            // Get donation-related data
            List<Donation> donations = donationDAO.getDonationsByDonorId(donor.getDonorId());
            BigDecimal totalDonations = donationDAO.getTotalDonationsByDonor(donor.getDonorId());

            // Get active projects
            List<Project> activeProjects = projectDAO.getActiveProjects();
            System.out.println("Found " + activeProjects.size() + " active projects"); // Debug

            request.setAttribute("donations", donations);
            request.setAttribute("totalDonations", totalDonations);
            request.setAttribute("activeProjects", activeProjects);
            request.setAttribute("projectsSupported", donations.size());

            request.getRequestDispatcher("/WEB-INF/views/donor/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("error", "Error loading dashboard data: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}