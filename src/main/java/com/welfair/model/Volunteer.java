package com.welfair.model;

public class Volunteer {
    private int volunteerId;
    private String name;
    private String phone;
    private String email;

    // Constructors, Getters, and Setters
    public Volunteer() {}
    public Volunteer(int volunteerId, String name, String phone, String email) {
        this.volunteerId = volunteerId;
        this.name = name;
        this.phone = phone;
        this.email = email;
    }

    // Getters and Setters
    public int getVolunteerId() { return volunteerId; }
    public void setVolunteerId(int volunteerId) { this.volunteerId = volunteerId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}