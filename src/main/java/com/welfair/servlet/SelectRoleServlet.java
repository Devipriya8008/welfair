package com.welfair.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/select-role")
public class SelectRoleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the role selection page
        request.getRequestDispatcher("/select-role.jsp").forward(request, response);
    }

    // Optional: Handle form submission with POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String selectedRole = request.getParameter("role");

        if (selectedRole == null || selectedRole.isEmpty()) {
            request.setAttribute("error", "Please select a role.");
            doGet(request, response);
            return;
        }

        // Redirect to registration with role pre-filled (optional)
        response.sendRedirect("register.jsp?role=" + selectedRole);
    }
}
