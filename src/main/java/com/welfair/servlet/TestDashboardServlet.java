package com.welfair.servlet;

import com.welfair.dao.DonationDAO;
import com.welfair.model.Donation;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import com.welfair.db.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/test-dashboard")
public class TestDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        try {
            DonationDAO dao = new DonationDAO();
            BigDecimal total = dao.getTotalDonations();
            out.println("Total Donations: " + total);

            // Raw SQL test
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT amount FROM donations");
            out.println("\nIndividual Donations:");
            while (rs.next()) {
                out.println(rs.getBigDecimal("amount"));
            }
            conn.close();
        } catch (Exception e) {
            out.println("ERROR: " + e.getMessage());
            e.printStackTrace(out);
        }
    }
}