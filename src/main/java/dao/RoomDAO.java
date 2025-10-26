package dao;

import db.DBContext;
import model.Room;
import model.RoomType;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Rooms table
 * Handles all database operations related to rooms
 */
public class RoomDAO extends DBContext {

    private static final int RECORDS_PER_PAGE = 10;

    /**
     * Check if room number already exists
     *
     * @param roomNumber Room number to check
     * @return true if room number exists, false otherwise
     */
    public boolean isRoomNumberExists(String roomNumber) {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE RoomNumber = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, roomNumber);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking room number: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Check if room number exists for a different room (used in edit)
     *
     * @param roomNumber Room number to check
     * @param roomID     Current room ID to exclude
     * @return true if room number exists for another room, false otherwise
     */
    public boolean isRoomNumberExistsForOtherRoom(String roomNumber, int roomID) {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE RoomNumber = ? AND RoomID != ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, roomNumber);
            ps.setInt(2, roomID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking room number: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get paginated list of rooms
     *
     * @param page Page number (1-based)
     * @return List of Room objects
     */
    public List<Room> getRoomList(int page) {
        List<Room> rooms = new ArrayList<>();
        int offset = (page - 1) * RECORDS_PER_PAGE;

        String sql = "SELECT r.RoomID, r.RoomNumber, r.RoomTypeID, r.Floor, r.Status, " +
                "r.Description, r.IsActive, " +
                "rt.TypeName, rt.BasePrice, rt.MaxGuests " +
                "FROM Rooms r " +
                "LEFT JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                "ORDER BY r.RoomNumber " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, RECORDS_PER_PAGE);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = extractRoomFromResultSet(rs);
                    rooms.add(room);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting room list: " + e.getMessage());
            e.printStackTrace();
        }

        return rooms;
    }

    /**
     * Get all rooms (without pagination)
     * 
     * @return List of all Room objects
     */
    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();

        String sql = "SELECT r.RoomID, r.RoomNumber, r.RoomTypeID, r.Floor, r.Status, " +
                "r.Description, r.IsActive, " +
                "rt.TypeName, rt.BasePrice, rt.MaxGuests " +
                "FROM Rooms r " +
                "LEFT JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                "WHERE r.IsActive = 1 " +
                "ORDER BY r.RoomNumber";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room room = extractRoomFromResultSet(rs);
                rooms.add(room);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all rooms: " + e.getMessage());
            e.printStackTrace();
        }

        return rooms;
    }

    /**
     * Get total number of rooms
     * 
     * @return Total count of rooms
     */
    public int getTotalRows() {
        String sql = "SELECT COUNT(*) FROM Rooms";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total rows: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Get room by ID
     * 
     * @param id Room ID
     * @return Room object if found, null otherwise
     */
    public Room getById(int id) {
        String sql = "SELECT r.RoomID, r.RoomNumber, r.RoomTypeID, r.Floor, r.Status, " +
                "r.Description, r.IsActive, " +
                "rt.TypeName, rt.BasePrice, rt.MaxGuests " +
                "FROM Rooms r " +
                "LEFT JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                "WHERE r.RoomID = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractRoomFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting room by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Create a new room
     * 
     * @param room Room object with data
     * @return true if creation successful, false otherwise
     */
    public boolean create(Room room) {
        String sql = "INSERT INTO Rooms (RoomNumber, RoomTypeID, Floor, Status, Description, IsActive) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomTypeID());
            ps.setInt(3, room.getFloor());
            ps.setString(4, room.getStatus());
            ps.setString(5, room.getDescription());
            ps.setBoolean(6, room.isActive());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error creating room: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update an existing room
     * 
     * @param room Room object with updated data
     * @return true if update successful, false otherwise
     */
    public boolean update(Room room) {
        String sql = "UPDATE Rooms SET RoomNumber = ?, RoomTypeID = ?, Floor = ?, " +
                "Status = ?, Description = ?, IsActive = ? " +
                "WHERE RoomID = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, room.getRoomNumber());
            ps.setInt(2, room.getRoomTypeID());
            ps.setInt(3, room.getFloor());
            ps.setString(4, room.getStatus());
            ps.setString(5, room.getDescription());
            ps.setBoolean(6, room.isActive());
            ps.setInt(7, room.getRoomID());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating room: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a room (soft delete - set IsActive to 0)
     * 
     * @param id Room ID to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "UPDATE Rooms SET IsActive = 0 WHERE RoomID = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting room: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get available rooms with filters and pagination (user-facing)
     *
     * @param page    Page number (1-based)
     * @param filters Map of filters: roomTypeId, priceMin, priceMax, floor,
     *                capacity, sortBy
     * @return List of available Room objects
     */
    public List<Room> getAvailableRooms(int page, java.util.Map<String, String> filters) {
        List<Room> rooms = new ArrayList<>();
        int offset = (page - 1) * 12; // 12 rooms per page for user view

        StringBuilder sql = new StringBuilder(
                "SELECT r.RoomID, r.RoomNumber, r.RoomTypeID, r.Floor, r.Status, " +
                        "r.Description, r.IsActive, " +
                        "rt.TypeName, rt.BasePrice, rt.MaxGuests " +
                        "FROM Rooms r " +
                        "INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                        "WHERE r.IsActive = 1 AND r.Status = N'Trống' ");

        // Apply filters
        if (filters.containsKey("roomTypeId") && !filters.get("roomTypeId").isEmpty()) {
            sql.append("AND r.RoomTypeID = ").append(filters.get("roomTypeId")).append(" ");
        }

        if (filters.containsKey("priceMin") && !filters.get("priceMin").isEmpty()) {
            sql.append("AND rt.BasePrice >= ").append(filters.get("priceMin")).append(" ");
        }

        if (filters.containsKey("priceMax") && !filters.get("priceMax").isEmpty()) {
            sql.append("AND rt.BasePrice <= ").append(filters.get("priceMax")).append(" ");
        }

        if (filters.containsKey("floor") && !filters.get("floor").isEmpty()) {
            sql.append("AND r.Floor = ").append(filters.get("floor")).append(" ");
        }

        if (filters.containsKey("capacity") && !filters.get("capacity").isEmpty()) {
            String capacity = filters.get("capacity");
            if ("4+".equals(capacity)) {
                sql.append("AND rt.MaxGuests >= 4 ");
            } else {
                sql.append("AND rt.MaxGuests = ").append(capacity).append(" ");
            }
        }

        // Apply sorting
        String sortBy = filters.getOrDefault("sortBy", "roomNumber");
        switch (sortBy) {
            case "priceAsc":
                sql.append("ORDER BY rt.BasePrice ASC ");
                break;
            case "priceDesc":
                sql.append("ORDER BY rt.BasePrice DESC ");
                break;
            case "rating":
                sql.append("ORDER BY r.RoomID DESC ");
                break;
            default:
                sql.append("ORDER BY r.RoomNumber ASC ");
        }

        sql.append("OFFSET ? ROWS FETCH NEXT 12 ROWS ONLY");

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql.toString())) {
            ps.setInt(1, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = extractRoomFromResultSet(rs);
                    rooms.add(room);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting available rooms: " + e.getMessage());
            e.printStackTrace();
        }

        return rooms;
    }

    /**
     * Get total count of available rooms with filters
     *
     * @param filters Map of filters
     * @return Total count
     */
    public int getTotalAvailableRooms(java.util.Map<String, String> filters) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Rooms r " +
                        "INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                        "WHERE r.IsActive = 1 AND r.Status = N'Trống' ");

        // Apply same filters as getAvailableRooms
        if (filters.containsKey("roomTypeId") && !filters.get("roomTypeId").isEmpty()) {
            sql.append("AND r.RoomTypeID = ").append(filters.get("roomTypeId")).append(" ");
        }

        if (filters.containsKey("priceMin") && !filters.get("priceMin").isEmpty()) {
            sql.append("AND rt.BasePrice >= ").append(filters.get("priceMin")).append(" ");
        }

        if (filters.containsKey("priceMax") && !filters.get("priceMax").isEmpty()) {
            sql.append("AND rt.BasePrice <= ").append(filters.get("priceMax")).append(" ");
        }

        if (filters.containsKey("floor") && !filters.get("floor").isEmpty()) {
            sql.append("AND r.Floor = ").append(filters.get("floor")).append(" ");
        }

        if (filters.containsKey("capacity") && !filters.get("capacity").isEmpty()) {
            String capacity = filters.get("capacity");
            if ("4+".equals(capacity)) {
                sql.append("AND rt.MaxGuests >= 4 ");
            } else {
                sql.append("AND rt.MaxGuests = ").append(capacity).append(" ");
            }
        }

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql.toString())) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting total available rooms: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Get room detail with full information
     *
     * @param roomId Room ID
     * @return Room object with full details, or null if not found
     */
    public Room getRoomDetail(int roomId) {
        String sql = "SELECT r.RoomID, r.RoomNumber, r.RoomTypeID, r.Floor, r.Status, " +
                "r.Description, r.IsActive, " +
                "rt.TypeName, rt.BasePrice, rt.MaxGuests, rt.Description as TypeDescription " +
                "FROM Rooms r " +
                "INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                "WHERE r.RoomID = ? AND r.IsActive = 1";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, roomId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractRoomFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting room detail: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Extract Room object from ResultSet
     *
     * @param rs ResultSet positioned at a room record
     * @return Room object
     * @throws SQLException if database access error occurs
     */
    private Room extractRoomFromResultSet(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomID(rs.getInt("RoomID"));
        room.setRoomNumber(rs.getString("RoomNumber"));
        room.setRoomTypeID(rs.getInt("RoomTypeID"));
        room.setFloor(rs.getInt("Floor"));
        room.setStatus(rs.getString("Status"));
        room.setDescription(rs.getString("Description"));
        room.setActive(rs.getBoolean("IsActive"));

        // Extract RoomType if joined
        try {
            String typeName = rs.getString("TypeName");
            if (typeName != null) {
                RoomType roomType = new RoomType();
                roomType.setRoomTypeID(rs.getInt("RoomTypeID"));
                roomType.setTypeName(typeName);
                roomType.setBasePrice(rs.getBigDecimal("BasePrice"));
                roomType.setMaxGuests(rs.getInt("MaxGuests"));
                room.setRoomType(roomType);
            }
        } catch (SQLException e) {
            // RoomType columns not in result set, ignore
        }

        return room;
    }
}
