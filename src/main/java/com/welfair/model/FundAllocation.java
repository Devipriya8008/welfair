package com.welfair.model;

import java.math.BigDecimal;
import java.sql.Date;

public class FundAllocation {
    private int fundId;
    private int projectId;
    private BigDecimal amount;
    private Date dateAllocated;

    // Constructors, Getters, and Setters
    public FundAllocation() {}
    public FundAllocation(int fundId, int projectId, BigDecimal amount, Date dateAllocated) {
        this.fundId = fundId;
        this.projectId = projectId;
        this.amount = amount;
        this.dateAllocated = dateAllocated;
    }

    // Getters and Setters
    public int getFundId() { return fundId; }
    public void setFundId(int fundId) { this.fundId = fundId; }
    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    public Date getDateAllocated() { return dateAllocated; }
    public void setDateAllocated(Date dateAllocated) { this.dateAllocated = dateAllocated; }
}