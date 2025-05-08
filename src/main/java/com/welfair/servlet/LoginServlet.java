package com.welfair.servlet;

import com.welfair.dao.UserDAO;
import com.welfair.model.User;
import com.welfair.util.PasswordUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDao = new UserDAO();

    // LoginServlet.java - Updated doGet method
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        if (!isValidRole(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Handle success message from registration
        String success = request.getParameter("success");
        if (success != null && success.equals("1")) {
            request.setAttribute("message", "Registration successful! Please login.");
        }

        request.setAttribute("role", role);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String expectedRole = request.getParameter("role");

        if (!isValidRole(expectedRole)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            User user = userDao.findByUsername(username);

            if (user != null &&
                    PasswordUtil.checkPassword(password, user.getPassword()) &&
                    user.getRole().equalsIgnoreCase(expectedRole)) {

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                redirectToDashboard(request, response, user.getRole().toLowerCase());
            } else {
                handleInvalidCredentials(request, response, expectedRole);
            }
        } catch (SQLException e) {
            handleDatabaseError(request, response, expectedRole, e);
        }
    }

    private boolean isValidRole(String role) {
        return role != null && (
                role.equalsIgnoreCase("admin") ||
                        role.equalsIgnoreCase("employee") ||
                        role.equalsIgnoreCase("donor") ||
                        role.equalsIgnoreCase("volunteer")
        );
    }

    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, String role)
            throws IOException {
        String contextPath = response.encodeRedirectURL(request.getContextPath());
        switch (role) {
            case "admin":
                response.sendRedirect(contextPath + "/admin-dashboard.jsp");
                break;
            case "employee":
                response.sendRedirect(contextPath + "/employee-dashboard.jsp");
                break;
            case "donor":
                response.sendRedirect(contextPath + "/donor-dashboard.jsp");
                break;
            case "volunteer":
                response.sendRedirect(contextPath + "/volunteer-dashboard.jsp");
                break;
            default:
                response.sendRedirect(contextPath + "/dashboard.jsp");
        }
    }

    private void handleInvalidCredentials(HttpServletRequest request,
                                          HttpServletResponse response,
                                          String role)
            throws ServletException, IOException {
        request.setAttribute("error", "Invalid username, password, or role");
        request.setAttribute("role", role);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    private void handleDatabaseError(HttpServletRequest request,
                                     HttpServletResponse response,
                                     String role, Exception e)
            throws ServletException, IOException {
        request.setAttribute("error", "Database error: " + e.getMessage());
        request.setAttribute("role", role);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
