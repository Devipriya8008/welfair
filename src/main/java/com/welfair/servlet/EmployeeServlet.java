package com.welfair.servlet;

import com.welfair.dao.EmployeeDAO;
import com.welfair.model.Employee;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "EmployeeServlet", urlPatterns = {"/employees"})
public class EmployeeServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action == null) {
                listEmployees(request, response);
            } else {
                switch (action) {
                    case "new":
                        showForm(request, response, new Employee());
                        break;
                    case "edit":
                        showEditForm(request, response);
                        break;
                    case "delete":
                        deleteEmployee(request, response);
                        break;
                    default:
                        listEmployees(request, response);
                }
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("update".equals(action)) {
                updateEmployee(request, response);
            } else {
                addEmployee(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        request.setAttribute("employees", employeeDAO.getAllEmployees());
        request.getRequestDispatcher("/WEB-INF/views/employee/list.jsp")
                .forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Employee employee)
            throws ServletException, IOException {
        request.setAttribute("employee", employee);
        request.setAttribute("action", employee.getEmpId() == 0 ? "create" : "update");
        request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp")
                .forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Employee employee = employeeDAO.getEmployeeById(id);
        if (employee != null) {
            showForm(request, response, employee);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void addEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        Employee emp = new Employee();
        populateEmployeeFromRequest(emp, request);

        // Validate email uniqueness
        if (employeeDAO.emailExists(emp.getEmail(), 0)) {
            request.setAttribute("error", "Email already exists");
            showForm(request, response, emp);
            return;
        }

        if (employeeDAO.addEmployee(emp)) {
            response.sendRedirect("employees");
        } else {
            request.setAttribute("error", "Failed to add employee");
            showForm(request, response, emp);
        }
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Employee emp = employeeDAO.getEmployeeById(id);

        if (emp == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String originalEmail = emp.getEmail();
        populateEmployeeFromRequest(emp, request);

        // Check if email was changed and now conflicts
        if (!originalEmail.equals(emp.getEmail()) &&
                employeeDAO.emailExists(emp.getEmail(), emp.getEmpId())) {
            request.setAttribute("error", "Email already exists");
            showForm(request, response, emp);
            return;
        }

        if (employeeDAO.updateEmployee(emp)) {
            response.sendRedirect("employees");
        } else {
            request.setAttribute("error", "Failed to update employee");
            showForm(request, response, emp);
        }
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (employeeDAO.deleteEmployee(id)) {
            response.sendRedirect("employees");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void populateEmployeeFromRequest(Employee emp, HttpServletRequest request) {
        emp.setUserId(Integer.parseInt(request.getParameter("user_id"))); // NEW
        emp.setName(request.getParameter("name"));
        emp.setPosition(request.getParameter("position"));
        emp.setPhone(request.getParameter("phone"));
        emp.setEmail(request.getParameter("email"));
    }
}