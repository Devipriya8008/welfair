package com.welfair.dao;

import com.welfair.model.FundAllocation;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FundAllocationDAO {
    // Add a new fund allocation
    public void addFundAllocation(FundAllocation fund) {
        String sql = "INSERT INTO fund_allocation (project_id, amount, date_allocated) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, fund.getProjectId());
            pstmt.setBigDecimal(2, fund.getAmount());
            pstmt.setDate(3, fund.getDateAllocated());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all fund allocations
    public List<FundAllocation> getAllFundAllocations() {
        List<FundAllocation> funds = new ArrayList<>();
        String sql = "SELECT * FROM fund_allocation";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                FundAllocation fund = new FundAllocation();
                fund.setFundId(rs.getInt("fund_id"));
                fund.setProjectId(rs.getInt("project_id"));
                fund.setAmount(rs.getBigDecimal("amount"));
                fund.setDateAllocated(rs.getDate("date_allocated"));
                funds.add(fund);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return funds;
    }

    // Get fund allocation by ID
    public FundAllocation getFundAllocationById(int id) {
        FundAllocation fund = null;
        String sql = "SELECT * FROM fund_allocation WHERE fund_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                fund = new FundAllocation();
                fund.setFundId(rs.getInt("fund_id"));
                fund.setProjectId(rs.getInt("project_id"));
                fund.setAmount(rs.getBigDecimal("amount"));
                fund.setDateAllocated(rs.getDate("date_allocated"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fund;
    }

    // Update fund allocation
    public void updateFundAllocation(FundAllocation fund) {
        String sql = "UPDATE fund_allocation SET project_id = ?, amount = ?, date_allocated = ? WHERE fund_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, fund.getProjectId());
            pstmt.setBigDecimal(2, fund.getAmount());
            pstmt.setDate(3, fund.getDateAllocated());
            pstmt.setInt(4, fund.getFundId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete fund allocation
    public void deleteFundAllocation(int id) {
        String sql = "DELETE FROM fund_allocation WHERE fund_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}