package com.welfair.dao;

import com.welfair.model.EventVolunteer;
import com.welfair.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventVolunteerDAO {

    public void assignVolunteerToEvent(EventVolunteer ev) throws SQLException {
        String sql = "INSERT INTO event_volunteers (event_id, volunteer_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, ev.getEventId());
            pstmt.setInt(2, ev.getVolunteerId());
            pstmt.executeUpdate();
        }
    }

    public EventVolunteer getEventVolunteerById(int eventId, int volunteerId) throws SQLException {
        String sql = "SELECT * FROM event_volunteers WHERE event_id = ? AND volunteer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, eventId);
            pstmt.setInt(2, volunteerId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new EventVolunteer(
                            rs.getInt("event_id"),
                            rs.getInt("volunteer_id")
                    );
                }
            }
        }
        return null;
    }

    public List<EventVolunteer> getAllEventVolunteers() throws SQLException {
        List<EventVolunteer> assignments = new ArrayList<>();
        String sql = "SELECT * FROM event_volunteers";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                assignments.add(new EventVolunteer(
                        rs.getInt("event_id"),
                        rs.getInt("volunteer_id")  // Fixed typo: was "volunteer_id"
                ));
            }
        }
        return assignments;
    }

    public List<EventVolunteer> getVolunteersByEventId(int eventId) throws SQLException {
        List<EventVolunteer> volunteers = new ArrayList<>();
        String sql = "SELECT * FROM event_volunteers WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, eventId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    volunteers.add(new EventVolunteer(
                            rs.getInt("event_id"),
                            rs.getInt("volunteer_id")
                    ));
                }
            }
        }
        return volunteers;
    }
    public void updateAssignment(int oldEventId, int oldVolunteerId, int newEventId, int newVolunteerId)
            throws SQLException {
        String sql = "UPDATE event_volunteers SET event_id = ?, volunteer_id = ? " +
                "WHERE event_id = ? AND volunteer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, newEventId);
            pstmt.setInt(2, newVolunteerId);
            pstmt.setInt(3, oldEventId);
            pstmt.setInt(4, oldVolunteerId);
            pstmt.executeUpdate();
        }
    }
    public void removeVolunteerFromEvent(int eventId, int volunteerId) throws SQLException {
        String sql = "DELETE FROM event_volunteers WHERE event_id = ? AND volunteer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, eventId);
            pstmt.setInt(2, volunteerId);
            pstmt.executeUpdate();
        }
    }
}