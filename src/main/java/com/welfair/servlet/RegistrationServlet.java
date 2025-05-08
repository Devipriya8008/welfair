package com.welfair.servlet;

import com.welfair.dao.*;
import com.welfair.db.DBConnection;
import com.welfair.model.*;
import com.welfair.util.PasswordUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
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
        donorDao = new DonorDAO();
        volunteerDao = new VolunteerDAO();
        employeeDao = new EmployeeDAO();
        adminDao = new AdminDAO();
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
        Connection conn = null;
        String role = request.getParameter("role");

        if (!isValidRole(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            userDao.setConnection(conn);
            donorDao.setConnection(conn);
            volunteerDao.setConnection(conn);
            employeeDao.setConnection(conn);
            adminDao.setConnection(conn);

            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String email = request.getParameter("email");

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

            if (userDao.findByUsername(username) != null) {
                forwardWithError(request, response, "Username already exists", role);
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setEmail(email);
            user.setRole(role);

            boolean isUserAdded = userDao.addUser(user);
            if (!isUserAdded) {
                forwardWithError(request, response, "Failed to register user", role);
                return;
            }

            User createdUser = userDao.findByUsername(username);
            if (createdUser == null) {
                forwardWithError(request, response, "Failed to retrieve registered user", role);
                return;
            }

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

            conn.commit();

            // Redirect to index.jsp with success parameter
            response.sendRedirect(
                    response.encodeRedirectURL(
                            request.getContextPath() + "/index.jsp?registerSuccess=true"
                    )
            );

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                e.addSuppressed(ex);
            }
            handleError(request, response, "Database error: " + e.getMessage(), role);
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                e.addSuppressed(ex);
            }
            handleError(request, response, "An unexpected error occurred: " + e.getMessage(), role);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
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