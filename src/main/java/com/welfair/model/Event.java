package com.welfair.model;

import java.sql.Date;

public class Event {
    private int eventId;
    private String name;
    private Date date;
    private String location;
    private String organizer;

    // Constructors, Getters, and Setters
    public Event() {}
    public Event(int eventId, String name, Date date, String location, String organizer) {
        this.eventId = eventId;
        this.name = name;
        this.date = date;
        this.location = location;
        this.organizer = organizer;
    }

    // Getters and Setters
    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getOrganizer() { return organizer; }
    public void setOrganizer(String organizer) { this.organizer = organizer; }
}