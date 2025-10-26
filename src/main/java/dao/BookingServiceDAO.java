package dao;

import db.DBContext;
import model.BookingService;
import model.Service;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for BookingServices table
 * Handles services associated with bookings
 * 
 * @author Aurora Hotel Team
 */
public class BookingServiceDAO extends DBContext {
    
    /**
     * Add a service to a booking
     * 
     * @param bookingID Booking ID
     * @param serviceID Service ID
     * @param quantity Quantity of service
     * @param unitPrice Unit price at time of booking
     * @return BookingService ID if successful, -1 otherwise
     */
    public int addServiceToBooking(int bookingID, int serviceID, int quantity, BigDecimal unitPrice) {
        String sql = "INSERT INTO BookingServices (BookingID, ServiceID, Quantity, UnitPrice, TotalPrice, ServiceDate) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE())";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            BigDecimal totalPrice = unitPrice.multiply(new BigDecimal(quantity));
            
            ps.setInt(1, bookingID);
            ps.setInt(2, serviceID);
            ps.setInt(3, quantity);
            ps.setBigDecimal(4, unitPrice);
            ps.setBigDecimal(5, totalPrice);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding service to booking: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Get all services for a booking
     * 
     * @param bookingID Booking ID
     * @return List of BookingService objects with Service details
     */
    public List<BookingService> getServicesByBooking(int bookingID) {
        List<BookingService> bookingServices = new ArrayList<>();
        
        String sql = "SELECT bs.*, s.ServiceName, s.Description, s.Unit, s.Category " +
                     "FROM BookingServices bs " +
                     "INNER JOIN Services s ON bs.ServiceID = s.ServiceID " +
                     "WHERE bs.BookingID = ? " +
                     "ORDER BY bs.ServiceDate DESC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingService bs = extractBookingServiceFromResultSet(rs);
                    
                    // Create Service object with basic info
                    Service service = new Service();
                    service.setServiceID(rs.getInt("ServiceID"));
                    service.setServiceName(rs.getString("ServiceName"));
                    service.setDescription(rs.getString("Description"));
                    service.setUnit(rs.getString("Unit"));
                    service.setCategory(rs.getString("Category"));
                    
                    bs.setService(service);
                    bookingServices.add(bs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting services by booking: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bookingServices;
    }
    
    /**
     * Remove a service from a booking
     * 
     * @param bookingServiceID BookingService ID to remove
     * @return true if deletion successful, false otherwise
     */
    public boolean removeServiceFromBooking(int bookingServiceID) {
        String sql = "DELETE FROM BookingServices WHERE BookingServiceID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingServiceID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error removing service from booking: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Calculate total cost of all services for a booking
     * 
     * @param bookingID Booking ID
     * @return Total cost of services
     */
    public BigDecimal calculateServicesTotal(int bookingID) {
        String sql = "SELECT ISNULL(SUM(TotalPrice), 0) AS ServicesTotal " +
                     "FROM BookingServices " +
                     "WHERE BookingID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("ServicesTotal");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error calculating services total: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Update service quantity and recalculate total
     * 
     * @param bookingServiceID BookingService ID
     * @param quantity New quantity
     * @return true if update successful, false otherwise
     */
    public boolean updateServiceQuantity(int bookingServiceID, int quantity) {
        String sql = "UPDATE BookingServices " +
                     "SET Quantity = ?, TotalPrice = UnitPrice * ? " +
                     "WHERE BookingServiceID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, quantity);
            ps.setInt(3, bookingServiceID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating service quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get a specific booking service by ID
     * 
     * @param bookingServiceID BookingService ID
     * @return BookingService object if found, null otherwise
     */
    public BookingService getBookingServiceById(int bookingServiceID) {
        String sql = "SELECT * FROM BookingServices WHERE BookingServiceID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingServiceID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractBookingServiceFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking service by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Extract BookingService object from ResultSet
     * 
     * @param rs ResultSet positioned at a booking service record
     * @return BookingService object
     * @throws SQLException if database access error occurs
     */
    private BookingService extractBookingServiceFromResultSet(ResultSet rs) throws SQLException {
        BookingService bs = new BookingService();
        bs.setBookingServiceID(rs.getInt("BookingServiceID"));
        bs.setBookingID(rs.getInt("BookingID"));
        bs.setServiceID(rs.getInt("ServiceID"));
        bs.setQuantity(rs.getInt("Quantity"));
        bs.setUnitPrice(rs.getBigDecimal("UnitPrice"));
        bs.setTotalPrice(rs.getBigDecimal("TotalPrice"));
        
        Timestamp serviceDate = rs.getTimestamp("ServiceDate");
        if (serviceDate != null) {
            bs.setServiceDate(serviceDate.toLocalDateTime());
        }
        
        bs.setNotes(rs.getString("Notes"));
        
        return bs;
    }
}

