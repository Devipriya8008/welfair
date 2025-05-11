package com.welfair.servlet;

import com.welfair.dao.EmployeeDAO;
import com.welfair.model.Employee;
import com.welfair.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/team")
public class TeamServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EmployeeDAO employeeDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.employeeDao = new EmployeeDAO();
        try {
            // Initialize the connection with debug logging
            System.out.println("Initializing database connection...");
            Connection connection = DBConnection.getConnection();
            System.out.println("Connection established: " + (connection != null && !connection.isClosed()));
            employeeDao.setConnection(connection);
        } catch (SQLException e) {
            System.err.println("Failed to initialize database connection: " + e.getMessage());
            throw new ServletException("Failed to initialize database connection", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("Fetching employees from database...");
            List<Employee> employees = employeeDao.getAllEmployees();

            // Debug output
            System.out.println("Number of employees fetched: " + employees.size());
            if (!employees.isEmpty()) {
                System.out.println("First employee: " + employees.get(0).getName());
            } else {
                System.out.println("No employees found in database");
            }

            request.setAttribute("employees", employees);
            request.getRequestDispatcher("/team.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("Database error in TeamServlet: " + e.getMessage());
            e.printStackTrace();

            // Create temporary test data if database fails
            List<Employee> testEmployees = createTestEmployees();
            request.setAttribute("employees", testEmployees);
            request.setAttribute("error", "Database error: Showing test data. " + e.getMessage());

            request.getRequestDispatcher("/team.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        try {
            if (employeeDao != null) {
                Connection connection = employeeDao.getActiveConnection();
                if (connection != null && !connection.isClosed()) {
                    System.out.println("Closing database connection...");
                    connection.close();
                }
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
        }
    }

    private List<Employee> createTestEmployees() {
        System.out.println("Creating test employee data...");
        List<Employee> testEmployees = new ArrayList<>();

        Employee emp1 = new Employee();
        emp1.setEmpId(1);
        emp1.setName("Test Employee 1");
        emp1.setPosition("Developer");
        emp1.setEmail("test1@example.com");
        emp1.setBio("Sample bio for test employee 1");
        emp1.setPhotoUrl("https://images.unsplash.com/photo-1534528741775-53994a69daeb");
        testEmployees.add(emp1);

        Employee emp2 = new Employee();
        emp2.setEmpId(2);
        emp2.setName("Test Employee 2");
        emp2.setPosition("Designer");
        emp2.setEmail("test2@example.com");
        emp2.setBio("Sample bio for test employee 2");
        testEmployees.add(emp2);

        return testEmployees;
    }
}