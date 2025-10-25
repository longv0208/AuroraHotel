package model;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Entity class for BookingDetails table
 * Represents detailed information about booked rooms
 */
public class BookingDetail {
    private int bookingDetailID;
    private int bookingID;
    private LocalDate serviceDate;
    private BigDecimal roomPrice;
    private String specialRequests;

    // No-arg constructor
    public BookingDetail() {
    }

    // Full constructor
    public BookingDetail(int bookingDetailID, int bookingID, LocalDate serviceDate, 
                         BigDecimal roomPrice, String specialRequests) {
        this.bookingDetailID = bookingDetailID;
        this.bookingID = bookingID;
        this.serviceDate = serviceDate;
        this.roomPrice = roomPrice;
        this.specialRequests = specialRequests;
    }

    // Constructor without ID
    public BookingDetail(int bookingID, LocalDate serviceDate, BigDecimal roomPrice, 
                         String specialRequests) {
        this.bookingID = bookingID;
        this.serviceDate = serviceDate;
        this.roomPrice = roomPrice;
        this.specialRequests = specialRequests;
    }

    // Getters and Setters
    public int getBookingDetailID() {
        return bookingDetailID;
    }

    public void setBookingDetailID(int bookingDetailID) {
        this.bookingDetailID = bookingDetailID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public LocalDate getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(LocalDate serviceDate) {
        this.serviceDate = serviceDate;
    }

    public BigDecimal getRoomPrice() {
        return roomPrice;
    }

    public void setRoomPrice(BigDecimal roomPrice) {
        this.roomPrice = roomPrice;
    }

    public String getSpecialRequests() {
        return specialRequests;
    }

    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
    }

    @Override
    public String toString() {
        return "BookingDetail{" +
                "bookingDetailID=" + bookingDetailID +
                ", bookingID=" + bookingID +
                ", serviceDate=" + serviceDate +
                ", roomPrice=" + roomPrice +
                ", specialRequests='" + specialRequests + '\'' +
                '}';
    }
}

