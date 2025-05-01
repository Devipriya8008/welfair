package com.welfair.dao;

import com.welfair.model.Donor;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonorDAO {
    // Create a new donor and return generated ID
    public int createDonor(Donor donor) throws SQLException {
        String sql = "INSERT INTO donors (name, email, phone, address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, donor.getName());
            pstmt.setString(2, donor.getEmail());
            pstmt.setString(3, donor.getPhone());
            pstmt.setString(4, donor.getAddress());
            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // Return generated donor_id
                }
            }
        }
        throw new SQLException("Creating donor failed, no ID obtained.");
    }

    // Get all donors
    public List<Donor> getAllDonors() throws SQLException {
        List<Donor> donors = new ArrayList<>();
        String sql = "SELECT * FROM donors ORDER BY name";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                donors.add(new Donor(
                        rs.getInt("donor_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("address")
                ));
            }
        }
        return donors;
    }

    // Get donor by ID
    public Donor getDonorById(int id) throws SQLException {
        String sql = "SELECT * FROM donors WHERE donor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Donor(
                            rs.getInt("donor_id"),
                            rs.getString("name"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("address")
                    );
                }
            }
        }
        return null;
    }

    // Update donor
    public boolean updateDonor(Donor donor) throws SQLException {
        String sql = "UPDATE donors SET name=?, email=?, phone=?, address=? WHERE donor_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, donor.getName());
            pstmt.setString(2, donor.getEmail());
            pstmt.setString(3, donor.getPhone());
            pstmt.setString(4, donor.getAddress());
            pstmt.setInt(5, donor.getDonorId());

            return pstmt.executeUpdate() > 0;
        }
    }

    // Delete donor
    public boolean deleteDonor(int id) throws SQLException {
        String sql = "DELETE FROM donors WHERE donor_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }
}