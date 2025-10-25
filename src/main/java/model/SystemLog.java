package model;

import java.time.LocalDateTime;

/**
 * Entity class for SystemLogs table
 * Tracks system actions and changes
 */
public class SystemLog {
    private int logID;
    private int userID;
    private String action;
    private String tableName;
    private Integer recordID;
    private String oldValue;
    private String newValue;
    private String ipAddress;
    private LocalDateTime logDate;

    // No-arg constructor
    public SystemLog() {
    }

    // Full constructor
    public SystemLog(int logID, int userID, String action, String tableName, 
                     Integer recordID, String oldValue, String newValue, 
                     String ipAddress, LocalDateTime logDate) {
        this.logID = logID;
        this.userID = userID;
        this.action = action;
        this.tableName = tableName;
        this.recordID = recordID;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.ipAddress = ipAddress;
        this.logDate = logDate;
    }

    // Constructor without ID
    public SystemLog(int userID, String action, String tableName, Integer recordID, 
                     String oldValue, String newValue, String ipAddress) {
        this.userID = userID;
        this.action = action;
        this.tableName = tableName;
        this.recordID = recordID;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.ipAddress = ipAddress;
    }

    // Getters and Setters
    public int getLogID() {
        return logID;
    }

    public void setLogID(int logID) {
        this.logID = logID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public Integer getRecordID() {
        return recordID;
    }

    public void setRecordID(Integer recordID) {
        this.recordID = recordID;
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

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public LocalDateTime getLogDate() {
        return logDate;
    }

    public void setLogDate(LocalDateTime logDate) {
        this.logDate = logDate;
    }

    @Override
    public String toString() {
        return "SystemLog{" +
                "logID=" + logID +
                ", userID=" + userID +
                ", action='" + action + '\'' +
                ", tableName='" + tableName + '\'' +
                ", recordID=" + recordID +
                ", oldValue='" + oldValue + '\'' +
                ", newValue='" + newValue + '\'' +
                ", ipAddress='" + ipAddress + '\'' +
                ", logDate=" + logDate +
                '}';
    }
}

