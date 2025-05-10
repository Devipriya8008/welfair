package com.welfair.servlet;

import com.welfair.dao.*;
import com.welfair.db.DBConnection;
import com.welfair.model.*;
import com.welfair.util.PasswordUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    private UserDAO userDao;
    private AdminDAO adminDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDAO();
        adminDao = new AdminDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            userDao.setConnection(conn);
            adminDao.setConnection(conn);

            // Get form data
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String department = request.getParameter("department");
            String role = "admin"; // Force role to admin

            // Validate inputs
            if (username == null || username.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    password == null || password.trim().isEmpty() ||
                    fullName == null || fullName.trim().isEmpty() ||
                    phone == null || phone.trim().isEmpty() ||
                    department == null || department.trim().isEmpty()) {
                forwardWithError(request, response, "All fields are required", conn);
                return;
            }

            if (!password.equals(confirmPassword)) {
                forwardWithError(request, response, "Passwords do not match", conn);
                return;
            }

            // Check if username exists
            if (userDao.findByUsername(username) != null) {
                forwardWithError(request, response, "Username already exists", conn);
                return;
            }

            // Create and save User
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setRole(role);

            if (!userDao.addUser(user)) {
                forwardWithError(request, response, "Failed to create user account", conn);
                return;
            }

            // Get the created user to get the generated ID
            User createdUser = userDao.findByUsername(username);
            if (createdUser == null) {
                conn.rollback();
                forwardWithError(request, response, "Failed to retrieve created user", conn);
                return;
            }

            // Create and save Admin
            Admin admin = new Admin();
            admin.setUserId(createdUser.getUserId());
            admin.setFullName(fullName);
            admin.setPhone(phone);
            admin.setDepartment(department);
            admin.setLastLogin(new Timestamp(System.currentTimeMillis()));

            if (!adminDao.addAdmin(admin)) {
                conn.rollback();
                forwardWithError(request, response, "Failed to create admin profile", conn);
                return;
            }

            // Commit transaction if everything succeeded
            conn.commit();

            // Redirect to login with success message
            response.sendRedirect(request.getContextPath() + "/login.jsp?registerSuccess=true&role=admin");

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                e.addSuppressed(ex);
            }
            forwardWithError(request, response, "Database error: " + e.getMessage(), conn);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }

    private void forwardWithError(HttpServletRequest request,
                                  HttpServletResponse response,
                                  String error,
                                  Connection conn) throws ServletException, IOException {
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException e) {
            error += " (Rollback failed: " + e.getMessage() + ")";
        }
        request.setAttribute("error", error);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}