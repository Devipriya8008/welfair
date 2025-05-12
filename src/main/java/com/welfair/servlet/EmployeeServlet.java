package com.welfair.servlet;

import com.welfair.dao.*;
import com.welfair.db.DBConnection;
import com.welfair.model.*;
import com.welfair.util.PasswordUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet(name = "EmployeeServlet", urlPatterns = {"/employees"})
public class EmployeeServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        userDAO = new UserDAO();
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
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Get employee details from form
            String name = request.getParameter("name");
            String email = request.getParameter("email");

            // Validate email uniqueness
            if (userDAO.emailExists(email, conn)) {
                conn.rollback();
                request.setAttribute("error", "Email already exists in system");
                showForm(request, response, new Employee());
                return;
            }

            // Create User first - using the employee's name as username
            User user = new User();
            user.setUsername(name); // Using the name directly as username
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword("TempPassword123!")); // Temporary password
            user.setRole("employee");

            if (!userDAO.addUser(user, conn)) {
                conn.rollback();
                request.setAttribute("error", "Failed to create user account");
                showForm(request, response, new Employee());
                return;
            }

            // Now create Employee with the new user_id
            Employee emp = new Employee();
            populateEmployeeFromRequest(emp, request);
            emp.setUserId(user.getUserId()); // Set the user_id from the newly created user

            if (employeeDAO.addEmployee(emp, conn)) {
                conn.commit();
                redirectToProperView(request, response);
            } else {
                conn.rollback();
                request.setAttribute("error", "Failed to add employee");
                showForm(request, response, emp);
            }
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            request.setAttribute("error", "Error creating employee: " + e.getMessage());
            showForm(request, response, new Employee());
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Employee emp = employeeDAO.getEmployeeById(id);

        populateEmployeeFromRequest(emp, request);
        emp.setBio(request.getParameter("bio"));
        emp.setPhotoUrl(request.getParameter("photo_url"));

        if (employeeDAO.updateEmployee(emp)) {
            response.sendRedirect(request.getContextPath() + "/admin-table?table=employees");
        } else {
            // Error handling
        }
    }

    private void redirectToProperView(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String fromAdmin = request.getParameter("fromAdmin");
        if ("true".equals(fromAdmin)) {
            response.sendRedirect(request.getContextPath() + "/admin-table?table=employees");
        } else {
            response.sendRedirect(request.getContextPath() + "/employees");
        }
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (employeeDAO.deleteEmployee(id)) {
            response.sendRedirect(request.getContextPath() + "/admin-table?table=employees");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void populateEmployeeFromRequest(Employee emp, HttpServletRequest request) {
        // Only set user_id if it's not already set (for new employees)
        if (emp.getUserId() == 0) {
            String userIdParam = request.getParameter("user_id");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                emp.setUserId(Integer.parseInt(userIdParam));
            }
        }
        emp.setName(request.getParameter("name"));
        emp.setPosition(request.getParameter("position"));
        emp.setPhone(request.getParameter("phone"));
        emp.setEmail(request.getParameter("email"));
        emp.setBio(request.getParameter("bio"));
        emp.setPhotoUrl(request.getParameter("photo_url"));
    }
}