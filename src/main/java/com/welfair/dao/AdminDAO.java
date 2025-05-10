package com.welfair.dao;

import com.welfair.db.DBConnection;
import com.welfair.model.Admin;
import java.sql.*;
import java.sql.Timestamp;

public class AdminDAO {
    private Connection connection;

    public AdminDAO() {
        // Connection will be set by servlet
    }

    public void setConnection(Connection connection) {
        this.connection = connection;
    }

    private Connection getActiveConnection() throws SQLException {
        return connection != null ? connection : DBConnection.getConnection();
    }

    public boolean addAdmin(Admin admin) throws SQLException {
        String sql = "INSERT INTO admin_details (user_id, full_name, phone, department, last_login) " +
                "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, admin.getUserId());
            stmt.setString(2, admin.getFullName());
            stmt.setString(3, admin.getPhone());
            stmt.setString(4, admin.getDepartment());
            stmt.setTimestamp(5, admin.getLastLogin());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    public Admin getAdminByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM admin_details WHERE user_id = ?";
        try (PreparedStatement stmt = getActiveConnection().prepareStatement(sql)) {
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

    public int getTotalDonations() throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM donations";
        try (PreparedStatement stmt = getActiveConnection().prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public int getActiveProjects() throws SQLException {
        String sql = "SELECT COUNT(*) FROM projects WHERE status = 'Active'";
        try (PreparedStatement stmt = getActiveConnection().prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public int getInventoryStockCount() throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM inventory";
        try (PreparedStatement stmt = getActiveConnection().prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public int getBeneficiaryCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM beneficiaries";
        try (PreparedStatement stmt = getActiveConnection().prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }
}