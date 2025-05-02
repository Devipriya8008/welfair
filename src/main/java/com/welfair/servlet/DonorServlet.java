package com.welfair.servlet;

import com.welfair.dao.DonorDAO;
import com.welfair.model.Donor;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "DonorServlet", urlPatterns = {"/donors"})
public class DonorServlet extends HttpServlet {
    private DonorDAO donorDAO;

    @Override
    public void init() throws ServletException {
        try {
            donorDAO = new DonorDAO();
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize DonorDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                // List all donors
                request.setAttribute("donors", donorDAO.getAllDonors());
                request.getRequestDispatcher("/WEB-INF/views/donor/list.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                // Show empty form for new donor - explicitly set donorId to 0
                Donor newDonor = new Donor();
                newDonor.setDonorId(0); // This ensures empty donorId is handled correctly
                request.setAttribute("donor", newDonor);
                request.getRequestDispatcher("/WEB-INF/views/donor/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                // Show form with existing donor data
                int id = Integer.parseInt(request.getParameter("id"));
                Donor donor = donorDAO.getDonorById(id);
                if (donor != null) {
                    request.setAttribute("donor", donor);
                    request.getRequestDispatcher("/WEB-INF/views/donor/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Donor not found with ID: " + id);
                }
            } else if ("delete".equals(action)) {
                // Delete donor
                int id = Integer.parseInt(request.getParameter("id"));
                if (donorDAO.deleteDonor(id)) {
                    response.sendRedirect(request.getContextPath() + "/donors");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Failed to delete donor with ID: " + id);
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            Donor donor = new Donor();
            donor.setName(request.getParameter("name"));
            donor.setEmail(request.getParameter("email"));
            donor.setPhone(request.getParameter("phone"));
            donor.setAddress(request.getParameter("address"));

            if ("update".equals(action)) {
                int donorId = Integer.parseInt(request.getParameter("donor_id"));
                donor.setDonorId(donorId);

                if (donorDAO.updateDonor(donor)) {
                    response.sendRedirect(request.getContextPath() + "/donors");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Update failed. Donor not found.");
                }
            } else {
                // Save new donor
                if (donorDAO.saveDonor(donor)) {
                    response.sendRedirect(request.getContextPath() + "/donors");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Save failed. Please try again.");
                }
            }

            request.setAttribute("donor", donor);
            request.getRequestDispatcher("/WEB-INF/views/donor/form.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ID format");
            request.getRequestDispatcher("/WEB-INF/views/donor/form.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        try {
            if (donorDAO != null) {
                donorDAO.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing DonorDAO: " + e.getMessage());
        }
    }
}