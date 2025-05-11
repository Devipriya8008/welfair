package com.welfair.model;

public class InventoryUsage {
    private int itemId;
    private int projectId;
    private int quantityUsed;

    // Constructors, Getters, and Setters
    public InventoryUsage() {}
    public InventoryUsage(int itemId, int projectId, int quantityUsed) {
        this.itemId = itemId;
        this.projectId = projectId;
        this.quantityUsed = quantityUsed;
    }

    // Getters and Setters
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }
    public int getQuantityUsed() { return quantityUsed; }
    public void setQuantityUsed(int quantityUsed) { this.quantityUsed = quantityUsed; }

    public void setItem(Inventory item) {
        this.itemId = item.getItemId();
        this.quantityUsed = item.getQuantity();
    }

    public Inventory getItem() {
        return new Inventory(this.itemId, "", this.quantityUsed, "");
    }
}