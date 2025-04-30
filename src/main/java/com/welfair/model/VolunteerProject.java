package com.welfair.model;

public class VolunteerProject {
    private int volunteerId;
    private int projectId;
    private String role;

    // Constructors, Getters, and Setters
    public VolunteerProject() {}
    public VolunteerProject(int volunteerId, int projectId, String role) {
        this.volunteerId = volunteerId;
        this.projectId = projectId;
        this.role = role;
    }

    // Getters and Setters
    public int getVolunteerId() { return volunteerId; }
    public void setVolunteerId(int volunteerId) { this.volunteerId = volunteerId; }
    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}