package com.welfair.servlet;

import com.welfair.dao.BeneficiaryDAO;
import com.welfair.model.Beneficiary;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "BeneficiaryServlet", urlPatterns = {"/beneficiaries"})
public class BeneficiaryServlet extends HttpServlet {
    private BeneficiaryDAO beneficiaryDAO;

    @Override
    public void init() throws ServletException {
        try {
            beneficiaryDAO = new BeneficiaryDAO();
        } catch (Exception e) {  // Catch any potential initialization errors
            throw new ServletException("Failed to initialize BeneficiaryDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                request.setAttribute("beneficiaries", beneficiaryDAO.getAllBeneficiaries());
                request.getRequestDispatcher("/WEB-INF/views/beneficiary/list.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                Beneficiary newBeneficiary = new Beneficiary();
                newBeneficiary.setBeneficiaryId(0);
                request.setAttribute("beneficiary", newBeneficiary);
                request.getRequestDispatcher("/WEB-INF/views/beneficiary/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Beneficiary beneficiary = beneficiaryDAO.getBeneficiaryById(id);
                if (beneficiary != null) {
                    request.setAttribute("beneficiary", beneficiary);
                    request.getRequestDispatcher("/WEB-INF/views/beneficiary/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Beneficiary not found with ID: " + id);
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                beneficiaryDAO.deleteBeneficiary(id);
                response.sendRedirect(request.getContextPath() + "/beneficiaries");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");
            Beneficiary beneficiary = new Beneficiary();

            // Set basic beneficiary info
            beneficiary.setName(request.getParameter("name"));
            beneficiary.setAge(Integer.parseInt(request.getParameter("age")));
            beneficiary.setGender(request.getParameter("gender"));
            beneficiary.setAddress(request.getParameter("address"));

            if ("update".equals(action)) {
                // Update existing beneficiary
                int beneficiaryId = Integer.parseInt(request.getParameter("beneficiary_id"));
                beneficiary.setBeneficiaryId(beneficiaryId);
                beneficiaryDAO.updateBeneficiary(beneficiary);
                response.sendRedirect(request.getContextPath() + "/beneficiaries");
            } else {
                // Add new beneficiary
                beneficiaryDAO.addBeneficiary(beneficiary);
                response.sendRedirect(request.getContextPath() + "/beneficiaries");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format");
            request.getRequestDispatcher("/WEB-INF/views/beneficiary/form.jsp").forward(request, response);
        }
    }
}