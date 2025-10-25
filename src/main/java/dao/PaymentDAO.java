package dao;

import db.DBContext;
import model.Payment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Payments table
 * Handles all database operations related to payments
 * 
 * @author Aurora Hotel Team
 */
public class PaymentDAO extends DBContext {
    
    /**
     * Create a new payment
     * 
     * @param payment Payment object with data
     * @return Payment ID if successful, -1 otherwise
     */
    public int createPayment(Payment payment) {
        String sql = "INSERT INTO Payments (BookingID, Amount, PaymentMethod, PaymentType, " +
                     "TransactionID, UserID, Notes, Status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getBookingID());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getPaymentType());
            ps.setString(5, payment.getTransactionID());
            ps.setInt(6, payment.getUserID());
            ps.setString(7, payment.getNotes());
            ps.setString(8, payment.getStatus() != null ? payment.getStatus() : "Thành công");
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating payment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Process deposit payment
     * Creates payment record and updates booking status
     * 
     * @param payment Payment object
     * @return true if successful, false otherwise
     */
    public boolean processDepositPayment(Payment payment) {
        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        
        try {
            conn = this.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Insert payment
            String sql1 = "INSERT INTO Payments (BookingID, Amount, PaymentMethod, PaymentType, " +
                         "TransactionID, UserID, Notes, Status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps1 = conn.prepareStatement(sql1);
            ps1.setInt(1, payment.getBookingID());
            ps1.setBigDecimal(2, payment.getAmount());
            ps1.setString(3, payment.getPaymentMethod());
            ps1.setString(4, "Đặt cọc");
            ps1.setString(5, payment.getTransactionID());
            ps1.setInt(6, payment.getUserID());
            ps1.setString(7, payment.getNotes());
            ps1.setString(8, "Thành công");
            ps1.executeUpdate();
            
            // Update booking
            String sql2 = "UPDATE Bookings SET DepositAmount = ?, Status = 'Đã xác nhận', " +
                         "UpdatedDate = GETDATE() WHERE BookingID = ?";
            ps2 = conn.prepareStatement(sql2);
            ps2.setBigDecimal(1, payment.getAmount());
            ps2.setInt(2, payment.getBookingID());
            ps2.executeUpdate();
            
            conn.commit(); // Commit transaction
            return true;
            
        } catch (SQLException e) {
            System.err.println("Error processing deposit payment: " + e.getMessage());
            e.printStackTrace();
            
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback transaction on error
                }
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }
            
            return false;
            
        } finally {
            try {
                if (ps1 != null) ps1.close();
                if (ps2 != null) ps2.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Process checkout payment
     * Creates payment record and updates booking and room status
     * 
     * @param payment Payment object
     * @return true if successful, false otherwise
     */
    public boolean processCheckoutPayment(Payment payment) {
        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;
        
        try {
            conn = this.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Insert payment
            String sql1 = "INSERT INTO Payments (BookingID, Amount, PaymentMethod, PaymentType, " +
                         "TransactionID, UserID, Notes, Status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps1 = conn.prepareStatement(sql1);
            ps1.setInt(1, payment.getBookingID());
            ps1.setBigDecimal(2, payment.getAmount());
            ps1.setString(3, payment.getPaymentMethod());
            ps1.setString(4, "Thanh toán");
            ps1.setString(5, payment.getTransactionID());
            ps1.setInt(6, payment.getUserID());
            ps1.setString(7, payment.getNotes());
            ps1.setString(8, "Thành công");
            ps1.executeUpdate();
            
            // Update booking status to checkout
            String sql2 = "UPDATE Bookings SET Status = 'Đã checkout', UpdatedDate = GETDATE() " +
                         "WHERE BookingID = ?";
            ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, payment.getBookingID());
            ps2.executeUpdate();
            
            // Update room status to available
            String sql3 = "UPDATE Rooms SET Status = 'Trống' " +
                         "WHERE RoomID = (SELECT RoomID FROM Bookings WHERE BookingID = ?)";
            ps3 = conn.prepareStatement(sql3);
            ps3.setInt(1, payment.getBookingID());
            ps3.executeUpdate();
            
            conn.commit(); // Commit transaction
            return true;
            
        } catch (SQLException e) {
            System.err.println("Error processing checkout payment: " + e.getMessage());
            e.printStackTrace();
            
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback transaction on error
                }
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }
            
            return false;
            
        } finally {
            try {
                if (ps1 != null) ps1.close();
                if (ps2 != null) ps2.close();
                if (ps3 != null) ps3.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Get payment by ID
     * 
     * @param paymentID Payment ID
     * @return Payment object if found, null otherwise
     */
    public Payment getPaymentById(int paymentID) {
        String sql = "SELECT * FROM Payments WHERE PaymentID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, paymentID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractPaymentFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting payment by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get payments by booking ID
     * 
     * @param bookingID Booking ID
     * @return List of Payment objects
     */
    public List<Payment> getPaymentsByBooking(int bookingID) {
        List<Payment> payments = new ArrayList<>();
        
        String sql = "SELECT * FROM Payments WHERE BookingID = ? ORDER BY PaymentDate DESC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment payment = extractPaymentFromResultSet(rs);
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting payments by booking: " + e.getMessage());
            e.printStackTrace();
        }
        
        return payments;
    }
    
    /**
     * Get all payments with pagination
     * 
     * @param page Page number (1-based)
     * @param recordsPerPage Records per page
     * @return List of Payment objects
     */
    public List<Payment> getAllPayments(int page, int recordsPerPage) {
        List<Payment> payments = new ArrayList<>();
        int offset = (page - 1) * recordsPerPage;
        
        String sql = "SELECT * FROM Payments ORDER BY PaymentDate DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, recordsPerPage);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment payment = extractPaymentFromResultSet(rs);
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting all payments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return payments;
    }
    
    /**
     * Get total number of payments
     * 
     * @return Total count of payments
     */
    public int getTotalRows() {
        String sql = "SELECT COUNT(*) FROM Payments";
        
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
     * Extract Payment object from ResultSet
     * 
     * @param rs ResultSet positioned at a payment record
     * @return Payment object
     * @throws SQLException if database access error occurs
     */
    private Payment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentID(rs.getInt("PaymentID"));
        payment.setBookingID(rs.getInt("BookingID"));
        
        Timestamp paymentDate = rs.getTimestamp("PaymentDate");
        if (paymentDate != null) {
            payment.setPaymentDate(paymentDate.toLocalDateTime());
        }
        
        payment.setAmount(rs.getBigDecimal("Amount"));
        payment.setPaymentMethod(rs.getString("PaymentMethod"));
        payment.setPaymentType(rs.getString("PaymentType"));
        payment.setTransactionID(rs.getString("TransactionID"));
        payment.setUserID(rs.getInt("UserID"));
        payment.setNotes(rs.getString("Notes"));
        payment.setStatus(rs.getString("Status"));
        
        return payment;
    }
}

