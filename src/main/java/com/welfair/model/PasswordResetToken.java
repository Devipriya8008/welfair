package com.welfair.model;

import java.sql.Timestamp;

public class PasswordResetToken {
    private int tokenId;
    private int userId;
    private String token;
    private Timestamp expiresAt;
    private boolean used;

    // Constructors
    public PasswordResetToken() {}

    public PasswordResetToken(int tokenId, int userId, String token, Timestamp expiresAt, boolean used) {
        this.tokenId = tokenId;
        this.userId = userId;
        this.token = token;
        this.expiresAt = expiresAt;
        this.used = used;
    }

    // Getters and Setters
    public int getTokenId() { return tokenId; }
    public void setTokenId(int tokenId) { this.tokenId = tokenId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public Timestamp getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }

    public boolean isUsed() { return used; }
    public void setUsed(boolean used) { this.used = used; }
}