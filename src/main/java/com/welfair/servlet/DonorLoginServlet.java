package com.welfair.servlet;

import com.welfair.dao.DonorDAO;
import com.welfair.dao.UserDAO;
import com.welfair.model.Donor;
import com.welfair.model.User;
import com.welfair.util.PasswordUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/donor-login")
public class DonorLoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userDAO.findByEmail(email);

            if (user != null && PasswordUtil.checkPassword(password, user.getPassword())
                    && "donor".equalsIgnoreCase(user.getRole())) {

                // Fetch the donor associated with the user
                DonorDAO donorDAO = new DonorDAO();
                Donor donor = donorDAO.getDonorByUserId(user.getUserId());

                if (donor == null) {
                    // Handle case where donor profile doesn't exist
                    request.setAttribute("error", "Donor profile not found.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("donor", donor); // Add donor to session

                // Redirect to the donor dashboard URL handled by a servlet
                response.sendRedirect(request.getContextPath() + "/donor-dashboard");
            } else {
                request.setAttribute("error", "Invalid credentials or not a donor.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            throw new ServletException("Login failed", e);
        }
    }
}
