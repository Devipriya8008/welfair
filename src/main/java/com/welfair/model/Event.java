package com.welfair.model;

import java.sql.Date;
import java.sql.Time;

public class Event {
    private int eventId;
    private String name;
    private Date date;
    private Time time; // Add this field
    private String location;
    private String organizer;
    private String shortDescription; // Add this field
    private String imageUrl; // Add this field
    private String category; // Add this field (volunteer, fundraiser, etc.)

    // Constructors
    public Event() {}

    public Event(int eventId, String name, Date date, Time time, String location,
                 String organizer, String shortDescription, String imageUrl, String category) {
        this.eventId = eventId;
        this.name = name;
        this.date = date;
        this.time = time;
        this.location = location;
        this.organizer = organizer;
        this.shortDescription = shortDescription;
        this.imageUrl = imageUrl;
        this.category = category;
    }

    // Getters and Setters (add for new fields)
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
    public Time getTime() { return time; }
    public void setTime(Time time) { this.time = time; }
    public String getShortDescription() { return shortDescription; }
    public void setShortDescription(String shortDescription) { this.shortDescription = shortDescription; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    // Keep existing getters/setters
    // ...
}