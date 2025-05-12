package com.welfair.servlet;

import com.welfair.dao.*;
import com.welfair.db.DBConnection;
import com.welfair.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.welfair.util.EmailUtil;
import com.welfair.util.PasswordUtil;

import java.sql.Statement;
import java.util.logging.Logger;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AdminDashboardServlet.class.getName());
    private AdminDAO adminDAO;
    private UserDAO userDAO;
    private DonationDAO donationDAO;
    private ProjectDAO projectDAO;
    private BeneficiaryDAO beneficiaryDAO;
    private InventoryDAO inventoryDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
        userDAO = new UserDAO();
        donationDAO = new DonationDAO();
        projectDAO = new ProjectDAO();
        beneficiaryDAO = new BeneficiaryDAO();
        inventoryDAO = new InventoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get counts for the dashboard cards
            BigDecimal totalDonations = donationDAO.getTotalDonations();
            int totalProjects = projectDAO.getTotalProjects();
            int totalBeneficiaries = beneficiaryDAO.getTotalBeneficiaries();
            int totalInventoryItems = inventoryDAO.getTotalInventoryItems();

            // Set attributes for dashboard cards
            request.setAttribute("totalDonations", totalDonations);
            request.setAttribute("totalProjects", totalProjects);
            request.setAttribute("totalBeneficiaries", totalBeneficiaries);
            request.setAttribute("totalInventoryItems", totalInventoryItems);

            // Forward to admin dashboard JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("admin-dashboard.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private BigDecimal getTotalDonations() throws SQLException {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT COALESCE(SUM(amount), 0) FROM donations");
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    private BigDecimal getDonationsGuaranteed() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // 1. Get connection
            conn = DBConnection.getConnection();
            System.out.println("DB Connection successful: " + conn);

            // 2. Execute simple query
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT COALESCE(SUM(amount), 0) FROM donations");

            // 3. Return result
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;

        } catch (SQLException e) {
            System.err.println("DATABASE ERROR: " + e.getMessage());
            return new BigDecimal("15000.00"); // Fallback value
        } finally {
            // 4. Cleanup resources
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("register".equals(action)) {
            handleRegistration(request, response);
        } else if ("forgot-password".equals(action)) {
            handleForgotPassword(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = "admin"; // Default role for admin dashboard registrations

            // Check if user exists
            if (userDAO.findByUsername(username) != null) {
                request.setAttribute("error", "Username already exists");
                doGet(request, response);
                return;
            }

            // Create new user
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setRole(role);
            Connection conn = DBConnection.getConnection();

            if (userDAO.addUser(user,conn)) {
                request.setAttribute("message", "Registration successful!");
            } else {
                request.setAttribute("error", "Registration failed");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        doGet(request, response);
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            User user = userDAO.findByEmail(email);

            if (user != null) {
                String token = userDAO.createPasswordResetToken(user.getUserId());
                String resetLink = request.getRequestURL().toString()
                        .replace("dashboard", "reset-password") + "?token=" + token;

                EmailUtil.sendPasswordResetEmail(user.getEmail(), resetLink);
                request.setAttribute("message", "Password reset link sent to your email");
            } else {
                request.setAttribute("error", "No account found with that email");
            }
        } catch (SQLException | jakarta.mail.MessagingException e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
        }
        doGet(request, response);
    }
}