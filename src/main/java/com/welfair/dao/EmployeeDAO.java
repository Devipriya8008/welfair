package com.welfair.dao;

import com.welfair.db.DBConnection;
import com.welfair.model.Employee;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {
    private Connection connection;

    public EmployeeDAO() throws SQLException {
        this.connection = DBConnection.getConnection();
        this.connection.setAutoCommit(true); // Ensure auto-commit
    }

    public boolean addEmployee(Employee employee) throws SQLException {

        String sql = "INSERT INTO employees (name, position, phone, email) VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            connection.setAutoCommit(false);
            stmt.setString(1, employee.getName());
            stmt.setString(2, employee.getPosition());

            // Handle null values
            if (employee.getPhone() == null || employee.getPhone().isEmpty()) {
                stmt.setNull(3, Types.VARCHAR);
            } else {
                stmt.setString(3, employee.getPhone());
            }

            if (employee.getEmail() == null || employee.getEmail().isEmpty()) {
                stmt.setNull(4, Types.VARCHAR);
            } else {
                stmt.setString(4, employee.getEmail());
            }

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        employee.setEmpId(generatedKeys.getInt(1));
                    }
                }
                connection.commit();
                return true;
            }
            connection.rollback();
            return false;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        }
    }


    public List<Employee> getAllEmployees() throws SQLException {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM employees ORDER BY name";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                employees.add(mapResultSetToEmployee(rs));
            }
        }
        return employees;
    }

    public Employee getEmployeeById(int id) throws SQLException {
        String sql = "SELECT * FROM employees WHERE emp_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        }
        return null;
    }

    public boolean updateEmployee(Employee employee) throws SQLException {
        String sql = "UPDATE employees SET name=?, position=?, phone=?, email=? WHERE emp_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, employee.getName());
            stmt.setString(2, employee.getPosition());
            stmt.setString(3, employee.getPhone());
            stmt.setString(4, employee.getEmail());
            stmt.setInt(5, employee.getEmpId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteEmployee(int id) throws SQLException {
        String sql = "DELETE FROM employees WHERE emp_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    private Employee mapResultSetToEmployee(ResultSet rs) throws SQLException {
        Employee employee = new Employee();
        employee.setEmpId(rs.getInt("emp_id"));
        employee.setName(rs.getString("name"));
        employee.setPosition(rs.getString("position"));
        employee.setPhone(rs.getString("phone"));
        employee.setEmail(rs.getString("email"));
        return employee;
    }

    public void close() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
}