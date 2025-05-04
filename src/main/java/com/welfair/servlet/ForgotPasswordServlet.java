package com.welfair.servlet;

import com.welfair.dao.UserDAO;
import com.welfair.model.User;
import com.welfair.util.EmailUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import javax.mail.MessagingException;

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

        try {
            User user = userDao.findByEmail(email);

            if (user != null) {
                String token = userDao.createPasswordResetToken(user.getUserId());

                // Build proper reset link
                String resetLink = BASE_URL + "/reset-password?token=" + token;

                try {
                    EmailUtil.sendPasswordResetEmail(user.getEmail(), resetLink);
                    request.setAttribute("message", "Password reset link has been sent to your email.");
                } catch (MessagingException e) {
                    request.setAttribute("error", "Failed to send email. Please try again later.");
                    e.printStackTrace();
                }
            } else {
                request.setAttribute("error", "No account found with that email address.");
            }

            doGet(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "An error occurred. Please try again.");
            doGet(request, response);
        }
    }
}