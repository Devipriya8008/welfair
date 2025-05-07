package com.welfair.servlet;

import com.welfair.dao.AdminDAO;
import com.welfair.dao.UserDAO;
import com.welfair.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import com.welfair.util.EmailUtil;
import com.welfair.util.PasswordUtil;

import javax.mail.MessagingException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private AdminDAO adminDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            adminDAO = new AdminDAO();
            userDAO = new UserDAO();
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int totalDonations = adminDAO.getTotalDonations();
        int activeProjects = adminDAO.getActiveProjects();
        int inventoryItems = adminDAO.getInventoryStockCount();
        int beneficiaryCount = adminDAO.getBeneficiaryCount();

        request.setAttribute("totalDonations", totalDonations);
        request.setAttribute("activeProjects", activeProjects);
        request.setAttribute("inventoryItems", inventoryItems);
        request.setAttribute("beneficiaryCount", beneficiaryCount);

        request.getRequestDispatcher("/WEB-INF/admin-dashboard.jsp").forward(request, response);
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

            if (userDAO.addUser(user)) {
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
        } catch (SQLException | MessagingException e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
        }
        doGet(request, response);
    }
}