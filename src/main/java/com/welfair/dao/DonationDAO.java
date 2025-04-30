package com.welfair.dao;

import com.welfair.model.Donation;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonationDAO {
    // Add a new donation
    public void addDonation(Donation donation) {
        String sql = "INSERT INTO donations (donor_id, project_id, amount, date, mode) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, donation.getDonorId());
            pstmt.setInt(2, donation.getProjectId());
            pstmt.setBigDecimal(3, donation.getAmount());
            pstmt.setTimestamp(4, donation.getDate());
            pstmt.setString(5, donation.getMode());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all donations
    public List<Donation> getAllDonations() {
        List<Donation> donations = new ArrayList<>();
        String sql = "SELECT * FROM donations";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Donation donation = new Donation();
                donation.setDonationId(rs.getInt("donation_id"));
                donation.setDonorId(rs.getInt("donor_id"));
                donation.setProjectId(rs.getInt("project_id"));
                donation.setAmount(rs.getBigDecimal("amount"));
                donation.setDate(rs.getTimestamp("date"));
                donation.setMode(rs.getString("mode"));
                donations.add(donation);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return donations;
    }

    // Get donation by ID
    public Donation getDonationById(int id) {
        Donation donation = null;
        String sql = "SELECT * FROM donations WHERE donation_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                donation = new Donation();
                donation.setDonationId(rs.getInt("donation_id"));
                donation.setDonorId(rs.getInt("donor_id"));
                donation.setProjectId(rs.getInt("project_id"));
                donation.setAmount(rs.getBigDecimal("amount"));
                donation.setDate(rs.getTimestamp("date"));
                donation.setMode(rs.getString("mode"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return donation;
    }

    // Update donation
    public void updateDonation(Donation donation) {
        String sql = "UPDATE donations SET donor_id = ?, project_id = ?, amount = ?, date = ?, mode = ? WHERE donation_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, donation.getDonorId());
            pstmt.setInt(2, donation.getProjectId());
            pstmt.setBigDecimal(3, donation.getAmount());
            pstmt.setTimestamp(4, donation.getDate());
            pstmt.setString(5, donation.getMode());
            pstmt.setInt(6, donation.getDonationId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete donation
    public void deleteDonation(int id) {
        String sql = "DELETE FROM donations WHERE donation_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}