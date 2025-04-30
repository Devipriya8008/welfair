package com.welfair.dao;

import com.welfair.model.Inventory;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {
    // Add a new inventory item
    public void addInventoryItem(Inventory item) {
        String sql = "INSERT INTO inventory (name, quantity, unit) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, item.getName());
            pstmt.setInt(2, item.getQuantity());
            pstmt.setString(3, item.getUnit());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all inventory items
    public List<Inventory> getAllInventoryItems() {
        List<Inventory> items = new ArrayList<>();
        String sql = "SELECT * FROM inventory";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Inventory item = new Inventory();
                item.setItemId(rs.getInt("item_id"));
                item.setName(rs.getString("name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnit(rs.getString("unit"));
                items.add(item);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // Get inventory item by ID
    public Inventory getInventoryItemById(int id) {
        Inventory item = null;
        String sql = "SELECT * FROM inventory WHERE item_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                item = new Inventory();
                item.setItemId(rs.getInt("item_id"));
                item.setName(rs.getString("name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnit(rs.getString("unit"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return item;
    }

    // Update inventory item
    public void updateInventoryItem(Inventory item) {
        String sql = "UPDATE inventory SET name = ?, quantity = ?, unit = ? WHERE item_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, item.getName());
            pstmt.setInt(2, item.getQuantity());
            pstmt.setString(3, item.getUnit());
            pstmt.setInt(4, item.getItemId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete inventory item
    public void deleteInventoryItem(int id) {
        String sql = "DELETE FROM inventory WHERE item_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}