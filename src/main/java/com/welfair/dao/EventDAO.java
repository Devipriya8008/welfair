package com.welfair.dao;

import com.welfair.model.Event;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {
    public List<Event> getAllEvents() throws SQLException {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT event_id, name, date, time, location, organizer, " +
                "short_description, image_url, category FROM events ORDER BY date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                events.add(mapEventFromResultSet(rs));
            }
        }
        return events;
    }

    public Event getEventById(int id) throws SQLException {
        String sql = "SELECT * FROM events WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapEventFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public boolean addEvent(Event event) throws SQLException {
        String sql = "INSERT INTO events (name, date, time, location, organizer, " +
                "short_description, image_url, category) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            setEventParameters(pstmt, event);

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        event.setEventId(rs.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }

    public boolean updateEvent(Event event) throws SQLException {
        String sql = "UPDATE events SET name=?, date=?, time=?, location=?, organizer=?, " +
                "short_description=?, image_url=?, category=? WHERE event_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            setEventParameters(pstmt, event);
            pstmt.setInt(9, event.getEventId());

            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteEvent(int id) throws SQLException {
        // First delete related records in event_volunteers table
        String deleteVolunteersSql = "DELETE FROM event_volunteers WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(deleteVolunteersSql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }

        // Then delete the event
        String sql = "DELETE FROM events WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    private Event mapEventFromResultSet(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setEventId(rs.getInt("event_id"));
        event.setName(rs.getString("name"));
        event.setDate(rs.getDate("date"));
        event.setTime(rs.getTime("time"));
        event.setLocation(rs.getString("location"));
        event.setOrganizer(rs.getString("organizer"));
        event.setShortDescription(rs.getString("short_description"));
        event.setImageUrl(rs.getString("image_url"));
        event.setCategory(rs.getString("category"));
        return event;
    }

    private void setEventParameters(PreparedStatement pstmt, Event event) throws SQLException {
        pstmt.setString(1, event.getName());
        pstmt.setDate(2, event.getDate());
        pstmt.setTime(3, event.getTime());
        pstmt.setString(4, event.getLocation());
        pstmt.setString(5, event.getOrganizer());
        pstmt.setString(6, event.getShortDescription());
        pstmt.setString(7, event.getImageUrl());
        pstmt.setString(8, event.getCategory());
    }
}