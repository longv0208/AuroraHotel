package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entity class for Customers table
 * Represents hotel customers
 */
public class Customer {
    private int customerID;
    private String fullName;
    private String idCard; // CMND/CCCD
    private String phone;
    private String email;
    private String address;
    private LocalDate dateOfBirth;
    private String nationality;
    private int userID; // Link to User account (nullable for guest customers)
    private LocalDateTime createdDate;
    private int totalBookings;
    private String notes;

    // No-arg constructor
    public Customer() {
    }

    // Full constructor
    public Customer(int customerID, String fullName, String idCard, String phone,
                    String email, String address, LocalDate dateOfBirth, String nationality,
                    int userID, LocalDateTime createdDate, int totalBookings, String notes) {
        this.customerID = customerID;
        this.fullName = fullName;
        this.idCard = idCard;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.nationality = nationality;
        this.userID = userID;
        this.createdDate = createdDate;
        this.totalBookings = totalBookings;
        this.notes = notes;
    }

    // Constructor without ID
    public Customer(String fullName, String idCard, String phone, String email, 
                    String address, LocalDate dateOfBirth, String nationality, String notes) {
        this.fullName = fullName;
        this.idCard = idCard;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.nationality = nationality;
        this.notes = notes;
        this.totalBookings = 0;
    }

    // Getters and Setters
    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getNationality() {
        return nationality;
    }

    public void setNationality(String nationality) {
        this.nationality = nationality;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public int getTotalBookings() {
        return totalBookings;
    }

    public void setTotalBookings(int totalBookings) {
        this.totalBookings = totalBookings;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    @Override
    public String toString() {
        return "Customer{" +
                "customerID=" + customerID +
                ", fullName='" + fullName + '\'' +
                ", idCard='" + idCard + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", address='" + address + '\'' +
                ", dateOfBirth=" + dateOfBirth +
                ", nationality='" + nationality + '\'' +
                ", userID=" + userID +
                ", createdDate=" + createdDate +
                ", totalBookings=" + totalBookings +
                ", notes='" + notes + '\'' +
                '}';
    }
}

