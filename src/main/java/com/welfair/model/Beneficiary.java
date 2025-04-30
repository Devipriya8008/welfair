package com.welfair.model;

public class Beneficiary {
    private int beneficiaryId;
    private String name;
    private int age;
    private String gender;
    private String address;

    // Constructors, Getters, and Setters
    public Beneficiary() {}
    public Beneficiary(int beneficiaryId, String name, int age, String gender, String address) {
        this.beneficiaryId = beneficiaryId;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.address = address;
    }

    // Getters and Setters
    public int getBeneficiaryId() { return beneficiaryId; }
    public void setBeneficiaryId(int beneficiaryId) { this.beneficiaryId = beneficiaryId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}