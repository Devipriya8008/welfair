package com.welfair.dao;

import com.welfair.model.Donor;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonorDAO {
    // Add a new donor
    public void addDonor(Donor donor) {
        String sql = "INSERT INTO donors (name, email, phone, address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, donor.getName());
            pstmt.setString(2, donor.getEmail());
            pstmt.setString(3, donor.getPhone());
            pstmt.setString(4, donor.getAddress());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all donors
    public List<Donor> getAllDonors() {
        List<Donor> donors = new ArrayList<>();
        String sql = "SELECT * FROM donors";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
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
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return donors;
    }

    // Get donor by ID
    public Donor getDonorById(int id) {
        Donor donor = null;
        String sql = "SELECT * FROM donors WHERE donor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                donor = new Donor();
                donor.setDonorId(rs.getInt("donor_id"));
                donor.setName(rs.getString("name"));
                donor.setEmail(rs.getString("email"));
                donor.setPhone(rs.getString("phone"));
                donor.setAddress(rs.getString("address"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return donor;
    }

    // Update donor
    public void updateDonor(Donor donor) {
        String sql = "UPDATE donors SET name = ?, email = ?, phone = ?, address = ? WHERE donor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, donor.getName());
            pstmt.setString(2, donor.getEmail());
            pstmt.setString(3, donor.getPhone());
            pstmt.setString(4, donor.getAddress());
            pstmt.setInt(5, donor.getDonorId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete donor
    public void deleteDonor(int id) {
        String sql = "DELETE FROM donors WHERE donor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}