package com.welfair.dao;

import com.welfair.model.Employee;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {
    private Connection connection;

    public EmployeeDAO() {
        // Connection will be set by servlet
    }

    public void setConnection(Connection connection) {
        this.connection = connection;
    }

    private Connection getActiveConnection() throws SQLException {
        return connection != null ? connection : DBConnection.getConnection();
    }

    public boolean addEmployee(Employee emp) throws SQLException {
        String sql = "INSERT INTO employees (user_id, name, position, department, phone, email) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, emp.getUserId());
            pstmt.setString(2, emp.getName());
            pstmt.setString(3, emp.getPosition());
            //pstmt.setString(4, emp.getDepartment());
            pstmt.setString(5, emp.getPhone());
            pstmt.setString(6, emp.getEmail());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        emp.setEmpId(rs.getInt(1));
                    }
                }
                return true;
            }
            return false;
        }
    }

    public List<Employee> getAllEmployees() throws SQLException {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM employees ORDER BY name";

        try (Statement stmt = getActiveConnection().createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Employee emp = new Employee();
                emp.setEmpId(rs.getInt("emp_id"));
                emp.setUserId(rs.getInt("user_id"));
                emp.setName(rs.getString("name"));
                emp.setPosition(rs.getString("position"));
                //emp.setDepartment(rs.getString("department"));
                emp.setPhone(rs.getString("phone"));
                emp.setEmail(rs.getString("email"));
                employees.add(emp);
            }
        }
        return employees;
    }

    public Employee getEmployeeById(int id) throws SQLException {
        String sql = "SELECT * FROM employees WHERE emp_id = ?";
        Employee emp = null;

        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    emp = new Employee();
                    emp.setEmpId(rs.getInt("emp_id"));
                    emp.setUserId(rs.getInt("user_id"));
                    emp.setName(rs.getString("name"));
                    emp.setPosition(rs.getString("position"));
                    //emp.setDepartment(rs.getString("department"));
                    emp.setPhone(rs.getString("phone"));
                    emp.setEmail(rs.getString("email"));
                }
            }
        }
        return emp;
    }

    public boolean updateEmployee(Employee emp) throws SQLException {
        String sql = "UPDATE employees SET user_id=?, name=?, position=?, department=?, phone=?, email=? WHERE emp_id=?";

        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setInt(1, emp.getUserId());
            pstmt.setString(2, emp.getName());
            pstmt.setString(3, emp.getPosition());
            //pstmt.setString(4, emp.getDepartment());
            pstmt.setString(5, emp.getPhone());
            pstmt.setString(6, emp.getEmail());
            pstmt.setInt(7, emp.getEmpId());

            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteEmployee(int id) throws SQLException {
        String sql = "DELETE FROM employees WHERE emp_id=?";

        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean emailExists(String email, int excludeEmpId) throws SQLException {
        String sql = "SELECT 1 FROM employees WHERE email = ? AND emp_id != ?";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.setInt(2, excludeEmpId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public Employee getEmployeeByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM employees WHERE user_id = ?";
        Employee emp = null;

        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    emp = new Employee();
                    emp.setEmpId(rs.getInt("emp_id"));
                    emp.setUserId(rs.getInt("user_id"));
                    emp.setName(rs.getString("name"));
                    emp.setPosition(rs.getString("position"));
                    //emp.setDepartment(rs.getString("department"));
                    emp.setPhone(rs.getString("phone"));
                    emp.setEmail(rs.getString("email"));
                }
            }
        }
        return emp;
    }
}