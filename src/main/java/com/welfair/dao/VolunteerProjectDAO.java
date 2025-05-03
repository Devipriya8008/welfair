package com.welfair.dao;

import com.welfair.model.VolunteerProject;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VolunteerProjectDAO {
    // Add these methods to your VolunteerProjectDAO class
    public boolean volunteerExists(int volunteerId) {
        String sql = "SELECT 1 FROM volunteers WHERE volunteer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, volunteerId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean projectExists(int projectId) {
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
    // Add a new volunteer-project association
    public void addVolunteerProject(VolunteerProject vp) {
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

    // Get all volunteer-project associations
    public List<VolunteerProject> getAllVolunteerProjects() {
        List<VolunteerProject> vps = new ArrayList<>();
        String sql = "SELECT * FROM volunteer_projects";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                VolunteerProject vp = new VolunteerProject();
                vp.setVolunteerId(rs.getInt("volunteer_id"));
                vp.setProjectId(rs.getInt("project_id"));
                vp.setRole(rs.getString("role"));
                vps.add(vp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vps;
    }

    // Get volunteer-project by IDs
    public VolunteerProject getVolunteerProject(int volunteerId, int projectId) {
        VolunteerProject vp = null;
        String sql = "SELECT * FROM volunteer_projects WHERE volunteer_id = ? AND project_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, volunteerId);
            pstmt.setInt(2, projectId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                vp = new VolunteerProject();
                vp.setVolunteerId(rs.getInt("volunteer_id"));
                vp.setProjectId(rs.getInt("project_id"));
                vp.setRole(rs.getString("role"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vp;
    }

    // Update volunteer-project
    public void updateVolunteerProject(VolunteerProject vp) {
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

    // Delete volunteer-project
    public void deleteVolunteerProject(int volunteerId, int projectId) {
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