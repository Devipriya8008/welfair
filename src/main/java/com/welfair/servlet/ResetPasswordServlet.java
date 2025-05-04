package com.welfair.servlet;

import com.welfair.dao.UserDAO;
import com.welfair.util.PasswordUtil;
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
                // Hash new password
                String hashedPassword = PasswordUtil.hashPassword(newPassword);

                // Update password
                if (userDao.updatePassword(userId, hashedPassword)) {
                    // Mark token as used
                    userDao.markTokenAsUsed(token);

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
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
}