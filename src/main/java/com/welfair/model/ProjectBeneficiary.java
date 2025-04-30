package com.welfair.model;

import java.sql.Date;

public class ProjectBeneficiary {
    private int projectId;
    private int beneficiaryId;
    private Date dateAssigned;

    // Constructors, Getters, and Setters
    public ProjectBeneficiary() {}
    public ProjectBeneficiary(int projectId, int beneficiaryId, Date dateAssigned) {
        this.projectId = projectId;
        this.beneficiaryId = beneficiaryId;
        this.dateAssigned = dateAssigned;
    }

    // Getters and Setters
    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }
    public int getBeneficiaryId() { return beneficiaryId; }
    public void setBeneficiaryId(int beneficiaryId) { this.beneficiaryId = beneficiaryId; }
    public Date getDateAssigned() { return dateAssigned; }
    public void setDateAssigned(Date dateAssigned) { this.dateAssigned = dateAssigned; }
}