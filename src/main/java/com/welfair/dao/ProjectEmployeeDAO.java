package com.welfair.dao;

import com.welfair.model.Employee;
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

    public List<ProjectEmployee> getEmployeesByProject(int projectId) {
        List<ProjectEmployee> employees = new ArrayList<>();
        String sql = "SELECT pe.*, e.name, e.position, e.email, e.bio, e.photo_url " +
                "FROM project_employees pe " +
                "JOIN employees e ON pe.emp_id = e.emp_id " +
                "WHERE pe.project_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, projectId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ProjectEmployee pe = new ProjectEmployee();
                    Employee employee = new Employee();

                    // Set ProjectEmployee fields
                    pe.setProjectId(projectId);
                    pe.setRole(rs.getString("role"));

                    // Set Employee fields
                    employee.setEmpId(rs.getInt("emp_id"));
                    employee.setName(rs.getString("name"));
                    employee.setPosition(rs.getString("position"));
                    employee.setEmail(rs.getString("email"));
                    employee.setBio(rs.getString("bio"));
                    employee.setPhotoUrl(rs.getString("photo_url"));

                    pe.setEmployee(employee);
                    employees.add(pe);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching employees: " + e.getMessage());
            e.printStackTrace();
        }
        return employees;
    }
}