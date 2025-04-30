package com.welfair.dao;

import com.welfair.model.VolunteerProject;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VolunteerProjectDAO {
    // Assign a volunteer to a project
    public void assignVolunteerToProject(VolunteerProject vp) {
        String sql = "INSERT INTO volunteer_projects (volunteer_id, project_id, role) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, vp.getVolunteerId());
            pstmt.setInt(2, vp.getProjectId());
            pstmt.setString(3, vp.getRole());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all volunteer-project assignments
    public List<VolunteerProject> getAllVolunteerProjects() {
        List<VolunteerProject> assignments = new ArrayList<>();
        String sql = "SELECT * FROM volunteer_projects";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                VolunteerProject vp = new VolunteerProject();
                vp.setVolunteerId(rs.getInt("volunteer_id"));
                vp.setProjectId(rs.getInt("project_id"));
                vp.setRole(rs.getString("role"));
                assignments.add(vp);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return assignments;
    }

    // Get volunteers by project ID
    public List<VolunteerProject> getVolunteersByProjectId(int projectId) {
        List<VolunteerProject> volunteers = new ArrayList<>();
        String sql = "SELECT * FROM volunteer_projects WHERE project_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, projectId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                VolunteerProject vp = new VolunteerProject();
                vp.setVolunteerId(rs.getInt("volunteer_id"));
                vp.setProjectId(rs.getInt("project_id"));
                vp.setRole(rs.getString("role"));
                volunteers.add(vp);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return volunteers;
    }

    // Update volunteer role in a project
    public void updateVolunteerRole(VolunteerProject vp) {
        String sql = "UPDATE volunteer_projects SET role = ? WHERE volunteer_id = ? AND project_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, vp.getRole());
            pstmt.setInt(2, vp.getVolunteerId());
            pstmt.setInt(3, vp.getProjectId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Remove a volunteer from a project
    public void removeVolunteerFromProject(int volunteerId, int projectId) {
        String sql = "DELETE FROM volunteer_projects WHERE volunteer_id = ? AND project_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, volunteerId);
            pstmt.setInt(2, projectId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}