package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entity class for BookingServices table
 * Represents services used during a booking
 */
public class BookingService {
    private int bookingServiceID;
    private int bookingID;
    private int serviceID;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;
    private LocalDateTime serviceDate;
    private String notes;
    
    // For joined queries
    private Service service;

    // No-arg constructor
    public BookingService() {
    }

    // Full constructor
    public BookingService(int bookingServiceID, int bookingID, int serviceID, 
                          int quantity, BigDecimal unitPrice, BigDecimal totalPrice, 
                          LocalDateTime serviceDate, String notes) {
        this.bookingServiceID = bookingServiceID;
        this.bookingID = bookingID;
        this.serviceID = serviceID;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.serviceDate = serviceDate;
        this.notes = notes;
    }

    // Constructor without ID
    public BookingService(int bookingID, int serviceID, int quantity, 
                          BigDecimal unitPrice, BigDecimal totalPrice, String notes) {
        this.bookingID = bookingID;
        this.serviceID = serviceID;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.notes = notes;
    }

    // Getters and Setters
    public int getBookingServiceID() {
        return bookingServiceID;
    }

    public void setBookingServiceID(int bookingServiceID) {
        this.bookingServiceID = bookingServiceID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public LocalDateTime getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(LocalDateTime serviceDate) {
        this.serviceDate = serviceDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    @Override
    public String toString() {
        return "BookingService{" +
                "bookingServiceID=" + bookingServiceID +
                ", bookingID=" + bookingID +
                ", serviceID=" + serviceID +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", totalPrice=" + totalPrice +
                ", serviceDate=" + serviceDate +
                ", notes='" + notes + '\'' +
                '}';
    }
}

