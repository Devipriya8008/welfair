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

        try {
            User user = userDao.findByUsername(username);

            if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
                // Successful login
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                // Redirect based on role
                switch(user.getRole()) {
                    case "admin":
                        response.sendRedirect("admin-dashboard.jsp");
                        break;
                    case "employee":
                        response.sendRedirect("employee-dashboard.jsp");
                        break;
                    default:
                        response.sendRedirect("dashboard.jsp");
                }
            } else {
                // Failed login
                request.setAttribute("error", "Invalid username or password");
                doGet(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error. Please try again.");
            doGet(request, response);
        }
    }
}