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
                request.setAttribute("donors", donorDAO.getAllDonors());
                request.getRequestDispatcher("/WEB-INF/views/donor/list.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Donor donor = donorDAO.getDonorById(id);
                if (donor != null) {
                    request.setAttribute("donor", donor);
                    request.getRequestDispatcher("/WEB-INF/views/donor/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else if ("new".equals(action)) {
                request.setAttribute("donor", new Donor());
                request.getRequestDispatcher("/WEB-INF/views/donor/form.jsp").forward(request, response);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                donorDAO.deleteDonor(id);
                response.sendRedirect(request.getContextPath() + "/donors");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
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
                // CRITICAL: Make sure you're getting the donor_id parameter
                donor.setDonorId(Integer.parseInt(request.getParameter("donor_id")));
                donorDAO.updateDonor(donor);
            }
            response.sendRedirect(request.getContextPath() + "/donors");
        } catch (SQLException e) {
            throw new ServletException("Database error during update", e);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid donor ID format", e);
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