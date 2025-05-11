package com.welfair.servlet;

import com.welfair.dao.*;
import com.welfair.db.DBConnection;
import com.welfair.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin-table")
public class AdminTableServlet extends HttpServlet {
    private DonorDAO donorDAO;
    private DonationDAO donationDAO;
    private ProjectDAO projectDAO;
    private BeneficiaryDAO beneficiaryDAO;
    private EmployeeDAO employeeDAO;
    private VolunteerDAO volunteerDAO;
    private EventDAO eventDAO;
    private EventVolunteerDAO eventVolunteerDAO;
    private InventoryDAO inventoryDAO;
    private InventoryUsageDAO inventoryUsageDAO;
    private FundAllocationDAO fundAllocationDAO;
    private ProjectBeneficiaryDAO projectBeneficiaryDAO;
    private ProjectEmployeeDAO projectEmployeeDAO;
    private VolunteerProjectDAO volunteerProjectDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        donorDAO = new DonorDAO();
        donationDAO = new DonationDAO();
        projectDAO = new ProjectDAO();
        beneficiaryDAO = new BeneficiaryDAO();
        employeeDAO = new EmployeeDAO();
        volunteerDAO = new VolunteerDAO();
        eventDAO = new EventDAO();
        eventVolunteerDAO = new EventVolunteerDAO();
        inventoryDAO = new InventoryDAO();
        inventoryUsageDAO = new InventoryUsageDAO();
        fundAllocationDAO = new FundAllocationDAO();
        projectBeneficiaryDAO = new ProjectBeneficiaryDAO();
        projectEmployeeDAO = new ProjectEmployeeDAO();
        volunteerProjectDAO = new VolunteerProjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tableName = request.getParameter("table");
        String viewPage = "admin-table-view.jsp";
        String table = request.getParameter("table");

        try {
            switch (tableName) {
                case "donors":
                    List<Donor> donors = donorDAO.getAllDonors();
                    request.setAttribute("tableData", donors);
                    request.setAttribute("tableName", "Donors");
                    break;

                case "donations":
                    List<Donation> donations = donationDAO.getAllDonations();
                    request.setAttribute("tableData", donations);
                    request.setAttribute("tableName", "Donations");
                    break;

                case "projects":
                    List<Project> projects = projectDAO.getAllProjects();
                    request.setAttribute("tableData", projects);
                    request.setAttribute("tableName", "Projects");
                    break;

                case "beneficiaries":
                    List<Beneficiary> beneficiaries = beneficiaryDAO.getAllBeneficiaries();
                    request.setAttribute("tableData", beneficiaries);
                    request.setAttribute("tableName", "Beneficiaries");
                    break;

                case "employees":
                    List<Employee> employees = employeeDAO.getAllEmployees();
                    request.setAttribute("tableData", employees);
                    request.setAttribute("tableName", "Employees");
                    break;

                case "volunteers":
                    List<Volunteer> volunteers = volunteerDAO.getAllVolunteers();
                    request.setAttribute("tableData", volunteers);
                    request.setAttribute("tableName", "Volunteers");
                    break;

                case "events":
                    List<Event> events = eventDAO.getAllEvents();
                    request.setAttribute("tableData", events);
                    request.setAttribute("tableName", "Events");
                    break;

                case "event_volunteers":
                    List<EventVolunteer> eventVolunteers = eventVolunteerDAO.getAllEventVolunteers();
                    request.setAttribute("tableData", eventVolunteers);
                    request.setAttribute("tableName", "Event Volunteers");
                    break;

                case "inventory":
                    List<Inventory> inventoryItems = inventoryDAO.getAllInventoryItems();
                    request.setAttribute("tableData", inventoryItems);
                    request.setAttribute("tableName", "Inventory");
                    break;

                case "inventory_usage":
                    List<InventoryUsage> inventoryUsage = inventoryUsageDAO.getAllInventoryUsage();
                    request.setAttribute("tableData", inventoryUsage);
                    request.setAttribute("tableName", "Inventory Usage");
                    break;

                case "fund_allocation":
                    List<FundAllocation> fundAllocations = fundAllocationDAO.getAllFundAllocations();
                    request.setAttribute("tableData", fundAllocations);
                    request.setAttribute("tableName", "Fund Allocations");
                    break;

                case "project_beneficiaries":
                    List<ProjectBeneficiary> projectBeneficiaries = projectBeneficiaryDAO.getAllProjectBeneficiaries();
                    request.setAttribute("tableData", projectBeneficiaries);
                    request.setAttribute("tableName", "Project Beneficiaries");
                    break;

                case "project_employees":
                    List<ProjectEmployee> projectEmployees = projectEmployeeDAO.getAllProjectEmployees();
                    request.setAttribute("tableData", projectEmployees);
                    request.setAttribute("tableName", "Project Employees");
                    break;

                case "volunteer_projects":
                    List<VolunteerProject> volunteerProjects = volunteerProjectDAO.getAllVolunteerProjects();
                    request.setAttribute("tableData", volunteerProjects);
                    request.setAttribute("tableName", "Volunteer Projects");
                    break;

                default:
                    request.setAttribute("error", "Invalid table specified");
                    viewPage = "error.jsp";
            }

            request.setAttribute("tableName", table.substring(0, 1).toUpperCase() + table.substring(1));
            request.setAttribute("tableId", table);
            request.getRequestDispatcher("/admin-table-view.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
