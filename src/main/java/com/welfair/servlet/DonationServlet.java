package com.welfair.servlet;

import com.welfair.dao.*;
import com.welfair.db.DBConnection;
import com.welfair.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

@WebServlet(name = "DonationServlet", urlPatterns = {"/donations"})
public class DonationServlet extends HttpServlet {
    private DonationDAO donationDAO;
    private DonorDAO donorDAO;
    private ProjectDAO projectDAO;

    @Override
    public void init() throws ServletException {
        try {
            donationDAO = new DonationDAO();
            donorDAO = new DonorDAO();
            projectDAO = new ProjectDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String fromAdmin = request.getParameter("fromAdmin");

        try {
            if (action == null) {
                request.setAttribute("donations", donationDAO.getAllDonations());
                if ("true".equals(fromAdmin)) {
                    response.sendRedirect(getServletContext().getContextPath() + "/admin-table?table=donations");
                } else {
                    request.getRequestDispatcher("/WEB-INF/views/donation/list.jsp").forward(request, response);
                }
            } else if ("new".equals(action)) {
                Donation newDonation = new Donation();
                request.setAttribute("donation", newDonation);
                request.setAttribute("fromAdmin", fromAdmin);
                request.getRequestDispatcher("/WEB-INF/views/donation/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Donation donation = donationDAO.getDonationById(id);
                if (donation != null) {
                    request.setAttribute("donation", donation);
                    request.setAttribute("fromAdmin", fromAdmin);
                    request.getRequestDispatcher("/WEB-INF/views/donation/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Donation not found with ID: " + id);
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                donationDAO.deleteDonation(id);
                response.sendRedirect(request.getContextPath() + "/admin-table?table=donations");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
            }
        } catch (Exception e) {
            handleException(request, response, e, fromAdmin);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String fromAdmin = request.getParameter("fromAdmin");
        Connection conn = null;
        Donation donation = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String action = request.getParameter("action");
            donation = extractDonationFromRequest(request);

            if ("update".equals(action)) {
                int donationId = Integer.parseInt(request.getParameter("donation_id"));
                donation.setDonationId(donationId);

                if (donationDAO.updateDonation(donation,conn)) {  // Pass the connection here
                    conn.commit();
                    response.sendRedirect(request.getContextPath() + "/admin-table?table=donations");
                    return;
                }
            }else {
                // Handle add operation
                if (donationDAO.addDonation(donation, conn)) {
                    conn.commit();
                    response.sendRedirect(request.getContextPath() + "/admin-table?table=donations");
                    return;
                }
            }

            conn.rollback();
            request.setAttribute("errorMessage", "Operation failed. Please try again.");

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                e.addSuppressed(ex);
            }
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("donation", donation != null ? donation : new Donation());
        request.setAttribute("fromAdmin", fromAdmin);
        request.getRequestDispatcher("/WEB-INF/views/donation/form.jsp")
                .forward(request, response);
    }

    private Donation extractDonationFromRequest(HttpServletRequest request) throws SQLException {
        Donation donation = new Donation();

        try {
            // Validate donor exists
            int donorId = Integer.parseInt(request.getParameter("donor_id"));
            if (donorDAO.getDonorById(donorId) == null) {
                throw new IllegalArgumentException("Donor with ID " + donorId + " does not exist");
            }
            donation.setDonorId(donorId);

            // Validate project exists
            int projectId = Integer.parseInt(request.getParameter("project_id"));
            if (projectDAO.getProjectById(projectId) == null) {
                throw new IllegalArgumentException("Project with ID " + projectId + " does not exist");
            }
            donation.setProjectId(projectId);

            // Handle amount
            try {
                donation.setAmount(new BigDecimal(request.getParameter("amount")));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid amount format");
            }

            donation.setMode(request.getParameter("mode"));

            // Robust date handling
            String dateParam = request.getParameter("date");
            if (dateParam == null || dateParam.isEmpty()) {
                donation.setDate(new Timestamp(System.currentTimeMillis()));
            } else {
                try {
                    // Handle both "yyyy-MM-dd" and "yyyy-MM-dd'T'HH:mm" formats
                    if (dateParam.contains("T")) {
                        LocalDateTime localDateTime = LocalDateTime.parse(dateParam,
                                DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                        donation.setDate(Timestamp.valueOf(localDateTime));
                    } else {
                        LocalDate localDate = LocalDate.parse(dateParam);
                        donation.setDate(Timestamp.valueOf(localDate.atStartOfDay()));
                    }
                } catch (DateTimeParseException e) {
                    throw new IllegalArgumentException("Invalid date format. Please use format: yyyy-MM-dd or yyyy-MM-ddTHH:mm");
                }
            }

        } catch (IllegalArgumentException e) {
            throw new SQLException("Validation error: " + e.getMessage(), e);
        }

        return donation;
    }

    private void redirectAfterOperation(HttpServletResponse response, String fromAdmin)
            throws IOException {
        String contextPath = getServletContext().getContextPath();
        String redirectUrl = "true".equals(fromAdmin)
                ? contextPath + "/admin-table?table=donations"
                : contextPath + "/donations";
        response.sendRedirect(redirectUrl);
    }

    private void handleException(HttpServletRequest request, HttpServletResponse response,
                                 Exception e, String fromAdmin) throws ServletException, IOException {
        request.setAttribute("errorMessage", e.getMessage());
        request.setAttribute("fromAdmin", fromAdmin);
        forwardToForm(request, response);
    }

    private void forwardToForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/donation/form.jsp").forward(request, response);
    }
}