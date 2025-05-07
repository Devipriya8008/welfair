package com.welfair.servlet;

import com.welfair.dao.UserDAO;
import com.welfair.util.PasswordUtil;
import com.welfair.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private final UserDAO userDao = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        try {
            if (token == null || !userDao.isValidPasswordResetToken(token)) {
                request.setAttribute("error", "Invalid or expired password reset link.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            request.setAttribute("token", token);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            // Validate token
            if (!userDao.isValidPasswordResetToken(token)) {
                request.setAttribute("error", "Invalid or expired password reset link.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            // Validate passwords match
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            // Get user ID from token
            int userId = userDao.getUserIdFromResetToken(token);

            if (userId > 0) {
                // Debug output
                System.out.println("Updating password for user ID: " + userId);
                System.out.println("New password (plain): " + newPassword);

                // Update password
                if (userDao.updatePassword(userId, newPassword)) {
                    // Mark token as used
                    userDao.markTokenAsUsed(token);

                    // Debug - verify the updated password
                    User updatedUser = userDao.findByUserId(userId);
                    System.out.println("Updated user password hash: " + updatedUser.getPassword());
                    System.out.println("Verification test: " +
                            PasswordUtil.checkPassword(newPassword, updatedUser.getPassword()));

                    request.setAttribute("message", "Your password has been reset successfully.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Failed to reset password. Please try again.");
                    request.setAttribute("token", token);
                    request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Invalid password reset link.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
}