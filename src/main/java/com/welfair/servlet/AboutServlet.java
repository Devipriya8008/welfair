package com.welfair.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.welfair.dao.DonorDAO;
import com.welfair.model.Donor;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import com.welfair.db.DBConnection;
@WebServlet("/api/about")
public class AboutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        String category = request.getParameter("category");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DBConnection.getConnection()) {
            switch (type) {
                case "team":
                    response.getWriter().write(getTeamData(conn));
                    break;
                case "projects":
                    response.getWriter().write(getProjectsData(conn));
                    break;
                case "impact":
                    response.getWriter().write(getImpactData(conn));
                    break;
                case "stories":
                    response.getWriter().write(getSuccessStories(conn, category));
                    break;
                case "finance":
                    response.getWriter().write(getFinancialData(conn));
                    break;
                case "partners":
                    response.getWriter().write(getPartnerData(conn));
                    break;
                case "volunteers":
                    response.getWriter().write(getVolunteerData(conn));
                    break;
                case "demographics":
                    response.getWriter().write(getDemographicData(conn));
                    break;
                case "age-groups":
                    response.getWriter().write(getAgeGroupData(conn));
                    break;
                default:
                    response.sendError(400, "Invalid type parameter");
            }
        } catch (SQLException e) {
            response.sendError(500, "Database error: " + e.getMessage());
        }
    }

    // 1. Team Member Showcase
    private String getTeamData(Connection conn) throws SQLException {
        String sql = "SELECT e.emp_id as id, e.name, e.position, e.email, e.bio, e.photo_url " +
                "FROM employees e JOIN users u ON e.user_id = u.user_id " +
                "WHERE u.role = 'employee' ORDER BY e.name LIMIT 10";
        return resultSetToJson(conn.createStatement().executeQuery(sql));
    }

    // 2. Project Timeline Visualization
    private String getProjectsData(Connection conn) throws SQLException {
        String sql = "SELECT project_id as id, name, description, start_date, " +
                "end_date, status, category, location FROM projects " +
                "ORDER BY start_date DESC";
        return resultSetToJson(conn.createStatement().executeQuery(sql));
    }

    // 3. Impact Statistics Dashboard
    private String getImpactData(Connection conn) throws SQLException {
        String beneficiariesSql = "SELECT COUNT(DISTINCT beneficiary_id) AS count FROM beneficiaries";
        String projectsSql = "SELECT COUNT(*) AS count FROM projects WHERE status = 'completed'";
        String fundsSql = "SELECT SUM(amount) AS amount FROM donations";

        int beneficiaries = getSingleIntResult(conn, beneficiariesSql);
        int projects = getSingleIntResult(conn, projectsSql);
        double funds = getSingleDoubleResult(conn, fundsSql);

        return gson.toJson(Map.of(
                "beneficiaries", beneficiaries,
                "projects", projects,
                "funds", funds
        ));
    }

    // 4. Success Stories Carousel
    private String getSuccessStories(Connection conn, String category) throws SQLException {
        String sql = "SELECT b.beneficiary_id as id, b.name, b.age, b.gender, " +
                "p.name as project, p.description as impact, " +
                "b.story_content, b.before_photo, b.after_photo " +
                "FROM beneficiaries b " +
                "JOIN project_beneficiaries pb ON b.beneficiary_id = pb.beneficiary_id " +
                "JOIN projects p ON pb.project_id = p.project_id " +
                "WHERE b.story_consent = true " +
                (category != null && !category.equals("all") ?
                        "AND p.category = '" + category + "' " : "") +
                "ORDER BY pb.date_assigned DESC LIMIT 5";
        return resultSetToJson(conn.createStatement().executeQuery(sql));
    }

    // 5. Financial Transparency Report
    private String getFinancialData(Connection conn) throws SQLException {
        // Recent donations
        String donationsSql = "SELECT d.name AS donor, dn.amount, p.name AS project, " +
                "dn.date, dn.payment_method " +
                "FROM donations dn " +
                "JOIN donors d ON dn.donor_id = d.donor_id " +
                "JOIN projects p ON dn.project_id = p.project_id " +
                "ORDER BY dn.date DESC LIMIT 10";

        // Fund allocation
        String allocationSql = "SELECT p.name AS project, fa.amount, " +
                "fa.date_allocated, fa.purpose " +
                "FROM fund_allocation fa " +
                "JOIN projects p ON fa.project_id = p.project_id " +
                "ORDER BY fa.date_allocated DESC LIMIT 5";

        Map<String, Object> result = new HashMap<>();
        result.put("donations", resultSetToList(conn.createStatement().executeQuery(donationsSql)));
        result.put("allocations", resultSetToList(conn.createStatement().executeQuery(allocationSql)));

        return gson.toJson(result);
    }

    // 6. Partner Network Display
    private String getPartnerData(Connection conn) throws SQLException {
        String sql = "SELECT d.donor_id as id, d.name, d.email, d.phone, " +
                "d.logo_url, d.website, d.partnership_since " +
                "FROM donors d " +
                "JOIN users u ON d.user_id = u.user_id " +
                "WHERE u.role = 'corporate' " +
                "ORDER BY d.partnership_since DESC";
        return resultSetToJson(conn.createStatement().executeQuery(sql));
    }

    // 7. Volunteer Spotlight
    private String getVolunteerData(Connection conn) throws SQLException {
        String sql = "SELECT v.volunteer_id as id, v.name, v.email, v.phone, " +
                "v.join_date, COUNT(ev.event_id) AS events_attended, " +
                "v.profile_photo, v.testimonial " +
                "FROM volunteers v " +
                "LEFT JOIN event_volunteers ev ON v.volunteer_id = ev.volunteer_id " +
                "GROUP BY v.volunteer_id " +
                "ORDER BY events_attended DESC LIMIT 5";
        return resultSetToJson(conn.createStatement().executeQuery(sql));
    }

    // Demographic Data
    private String getDemographicData(Connection conn) throws SQLException {
        String sql = "SELECT gender, COUNT(*) as count, AVG(age) as avg_age " +
                "FROM beneficiaries GROUP BY gender";
        return resultSetToJson(conn.createStatement().executeQuery(sql));
    }

    // Age Group Distribution
    private String getAgeGroupData(Connection conn) throws SQLException {
        String sql = "SELECT " +
                "CASE " +
                "  WHEN age < 18 THEN 'Children' " +
                "  WHEN age BETWEEN 18 AND 65 THEN 'Adults' " +
                "  ELSE 'Seniors' " +
                "END AS age_group, " +
                "COUNT(*) AS count " +
                "FROM beneficiaries " +
                "GROUP BY age_group";
        return resultSetToJson(conn.createStatement().executeQuery(sql));
    }

    // Helper methods
    private String resultSetToJson(ResultSet rs) throws SQLException {
        return gson.toJson(resultSetToList(rs));
    }

    private List<Map<String, Object>> resultSetToList(ResultSet rs) throws SQLException {
        List<Map<String, Object>> results = new ArrayList<>();
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            for (int i = 1; i <= columnCount; i++) {
                row.put(metaData.getColumnName(i), rs.getObject(i));
            }
            results.add(row);
        }
        return results;
    }

    private int getSingleIntResult(Connection conn, String sql) throws SQLException {
        ResultSet rs = conn.createStatement().executeQuery(sql);
        rs.next();
        return rs.getInt(1);
    }

    private double getSingleDoubleResult(Connection conn, String sql) throws SQLException {
        ResultSet rs = conn.createStatement().executeQuery(sql);
        rs.next();
        return rs.getDouble(1);
    }
}