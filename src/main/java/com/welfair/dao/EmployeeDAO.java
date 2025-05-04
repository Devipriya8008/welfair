package com.welfair.dao;

import com.welfair.model.Employee;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    // Create employee
    public boolean addEmployee(Employee emp) {
        String sql = "INSERT INTO employees (user_id, name, position, phone, email) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, emp.getUserId()); // NEW
            pstmt.setString(2, emp.getName());
            pstmt.setString(3, emp.getPosition());
            pstmt.setString(4, emp.getPhone());
            pstmt.setString(5, emp.getEmail());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        emp.setEmpId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get all employees
    public List<Employee> getAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM employees ORDER BY name";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Employee emp = new Employee();
                emp.setEmpId(rs.getInt("emp_id"));
                emp.setUserId(rs.getInt("user_id")); // NEW
                emp.setName(rs.getString("name"));
                emp.setPosition(rs.getString("position"));
                emp.setPhone(rs.getString("phone"));
                emp.setEmail(rs.getString("email"));
                employees.add(emp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employees;
    }

    // Get employee by ID
    public Employee getEmployeeById(int id) {
        String sql = "SELECT * FROM employees WHERE emp_id = ?";
        Employee emp = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    emp = new Employee();
                    emp.setEmpId(rs.getInt("emp_id"));
                    emp.setUserId(rs.getInt("user_id")); // NEW
                    emp.setName(rs.getString("name"));
                    emp.setPosition(rs.getString("position"));
                    emp.setPhone(rs.getString("phone"));
                    emp.setEmail(rs.getString("email"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return emp;
    }

    // Update employee
    public boolean updateEmployee(Employee emp) {
        String sql = "UPDATE employees SET user_id=?, name=?, position=?, phone=?, email=? WHERE emp_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, emp.getUserId()); // NEW
            pstmt.setString(2, emp.getName());
            pstmt.setString(3, emp.getPosition());
            pstmt.setString(4, emp.getPhone());
            pstmt.setString(5, emp.getEmail());
            pstmt.setInt(6, emp.getEmpId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete employee
    public boolean deleteEmployee(int id) {
        String sql = "DELETE FROM employees WHERE emp_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Check if email exists (excluding current employee)
    public boolean emailExists(String email, int excludeEmpId) {
        String sql = "SELECT 1 FROM employees WHERE email = ? AND emp_id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.setInt(2, excludeEmpId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // NEW: Get employee by user ID
    public Employee getEmployeeByUserId(int userId) {
        String sql = "SELECT * FROM employees WHERE user_id = ?";
        Employee emp = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    emp = new Employee();
                    emp.setEmpId(rs.getInt("emp_id"));
                    emp.setUserId(rs.getInt("user_id"));
                    emp.setName(rs.getString("name"));
                    emp.setPosition(rs.getString("position"));
                    emp.setPhone(rs.getString("phone"));
                    emp.setEmail(rs.getString("email"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return emp;
    }
}