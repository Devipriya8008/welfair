package com.welfair.servlet;

import com.welfair.dao.EmployeeDAO;
import com.welfair.model.Employee;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/team")
public class TeamServlet extends HttpServlet {
    private EmployeeDAO employeeDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.employeeDao = new EmployeeDAO(); // Initialize your DAO
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Employee> employees = employeeDao.getAllEmployees();

            request.setAttribute("employees", employees);
            request.getRequestDispatcher("/WEB-INF/views/team.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading team data");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}