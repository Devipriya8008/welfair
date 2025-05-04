package com.welfair.servlet;

import com.welfair.dao.UserDAO;
import com.welfair.dao.DonorDAO;
import com.welfair.dao.VolunteerDAO;
import com.welfair.dao.EmployeeDAO;
import com.welfair.model.User;
import com.welfair.model.Donor;
import com.welfair.model.Volunteer;
import com.welfair.model.Employee;
import com.welfair.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    private UserDAO userDao;
    private DonorDAO donorDao;
    private VolunteerDAO volunteerDao;
    private EmployeeDAO employeeDao;

    @Override
    public void init() throws ServletException {
        super.init();
        userDao = new UserDAO();
        try {
            donorDao = new DonorDAO();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        try {
            volunteerDao = new VolunteerDAO();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        employeeDao = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to registration page with role parameter
        String role = request.getParameter("role");
        if (role == null || role.isEmpty()) {
            response.sendRedirect("select-role.jsp");
            return;
        }
        request.getRequestDispatcher("/register.jsp?role=" + role).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Read form fields
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        // Validate input
        if (username == null || username.isEmpty() ||
                password == null || password.isEmpty() ||
                confirmPassword == null || confirmPassword.isEmpty() ||
                email == null || email.isEmpty() ||
                role == null || role.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("register.jsp?role=" + role).forward(request, response);
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp?role=" + role).forward(request, response);
            return;
        }

        // Validate email format
        if (!email.matches("^[\\w-_.+]*[\\w-_.]@([\\w]+\\.)+[\\w]+[\\w]$")) {
            request.setAttribute("error", "Invalid email format.");
            request.getRequestDispatcher("register.jsp?role=" + role).forward(request, response);
            return;
        }

        // Create user object
        User user = new User();
        user.setUsername(username);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setEmail(email);
        user.setRole(role.toLowerCase());

        try {
            // Check if username already exists
            if (userDao.findByUsername(username) != null) {
                request.setAttribute("error", "Username already taken.");
                request.getRequestDispatcher("register.jsp?role=" + role).forward(request, response);
                return;
            }

            // Check if email already exists
            if (userDao.findByEmail(email) != null) {
                request.setAttribute("error", "Email already registered.");
                request.getRequestDispatcher("register.jsp?role=" + role).forward(request, response);
                return;
            }

            // Register user
            boolean isUserAdded = userDao.addUser(user);
            if (!isUserAdded) {
                request.setAttribute("error", "Failed to register user.");
                request.getRequestDispatcher("register.jsp?role=" + role).forward(request, response);
                return;
            }

            // Get the newly created user to get the ID
            User createdUser = userDao.findByUsername(username);
            if (createdUser == null) {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("register.jsp?role=" + role).forward(request, response);
                return;
            }

            // Handle role-specific registration
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
                    emp.setPosition("Default Position");
                    emp.setUserId(createdUser.getUserId());
                    employeeDao.addEmployee(emp);
                    break;

                case "admin":
                    // No additional action needed for admin
                    break;

                default:
                    request.setAttribute("error", "Invalid role selected.");
                    request.getRequestDispatcher("register.jsp?role=" + role).forward(request, response);
                    return;
            }

            // Redirect to login with success message
            response.sendRedirect("login.jsp?role=" + role + "&success=Registration successful. Please login.");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp?role=" + role).forward(request, response);
        }
    }
}