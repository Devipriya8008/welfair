package com.welfair.servlet;

import com.welfair.dao.AdminDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private AdminDAO adminDAO;

    @Override
    public void init() {
        try {
            adminDAO = new AdminDAO();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize AdminDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int totalDonations = adminDAO.getTotalDonations();
        int activeProjects = adminDAO.getActiveProjects();
        int inventoryItems = adminDAO.getInventoryStockCount();
        int beneficiaryCount = adminDAO.getBeneficiaryCount();

        request.setAttribute("totalDonations", totalDonations);
        request.setAttribute("activeProjects", activeProjects);
        request.setAttribute("inventoryItems", inventoryItems);
        request.setAttribute("beneficiaryCount", beneficiaryCount);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/admin-dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
