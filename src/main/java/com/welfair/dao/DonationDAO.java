package com.welfair.dao;

import com.welfair.model.Donation;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonationDAO {
    // Add a new donation
    public void addDonation(Donation donation) throws SQLException {
        String sql = "INSERT INTO donations (donor_id, project_id, amount, date, mode) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            setDonationParameters(pstmt, donation);
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    donation.setDonationId(generatedKeys.getInt(1));
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
    public void updateDonation(Donation donation) throws SQLException {
        String sql = "UPDATE donations SET donor_id = ?, project_id = ?, amount = ?, date = ?, mode = ? WHERE donation_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            setDonationParameters(pstmt, donation);
            pstmt.setInt(6, donation.getDonationId());
            pstmt.executeUpdate();
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
        pstmt.setTimestamp(4, donation.getDate());
        pstmt.setString(5, donation.getMode());
    }

    private Donation mapRowToDonation(ResultSet rs) throws SQLException {
        Donation donation = new Donation();
        donation.setDonationId(rs.getInt("donation_id"));
        donation.setDonorId(rs.getInt("donor_id"));
        donation.setProjectId(rs.getInt("project_id"));
        donation.setAmount(rs.getBigDecimal("amount"));
        donation.setDate(rs.getTimestamp("date"));
        donation.setMode(rs.getString("mode"));
        return donation;
    }
}