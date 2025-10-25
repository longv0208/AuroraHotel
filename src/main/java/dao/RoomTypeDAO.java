package dao;

import db.DBContext;
import model.RoomType;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for RoomTypes table
 * Handles all database operations related to room types
 */
public class RoomTypeDAO extends DBContext {
    
    /**
     * Get all active room types
     * 
     * @return List of RoomType objects
     */
    public List<RoomType> getAllRoomTypes() {
        List<RoomType> roomTypes = new ArrayList<>();
        
        String sql = "SELECT RoomTypeID, TypeName, Description, BasePrice, MaxGuests, Amenities, IsActive " +
                     "FROM RoomTypes " +
                     "WHERE IsActive = 1 " +
                     "ORDER BY TypeName";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                RoomType roomType = extractRoomTypeFromResultSet(rs);
                roomTypes.add(roomType);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all room types: " + e.getMessage());
            e.printStackTrace();
        }
        
        return roomTypes;
    }
    
    /**
     * Get room type by ID
     * 
     * @param id RoomType ID
     * @return RoomType object if found, null otherwise
     */
    public RoomType getById(int id) {
        String sql = "SELECT RoomTypeID, TypeName, Description, BasePrice, MaxGuests, Amenities, IsActive " +
                     "FROM RoomTypes " +
                     "WHERE RoomTypeID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractRoomTypeFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting room type by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Extract RoomType object from ResultSet
     * 
     * @param rs ResultSet positioned at a room type record
     * @return RoomType object
     * @throws SQLException if database access error occurs
     */
    private RoomType extractRoomTypeFromResultSet(ResultSet rs) throws SQLException {
        RoomType roomType = new RoomType();
        roomType.setRoomTypeID(rs.getInt("RoomTypeID"));
        roomType.setTypeName(rs.getString("TypeName"));
        roomType.setDescription(rs.getString("Description"));
        roomType.setBasePrice(rs.getBigDecimal("BasePrice"));
        roomType.setMaxGuests(rs.getInt("MaxGuests"));
        roomType.setAmenities(rs.getString("Amenities"));
        roomType.setActive(rs.getBoolean("IsActive"));
        
        return roomType;
    }
}

