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

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        if (!isValidRole(role)) {
            response.sendRedirect("index.jsp");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String expectedRole = request.getParameter("role");

        if (!isValidRole(expectedRole)) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            User user = userDao.findByUsername(username);

            if (user != null &&
                    PasswordUtil.checkPassword(password, user.getPassword()) &&
                    user.getRole().equalsIgnoreCase(expectedRole)) {

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                redirectToDashboard(response, user.getRole().toLowerCase());
            } else {
                handleInvalidCredentials(request, response, expectedRole);
            }
        } catch (SQLException e) {
            handleDatabaseError(request, response, expectedRole, e);
        }
    }

    private boolean isValidRole(String role) {
        return role != null && (role.equalsIgnoreCase("admin") ||
                role.equalsIgnoreCase("employee") ||
                role.equalsIgnoreCase("donor") ||
                role.equalsIgnoreCase("volunteer"));
    }

    private void redirectToDashboard(HttpServletResponse response, String role) throws IOException {
        switch (role) {
            case "admin":
                response.sendRedirect("admin-dashboard.jsp");
                break;
            case "employee":
                response.sendRedirect("employee-dashboard.jsp");
                break;
            case "donor":
                response.sendRedirect("donor-dashboard.jsp");
                break;
            case "volunteer":
                response.sendRedirect("volunteer-dashboard.jsp");
                break;
            default:
                response.sendRedirect("dashboard.jsp");
        }
    }

    private void handleInvalidCredentials(HttpServletRequest request,
                                          HttpServletResponse response,
                                          String role)
            throws ServletException, IOException {
        request.setAttribute("error", "Invalid username, password, or role");
        request.setAttribute("role", role);
        request.getRequestDispatcher("/login.jsp?role=" + role).forward(request, response);
    }

    private void handleDatabaseError(HttpServletRequest request,
                                     HttpServletResponse response,
                                     String role, Exception e)
            throws ServletException, IOException {
        request.setAttribute("error", "Database error: " + e.getMessage());
        request.setAttribute("role", role);
        request.getRequestDispatcher("/login.jsp?role=" + role).forward(request, response);
    }
}