package com.welfair.servlet;

import com.welfair.dao.UserDAO;
import com.welfair.dao.DonorDAO;
import com.welfair.dao.VolunteerDAO;
import com.welfair.dao.EmployeeDAO;
import com.welfair.dao.AdminDAO;
import com.welfair.model.User;
import com.welfair.model.Donor;
import com.welfair.model.Volunteer;
import com.welfair.model.Employee;
import com.welfair.model.Admin;
import com.welfair.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
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
            volunteerDao = new VolunteerDAO();
            adminDao = new AdminDAO();
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
        employeeDao = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        if (role == null || !(role.equalsIgnoreCase("donor") ||
                role.equalsIgnoreCase("volunteer") ||
                role.equalsIgnoreCase("employee") ||
                role.equalsIgnoreCase("admin"))) {
            response.sendRedirect("role-selection.jsp");
            return;
        }
        request.getRequestDispatcher("/register.jsp").forward(request, response);
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
        if (username == null || username.isEmpty() || password == null || password.isEmpty() ||
                email == null || email.isEmpty() || role == null || role.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Additional validation for admin role
        if (role.equalsIgnoreCase("admin")) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String department = request.getParameter("department");

            if (fullName == null || fullName.isEmpty() ||
                    phone == null || phone.isEmpty() ||
                    department == null || department.isEmpty()) {
                request.setAttribute("error", "All admin details are required.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setEmail(email);
        user.setRole(role);

        try {
            // Check if username already exists
            if (userDao.findByUsername(username) != null) {
                request.setAttribute("error", "Username already taken.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Register user
            boolean isUserAdded = userDao.addUser(user);
            if (!isUserAdded) {
                request.setAttribute("error", "Failed to register user.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            User createdUser = userDao.findByUsername(username); // Get user with ID

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
                    Admin admin = new Admin();
                    admin.setUserId(createdUser.getUserId());
                    admin.setFullName(request.getParameter("fullName"));
                    admin.setPhone(request.getParameter("phone"));
                    admin.setDepartment(request.getParameter("department"));
                    admin.setLastLogin(new Timestamp(System.currentTimeMillis()));
                    adminDao.addAdmin(admin);
                    break;

                default:
                    request.setAttribute("error", "Invalid role selected.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
            }

            response.sendRedirect("login.jsp?success=1&role=" + role);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}