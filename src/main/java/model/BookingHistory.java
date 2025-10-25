package model;

import java.time.LocalDateTime;

/**
 * Entity class for BookingHistory table
 * Tracks changes to bookings for audit trail
 */
public class BookingHistory {
    private int historyID;
    private int bookingID;
    private String fieldChanged;
    private String oldValue;
    private String newValue;
    private int changedBy;
    private LocalDateTime changedDate;
    private String action; // CREATE, UPDATE, CANCEL, CHECKIN, CHECKOUT
    private String notes;
    private String ipAddress;

    // No-arg constructor
    public BookingHistory() {
    }

    // Full constructor
    public BookingHistory(int historyID, int bookingID, String fieldChanged, String oldValue, 
                          String newValue, int changedBy, LocalDateTime changedDate, 
                          String action, String notes, String ipAddress) {
        this.historyID = historyID;
        this.bookingID = bookingID;
        this.fieldChanged = fieldChanged;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.changedBy = changedBy;
        this.changedDate = changedDate;
        this.action = action;
        this.notes = notes;
        this.ipAddress = ipAddress;
    }

    // Constructor without ID
    public BookingHistory(int bookingID, String fieldChanged, String oldValue, String newValue, 
                          int changedBy, String action, String notes, String ipAddress) {
        this.bookingID = bookingID;
        this.fieldChanged = fieldChanged;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.changedBy = changedBy;
        this.action = action;
        this.notes = notes;
        this.ipAddress = ipAddress;
    }

    // Getters and Setters
    public int getHistoryID() {
        return historyID;
    }

    public void setHistoryID(int historyID) {
        this.historyID = historyID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public String getFieldChanged() {
        return fieldChanged;
    }

    public void setFieldChanged(String fieldChanged) {
        this.fieldChanged = fieldChanged;
    }

    public String getOldValue() {
        return oldValue;
    }

    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public int getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(int changedBy) {
        this.changedBy = changedBy;
    }

    public LocalDateTime getChangedDate() {
        return changedDate;
    }

    public void setChangedDate(LocalDateTime changedDate) {
        this.changedDate = changedDate;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    @Override
    public String toString() {
        return "BookingHistory{" +
                "historyID=" + historyID +
                ", bookingID=" + bookingID +
                ", fieldChanged='" + fieldChanged + '\'' +
                ", oldValue='" + oldValue + '\'' +
                ", newValue='" + newValue + '\'' +
                ", changedBy=" + changedBy +
                ", changedDate=" + changedDate +
                ", action='" + action + '\'' +
                ", notes='" + notes + '\'' +
                ", ipAddress='" + ipAddress + '\'' +
                '}';
    }
}

