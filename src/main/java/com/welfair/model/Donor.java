package com.welfair.model;

public class Donor {
    private int donorId;
    private String name;
    private String email;
    private String phone;
    private String address;

    // Constructors
    public Donor() {}
    public Donor(int donorId, String name, String email, String phone, String address) {
        this.donorId = donorId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

    // Getters and Setters
    public int getDonorId() { return donorId; }
    public void setDonorId(int donorId) { this.donorId = donorId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}