package com.welfair.servlet;

import com.welfair.dao.DonationDAO;
import com.welfair.dao.ProjectDAO;
import com.welfair.db.DBConnection;
import com.welfair.model.Donation;
import com.welfair.model.Donor;
import com.welfair.model.Project;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

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
            // DEBUG CODE START
            System.out.println("=== DEBUG START ===");
            try {
                List<Project> testProjects = projectDAO.getAllProjects();  // Changed from ProjectDAO to projectDAO
                System.out.println("Servlet received projects: " + testProjects.size());

                // Test direct database connection
                try (Connection conn = DBConnection.getConnection()) {
                    System.out.println("DB Connection successful to: " + conn.getMetaData().getURL());

                    // Test direct query
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM projects WHERE status = 'Active'");
                    rs.next();
                    System.out.println("Direct DB query count: " + rs.getInt(1));
                }
            } catch (SQLException e) {
                System.out.println("DEBUG ERROR: " + e.getMessage());
                e.printStackTrace();
            }
            System.out.println("=== DEBUG END ===");
            // DEBUG CODE END

            // Original code continues...
            List<Donation> donations = donationDAO.getDonationsByDonorId(donor.getDonorId());
            BigDecimal totalDonations = donationDAO.getTotalDonationsByDonor(donor.getDonorId());

            List<Project> activeProjects = projectDAO.getActiveProjects();
            if (activeProjects.isEmpty()) {
                request.setAttribute("projectError", "No active projects available at the moment");
            }

            request.setAttribute("donations", donations);
            request.setAttribute("totalDonations", totalDonations);
            request.setAttribute("activeProjects", activeProjects);
            request.setAttribute("projectsSupported", donations.size());

            request.getRequestDispatcher("/donor-dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("error", "Error loading dashboard data: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}