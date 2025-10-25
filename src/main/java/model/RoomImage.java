package model;

import java.time.LocalDateTime;

/**
 * Entity class for RoomImages table
 * Represents images for rooms or room types
 */
public class RoomImage {
    private int imageID;
    private Integer roomID; // NULL if image is for room type
    private Integer roomTypeID; // NULL if image is for specific room
    private String imageURL;
    private String imageTitle;
    private String description;
    private boolean isPrimary;
    private int displayOrder;
    private int uploadedBy;
    private LocalDateTime uploadedDate;
    private boolean isActive;

    // No-arg constructor
    public RoomImage() {
    }

    // Full constructor
    public RoomImage(int imageID, Integer roomID, Integer roomTypeID, String imageURL, 
                     String imageTitle, String description, boolean isPrimary, int displayOrder, 
                     int uploadedBy, LocalDateTime uploadedDate, boolean isActive) {
        this.imageID = imageID;
        this.roomID = roomID;
        this.roomTypeID = roomTypeID;
        this.imageURL = imageURL;
        this.imageTitle = imageTitle;
        this.description = description;
        this.isPrimary = isPrimary;
        this.displayOrder = displayOrder;
        this.uploadedBy = uploadedBy;
        this.uploadedDate = uploadedDate;
        this.isActive = isActive;
    }

    // Constructor without ID
    public RoomImage(Integer roomID, Integer roomTypeID, String imageURL, String imageTitle, 
                     String description, boolean isPrimary, int displayOrder, int uploadedBy) {
        this.roomID = roomID;
        this.roomTypeID = roomTypeID;
        this.imageURL = imageURL;
        this.imageTitle = imageTitle;
        this.description = description;
        this.isPrimary = isPrimary;
        this.displayOrder = displayOrder;
        this.uploadedBy = uploadedBy;
        this.isActive = true;
    }

    // Getters and Setters
    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public Integer getRoomID() {
        return roomID;
    }

    public void setRoomID(Integer roomID) {
        this.roomID = roomID;
    }

    public Integer getRoomTypeID() {
        return roomTypeID;
    }

    public void setRoomTypeID(Integer roomTypeID) {
        this.roomTypeID = roomTypeID;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String getImageTitle() {
        return imageTitle;
    }

    public void setImageTitle(String imageTitle) {
        this.imageTitle = imageTitle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isPrimary() {
        return isPrimary;
    }

    public void setPrimary(boolean primary) {
        isPrimary = primary;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public int getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(int uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    public LocalDateTime getUploadedDate() {
        return uploadedDate;
    }

    public void setUploadedDate(LocalDateTime uploadedDate) {
        this.uploadedDate = uploadedDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "RoomImage{" +
                "imageID=" + imageID +
                ", roomID=" + roomID +
                ", roomTypeID=" + roomTypeID +
                ", imageURL='" + imageURL + '\'' +
                ", imageTitle='" + imageTitle + '\'' +
                ", description='" + description + '\'' +
                ", isPrimary=" + isPrimary +
                ", displayOrder=" + displayOrder +
                ", uploadedBy=" + uploadedBy +
                ", uploadedDate=" + uploadedDate +
                ", isActive=" + isActive +
                '}';
    }
}

