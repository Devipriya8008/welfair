package com.welfair.servlet;

import com.welfair.dao.*;
import com.welfair.model.*;
import com.welfair.util.PasswordUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    private UserDAO userDao;
    private DonorDAO donorDao;
    private VolunteerDAO volunteerDao;
    private EmployeeDAO employeeDao;
    private AdminDAO adminDao;

    @Override
    public void init() throws ServletException {
        super.init();
        userDao = new UserDAO();
        try {
            donorDao = new DonorDAO();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize DonorDAO", e);
        }
        try {
            volunteerDao = new VolunteerDAO();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize VolunteerDAO", e);
        }
        employeeDao = new EmployeeDAO();
        try {
            adminDao = new AdminDAO();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize AdminDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String role = request.getParameter("role");
            if (!isValidRole(role)) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }
            request.setAttribute("role", role);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "An error occurred while loading registration page", null);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");

        if (!isValidRole(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Common fields
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");

        // Validate input
        if (username == null || username.isEmpty() ||
                password == null || password.isEmpty() ||
                email == null || email.isEmpty()) {
            forwardWithError(request, response, "All fields are required", role);
            return;
        }

        if (!password.equals(confirmPassword)) {
            forwardWithError(request, response, "Passwords do not match", role);
            return;
        }

        // Role-specific validation
        if (role.equalsIgnoreCase("admin")) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String department = request.getParameter("department");

            if (fullName == null || fullName.isEmpty() ||
                    phone == null || phone.isEmpty() ||
                    department == null || department.isEmpty()) {
                forwardWithError(request, response, "All admin details are required", role);
                return;
            }
        }

        if (role.equalsIgnoreCase("employee")) {
            String position = request.getParameter("position");
            String department = request.getParameter("department");

            if (position == null || position.isEmpty() ||
                    department == null || department.isEmpty()) {
                forwardWithError(request, response, "All employee details are required", role);
                return;
            }
        }

        try {
            // Check if username exists
            if (userDao.findByUsername(username) != null) {
                forwardWithError(request, response, "Username already exists", role);
                return;
            }

            // Create user
            User user = new User();
            user.setUsername(username);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setEmail(email);
            user.setRole(role);

            // Add user
            boolean isUserAdded = userDao.addUser(user);
            if (!isUserAdded) {
                forwardWithError(request, response, "Failed to register user", role);
                return;
            }

            // Get user with ID
            User createdUser = userDao.findByUsername(username);
            if (createdUser == null) {
                forwardWithError(request, response, "Failed to retrieve registered user", role);
                return;
            }

            // Create role-specific entity
            switch (role.toLowerCase()) {
                case "donor":
                    Donor donor = new Donor();
                    donor.setName(username);
                    donor.setEmail(email);
                    donor.setUserId(createdUser.getUserId());
                    donorDao.saveDonor(donor);
                    break;

                case "volunteer":
                    Volunteer volunteer = new Volunteer();
                    volunteer.setName(username);
                    volunteer.setEmail(email);
                    volunteer.setUserId(createdUser.getUserId());
                    volunteerDao.addVolunteer(volunteer);
                    break;

                case "employee":
                    Employee emp = new Employee();
                    emp.setName(username);
                    emp.setEmail(email);
                    emp.setPosition(request.getParameter("position"));
                    //emp.setDepartment(request.getParameter("department"));
                    emp.setUserId(createdUser.getUserId());
                    employeeDao.addEmployee(emp);
                    break;

                case "admin":
                    Admin admin = new Admin();
                    admin.setUserId(createdUser.getUserId());
                    admin.setFullName(request.getParameter("fullName"));
                    admin.setPhone(request.getParameter("phone"));
                    admin.setDepartment(request.getParameter("department"));
                    admin.setLastLogin(new Timestamp(System.currentTimeMillis()));
                    adminDao.addAdmin(admin);
                    break;
            }

            // Redirect to login with success message
            response.sendRedirect(request.getContextPath() + "/login?success=1&role=" + role);

        } catch (SQLException e) {
            handleError(request, response, "Database error: " + e.getMessage(), role);
        } catch (Exception e) {
            handleError(request, response, "An unexpected error occurred: " + e.getMessage(), role);
        }
    }

    private boolean isValidRole(String role) {
        return role != null && (role.equalsIgnoreCase("admin") ||
                role.equalsIgnoreCase("employee") ||
                role.equalsIgnoreCase("donor") ||
                role.equalsIgnoreCase("volunteer"));
    }

    private void forwardWithError(HttpServletRequest request,
                                  HttpServletResponse response,
                                  String error,
                                  String role)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("role", role);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    private void handleError(HttpServletRequest request,
                             HttpServletResponse response,
                             String errorMessage,
                             String role)
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        if (role != null) {
            request.setAttribute("role", role);
        }
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
}