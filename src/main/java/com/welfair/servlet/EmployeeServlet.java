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
    public void init() throws ServletException {
        try {
            employeeDAO = new EmployeeDAO();
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize EmployeeDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                // List all employees
                request.setAttribute("employees", employeeDAO.getAllEmployees());
                request.getRequestDispatcher("/WEB-INF/views/employee/list.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                // Show new employee form
                request.setAttribute("employee", new Employee());
                request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                // Show edit form
                int id = Integer.parseInt(request.getParameter("id"));
                Employee employee = employeeDAO.getEmployeeById(id);
                if (employee != null) {
                    request.setAttribute("employee", employee);
                    request.getRequestDispatcher("/WEB-INF/views/employee/form.jsp").forward(request, response);
                } else {
                    request.getSession().setAttribute("errorMessage", "Employee not found");
                    response.sendRedirect(request.getContextPath() + "/employees");
                }
            } else if ("delete".equals(action)) {
                // Handle delete
                int id = Integer.parseInt(request.getParameter("id"));
                if (employeeDAO.deleteEmployee(id)) {
                    request.getSession().setAttribute("successMessage", "Employee deleted successfully");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete employee");
                }
                response.sendRedirect(request.getContextPath() + "/employees");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid employee ID");
            response.sendRedirect(request.getContextPath() + "/employees");
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // MUST BE FIRST LINE IN doPost
        request.setCharacterEncoding("UTF-8");

        try {
            Employee employee = new Employee();
            employee.setName(request.getParameter("name"));
            employee.setPosition(request.getParameter("position"));
            employee.setPhone(request.getParameter("phone"));
            employee.setEmail(request.getParameter("email"));

            String empIdParam = request.getParameter("emp_id");
            boolean isUpdate = empIdParam != null && !empIdParam.isEmpty();

            if (isUpdate) {
                // Update existing employee
                employee.setEmpId(Integer.parseInt(empIdParam));
                if (employeeDAO.updateEmployee(employee)) {
                    request.getSession().setAttribute("successMessage", "Employee updated successfully");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to update employee");
                }
            } else {
                // Add new employee
                if (employeeDAO.addEmployee(employee)) {
                    request.getSession().setAttribute("successMessage", "Employee added successfully");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to add employee");
                }
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid employee ID");
        } catch (SQLException e) {
            request.getSession().setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/employees");
    }

    @Override
    public void destroy() {
        try {
            if (employeeDAO != null) {
                employeeDAO.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing EmployeeDAO: " + e.getMessage());
        }
    }
}