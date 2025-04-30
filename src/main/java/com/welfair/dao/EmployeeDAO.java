package com.welfair.dao;

import com.welfair.model.Employee;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {
    // Add a new employee
    public void addEmployee(Employee employee) {
        String sql = "INSERT INTO employees (name, position, phone, email) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, employee.getName());
            pstmt.setString(2, employee.getPosition());
            pstmt.setString(3, employee.getPhone());
            pstmt.setString(4, employee.getEmail());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all employees
    public List<Employee> getAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM employees";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Employee employee = new Employee();
                employee.setEmpId(rs.getInt("emp_id"));
                employee.setName(rs.getString("name"));
                employee.setPosition(rs.getString("position"));
                employee.setPhone(rs.getString("phone"));
                employee.setEmail(rs.getString("email"));
                employees.add(employee);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employees;
    }

    // Get employee by ID
    public Employee getEmployeeById(int id) {
        Employee employee = null;
        String sql = "SELECT * FROM employees WHERE emp_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                employee = new Employee();
                employee.setEmpId(rs.getInt("emp_id"));
                employee.setName(rs.getString("name"));
                employee.setPosition(rs.getString("position"));
                employee.setPhone(rs.getString("phone"));
                employee.setEmail(rs.getString("email"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employee;
    }

    // Update employee
    public void updateEmployee(Employee employee) {
        String sql = "UPDATE employees SET name = ?, position = ?, phone = ?, email = ? WHERE emp_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, employee.getName());
            pstmt.setString(2, employee.getPosition());
            pstmt.setString(3, employee.getPhone());
            pstmt.setString(4, employee.getEmail());
            pstmt.setInt(5, employee.getEmpId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete employee
    public void deleteEmployee(int id) {
        String sql = "DELETE FROM employees WHERE emp_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}