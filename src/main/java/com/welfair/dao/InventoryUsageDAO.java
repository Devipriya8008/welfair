package com.welfair.dao;

import com.welfair.model.InventoryUsage;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryUsageDAO {
    // Record inventory usage for a project
    public void addInventoryUsage(InventoryUsage usage) {
        String sql = "INSERT INTO inventory_usage (item_id, project_id, quantity_used) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, usage.getItemId());
            pstmt.setInt(2, usage.getProjectId());
            pstmt.setInt(3, usage.getQuantityUsed());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public boolean exists(int itemId, int projectId) {
        String sql = "SELECT COUNT(*) FROM inventory_usage WHERE item_id = ? AND project_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, itemId);
            stmt.setInt(2, projectId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    private Connection getConnection() throws SQLException {
        String jdbcURL = "jdbc:postgresql://localhost:5432/your_database_name";
        String jdbcUsername = "your_username";
        String jdbcPassword = "your_password";

        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public InventoryUsage getInventoryUsageById(int itemId, int projectId) {
        String sql = "SELECT * FROM inventory_usage WHERE item_id = ? AND project_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, itemId);
            stmt.setInt(2, projectId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new InventoryUsage(
                        rs.getInt("item_id"),
                        rs.getInt("project_id"),
                        rs.getInt("quantity_used")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get all inventory usage records
    public List<InventoryUsage> getAllInventoryUsage() {
        List<InventoryUsage> usages = new ArrayList<>();
        String sql = "SELECT * FROM inventory_usage";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                InventoryUsage usage = new InventoryUsage();
                usage.setItemId(rs.getInt("item_id"));
                usage.setProjectId(rs.getInt("project_id"));
                usage.setQuantityUsed(rs.getInt("quantity_used"));
                usages.add(usage);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usages;
    }

    // Get usage by project ID
    public List<InventoryUsage> getUsageByProjectId(int projectId) {
        List<InventoryUsage> usages = new ArrayList<>();
        String sql = "SELECT * FROM inventory_usage WHERE project_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, projectId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                InventoryUsage usage = new InventoryUsage();
                usage.setItemId(rs.getInt("item_id"));
                usage.setProjectId(rs.getInt("project_id"));
                usage.setQuantityUsed(rs.getInt("quantity_used"));
                usages.add(usage);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usages;
    }

    // Update inventory usage
    public void updateInventoryUsage(InventoryUsage usage) {
        String sql = "UPDATE inventory_usage SET quantity_used = ? WHERE item_id = ? AND project_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, usage.getQuantityUsed());
            pstmt.setInt(2, usage.getItemId());
            pstmt.setInt(3, usage.getProjectId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete inventory usage record
    public void deleteInventoryUsage(int itemId, int projectId) {
        String sql = "DELETE FROM inventory_usage WHERE item_id = ? AND project_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, itemId);
            pstmt.setInt(2, projectId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}