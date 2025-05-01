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

    // CRUD Operations
    public boolean addDonor(Donor donor) throws SQLException {
        String sql = "INSERT INTO donors (name, email, phone, address) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, donor.getName());
            stmt.setString(2, donor.getEmail());
            stmt.setString(3, donor.getPhone());
            stmt.setString(4, donor.getAddress());

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
        String sql = "UPDATE donors SET name=?, email=?, phone=?, address=? WHERE donor_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, donor.getName());
            stmt.setString(2, donor.getEmail());
            stmt.setString(3, donor.getPhone());
            stmt.setString(4, donor.getAddress());
            stmt.setInt(5, donor.getDonorId());
            return stmt.executeUpdate() > 0;
        }
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