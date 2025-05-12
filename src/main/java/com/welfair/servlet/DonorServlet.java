package com.welfair.servlet;

import com.welfair.dao.*;
import com.welfair.db.DBConnection;
import com.welfair.model.*;
import com.welfair.util.PasswordUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "DonorServlet", urlPatterns = {"/donors"})
public class DonorServlet extends HttpServlet {
    private DonorDAO donorDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        donorDAO = new DonorDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        boolean fromAdmin = "true".equals(request.getParameter("fromAdmin"));

        try {
            if (action == null) {
                if (fromAdmin) {
                    response.sendRedirect(request.getContextPath() + "/admin-table?table=donors");
                } else {
                    request.setAttribute("donors", donorDAO.getAllDonors());
                    request.getRequestDispatcher("/WEB-INF/views/donor/list.jsp").forward(request, response);
                }
            } else if ("new".equals(action)) {
                Donor newDonor = new Donor();
                newDonor.setDonorId(0);
                request.setAttribute("donor", newDonor);
                request.setAttribute("fromAdmin", fromAdmin);
                request.getRequestDispatcher("/WEB-INF/views/donor/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Donor donor = donorDAO.getDonorById(id);
                if (donor != null) {
                    request.setAttribute("donor", donor);
                    request.setAttribute("fromAdmin", fromAdmin);
                    request.getRequestDispatcher("/WEB-INF/views/donor/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Donor not found with ID: " + id);
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (donorDAO.deleteDonor(id)) {
                    if (fromAdmin) {
                        response.sendRedirect(request.getContextPath() + "/admin-table?table=donors");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/donors");
                    }
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");
            Donor donor = new Donor();
            donor.setName(request.getParameter("name"));
            donor.setEmail(request.getParameter("email"));
            donor.setPhone(request.getParameter("phone"));
            donor.setAddress(request.getParameter("address"));

            if ("update".equals(action)) {
                // Update existing donor
                int donorId = Integer.parseInt(request.getParameter("donor_id"));
                Donor existingDonor = donorDAO.getDonorById(donorId);
                if (existingDonor != null) {
                    donor.setDonorId(donorId);
                    donor.setUserId(existingDonor.getUserId());
                    if (donorDAO.updateDonor(donor)) {
                        // Also update the corresponding user's name
                        User user = userDAO.getUserById(existingDonor.getUserId());
                        if (user != null) {
                            user.setUsername(donor.getName()); // Update username to match donor name
                            userDAO.updateUser(user);
                        }
                        response.sendRedirect(request.getContextPath() + "/admin-table?table=donors");
                        return;
                    }
                }
            } else {
                // For new donors, create user first with name as username
                User user = new User();
                user.setUsername(donor.getName()); // Use donor's name as username
                user.setEmail(donor.getEmail());
                user.setPassword(PasswordUtil.hashPassword("Temporary123!")); // Temporary password
                user.setRole("donor");

                // Start transaction
                Connection conn = DBConnection.getConnection();
                try {
                    conn.setAutoCommit(false);

                    // 1. Create user with donor's name as username
                    if (userDAO.addUser(user, conn)) {
                        // 2. Create donor with the new user's ID
                        donor.setUserId(user.getUserId());
                        if (donorDAO.saveDonor(donor, conn)) {
                            conn.commit();
                            response.sendRedirect(request.getContextPath() + "/admin-table?table=donors");
                            return;
                        }
                    }
                    conn.rollback();
                } finally {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            }

            request.setAttribute("errorMessage", "Operation failed. Please try again.");
            request.setAttribute("donor", donor);
            request.getRequestDispatcher("/WEB-INF/views/donor/form.jsp").forward(request, response);

        } catch (SQLException | NumberFormatException e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/donor/form.jsp").forward(request, response);
        }
    }


    /*public void destroy() {
        try {
            if (donorDAO != null) {
                donorDAO.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing DonorDAO: " + e.getMessage());
        }
    }*/
}
