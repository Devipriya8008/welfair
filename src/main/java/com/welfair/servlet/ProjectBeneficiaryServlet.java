package com.welfair.servlet;

import com.welfair.dao.ProjectBeneficiaryDAO;
import com.welfair.model.ProjectBeneficiary;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProjectBeneficiaryServlet", urlPatterns = {"/project-beneficiaries"})
public class ProjectBeneficiaryServlet extends HttpServlet {
    private ProjectBeneficiaryDAO dao;

    @Override
    public void init() {
        dao = new ProjectBeneficiaryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("new".equals(action)) {
            request.setAttribute("assignment", new ProjectBeneficiary());
            request.getRequestDispatcher("/WEB-INF/views/project_beneficiary/form.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            int beneficiaryId = Integer.parseInt(request.getParameter("beneficiaryId"));
            // Reuse assignmentExists logic (you can enhance DAO to return ProjectBeneficiary)
            ProjectBeneficiary pb = new ProjectBeneficiary(projectId, beneficiaryId, null); // Set dummy date or fetch from DB
            request.setAttribute("assignment", pb);
            request.getRequestDispatcher("/WEB-INF/views/project_beneficiary/form.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            int beneficiaryId = Integer.parseInt(request.getParameter("beneficiaryId"));
            dao.deleteAssignment(projectId, beneficiaryId);
            response.sendRedirect(request.getContextPath() + "/project-beneficiaries");
        } else {
            List<Map<String, Object>> assignments = dao.getAllAssignments();
            request.setAttribute("assignments", assignments);
            request.getRequestDispatcher("/WEB-INF/views/project_beneficiary/list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int projectId = Integer.parseInt(request.getParameter("projectId"));
        int beneficiaryId = Integer.parseInt(request.getParameter("beneficiaryId"));
        Date dateAssigned = Date.valueOf(request.getParameter("dateAssigned"));

        ProjectBeneficiary pb = new ProjectBeneficiary(projectId, beneficiaryId, dateAssigned);
        dao.saveAssignment(pb);
        response.sendRedirect(request.getContextPath() + "/project-beneficiaries");
    }
}
