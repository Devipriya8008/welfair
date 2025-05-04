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
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String expectedRole = request.getParameter("role");

        try {
            User user = userDao.findByUsername(username);

            if (user != null &&
                    PasswordUtil.checkPassword(password, user.getPassword()) &&
                    user.getRole().equalsIgnoreCase(expectedRole)) {

                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                switch (user.getRole().toLowerCase()) {
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
            } else {
                request.setAttribute("error", "Invalid username, password, or role.");
                request.getRequestDispatcher("/login.jsp?role=" + expectedRole).forward(request, response);
            }

        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp?role=" + expectedRole).forward(request, response);
        }
    }

}