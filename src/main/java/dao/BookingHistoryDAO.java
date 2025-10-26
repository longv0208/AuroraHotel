package dao;

import db.DBContext;
import model.BookingHistory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for BookingHistory table
 * Handles booking history tracking and audit trail
 * 
 * @author Aurora Hotel Team
 */
public class BookingHistoryDAO extends DBContext {
    
    /**
     * Get all history records for a booking
     * 
     * @param bookingID Booking ID
     * @return List of BookingHistory objects ordered by date descending
     */
    public List<BookingHistory> getHistoryByBooking(int bookingID) {
        List<BookingHistory> historyList = new ArrayList<>();
        
        String sql = "SELECT * FROM BookingHistory " +
                     "WHERE BookingID = ? " +
                     "ORDER BY ChangedDate DESC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingHistory history = extractBookingHistoryFromResultSet(rs);
                    historyList.add(history);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking history: " + e.getMessage());
            e.printStackTrace();
        }
        
        return historyList;
    }
    
    /**
     * Log a history record for a booking
     * 
     * @param bookingID Booking ID
     * @param action Action performed (CREATE, UPDATE, CANCEL, CHECKIN, CHECKOUT)
     * @param fieldChanged Field that was changed
     * @param oldValue Old value
     * @param newValue New value
     * @param changedBy User ID who made the change
     * @param ipAddress IP address of the user
     * @return History ID if successful, -1 otherwise
     */
    public int logHistory(int bookingID, String action, String fieldChanged, 
                          String oldValue, String newValue, int changedBy, String ipAddress) {
        String sql = "INSERT INTO BookingHistory (BookingID, Action, FieldChanged, OldValue, NewValue, ChangedBy, ChangedDate, IPAddress) " +
                     "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bookingID);
            ps.setString(2, action);
            ps.setString(3, fieldChanged);
            ps.setString(4, oldValue);
            ps.setString(5, newValue);
            ps.setInt(6, changedBy);
            ps.setString(7, ipAddress);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error logging booking history: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Log a simple action without field details
     * 
     * @param bookingID Booking ID
     * @param action Action performed
     * @param changedBy User ID who made the change
     * @param ipAddress IP address of the user
     * @param notes Additional notes
     * @return History ID if successful, -1 otherwise
     */
    public int logAction(int bookingID, String action, int changedBy, String ipAddress, String notes) {
        String sql = "INSERT INTO BookingHistory (BookingID, Action, ChangedBy, ChangedDate, IPAddress, Notes) " +
                     "VALUES (?, ?, ?, GETDATE(), ?, ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bookingID);
            ps.setString(2, action);
            ps.setInt(3, changedBy);
            ps.setString(4, ipAddress);
            ps.setString(5, notes);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error logging booking action: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Get history count for a booking
     * 
     * @param bookingID Booking ID
     * @return Number of history records
     */
    public int getHistoryCount(int bookingID) {
        String sql = "SELECT COUNT(*) AS HistoryCount FROM BookingHistory WHERE BookingID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("HistoryCount");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting history count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Extract BookingHistory object from ResultSet
     * 
     * @param rs ResultSet positioned at a booking history record
     * @return BookingHistory object
     * @throws SQLException if database access error occurs
     */
    private BookingHistory extractBookingHistoryFromResultSet(ResultSet rs) throws SQLException {
        BookingHistory history = new BookingHistory();
        history.setHistoryID(rs.getInt("HistoryID"));
        history.setBookingID(rs.getInt("BookingID"));
        history.setFieldChanged(rs.getString("FieldChanged"));
        history.setOldValue(rs.getString("OldValue"));
        history.setNewValue(rs.getString("NewValue"));
        history.setChangedBy(rs.getInt("ChangedBy"));
        
        Timestamp changedDate = rs.getTimestamp("ChangedDate");
        if (changedDate != null) {
            history.setChangedDate(changedDate.toLocalDateTime());
        }
        
        history.setAction(rs.getString("Action"));
        history.setNotes(rs.getString("Notes"));
        history.setIpAddress(rs.getString("IPAddress"));
        
        return history;
    }
}

