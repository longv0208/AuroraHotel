package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entity class for Bookings table
 * Represents room bookings
 */
public class Booking {
    private int bookingID;
    private int customerID;
    private int roomID;
    private int userID; // User who created the booking
    private LocalDateTime bookingDate;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private int numberOfGuests;
    private String status; // Chờ xác nhận, Đã xác nhận, Đã checkin, Đã checkout, Đã hủy
    private BigDecimal totalAmount;
    private BigDecimal depositAmount;
    private String notes;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;
    
    // For joined queries
    private Customer customer;
    private Room room;
    private User user;

    // No-arg constructor
    public Booking() {
    }

    // Full constructor
    public Booking(int bookingID, int customerID, int roomID, int userID, 
                   LocalDateTime bookingDate, LocalDate checkInDate, LocalDate checkOutDate, 
                   int numberOfGuests, String status, BigDecimal totalAmount, 
                   BigDecimal depositAmount, String notes, LocalDateTime createdDate, 
                   LocalDateTime updatedDate) {
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.roomID = roomID;
        this.userID = userID;
        this.bookingDate = bookingDate;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.numberOfGuests = numberOfGuests;
        this.status = status;
        this.totalAmount = totalAmount;
        this.depositAmount = depositAmount;
        this.notes = notes;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // Constructor without ID
    public Booking(int customerID, int roomID, int userID, LocalDate checkInDate, 
                   LocalDate checkOutDate, int numberOfGuests, BigDecimal totalAmount, 
                   BigDecimal depositAmount, String notes) {
        this.customerID = customerID;
        this.roomID = roomID;
        this.userID = userID;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.numberOfGuests = numberOfGuests;
        this.totalAmount = totalAmount;
        this.depositAmount = depositAmount;
        this.notes = notes;
        this.status = "Chờ xác nhận";
    }

    // Getters and Setters
    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public LocalDateTime getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDateTime bookingDate) {
        this.bookingDate = bookingDate;
    }

    public LocalDate getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(LocalDate checkInDate) {
        this.checkInDate = checkInDate;
    }

    public LocalDate getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(LocalDate checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public int getNumberOfGuests() {
        return numberOfGuests;
    }

    public void setNumberOfGuests(int numberOfGuests) {
        this.numberOfGuests = numberOfGuests;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getDepositAmount() {
        return depositAmount;
    }

    public void setDepositAmount(BigDecimal depositAmount) {
        this.depositAmount = depositAmount;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public LocalDateTime getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(LocalDateTime updatedDate) {
        this.updatedDate = updatedDate;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "Booking{" +
                "bookingID=" + bookingID +
                ", customerID=" + customerID +
                ", roomID=" + roomID +
                ", userID=" + userID +
                ", bookingDate=" + bookingDate +
                ", checkInDate=" + checkInDate +
                ", checkOutDate=" + checkOutDate +
                ", numberOfGuests=" + numberOfGuests +
                ", status='" + status + '\'' +
                ", totalAmount=" + totalAmount +
                ", depositAmount=" + depositAmount +
                ", notes='" + notes + '\'' +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                '}';
    }
}

