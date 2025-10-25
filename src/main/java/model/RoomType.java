package model;

import java.math.BigDecimal;

/**
 * Entity class for RoomTypes table
 * Represents different types of hotel rooms
 */
public class RoomType {
    private int roomTypeID;
    private String typeName;
    private String description;
    private BigDecimal basePrice;
    private int maxGuests;
    private String amenities;
    private boolean isActive;

    // No-arg constructor
    public RoomType() {
    }

    // Full constructor
    public RoomType(int roomTypeID, String typeName, String description, 
                    BigDecimal basePrice, int maxGuests, String amenities, boolean isActive) {
        this.roomTypeID = roomTypeID;
        this.typeName = typeName;
        this.description = description;
        this.basePrice = basePrice;
        this.maxGuests = maxGuests;
        this.amenities = amenities;
        this.isActive = isActive;
    }

    // Constructor without ID
    public RoomType(String typeName, String description, BigDecimal basePrice, 
                    int maxGuests, String amenities) {
        this.typeName = typeName;
        this.description = description;
        this.basePrice = basePrice;
        this.maxGuests = maxGuests;
        this.amenities = amenities;
        this.isActive = true;
    }

    // Getters and Setters
    public int getRoomTypeID() {
        return roomTypeID;
    }

    public void setRoomTypeID(int roomTypeID) {
        this.roomTypeID = roomTypeID;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(BigDecimal basePrice) {
        this.basePrice = basePrice;
    }

    public int getMaxGuests() {
        return maxGuests;
    }

    public void setMaxGuests(int maxGuests) {
        this.maxGuests = maxGuests;
    }

    public String getAmenities() {
        return amenities;
    }

    public void setAmenities(String amenities) {
        this.amenities = amenities;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "RoomType{" +
                "roomTypeID=" + roomTypeID +
                ", typeName='" + typeName + '\'' +
                ", description='" + description + '\'' +
                ", basePrice=" + basePrice +
                ", maxGuests=" + maxGuests +
                ", amenities='" + amenities + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}

