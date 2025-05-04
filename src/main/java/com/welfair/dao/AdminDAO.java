package com.welfair.dao;

import com.welfair.db.DBConnection;
import com.welfair.model.Admin;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class AdminDAO {
    private final Connection conn;

    public AdminDAO() throws SQLException {
        this.conn = DBConnection.getConnection();
    }

    public void addAdmin(Admin admin) throws SQLException {
        String sql = "INSERT INTO admin_details (user_id, full_name, phone, department, last_login) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, admin.getUserId());
            stmt.setString(2, admin.getFullName());
            stmt.setString(3, admin.getPhone());
            stmt.setString(4, admin.getDepartment());
            stmt.setTimestamp(5, admin.getLastLogin());
            stmt.executeUpdate();
        }
    }

    public Admin getAdminByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM admin_details WHERE user_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setUserId(rs.getInt("user_id"));
                    admin.setFullName(rs.getString("full_name"));
                    admin.setPhone(rs.getString("phone"));
                    admin.setDepartment(rs.getString("department"));
                    admin.setLastLogin(rs.getTimestamp("last_login"));
                    return admin;
                }
            }
        }
        return null;
    }

    // Dashboard stats methods remain the same
    public int getTotalDonations() {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM donations";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getActiveProjects() {
        String sql = "SELECT COUNT(*) FROM projects WHERE status = 'Active'";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getInventoryStockCount() {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM inventory";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getBeneficiaryCount() {
        String sql = "SELECT COUNT(*) FROM beneficiaries";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}