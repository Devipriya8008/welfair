package com.welfair.dao;

import com.welfair.model.EventVolunteer;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventVolunteerDAO {
    // Assign a volunteer to an event
    public void assignVolunteerToEvent(EventVolunteer ev) {
        String sql = "INSERT INTO event_volunteers (event_id, volunteer_id, inverter_id) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, ev.getEventId());
            pstmt.setInt(2, ev.getVolunteerId());
            pstmt.setInt(3, ev.getInverterId());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all event-volunteer assignments
    public List<EventVolunteer> getAllEventVolunteers() {
        List<EventVolunteer> assignments = new ArrayList<>();
        String sql = "SELECT * FROM event_volunteers";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                EventVolunteer ev = new EventVolunteer();
                ev.setEventId(rs.getInt("event_id"));
                ev.setVolunteerId(rs.getInt("volunteer_id"));
                ev.setInverterId(rs.getInt("inverter_id"));
                assignments.add(ev);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return assignments;
    }

    // Get volunteers by event ID
    public List<EventVolunteer> getVolunteersByEventId(int eventId) {
        List<EventVolunteer> volunteers = new ArrayList<>();
        String sql = "SELECT * FROM event_volunteers WHERE event_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                EventVolunteer ev = new EventVolunteer();
                ev.setEventId(rs.getInt("event_id"));
                ev.setVolunteerId(rs.getInt("volunteer_id"));
                ev.setInverterId(rs.getInt("inverter_id"));
                volunteers.add(ev);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return volunteers;
    }

    // Remove a volunteer from an event
    public void removeVolunteerFromEvent(int eventId, int volunteerId) {
        String sql = "DELETE FROM event_volunteers WHERE event_id = ? AND volunteer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            pstmt.setInt(2, volunteerId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}