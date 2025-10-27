package dao;

import db.DBContext;
import model.RoomImage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for RoomImages table
 * Handles all database operations related to room images
 */
public class RoomImageDAO extends DBContext {
    
    /**
     * Create a new room image
     * 
     * @param image RoomImage object with data
     * @return true if creation successful, false otherwise
     */
    public boolean create(RoomImage image) {
        String sql = "INSERT INTO RoomImages (RoomID, RoomTypeID, ImageURL, ImageTitle, Description, IsPrimary, DisplayOrder, UploadedBy, IsActive) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setObject(1, image.getRoomID());
            ps.setObject(2, image.getRoomTypeID());
            ps.setString(3, image.getImageURL());
            ps.setString(4, image.getImageTitle());
            ps.setString(5, image.getDescription());
            ps.setBoolean(6, image.isPrimary());
            ps.setInt(7, image.getDisplayOrder());
            ps.setInt(8, image.getUploadedBy());
            ps.setBoolean(9, image.isActive());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error creating room image: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get images by room ID
     * 
     * @param roomId Room ID
     * @return List of RoomImage objects
     */
    public List<RoomImage> getByRoomId(int roomId) {
        List<RoomImage> images = new ArrayList<>();
        
        String sql = "SELECT ImageID, RoomID, RoomTypeID, ImageURL, ImageTitle, Description, IsPrimary, DisplayOrder, UploadedBy, UploadedDate, IsActive " +
                     "FROM RoomImages WHERE RoomID = ? AND IsActive = 1 ORDER BY IsPrimary DESC, DisplayOrder ASC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, roomId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomImage image = extractRoomImageFromResultSet(rs);
                    images.add(image);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting images by room: " + e.getMessage());
            e.printStackTrace();
        }
        
        return images;
    }
    
    /**
     * Get images by room type ID
     * 
     * @param roomTypeId Room Type ID
     * @return List of RoomImage objects
     */
    public List<RoomImage> getByRoomTypeId(int roomTypeId) {
        List<RoomImage> images = new ArrayList<>();
        
        String sql = "SELECT ImageID, RoomID, RoomTypeID, ImageURL, ImageTitle, Description, IsPrimary, DisplayOrder, UploadedBy, UploadedDate, IsActive " +
                     "FROM RoomImages WHERE RoomTypeID = ? AND RoomID IS NULL AND IsActive = 1 ORDER BY IsPrimary DESC, DisplayOrder ASC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomImage image = extractRoomImageFromResultSet(rs);
                    images.add(image);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting images by room type: " + e.getMessage());
            e.printStackTrace();
        }
        
        return images;
    }
    
    /**
     * Get image by ID
     * 
     * @param imageId Image ID
     * @return RoomImage object if found, null otherwise
     */
    public RoomImage getById(int imageId) {
        String sql = "SELECT ImageID, RoomID, RoomTypeID, ImageURL, ImageTitle, Description, IsPrimary, DisplayOrder, UploadedBy, UploadedDate, IsActive " +
                     "FROM RoomImages WHERE ImageID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, imageId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractRoomImageFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting image by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Set image as primary for a room
     * 
     * @param imageId Image ID
     * @param roomId Room ID
     * @return true if successful, false otherwise
     */
    public boolean setPrimary(int imageId, int roomId) {
        try {
            // First, set all images for this room to non-primary
            String sql1 = "UPDATE RoomImages SET IsPrimary = 0 WHERE RoomID = ?";
            try (PreparedStatement ps = this.getConnection().prepareStatement(sql1)) {
                ps.setInt(1, roomId);
                ps.executeUpdate();
            }
            
            // Then set the selected image as primary
            String sql2 = "UPDATE RoomImages SET IsPrimary = 1 WHERE ImageID = ?";
            try (PreparedStatement ps = this.getConnection().prepareStatement(sql2)) {
                ps.setInt(1, imageId);
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error setting primary image: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update image
     * 
     * @param image RoomImage object with updated data
     * @return true if update successful, false otherwise
     */
    public boolean update(RoomImage image) {
        String sql = "UPDATE RoomImages SET ImageURL = ?, ImageTitle = ?, Description = ?, DisplayOrder = ? WHERE ImageID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, image.getImageURL());
            ps.setString(2, image.getImageTitle());
            ps.setString(3, image.getDescription());
            ps.setInt(4, image.getDisplayOrder());
            ps.setInt(5, image.getImageID());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating image: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete image (soft delete)
     * 
     * @param imageId Image ID
     * @return true if deletion successful, false otherwise
     */
    public boolean delete(int imageId) {
        String sql = "UPDATE RoomImages SET IsActive = 0 WHERE ImageID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, imageId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting image: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get primary image for a room (returns first primary or first image if no primary)
     * 
     * @param roomId Room ID
     * @return RoomImage object if found, null otherwise
     */
    public RoomImage getPrimaryImageByRoomId(int roomId) {
        String sql = "SELECT TOP 1 ImageID, RoomID, RoomTypeID, ImageURL, ImageTitle, Description, IsPrimary, DisplayOrder, UploadedBy, UploadedDate, IsActive " +
                     "FROM RoomImages WHERE RoomID = ? AND IsActive = 1 ORDER BY IsPrimary DESC, DisplayOrder ASC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, roomId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractRoomImageFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting primary image by room ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Extract RoomImage from ResultSet
     */
    private RoomImage extractRoomImageFromResultSet(ResultSet rs) throws SQLException {
        RoomImage image = new RoomImage();
        image.setImageID(rs.getInt("ImageID"));
        
        Object roomId = rs.getObject("RoomID");
        if (roomId != null) {
            image.setRoomID((Integer) roomId);
        }
        
        Object roomTypeId = rs.getObject("RoomTypeID");
        if (roomTypeId != null) {
            image.setRoomTypeID((Integer) roomTypeId);
        }
        
        image.setImageURL(rs.getString("ImageURL"));
        image.setImageTitle(rs.getString("ImageTitle"));
        image.setDescription(rs.getString("Description"));
        image.setPrimary(rs.getBoolean("IsPrimary"));
        image.setDisplayOrder(rs.getInt("DisplayOrder"));
        image.setUploadedBy(rs.getInt("UploadedBy"));
        
        Timestamp uploadedDate = rs.getTimestamp("UploadedDate");
        if (uploadedDate != null) {
            image.setUploadedDate(uploadedDate.toLocalDateTime());
        }
        
        image.setActive(rs.getBoolean("IsActive"));
        
        return image;
    }
}

