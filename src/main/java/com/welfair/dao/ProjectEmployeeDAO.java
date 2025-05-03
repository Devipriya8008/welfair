package com.welfair.dao;

import com.welfair.model.ProjectEmployee;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProjectEmployeeDAO {
    // Add a new project-employee association
    public void addProjectEmployee(ProjectEmployee pe) {
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

    // Get all project-employee associations
    public List<ProjectEmployee> getAllProjectEmployees() {
        List<ProjectEmployee> pes = new ArrayList<>();
        String sql = "SELECT * FROM project_employees";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                ProjectEmployee pe = new ProjectEmployee();
                pe.setEmpId(rs.getInt("emp_id"));
                pe.setProjectId(rs.getInt("project_id"));
                pe.setRole(rs.getString("role"));
                pes.add(pe);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pes;
    }

    // Get project-employee by IDs
    public ProjectEmployee getProjectEmployee(int empId, int projectId) {
        ProjectEmployee pe = null;
        String sql = "SELECT * FROM project_employees WHERE emp_id = ? AND project_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, empId);
            pstmt.setInt(2, projectId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                pe = new ProjectEmployee();
                pe.setEmpId(rs.getInt("emp_id"));
                pe.setProjectId(rs.getInt("project_id"));
                pe.setRole(rs.getString("role"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pe;
    }

    // Update project-employee
    public void updateProjectEmployee(ProjectEmployee pe) {
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

    // Delete project-employee
    public void deleteProjectEmployee(int empId, int projectId) {
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

    // Validation methods
    public boolean employeeExists(int empId) {
        String sql = "SELECT 1 FROM employees WHERE emp_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, empId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean projectExistsForEmployee(int projectId) {
        String sql = "SELECT 1 FROM projects WHERE project_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, projectId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}