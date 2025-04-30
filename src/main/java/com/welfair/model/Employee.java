package com.welfair.model;

public class Employee {
    private int empId;
    private String name;
    private String position;
    private String phone;
    private String email;

    // Constructors, Getters, and Setters
    public Employee() {}
    public Employee(int empId, String name, String position, String phone, String email) {
        this.empId = empId;
        this.name = name;
        this.position = position;
        this.phone = phone;
        this.email = email;
    }

    // Getters and Setters
    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}