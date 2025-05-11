package com.welfair.dao;

import com.welfair.model.Event;
import com.welfair.db.DBConnection;
import java.sql.*;
        import java.util.ArrayList;
import java.util.List;

public class EventDAO {
    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Event event = new Event();
                event.setEventId(rs.getInt("event_id"));
                event.setName(rs.getString("name"));
                event.setDate(rs.getDate("date"));
                event.setTime(rs.getTime("time")); // Add this line
                event.setLocation(rs.getString("location"));
                event.setOrganizer(rs.getString("organizer"));
                event.setShortDescription(rs.getString("short_description")); // Add this line
                event.setImageUrl(rs.getString("image_url")); // Add this line
                event.setCategory(rs.getString("category")); // Add this line
                events.add(event);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return events;
    }
    public Event getEventById(int id) {
        Event event = null;
        String sql = "SELECT * FROM events WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                event = new Event();
                event.setEventId(rs.getInt("event_id"));
                event.setName(rs.getString("name"));
                event.setDate(rs.getDate("date"));
                event.setLocation(rs.getString("location"));
                event.setOrganizer(rs.getString("organizer"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return event;
    }

    // Update event
    public void updateEvent(Event event) {
        String sql = "UPDATE events SET name = ?, date = ?, location = ?, organizer = ? WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, event.getName());
            pstmt.setDate(2, event.getDate());
            pstmt.setString(3, event.getLocation());
            pstmt.setString(4, event.getOrganizer());
            pstmt.setInt(5, event.getEventId());
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete event
    public void deleteEvent(int id) {
        String sql = "DELETE FROM events WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void addEvent(Event event) {
        String sql = "INSERT INTO events (name, date, location, organizer) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, event.getName());
            pstmt.setDate(2, event.getDate());
            pstmt.setString(3, event.getLocation());
            pstmt.setString(4, event.getOrganizer());
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // Keep other methods as they are
    // ...
}