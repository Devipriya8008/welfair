package com.welfair.dao;

import com.welfair.model.Admin;
import com.welfair.db.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AdminDAO {

    private final Connection conn;

    public AdminDAO() throws SQLException {
        this.conn =DBConnection.getConnection();
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
}
