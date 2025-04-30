package com.welfair.model;

public class EventVolunteer {
    private int eventId;
    private int volunteerId;
    private int inverterId;

    // Constructors, Getters, and Setters
    public EventVolunteer() {}
    public EventVolunteer(int eventId, int volunteerId, int inverterId) {
        this.eventId = eventId;
        this.volunteerId = volunteerId;
        this.inverterId = inverterId;
    }

    // Getters and Setters
    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
    public int getVolunteerId() { return volunteerId; }
    public void setVolunteerId(int volunteerId) { this.volunteerId = volunteerId; }
    public int getInverterId() { return inverterId; }
    public void setInverterId(int inverterId) { this.inverterId = inverterId; }
}