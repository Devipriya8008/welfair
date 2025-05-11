package com.welfair.model;

public class ProjectEmployee {
    private int empId;
    private int projectId;
    private String role;

    // Constructors
    public ProjectEmployee() {}
    public ProjectEmployee(int empId, int projectId, String role) {
        this.empId = empId;
        this.projectId = projectId;
        this.role = role;
    }

    // Getters and Setters
    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }
    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public void setEmployee(Employee employee) {
        this.empId = employee.getEmpId();
        this.role = employee.getPosition();
    }
    public Employee getEmployee() {
        return new Employee(this.empId, 0, "", this.role, "", "");
    }
}