package com.welfair.db;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnectionTest {
    public static void main(String[] args) {
        try {
            Connection connection = DBConnection.getConnection();
            System.out.println("Connection successful: " + connection);
        } catch (SQLException e) {
            System.out.println("Connection failed.");
            e.printStackTrace();

        }
    }
}