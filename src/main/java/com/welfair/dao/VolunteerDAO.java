package com.welfair.dao;

import com.welfair.model.Volunteer;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VolunteerDAO {
    // Add a new volunteer
    public void addVolunteer(Volunteer volunteer) {
        String sql = "INSERT INTO volunteers (name, phone, email) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, volunteer.getName());
            pstmt.setString(2, volunteer.getPhone());
            pstmt.setString(3, volunteer.getEmail());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
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
    public void updateVolunteer(Volunteer volunteer) {
        String sql = "UPDATE volunteers SET name = ?, phone = ?, email = ? WHERE volunteer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, volunteer.getName());
            pstmt.setString(2, volunteer.getPhone());
            pstmt.setString(3, volunteer.getEmail());
            pstmt.setInt(4, volunteer.getVolunteerId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
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