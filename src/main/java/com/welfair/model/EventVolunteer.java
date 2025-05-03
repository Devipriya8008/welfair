package com.welfair.model;

public class EventVolunteer {
    private int eventId;
    private int volunteerId;

    // Constructors
    public EventVolunteer() {}

    public EventVolunteer(int eventId, int volunteerId) {
        this.eventId = eventId;
        this.volunteerId = volunteerId;
    }

    // Getters and Setters
    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public int getVolunteerId() { return volunteerId; }
    public void setVolunteerId(int volunteerId) { this.volunteerId = volunteerId; }
}