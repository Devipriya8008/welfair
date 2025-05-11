package com.welfair.model;

public class Employee {
    private int empId;
    private int userId; // NEW: Added user_id field
    private String name;
    private String position;
    private String phone;
    private String email;
    private String bio;
    private String photoUrl;
    // Constructors
    public Employee() {}

    public Employee(int empId, int userId, String name, String position, String phone, String email) {
        this.empId = empId;
        this.userId = userId;
        this.name = name;
        this.position = position;
        this.phone = phone;
        this.email = email;
    }

    // Getters and Setters
    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }

    public int getUserId() { return userId; } // NEW
    public void setUserId(int userId) { this.userId = userId; } // NEW

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public void setBio(String bio){this.bio=bio;}
    public String getBio() {
        return bio;
    }
    public void setPhotoUrl(String photoUrl) { this.photoUrl = photoUrl; }

    public String getPhotoUrl() {
        return photoUrl;
    }
}