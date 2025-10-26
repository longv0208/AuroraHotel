package dao;

import db.DBContext;
import model.BookingDetail;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for BookingDetails table
 * Handles all database operations related to booking details
 */
public class BookingDetailDAO extends DBContext {
    
    /**
     * Create a new booking detail
     * 
     * @param detail BookingDetail object with data
     * @return true if creation successful, false otherwise
     */
    public boolean create(BookingDetail detail) {
        String sql = "INSERT INTO BookingDetails (BookingID, ServiceDate, RoomPrice, SpecialRequests) " +
                     "VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, detail.getBookingID());
            ps.setDate(2, java.sql.Date.valueOf(detail.getServiceDate()));
            ps.setBigDecimal(3, detail.getRoomPrice());
            ps.setString(4, detail.getSpecialRequests());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error creating booking detail: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get booking details by booking ID
     * 
     * @param bookingId Booking ID
     * @return List of BookingDetail objects
     */
    public List<BookingDetail> getByBookingId(int bookingId) {
        List<BookingDetail> details = new ArrayList<>();
        
        String sql = "SELECT BookingDetailID, BookingID, ServiceDate, RoomPrice, SpecialRequests " +
                     "FROM BookingDetails WHERE BookingID = ? ORDER BY ServiceDate";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingDetail detail = extractBookingDetailFromResultSet(rs);
                    details.add(detail);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking details: " + e.getMessage());
            e.printStackTrace();
        }
        
        return details;
    }
    
    /**
     * Get booking detail by ID
     * 
     * @param detailId BookingDetail ID
     * @return BookingDetail object if found, null otherwise
     */
    public BookingDetail getById(int detailId) {
        String sql = "SELECT BookingDetailID, BookingID, ServiceDate, RoomPrice, SpecialRequests " +
                     "FROM BookingDetails WHERE BookingDetailID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, detailId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractBookingDetailFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking detail by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Update booking detail
     * 
     * @param detail BookingDetail object with updated data
     * @return true if update successful, false otherwise
     */
    public boolean update(BookingDetail detail) {
        String sql = "UPDATE BookingDetails SET ServiceDate = ?, RoomPrice = ?, SpecialRequests = ? " +
                     "WHERE BookingDetailID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(detail.getServiceDate()));
            ps.setBigDecimal(2, detail.getRoomPrice());
            ps.setString(3, detail.getSpecialRequests());
            ps.setInt(4, detail.getBookingDetailID());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating booking detail: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete booking detail
     * 
     * @param detailId BookingDetail ID
     * @return true if deletion successful, false otherwise
     */
    public boolean delete(int detailId) {
        String sql = "DELETE FROM BookingDetails WHERE BookingDetailID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, detailId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting booking detail: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete all booking details for a booking
     * 
     * @param bookingId Booking ID
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteByBookingId(int bookingId) {
        String sql = "DELETE FROM BookingDetails WHERE BookingID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting booking details: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Extract BookingDetail from ResultSet
     */
    private BookingDetail extractBookingDetailFromResultSet(ResultSet rs) throws SQLException {
        BookingDetail detail = new BookingDetail();
        detail.setBookingDetailID(rs.getInt("BookingDetailID"));
        detail.setBookingID(rs.getInt("BookingID"));
        detail.setServiceDate(rs.getDate("ServiceDate").toLocalDate());
        detail.setRoomPrice(rs.getBigDecimal("RoomPrice"));
        detail.setSpecialRequests(rs.getString("SpecialRequests"));
        return detail;
    }
}

