package com.welfair.servlet;

import com.welfair.dao.FundAllocationDAO;
import com.welfair.model.FundAllocation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/fund_allocation/*")
public class FundAllocationServlet extends HttpServlet {
    private FundAllocationDAO fundDAO;

    @Override
    public void init() {
        fundDAO = new FundAllocationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();
        if (action == null || action.equals("/")) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/new":
                    showForm(request, response, null);
                    break;
                case "/edit":
                    String idParam = request.getParameter("id");
                    if (idParam != null) {
                        int editId = Integer.parseInt(idParam);
                        FundAllocation editFund = fundDAO.getFundAllocationById(editId);
                        showForm(request, response, editFund);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/funds/list");
                    }
                    break;
                case "/delete":
                    String delIdParam = request.getParameter("id");
                    if (delIdParam != null) {
                        int delId = Integer.parseInt(delIdParam);
                        fundDAO.deleteFundAllocation(delId);
                    }
                    response.sendRedirect(request.getContextPath() + "/funds/list");
                    break;
                case "/list":
                default:
                    request.setAttribute("funds", fundDAO.getAllFundAllocations());
                    request.getRequestDispatcher("/WEB-INF/views/funds/list.jsp").forward(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            FundAllocation fund = new FundAllocation();

            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                fund.setFundId(Integer.parseInt(idStr));
            }

            fund.setProjectId(Integer.parseInt(request.getParameter("projectId")));
            fund.setAmount(new BigDecimal(request.getParameter("amount")));
            fund.setDateAllocated(Date.valueOf(request.getParameter("dateAllocated")));

            if (fund.getFundId() > 0) {
                fundDAO.updateFundAllocation(fund);
            } else {
                fundDAO.addFundAllocation(fund);
            }

            response.sendRedirect(request.getContextPath() + "/funds/list");
        } catch (Exception e) {
            throw new ServletException("Form submission failed", e);
        }
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, FundAllocation fund)
            throws ServletException, IOException {
        request.setAttribute("fund", fund);
        request.getRequestDispatcher("/WEB-INF/views/funds/form.jsp").forward(request, response);
    }
}
