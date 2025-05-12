package com.welfair.dao;

import com.welfair.model.Volunteer;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VolunteerDAO {
    private Connection connection;

    public VolunteerDAO() {
        // Connection will be set by servlet
    }

    public void setConnection(Connection connection) {
        this.connection = connection;
    }

    private Connection getActiveConnection() throws SQLException {
        return connection != null ? connection : DBConnection.getConnection();
    }

    public boolean addVolunteer(Volunteer volunteer) throws SQLException {
        Connection conn = null;
        PreparedStatement userStmt = null;
        PreparedStatement volunteerStmt = null;
        ResultSet userKeys = null;
        ResultSet volunteerKeys = null;

        try {
            conn = getActiveConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert into users table
            String userSql = "INSERT INTO users (username, password, role, email) VALUES (?, ?, 'volunteer', ?)";
            userStmt = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS);
            userStmt.setString(1, volunteer.getEmail());
            userStmt.setString(2, generateHashedPassword("tempPassword")); // Implement password hashing
            userStmt.setString(3, volunteer.getEmail());

            int userAffected = userStmt.executeUpdate();
            if (userAffected != 1) {
                throw new SQLException("Failed to create user record");
            }

            // Get generated user ID
            userKeys = userStmt.getGeneratedKeys();
            if (!userKeys.next()) {
                throw new SQLException("Failed to get generated user ID");
            }
            int userId = userKeys.getInt(1);
            volunteer.setUserId(userId);

            // 2. Insert into volunteers table
            String volunteerSql = "INSERT INTO volunteers (user_id, name, phone, email) VALUES (?, ?, ?, ?)";
            volunteerStmt = conn.prepareStatement(volunteerSql, Statement.RETURN_GENERATED_KEYS);
            volunteerStmt.setInt(1, userId);
            volunteerStmt.setString(2, volunteer.getName());
            volunteerStmt.setString(3, volunteer.getPhone());
            volunteerStmt.setString(4, volunteer.getEmail());

            int volunteerAffected = volunteerStmt.executeUpdate();
            if (volunteerAffected != 1) {
                throw new SQLException("Failed to create volunteer record");
            }

            // Get generated volunteer ID
            volunteerKeys = volunteerStmt.getGeneratedKeys();
            if (volunteerKeys.next()) {
                volunteer.setVolunteerId(volunteerKeys.getInt(1));
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw new SQLException("Error adding volunteer: " + e.getMessage(), e);
        } finally {
            // Close resources in reverse order
            if (volunteerKeys != null) try { volunteerKeys.close(); } catch (SQLException e) { /* ignore */ }
            if (userKeys != null) try { userKeys.close(); } catch (SQLException e) { /* ignore */ }
            if (volunteerStmt != null) try { volunteerStmt.close(); } catch (SQLException e) { /* ignore */ }
            if (userStmt != null) try { userStmt.close(); } catch (SQLException e) { /* ignore */ }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) { /* ignore */ }
            }
        }
    }

    private String generateHashedPassword(String password) {
        // Implement proper password hashing (e.g., BCrypt)
        return password; // Replace with real hashing in production
    }

    public List<Volunteer> getAllVolunteers() throws SQLException {
        List<Volunteer> volunteers = new ArrayList<>();
        String sql = "SELECT * FROM volunteers";

        try (Statement stmt = getActiveConnection().createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Volunteer volunteer = new Volunteer();
                volunteer.setVolunteerId(rs.getInt("volunteer_id"));
                volunteer.setUserId(rs.getInt("user_id"));
                volunteer.setName(rs.getString("name"));
                volunteer.setPhone(rs.getString("phone"));
                volunteer.setEmail(rs.getString("email"));
                volunteers.add(volunteer);
            }
        }
        return volunteers;
    }

    public Volunteer getVolunteerById(int id) throws SQLException {
        String sql = "SELECT * FROM volunteers WHERE volunteer_id = ?";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Volunteer volunteer = new Volunteer();
                    volunteer.setVolunteerId(rs.getInt("volunteer_id"));
                    volunteer.setUserId(rs.getInt("user_id"));
                    volunteer.setName(rs.getString("name"));
                    volunteer.setPhone(rs.getString("phone"));
                    volunteer.setEmail(rs.getString("email"));
                    return volunteer;
                }
            }
        }
        return null;
    }

    public boolean updateVolunteer(Volunteer volunteer) throws SQLException {
        String sql = "UPDATE volunteers SET name=?, phone=?, email=? WHERE volunteer_id=?";

        try (Connection conn = getActiveConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, volunteer.getName());
            pstmt.setString(2, volunteer.getPhone());
            pstmt.setString(3, volunteer.getEmail());
            pstmt.setInt(4, volunteer.getVolunteerId());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    public boolean deleteVolunteer(int id) throws SQLException {
        String sql = "DELETE FROM volunteers WHERE volunteer_id=?";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public Volunteer getVolunteerByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM volunteers WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Volunteer volunteer = new Volunteer();
                volunteer.setVolunteerId(rs.getInt("volunteer_id"));
                volunteer.setUserId(rs.getInt("user_id"));
                volunteer.setName(rs.getString("name"));
                volunteer.setPhone(rs.getString("phone"));
                volunteer.setEmail(rs.getString("email"));
                return volunteer;
            }
        }
        return null;
    }
}