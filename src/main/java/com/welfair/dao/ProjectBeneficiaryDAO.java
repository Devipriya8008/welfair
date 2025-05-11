package com.welfair.dao;

import com.welfair.db.DBConnection;
import com.welfair.model.ProjectBeneficiary;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProjectBeneficiaryDAO {

    public boolean saveAssignment(ProjectBeneficiary pb) {
        String sql;
        if (assignmentExists(pb.getProjectId(), pb.getBeneficiaryId())) {
            sql = "UPDATE project_beneficiaries SET date_assigned = ? WHERE project_id = ? AND beneficiary_id = ?";
        } else {
            sql = "INSERT INTO project_beneficiaries (project_id, beneficiary_id, date_assigned) VALUES (?, ?, ?)";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (assignmentExists(pb.getProjectId(), pb.getBeneficiaryId())) {
                pstmt.setDate(1, pb.getDateAssigned());
                pstmt.setInt(2, pb.getProjectId());
                pstmt.setInt(3, pb.getBeneficiaryId());
            } else {
                pstmt.setInt(1, pb.getProjectId());
                pstmt.setInt(2, pb.getBeneficiaryId());
                pstmt.setDate(3, pb.getDateAssigned());
            }

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error saving assignment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<ProjectBeneficiary> getAllProjectBeneficiaries() throws SQLException {
        List<ProjectBeneficiary> projectBeneficiaries = new ArrayList<>();
        String sql = "SELECT * FROM project_beneficiaries";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ProjectBeneficiary pb = new ProjectBeneficiary();
                pb.setProjectId(resultSet.getInt("project_id"));
                pb.setBeneficiaryId(resultSet.getInt("beneficiary_id"));
                pb.setDateAssigned(resultSet.getDate("date_assigned"));
                projectBeneficiaries.add(pb);
            }
        }
        return projectBeneficiaries;
    }

    public List<Map<String, Object>> getAllAssignments() {
        List<Map<String, Object>> assignments = new ArrayList<>();
        String sql = "SELECT pb.project_id, p.name as project_name, " +
                "pb.beneficiary_id, b.name as beneficiary_name, " +
                "pb.date_assigned " +
                "FROM project_beneficiaries pb " +
                "JOIN projects p ON pb.project_id = p.project_id " +
                "JOIN beneficiaries b ON pb.beneficiary_id = b.beneficiary_id " +
                "ORDER BY pb.date_assigned DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> assignment = new HashMap<>();
                assignment.put("projectId", rs.getInt("project_id"));
                assignment.put("projectName", rs.getString("project_name"));
                assignment.put("beneficiaryId", rs.getInt("beneficiary_id"));
                assignment.put("beneficiaryName", rs.getString("beneficiary_name"));
                assignment.put("dateAssigned", rs.getDate("date_assigned"));
                assignments.add(assignment);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching assignments: " + e.getMessage());
            e.printStackTrace();
        }
        return assignments;
    }

    public boolean deleteAssignment(int projectId, int beneficiaryId) {
        String sql = "DELETE FROM project_beneficiaries WHERE project_id = ? AND beneficiary_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, projectId);
            pstmt.setInt(2, beneficiaryId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting assignment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private boolean assignmentExists(int projectId, int beneficiaryId) {
        String sql = "SELECT 1 FROM project_beneficiaries WHERE project_id = ? AND beneficiary_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, projectId);
            pstmt.setInt(2, beneficiaryId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            System.err.println("Error checking assignment existence: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}