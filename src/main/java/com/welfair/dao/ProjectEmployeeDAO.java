package com.welfair.dao;

import com.welfair.model.ProjectEmployee;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProjectEmployeeDAO {
    // Assign an employee to a project
    public void assignEmployeeToProject(ProjectEmployee pe) {
        String sql = "INSERT INTO project_employees (emp_id, project_id, role) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pe.getEmpId());
            pstmt.setInt(2, pe.getProjectId());
            pstmt.setString(3, pe.getRole());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all employee-project assignments
    public List<ProjectEmployee> getAllProjectEmployees() {
        List<ProjectEmployee> assignments = new ArrayList<>();
        String sql = "SELECT * FROM project_employees";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                ProjectEmployee pe = new ProjectEmployee();
                pe.setEmpId(rs.getInt("emp_id"));
                pe.setProjectId(rs.getInt("project_id"));
                pe.setRole(rs.getString("role"));
                assignments.add(pe);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return assignments;
    }

    // Get employees by project ID
    public List<ProjectEmployee> getEmployeesByProjectId(int projectId) {
        List<ProjectEmployee> employees = new ArrayList<>();
        String sql = "SELECT * FROM project_employees WHERE project_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, projectId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ProjectEmployee pe = new ProjectEmployee();
                pe.setEmpId(rs.getInt("emp_id"));
                pe.setProjectId(rs.getInt("project_id"));
                pe.setRole(rs.getString("role"));
                employees.add(pe);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employees;
    }

    // Update employee role in a project
    public void updateEmployeeRole(ProjectEmployee pe) {
        String sql = "UPDATE project_employees SET role = ? WHERE emp_id = ? AND project_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, pe.getRole());
            pstmt.setInt(2, pe.getEmpId());
            pstmt.setInt(3, pe.getProjectId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Remove an employee from a project
    public void removeEmployeeFromProject(int empId, int projectId) {
        String sql = "DELETE FROM project_employees WHERE emp_id = ? AND project_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, empId);
            pstmt.setInt(2, projectId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}