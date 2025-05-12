package com.welfair.servlet;

import com.welfair.dao.InventoryDAO;
import com.welfair.model.Inventory;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {
    private InventoryDAO inventoryDAO;

    @Override
    public void init() {
        inventoryDAO = new InventoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("new".equals(action)) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/inventory/form.jsp");
            dispatcher.forward(request, response);
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("item_id"));
            Inventory item = inventoryDAO.getInventoryItemById(id);
            request.setAttribute("item", item);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/inventory/form.jsp");
            dispatcher.forward(request, response);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("item_id"));
            inventoryDAO.deleteInventoryItem(id);
            response.sendRedirect(request.getContextPath() + "/admin-table?table=inventory");
        } else {
            List<Inventory> items = inventoryDAO.getAllInventoryItems();
            request.setAttribute("items", items);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/inventory/list.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = request.getParameter("item_id") != null && !request.getParameter("item_id").isEmpty()
                ? Integer.parseInt(request.getParameter("item_id")) : 0;

        String name = request.getParameter("name");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String unit = request.getParameter("unit");

        Inventory item = new Inventory(id, name, quantity, unit);

        if (id == 0) {
            inventoryDAO.addInventoryItem(item);
        } else {
            inventoryDAO.updateInventoryItem(item);
        }

        response.sendRedirect(request.getContextPath() + "/admin-table?table=inventory");
    }
}
