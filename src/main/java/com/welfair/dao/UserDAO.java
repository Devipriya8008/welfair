package com.welfair.dao;

import com.welfair.model.User;
import com.welfair.model.PasswordResetToken;
import com.welfair.util.PasswordUtil;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.UUID;
import com.welfair.db.DBConnection;

import static com.welfair.db.DBConnection.getConnection;

public class UserDAO {
    private Connection connection;

    public UserDAO() {
        // Connection will be set by servlet
    }

    public void setConnection(Connection connection) {
        this.connection = connection;
    }

    private Connection getActiveConnection() throws SQLException {
        return connection != null ? connection : getConnection();
    }

    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        }
        return null;
    }

    public boolean addUser(User user, Connection conn) throws SQLException {
        // First check if username already exists
        if (usernameExists(user.getUsername(), conn)) {
            // If username exists, append a number to make it unique
            int counter = 1;
            String originalUsername = user.getUsername();
            while (usernameExists(user.getUsername(), conn)) {
                user.setUsername(originalUsername + counter);
                counter++;
            }
        }

        String sql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) return false;

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setUserId(generatedKeys.getInt(1));
                }
            }
            return true;
        }
    }

    private boolean usernameExists(String username, Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
            return null;
        }
    }

    private User mapUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        return user;
    }

    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            pstmt.setString(1, hashedPassword);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public String createPasswordResetToken(int userId) throws SQLException {
        String deleteSql = "DELETE FROM password_reset_tokens WHERE user_id = ?";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(deleteSql)) {
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
        }

        String token = UUID.randomUUID().toString();
        LocalDateTime expiresAt = LocalDateTime.now().plusHours(24);

        String insertSql = "INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(insertSql)) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, token);
            pstmt.setTimestamp(3, Timestamp.valueOf(expiresAt));
            pstmt.executeUpdate();
        }

        return token;
    }

    public boolean isValidPasswordResetToken(String token) throws SQLException {
        String sql = "SELECT * FROM password_reset_tokens WHERE token = ? AND used = false AND expires_at > NOW()";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setString(1, token);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
        }
    }

    public int getUserIdFromResetToken(String token) throws SQLException {
        String sql = "SELECT user_id FROM password_reset_tokens WHERE token = ?";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setString(1, token);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
            return -1;
        }
    }

    public void markTokenAsUsed(String token) throws SQLException {
        String sql = "UPDATE password_reset_tokens SET used = true WHERE token = ?";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setString(1, token);
            pstmt.executeUpdate();
        }
    }
    public User authenticateUser(String email, String plainPassword) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                if (PasswordUtil.checkPassword(plainPassword, hashedPassword)) {
                    return mapUserFromResultSet(rs); // Return user if password matches
                }
            }
            return null; // User not found or wrong password
        }
    }

    public User findByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (PreparedStatement pstmt = getActiveConnection().prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
            return null;
        }
    }
    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET username=?, email=?, password=?, role=? WHERE user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());
            stmt.setInt(5, user.getUserId());
            return stmt.executeUpdate() > 0;
        }
    }

    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        }
        return null;
    }
    public boolean emailExists(String email, Connection conn) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }
}