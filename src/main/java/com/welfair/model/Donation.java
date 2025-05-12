package com.welfair.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Objects;

public class Donation {
    private int donationId;
    private int donorId;
    private int projectId;
    private BigDecimal amount;
    private Timestamp date;
    private String mode;
    private String projectTitle;
    private String donorEmail;
    private String donorName;

    // Constructors
    public Donation() {
        this.amount = BigDecimal.ZERO;
        this.date = new Timestamp(System.currentTimeMillis());
        this.mode = "Unknown";
    }

    public Donation(int donorId, int projectId, BigDecimal amount, String mode) {
        this();
        this.donorId = donorId;
        this.projectId = projectId;
        this.amount = amount != null ? amount : BigDecimal.ZERO;
        this.mode = mode != null ? mode : "Unknown";
    }

    // Getters and Setters (same as before)
    public int getDonationId() {
        return donationId;
    }

    public void setDonationId(int donationId) {
        this.donationId = donationId;
    }

    public int getDonorId() {
        return donorId;
    }

    public void setDonorId(int donorId) {
        this.donorId = donorId;
    }

    public int getProjectId() {
        return projectId;
    }

    public void setProjectId(int projectId) {
        this.projectId = projectId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount != null ? amount : BigDecimal.ZERO;
    }

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date != null ? date : new Timestamp(System.currentTimeMillis());
    }

    // Convenience method for LocalDateTime
    public LocalDateTime getLocalDateTime() {
        return date != null ? date.toLocalDateTime() : LocalDateTime.now();
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode != null ? mode : "Unknown";
    }

    public String getProjectTitle() {
        return projectTitle;
    }

    public void setProjectTitle(String projectTitle) {
        this.projectTitle = projectTitle;
    }

    public String getDonorEmail() {
        return donorEmail;
    }

    public void setDonorEmail(String donorEmail) {
        this.donorEmail = donorEmail;
    }

    public String getDonorName() {
        return donorName;
    }

    public void setDonorName(String donorName) {
        this.donorName = donorName;
    }

    // Utility methods
    @Override
    public String toString() {
        return "Donation{" +
                "donationId=" + donationId +
                ", donorId=" + donorId +
                ", projectId=" + projectId +
                ", amount=" + amount +
                ", date=" + date +
                ", mode='" + mode + '\'' +
                ", projectTitle='" + projectTitle + '\'' +
                ", donorEmail='" + donorEmail + '\'' +
                ", donorName='" + donorName + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Donation donation = (Donation) o;
        return donationId == donation.donationId &&
                donorId == donation.donorId &&
                projectId == donation.projectId &&
                Objects.equals(amount, donation.amount) &&
                Objects.equals(date, donation.date) &&
                Objects.equals(mode, donation.mode);
    }

    @Override
    public int hashCode() {
        return Objects.hash(donationId, donorId, projectId, amount, date, mode);
    }
}