package dao;

import db.DBContext;
import model.CouponUsage;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for CouponUsage table
 * Handles all database operations related to coupon usage tracking
 */
public class CouponUsageDAO extends DBContext {
    
    /**
     * Create a new coupon usage record
     * 
     * @param usage CouponUsage object with data
     * @return true if creation successful, false otherwise
     */
    public boolean create(CouponUsage usage) {
        String sql = "INSERT INTO CouponUsage (CouponID, BookingID, CustomerID, DiscountAmount, UsedDate) " +
                     "VALUES (?, ?, ?, ?, GETDATE())";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, usage.getCouponID());
            ps.setInt(2, usage.getBookingID());
            ps.setInt(3, usage.getCustomerID());
            ps.setBigDecimal(4, usage.getDiscountAmount());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error creating coupon usage: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get coupon usage by booking ID
     * 
     * @param bookingId Booking ID
     * @return CouponUsage object if found, null otherwise
     */
    public CouponUsage getByBookingId(int bookingId) {
        String sql = "SELECT UsageID, CouponID, BookingID, CustomerID, DiscountAmount, UsedDate " +
                     "FROM CouponUsage WHERE BookingID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCouponUsageFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting coupon usage by booking: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all coupon usages by customer ID
     * 
     * @param customerId Customer ID
     * @return List of CouponUsage objects
     */
    public List<CouponUsage> getByCustomerId(int customerId) {
        List<CouponUsage> usages = new ArrayList<>();
        
        String sql = "SELECT UsageID, CouponID, BookingID, CustomerID, DiscountAmount, UsedDate " +
                     "FROM CouponUsage WHERE CustomerID = ? ORDER BY UsedDate DESC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CouponUsage usage = extractCouponUsageFromResultSet(rs);
                    usages.add(usage);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting coupon usages by customer: " + e.getMessage());
            e.printStackTrace();
        }
        
        return usages;
    }
    
    /**
     * Get total usage count for a coupon
     * 
     * @param couponId Coupon ID
     * @return Total usage count
     */
    public int getTotalUsage(int couponId) {
        String sql = "SELECT COUNT(*) as TotalUsage FROM CouponUsage WHERE CouponID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, couponId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("TotalUsage");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting total coupon usage: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get all coupon usages by coupon ID
     * 
     * @param couponId Coupon ID
     * @return List of CouponUsage objects
     */
    public List<CouponUsage> getByCouponId(int couponId) {
        List<CouponUsage> usages = new ArrayList<>();
        
        String sql = "SELECT UsageID, CouponID, BookingID, CustomerID, DiscountAmount, UsedDate " +
                     "FROM CouponUsage WHERE CouponID = ? ORDER BY UsedDate DESC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, couponId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CouponUsage usage = extractCouponUsageFromResultSet(rs);
                    usages.add(usage);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting coupon usages: " + e.getMessage());
            e.printStackTrace();
        }
        
        return usages;
    }
    
    /**
     * Delete coupon usage record
     * 
     * @param usageId Usage ID
     * @return true if deletion successful, false otherwise
     */
    public boolean delete(int usageId) {
        String sql = "DELETE FROM CouponUsage WHERE UsageID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, usageId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting coupon usage: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Extract CouponUsage from ResultSet
     */
    private CouponUsage extractCouponUsageFromResultSet(ResultSet rs) throws SQLException {
        CouponUsage usage = new CouponUsage();
        usage.setUsageID(rs.getInt("UsageID"));
        usage.setCouponID(rs.getInt("CouponID"));
        usage.setBookingID(rs.getInt("BookingID"));
        usage.setCustomerID(rs.getInt("CustomerID"));
        usage.setDiscountAmount(rs.getBigDecimal("DiscountAmount"));
        usage.setUsedDate(rs.getTimestamp("UsedDate").toLocalDateTime());
        return usage;
    }
}

