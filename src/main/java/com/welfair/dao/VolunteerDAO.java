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

    public boolean addVolunteer(Volunteer volunteer) throws SQLException {
        String sql = "INSERT INTO volunteers (user_id, name, phone, email) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, volunteer.getUserId()); // NEW
            pstmt.setString(2, volunteer.getName());
            pstmt.setString(3, volunteer.getPhone());
            pstmt.setString(4, volunteer.getEmail());

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

    public List<Volunteer> getAllVolunteers() throws SQLException {
        List<Volunteer> volunteers = new ArrayList<>();
        String sql = "SELECT * FROM volunteers";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Volunteer volunteer = new Volunteer();
                volunteer.setVolunteerId(rs.getInt("volunteer_id"));
                volunteer.setUserId(rs.getInt("user_id")); // NEW
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
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Volunteer volunteer = new Volunteer();
                    volunteer.setVolunteerId(rs.getInt("volunteer_id"));
                    volunteer.setUserId(rs.getInt("user_id")); // NEW
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
        String sql = "UPDATE volunteers SET user_id=?, name=?, phone=?, email=? WHERE volunteer_id=?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, volunteer.getUserId()); // NEW
            pstmt.setString(2, volunteer.getName());
            pstmt.setString(3, volunteer.getPhone());
            pstmt.setString(4, volunteer.getEmail());
            pstmt.setInt(5, volunteer.getVolunteerId());

            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteVolunteer(int id) throws SQLException {
        String sql = "DELETE FROM volunteers WHERE volunteer_id=?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public void close() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
}