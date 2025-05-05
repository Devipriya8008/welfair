package com.welfair.dao;

import com.welfair.db.DBConnection;
import com.welfair.model.Donor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonorDAO {
    private Connection connection;

    public DonorDAO() throws SQLException {
        this.connection = DBConnection.getConnection();
    }

    public boolean saveDonor(Donor donor) throws SQLException {
        String sql = "INSERT INTO donors (user_id, name, email, phone, address) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, donor.getUserId()); // NEW
            stmt.setString(2, donor.getName());
            stmt.setString(3, donor.getEmail());
            stmt.setString(4, donor.getPhone());
            stmt.setString(5, donor.getAddress());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) return false;

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    donor.setDonorId(generatedKeys.getInt(1));
                }
            }
            return true;
        }
    }

    public List<Donor> getAllDonors() throws SQLException {
        List<Donor> donors = new ArrayList<>();
        String sql = "SELECT * FROM donors";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Donor donor = new Donor();
                donor.setDonorId(rs.getInt("donor_id"));
                donor.setUserId(rs.getInt("user_id")); // NEW
                donor.setName(rs.getString("name"));
                donor.setEmail(rs.getString("email"));
                donor.setPhone(rs.getString("phone"));
                donor.setAddress(rs.getString("address"));
                donors.add(donor);
            }
        }
        return donors;
    }

    public Donor getDonorById(int id) throws SQLException {
        String sql = "SELECT * FROM donors WHERE donor_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Donor donor = new Donor();
                    donor.setDonorId(rs.getInt("donor_id"));
                    donor.setUserId(rs.getInt("user_id")); // NEW
                    donor.setName(rs.getString("name"));
                    donor.setEmail(rs.getString("email"));
                    donor.setPhone(rs.getString("phone"));
                    donor.setAddress(rs.getString("address"));
                    return donor;
                }
            }
        }
        return null;
    }

    public boolean updateDonor(Donor donor) throws SQLException {
        String sql = "UPDATE donors SET user_id=?, name=?, email=?, phone=?, address=? WHERE donor_id=?";
        try {
            connection.setAutoCommit(false); // Start transaction
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setInt(1, donor.getUserId()); // NEW
                stmt.setString(2, donor.getName());
                stmt.setString(3, donor.getEmail());
                stmt.setString(4, donor.getPhone());
                stmt.setString(5, donor.getAddress());
                stmt.setInt(6, donor.getDonorId());

                int rowsAffected = stmt.executeUpdate();
                connection.commit(); // Commit transaction

                return rowsAffected > 0;
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            }
        } finally {
            connection.setAutoCommit(true);
        }
    }
    public Donor getDonorByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM donors WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Donor donor = new Donor();
                    donor.setDonorId(rs.getInt("donor_id"));
                    donor.setUserId(rs.getInt("user_id"));
                    donor.setName(rs.getString("name"));
                    donor.setEmail(rs.getString("email"));
                    donor.setPhone(rs.getString("phone"));
                    donor.setAddress(rs.getString("address"));
                    return donor;
                }
            }
        }
        return null;
    }

    public boolean deleteDonor(int id) throws SQLException {
        String sql = "DELETE FROM donors WHERE donor_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    public void close() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
}
