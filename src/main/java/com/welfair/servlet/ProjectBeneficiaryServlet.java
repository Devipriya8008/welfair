package com.welfair.servlet;

import com.welfair.dao.ProjectBeneficiaryDAO;
import com.welfair.model.ProjectBeneficiary;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

@WebServlet("/project-beneficiary/*")
public class ProjectBeneficiaryServlet extends HttpServlet {
    private ProjectBeneficiaryDAO projectBeneficiaryDAO;

    @Override
    public void init() throws ServletException {
        projectBeneficiaryDAO = new ProjectBeneficiaryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            action = "/list"; // Default action if no path info is provided
        }

        try {
            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/insert":
                    insertProjectBeneficiary(request, response);
                    break;
                case "/delete":
                    deleteProjectBeneficiary(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateProjectBeneficiary(request, response);
                    break;
                case "/list":
                    listProjectBeneficiaries(request, response);
                    break;
                default:
                    listProjectBeneficiaries(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private void listProjectBeneficiaries(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> listProjectBeneficiary = projectBeneficiaryDAO.getAllAssignments();
        request.setAttribute("listProjectBeneficiary", listProjectBeneficiary);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int projectId = Integer.parseInt(request.getParameter("projectId"));
        int beneficiaryId = Integer.parseInt(request.getParameter("beneficiaryId"));
        ProjectBeneficiary existingProjectBeneficiary = new ProjectBeneficiary();
        existingProjectBeneficiary.setProjectId(projectId);
        existingProjectBeneficiary.setBeneficiaryId(beneficiaryId);
        request.setAttribute("projectBeneficiary", existingProjectBeneficiary);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertProjectBeneficiary(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int projectId = Integer.parseInt(request.getParameter("projectId"));
        int beneficiaryId = Integer.parseInt(request.getParameter("beneficiaryId"));
        Date dateAssigned = Date.valueOf(request.getParameter("dateAssigned"));

        ProjectBeneficiary newProjectBeneficiary = new ProjectBeneficiary(projectId, beneficiaryId, dateAssigned);
        projectBeneficiaryDAO.saveAssignment(newProjectBeneficiary);
        response.sendRedirect(request.getContextPath() + "/project-beneficiary/list");
    }

    private void updateProjectBeneficiary(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int projectId = Integer.parseInt(request.getParameter("projectId"));
        int beneficiaryId = Integer.parseInt(request.getParameter("beneficiaryId"));
        Date dateAssigned = Date.valueOf(request.getParameter("dateAssigned"));

        ProjectBeneficiary updatedProjectBeneficiary = new ProjectBeneficiary(projectId, beneficiaryId, dateAssigned);
        projectBeneficiaryDAO.saveAssignment(updatedProjectBeneficiary);
        response.sendRedirect(request.getContextPath() + "/project-beneficiary/list");
    }

    private void deleteProjectBeneficiary(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int projectId = Integer.parseInt(request.getParameter("projectId"));
        int beneficiaryId = Integer.parseInt(request.getParameter("beneficiaryId"));

        projectBeneficiaryDAO.deleteAssignment(projectId, beneficiaryId);
        response.sendRedirect(request.getContextPath() + "/project-beneficiary/list");
    }
}
