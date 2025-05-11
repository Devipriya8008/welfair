package com.welfair.servlet;

import com.welfair.dao.InventoryUsageDAO;
import com.welfair.model.InventoryUsage;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/inventory_usage")
public class InventoryUsageServlet extends HttpServlet {
    private InventoryUsageDAO usageDAO;

    @Override
    public void init() {
        usageDAO = new InventoryUsageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.setAttribute("usage", null); // for new form
                RequestDispatcher addDispatcher = request.getRequestDispatcher("/WEB-INF/views/inventory_usage/form.jsp");
                addDispatcher.forward(request, response);
                break;

            case "edit":
                int editItemId = Integer.parseInt(request.getParameter("item_id"));
                int editProjectId = Integer.parseInt(request.getParameter("project_id"));
                InventoryUsage usage = usageDAO.getInventoryUsageById(editItemId, editProjectId);
                request.setAttribute("usage", usage);
                RequestDispatcher editDispatcher = request.getRequestDispatcher("/WEB-INF/views/inventory_usage/form.jsp");
                editDispatcher.forward(request, response);
                break;

            case "delete":
                int delItemId = Integer.parseInt(request.getParameter("item_id"));
                int delProjectId = Integer.parseInt(request.getParameter("project_id"));
                usageDAO.deleteInventoryUsage(delItemId, delProjectId);
                response.sendRedirect("inventory_usage");
                break;

            default:
                List<InventoryUsage> usageList = usageDAO.getAllInventoryUsage();
                request.setAttribute("usages", usageList);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/inventory_usage/list.jsp");
                dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int projectId = Integer.parseInt(request.getParameter("project_id"));
        int quantityUsed = Integer.parseInt(request.getParameter("quantity_used"));

        InventoryUsage usage = new InventoryUsage(itemId, projectId, quantityUsed);

        // Update or insert
        if (usageDAO.exists(itemId, projectId)) {
            usageDAO.updateInventoryUsage(usage);
        } else {
            usageDAO.addInventoryUsage(usage);
        }

        response.sendRedirect("inventory_usage");
    }
}
