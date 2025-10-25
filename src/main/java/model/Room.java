package model;

/**
 * Entity class for Rooms table
 * Represents individual hotel rooms
 */
public class Room {
    private int roomID;
    private String roomNumber;
    private int roomTypeID;
    private int floor;
    private String status; // Trống, Đã đặt, Đang sử dụng, Bảo trì
    private String description;
    private boolean isActive;
    
    // For joined queries
    private RoomType roomType;

    // No-arg constructor
    public Room() {
    }

    // Full constructor
    public Room(int roomID, String roomNumber, int roomTypeID, int floor, 
                String status, String description, boolean isActive) {
        this.roomID = roomID;
        this.roomNumber = roomNumber;
        this.roomTypeID = roomTypeID;
        this.floor = floor;
        this.status = status;
        this.description = description;
        this.isActive = isActive;
    }

    // Constructor without ID
    public Room(String roomNumber, int roomTypeID, int floor, String status, String description) {
        this.roomNumber = roomNumber;
        this.roomTypeID = roomTypeID;
        this.floor = floor;
        this.status = status;
        this.description = description;
        this.isActive = true;
    }

    // Getters and Setters
    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public int getRoomTypeID() {
        return roomTypeID;
    }

    public void setRoomTypeID(int roomTypeID) {
        this.roomTypeID = roomTypeID;
    }

    public int getFloor() {
        return floor;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }

    @Override
    public String toString() {
        return "Room{" +
                "roomID=" + roomID +
                ", roomNumber='" + roomNumber + '\'' +
                ", roomTypeID=" + roomTypeID +
                ", floor=" + floor +
                ", status='" + status + '\'' +
                ", description='" + description + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}

