package com.welfair.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Donation {
    private int donationId;
    private int donorId;
    private int projectId;
    private BigDecimal amount;
    private Timestamp date;
    private String mode;

    // ✅ Add these two fields
    private String projectTitle;
    private String donorEmail;

    public Donation() {}

    public Donation(int donationId, int donorId, int projectId, BigDecimal amount, Timestamp date, String mode) {
        this.donationId = donationId;
        this.donorId = donorId;
        this.projectId = projectId;
        this.amount = amount;
        this.date = date;
        this.mode = mode;
    }

    // Getters and Setters
    public int getDonationId() { return donationId; }
    public void setDonationId(int donationId) { this.donationId = donationId; }

    public int getDonorId() { return donorId; }
    public void setDonorId(int donorId) { this.donorId = donorId; }

    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }

    public String getMode() { return mode; }
    public void setMode(String mode) { this.mode = mode; }

    // ✅ Add missing getters/setters
    public String getProjectTitle() { return projectTitle; }
    public void setProjectTitle(String projectTitle) { this.projectTitle = projectTitle; }

    public String getDonorEmail() { return donorEmail; }
    public void setDonorEmail(String donorEmail) { this.donorEmail = donorEmail; }
}
