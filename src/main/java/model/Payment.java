package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entity class for Payments table
 * Represents payment transactions
 */
public class Payment {
    private int paymentID;
    private int bookingID;
    private LocalDateTime paymentDate;
    private BigDecimal amount;
    private String paymentMethod; // Cash, Transfer, Card
    private String paymentType; // Đặt cọc, Thanh toán, Hoàn tiền
    private String transactionID;
    private int userID; // User who processed the payment
    private String notes;
    private String status;

    // No-arg constructor
    public Payment() {
    }

    // Full constructor
    public Payment(int paymentID, int bookingID, LocalDateTime paymentDate, 
                   BigDecimal amount, String paymentMethod, String paymentType, 
                   String transactionID, int userID, String notes, String status) {
        this.paymentID = paymentID;
        this.bookingID = bookingID;
        this.paymentDate = paymentDate;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentType = paymentType;
        this.transactionID = transactionID;
        this.userID = userID;
        this.notes = notes;
        this.status = status;
    }

    // Constructor without ID
    public Payment(int bookingID, BigDecimal amount, String paymentMethod, 
                   String paymentType, String transactionID, int userID, String notes) {
        this.bookingID = bookingID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentType = paymentType;
        this.transactionID = transactionID;
        this.userID = userID;
        this.notes = notes;
        this.status = "Thành công";
    }

    // Getters and Setters
    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(String transactionID) {
        this.transactionID = transactionID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "paymentID=" + paymentID +
                ", bookingID=" + bookingID +
                ", paymentDate=" + paymentDate +
                ", amount=" + amount +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentType='" + paymentType + '\'' +
                ", transactionID='" + transactionID + '\'' +
                ", userID=" + userID +
                ", notes='" + notes + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}

