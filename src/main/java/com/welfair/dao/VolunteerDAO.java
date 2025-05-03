package com.welfair.dao;

import com.welfair.model.Volunteer;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VolunteerDAO {
    private Connection connection;

    public VolunteerDAO() throws SQLException {
        this.connection = DBConnection.getConnection();
    }

    // Add a new volunteer with proper error handling
    // In VolunteerDAO.java
    public boolean addVolunteer(Volunteer volunteer) throws SQLException {
        String sql = "INSERT INTO volunteers (name, phone, email) VALUES (?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, volunteer.getName());
            pstmt.setString(2, volunteer.getPhone());
            pstmt.setString(3, volunteer.getEmail());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        volunteer.setVolunteerId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;
        }
    }

    // Get all volunteers
    public List<Volunteer> getAllVolunteers() {
        List<Volunteer> volunteers = new ArrayList<>();
        String sql = "SELECT * FROM volunteers";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Volunteer volunteer = new Volunteer();
                volunteer.setVolunteerId(rs.getInt("volunteer_id"));
                volunteer.setName(rs.getString("name"));
                volunteer.setPhone(rs.getString("phone"));
                volunteer.setEmail(rs.getString("email"));
                volunteers.add(volunteer);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return volunteers;
    }

    // Get volunteer by ID
    public Volunteer getVolunteerById(int id) {
        Volunteer volunteer = null;
        String sql = "SELECT * FROM volunteers WHERE volunteer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                volunteer = new Volunteer();
                volunteer.setVolunteerId(rs.getInt("volunteer_id"));
                volunteer.setName(rs.getString("name"));
                volunteer.setPhone(rs.getString("phone"));
                volunteer.setEmail(rs.getString("email"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return volunteer;
    }

    // Update volunteer
    // In VolunteerDAO.java
    public boolean updateVolunteer(Volunteer volunteer) throws SQLException {
        String sql = "UPDATE volunteers SET name=?, phone=?, email=? WHERE volunteer_id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, volunteer.getName());
            pstmt.setString(2, volunteer.getPhone());
            pstmt.setString(3, volunteer.getEmail());
            pstmt.setInt(4, volunteer.getVolunteerId());

            int rowsUpdated = pstmt.executeUpdate();
            conn.commit(); // Commit transaction

            return rowsUpdated > 0;
        } catch (SQLException e) {
            if (conn != null) conn.rollback(); // Rollback on error
            throw e;
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) {
                conn.setAutoCommit(true); // Reset auto-commit
                conn.close();
            }
        }
    }

    // Delete volunteer
    public void deleteVolunteer(int id) {
        String sql = "DELETE FROM volunteers WHERE volunteer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}