package com.welfair.servlet;

import com.welfair.dao.UserDAO;
import com.welfair.model.User;
import com.welfair.util.PasswordUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import com.welfair.db.DBConnection;
import java.sql.Connection;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDao = new UserDAO();

    @Override
    public void init() throws ServletException {
        userDao = new UserDAO();
    }

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
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            userDao.setConnection(conn);

            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
                request.setAttribute("error", "Username and password are required");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            User user = userDao.findByUsername(username);
            if (user == null || !PasswordUtil.checkPassword(password, user.getPassword())) {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            if (role != null && !role.equalsIgnoreCase(user.getRole())) {
                request.setAttribute("error", "You don't have permission to access this role");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            // Set both the user object and the individual attributes
            session.setAttribute("user", user);
            session.setAttribute("user_id", user.getUserId()); // Make sure User class has getId()
            session.setAttribute("role", user.getRole());

            // Use the redirectToDashboard method
            redirectToDashboard(request, response, user.getRole());

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
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
        HttpSession session = request.getSession();

        // Check for return to events
        if (session.getAttribute("returnToEvents") != null) {
            session.removeAttribute("returnToEvents");
            response.sendRedirect(contextPath + "/events1.jsp?filter=volunteer");
            return;
        }

        switch (role.toLowerCase()) {
            case "volunteer":
                response.sendRedirect(contextPath + "/volunteer-dashboard.jsp");
                break;
            case "admin":
                response.sendRedirect(contextPath + "/admin-dashboard.jsp");
                break;
            case "employee":
                response.sendRedirect(contextPath + "/employee-dashboard.jsp");
                break;
            case "donor":
                response.sendRedirect(contextPath + "/donor-dashboard.jsp");
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