package com.welfair.dao;

import com.welfair.model.Donation;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class DonationDAO {
    // Add a new donation
    public boolean addDonation(Donation donation, Connection conn) throws SQLException {
        String sql = "INSERT INTO donations (donor_id, project_id, amount, date, mode) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            // Set parameters with null checks
            pstmt.setInt(1, donation.getDonorId());
            pstmt.setInt(2, donation.getProjectId());
            pstmt.setBigDecimal(3, donation.getAmount() != null ? donation.getAmount() : BigDecimal.ZERO);

            // Handle date - use current time if null
            Timestamp date = donation.getDate() != null ? donation.getDate() : new Timestamp(System.currentTimeMillis());
            pstmt.setTimestamp(4, date);

            // Handle mode - default to 'Unknown' if null
            pstmt.setString(5, donation.getMode() != null ? donation.getMode() : "Unknown");

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating donation failed, no rows affected.");
            }

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    donation.setDonationId(generatedKeys.getInt(1));
                    return true;
                } else {
                    throw new SQLException("Creating donation failed, no ID obtained.");
                }
            }
        }
    }

    // Get all donations
    public List<Donation> getAllDonations() throws SQLException {
        List<Donation> donations = new ArrayList<>();
        String sql = "SELECT * FROM donations ORDER BY date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                donations.add(mapRowToDonation(rs));
            }
        }
        return donations;
    }

    // Get donation by ID
    public Donation getDonationById(int id) throws SQLException {
        String sql = "SELECT * FROM donations WHERE donation_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToDonation(rs);
                }
            }
        }
        return null;
    }

    // Update donation
    public boolean updateDonation(Donation donation, Connection conn) throws SQLException {
        // First delete the existing record
        String deleteSql = "DELETE FROM donations WHERE donation_id = ?";
        try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
            deleteStmt.setInt(1, donation.getDonationId());
            int deletedRows = deleteStmt.executeUpdate();

            if (deletedRows == 0) {
                return false; // No record found to update
            }
        }

        // Then insert new record with same ID
        String insertSql = "INSERT INTO donations (donation_id, donor_id, project_id, amount, date, mode) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
            insertStmt.setInt(1, donation.getDonationId());
            insertStmt.setInt(2, donation.getDonorId());
            insertStmt.setInt(3, donation.getProjectId());
            insertStmt.setBigDecimal(4, donation.getAmount());
            insertStmt.setTimestamp(5, donation.getDate());
            insertStmt.setString(6, donation.getMode());

            int insertedRows = insertStmt.executeUpdate();
            return insertedRows > 0;
        }
    }

    // Delete donation
    public void deleteDonation(int id) throws SQLException {
        String sql = "DELETE FROM donations WHERE donation_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }

    private void setDonationParameters(PreparedStatement pstmt, Donation donation)
            throws SQLException {
        pstmt.setInt(1, donation.getDonorId());
        pstmt.setInt(2, donation.getProjectId());
        pstmt.setBigDecimal(3, donation.getAmount());

        // Ensure date is not null
        if (donation.getDate() == null) {
            System.out.println("WARNING: Date is null, setting to current timestamp"); // Debug line
            pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
        } else {
            pstmt.setTimestamp(4, donation.getDate());
        }

        pstmt.setString(5, donation.getMode());
    }

    private Donation mapRowToDonation(ResultSet rs) throws SQLException {
        Donation donation = new Donation();
        donation.setDonationId(rs.getInt("donation_id"));
        donation.setDonorId(rs.getInt("donor_id"));
        donation.setProjectId(rs.getInt("project_id"));

        // Handle amount - ensure it's never null
        BigDecimal amount = rs.getBigDecimal("amount");
        donation.setAmount(amount != null ? amount : BigDecimal.ZERO);

        // Handle date - ensure proper timestamp conversion
        Timestamp timestamp = rs.getTimestamp("date");
        donation.setDate(timestamp != null ? timestamp : new Timestamp(System.currentTimeMillis()));

        donation.setMode(rs.getString("mode"));
        return donation;
    }
    public List<Donation> getDonationsByDonorId(int donorId) throws SQLException {
        List<Donation> donations = new ArrayList<>();
        String sql = "SELECT d.*, p.title as project_title FROM donations d "
                + "JOIN project p ON d.project_id = p.project_id "
                + "WHERE d.donor_id = ? ORDER BY d.date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, donorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Donation donation = mapRowToDonation(rs);
                    donation.setProjectTitle(rs.getString("project_title"));
                    donations.add(donation);
                }
            }
        }
        return donations;
    }

    public BigDecimal getTotalDonationsByDonor(int donorId) throws SQLException {
        String sql = "SELECT SUM(amount) AS total FROM donations WHERE donor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, donorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("total");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    public Donation getDonationForReceipt(int donationId) throws SQLException {
        String sql = "SELECT d.*, p.title AS project_title, u.email "
                + "FROM donations d "
                + "JOIN project p ON d.project_id = p.project_id "
                + "JOIN donor dr ON d.donor_id = dr.donor_id "
                + "JOIN users u ON dr.user_id = u.user_id "
                + "WHERE d.donation_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, donationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Donation donation = mapRowToDonation(rs);
                    donation.setProjectTitle(rs.getString("project_title"));
                    donation.setDonorEmail(rs.getString("email"));
                    return donation;
                }
            }
        }
        return null;
    }
    public BigDecimal getTotalDonations() throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) AS total FROM donations";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                BigDecimal result = rs.getBigDecimal("total");
                System.out.println("[DAO] Retrieved total donations: " + result);
                return result;
            }
            return BigDecimal.ZERO;
        }
    }

}