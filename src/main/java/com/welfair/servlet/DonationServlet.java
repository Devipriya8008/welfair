package com.welfair.servlet;

import com.welfair.dao.DonationDAO;
import com.welfair.model.Donation;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet(name = "DonationServlet", urlPatterns = {"/donations"})
public class DonationServlet extends HttpServlet {
    private DonationDAO donationDAO;

    @Override
    public void init() throws ServletException {
        try {
            donationDAO = new DonationDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize DonationDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                request.setAttribute("donations", donationDAO.getAllDonations());
                request.getRequestDispatcher("/WEB-INF/views/donation/list.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                Donation newDonation = new Donation();
                newDonation.setDonationId(0);
                request.setAttribute("donation", newDonation);
                request.getRequestDispatcher("/WEB-INF/views/donation/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Donation donation = donationDAO.getDonationById(id);
                if (donation != null) {
                    request.setAttribute("donation", donation);
                    request.getRequestDispatcher("/WEB-INF/views/donation/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Donation not found with ID: " + id);
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                donationDAO.deleteDonation(id);
                response.sendRedirect(request.getContextPath() + "/donations");
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
            Donation donation = new Donation();

            // Set donation info
            donation.setDonorId(Integer.parseInt(request.getParameter("donor_id")));
            donation.setProjectId(Integer.parseInt(request.getParameter("project_id")));
            donation.setAmount(new BigDecimal(request.getParameter("amount")));

            // Handle date conversion using java.time API
            String dateParam = request.getParameter("date");
            if (dateParam == null || dateParam.isEmpty()) {
                throw new IllegalArgumentException("Date is required");
            }
            LocalDate localDate = LocalDate.parse(dateParam);
            LocalDateTime localDateTime = localDate.atStartOfDay();
            donation.setDate(Timestamp.valueOf(localDateTime));

            donation.setMode(request.getParameter("mode"));

            if ("update".equals(action)) {
                // Update existing donation
                int donationId = Integer.parseInt(request.getParameter("donation_id"));
                donation.setDonationId(donationId);
                donationDAO.updateDonation(donation);
                response.sendRedirect(request.getContextPath() + "/donations");
            } else {
                // Add new donation
                donationDAO.addDonation(donation);
                response.sendRedirect(request.getContextPath() + "/donations");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format");
            request.getRequestDispatcher("/WEB-INF/views/donation/form.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Invalid date: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/donation/form.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/donation/form.jsp").forward(request, response);
        }
    }
}