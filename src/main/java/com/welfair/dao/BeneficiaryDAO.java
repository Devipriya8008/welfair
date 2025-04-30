package com.welfair.dao;

import com.welfair.model.Beneficiary;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BeneficiaryDAO {
    // Add a new beneficiary
    public void addBeneficiary(Beneficiary beneficiary) {
        String sql = "INSERT INTO beneficiaries (name, age, gender, address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, beneficiary.getName());
            pstmt.setInt(2, beneficiary.getAge());
            pstmt.setString(3, beneficiary.getGender());
            pstmt.setString(4, beneficiary.getAddress());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all beneficiaries
    public List<Beneficiary> getAllBeneficiaries() {
        List<Beneficiary> beneficiaries = new ArrayList<>();
        String sql = "SELECT * FROM beneficiaries";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Beneficiary beneficiary = new Beneficiary();
                beneficiary.setBeneficiaryId(rs.getInt("beneficiary_id"));
                beneficiary.setName(rs.getString("name"));
                beneficiary.setAge(rs.getInt("age"));
                beneficiary.setGender(rs.getString("gender"));
                beneficiary.setAddress(rs.getString("address"));
                beneficiaries.add(beneficiary);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return beneficiaries;
    }

    // Get beneficiary by ID
    public Beneficiary getBeneficiaryById(int id) {
        Beneficiary beneficiary = null;
        String sql = "SELECT * FROM beneficiaries WHERE beneficiary_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                beneficiary = new Beneficiary();
                beneficiary.setBeneficiaryId(rs.getInt("beneficiary_id"));
                beneficiary.setName(rs.getString("name"));
                beneficiary.setAge(rs.getInt("age"));
                beneficiary.setGender(rs.getString("gender"));
                beneficiary.setAddress(rs.getString("address"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return beneficiary;
    }

    // Update beneficiary
    public void updateBeneficiary(Beneficiary beneficiary) {
        String sql = "UPDATE beneficiaries SET name = ?, age = ?, gender = ?, address = ? WHERE beneficiary_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, beneficiary.getName());
            pstmt.setInt(2, beneficiary.getAge());
            pstmt.setString(3, beneficiary.getGender());
            pstmt.setString(4, beneficiary.getAddress());
            pstmt.setInt(5, beneficiary.getBeneficiaryId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete beneficiary
    public void deleteBeneficiary(int id) {
        String sql = "DELETE FROM beneficiaries WHERE beneficiary_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}