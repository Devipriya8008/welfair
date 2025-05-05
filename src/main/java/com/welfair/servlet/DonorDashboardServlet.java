package com.welfair.servlet;

import com.welfair.dao.*;
import com.welfair.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.math.BigDecimal;

@WebServlet("/donor-dashboard")
public class DonorDashboardServlet extends HttpServlet {
    private DonationDAO donationDAO;
    private ProjectDAO projectDAO;
    private DonorDAO donorDAO;

    @Override
    public void init() throws ServletException {
        try {
            donationDAO = new DonationDAO();
            projectDAO = new ProjectDAO();
            donorDAO = new DonorDAO();
        } catch (Exception e) {
            throw new ServletException("Initialization failed", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("donor")) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Donor donor = donorDAO.getDonorByUserId(user.getUserId());
            List<Donation> donations = donationDAO.getDonationsByDonorId(donor.getDonorId());
            BigDecimal totalDonations = donationDAO.getTotalDonationsByDonor(donor.getDonorId());
            List<Project> activeProjects = projectDAO.getActiveProjects();

            request.setAttribute("donor", donor);
            request.setAttribute("donations", donations);
            request.setAttribute("totalDonations", totalDonations);
            request.setAttribute("activeProjects", activeProjects);
            request.setAttribute("projectsSupported", donations.stream().map(d -> d.getProjectId()).distinct().count());

            request.getRequestDispatcher("/donor-dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}