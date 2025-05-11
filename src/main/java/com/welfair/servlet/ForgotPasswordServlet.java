package com.welfair.servlet;

import com.welfair.dao.UserDAO;
import com.welfair.model.User;
import com.welfair.util.EmailUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.mail.MessagingException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private final UserDAO userDao = new UserDAO();

    // Configure this based on your environment
    private static final String BASE_URL = "http://localhost:8080/welfair";// Change this for production

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String role = request.getParameter("role"); // Get role parameter if exists

        try {
            User user = userDao.findByEmail(email);

            if (user != null && (role == null || user.getRole().equals(role))) {
                String token = userDao.createPasswordResetToken(user.getUserId());

                // Build reset link with context path
                String resetLink = request.getScheme() + "://" +
                        request.getServerName() +
                        (request.getServerPort() != 80 ? ":" + request.getServerPort() : "") +
                        request.getContextPath() +
                        "/reset-password?token=" + token;

                if (role != null) {
                    resetLink += "&role=" + role;
                }

                try {
                    EmailUtil.sendPasswordResetEmail(user.getEmail(), resetLink);
                    request.setAttribute("message", "Password reset link has been sent to your email.");
                } catch (MessagingException e) {
                    request.setAttribute("error", "Failed to send email. Please try again later.");
                }
            } else {
                String errorMsg = "No account found";
                if (role != null) {
                    errorMsg += " with that email address for the " + role + " role.";
                } else {
                    errorMsg += " with that email address.";
                }
                request.setAttribute("error", errorMsg);
            }

            if (role != null) {
                request.setAttribute("role", role);
            }
            doGet(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "An error occurred. Please try again.");
            doGet(request, response);
        }
    }
}