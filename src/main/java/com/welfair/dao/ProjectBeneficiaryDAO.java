package com.welfair.dao;

import com.welfair.model.ProjectBeneficiary;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProjectBeneficiaryDAO {
    // Assign a beneficiary to a project
    public void assignBeneficiaryToProject(ProjectBeneficiary pb) {
        String sql = "INSERT INTO project_beneficiaries (project_id, beneficiary_id, date_assigned) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pb.getProjectId());
            pstmt.setInt(2, pb.getBeneficiaryId());
            pstmt.setDate(3, pb.getDateAssigned());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all project-beneficiary assignments
    public List<ProjectBeneficiary> getAllProjectBeneficiaries() {
        List<ProjectBeneficiary> assignments = new ArrayList<>();
        String sql = "SELECT * FROM project_beneficiaries";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                ProjectBeneficiary pb = new ProjectBeneficiary();
                pb.setProjectId(rs.getInt("project_id"));
                pb.setBeneficiaryId(rs.getInt("beneficiary_id"));
                pb.setDateAssigned(rs.getDate("date_assigned"));
                assignments.add(pb);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return assignments;
    }

    // Get assignments by project ID
    public List<ProjectBeneficiary> getAssignmentsByProjectId(int projectId) {
        List<ProjectBeneficiary> assignments = new ArrayList<>();
        String sql = "SELECT * FROM project_beneficiaries WHERE project_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, projectId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ProjectBeneficiary pb = new ProjectBeneficiary();
                pb.setProjectId(rs.getInt("project_id"));
                pb.setBeneficiaryId(rs.getInt("beneficiary_id"));
                pb.setDateAssigned(rs.getDate("date_assigned"));
                assignments.add(pb);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return assignments;
    }

    // Remove a beneficiary from a project
    public void removeBeneficiaryFromProject(int projectId, int beneficiaryId) {
        String sql = "DELETE FROM project_beneficiaries WHERE project_id = ? AND beneficiary_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, projectId);
            pstmt.setInt(2, beneficiaryId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}