package com.welfair.model;

public class Admin {
    private int adminId;
    private int userId;
    private String fullName;
    private String phone;
    private String department;
    private java.sql.Timestamp lastLogin;

    // Getters and setters
    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public java.sql.Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(java.sql.Timestamp lastLogin) { this.lastLogin = lastLogin; }
}