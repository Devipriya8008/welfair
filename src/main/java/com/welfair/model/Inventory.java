package com.welfair.model;

public class Inventory {
    private int itemId;
    private String name;
    private int quantity;
    private String unit;

    // Constructors, Getters, and Setters
    public Inventory() {}
    public Inventory(int itemId, String name, int quantity, String unit) {
        this.itemId = itemId;
        this.name = name;
        this.quantity = quantity;
        this.unit = unit;
    }

    // Getters and Setters
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
}