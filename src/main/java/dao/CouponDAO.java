package dao;

import db.DBContext;
import model.Coupon;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Coupons table
 * Handles all database operations related to discount coupons
 * 
 * @author Aurora Hotel Team
 */
public class CouponDAO extends DBContext {
    
    private static final int RECORDS_PER_PAGE = 10;
    
    /**
     * Create a new coupon
     * 
     * @param coupon Coupon object with data
     * @return Coupon ID if successful, -1 otherwise
     */
    public int createCoupon(Coupon coupon) {
        String sql = "INSERT INTO Coupons (CouponCode, Description, DiscountType, DiscountValue, " +
                     "MinBookingAmount, MaxDiscountAmount, RoomTypeID, StartDate, EndDate, " +
                     "UsageLimit, UsedCount, IsActive, CreatedBy) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 1, ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, coupon.getCouponCode().toUpperCase());
            ps.setString(2, coupon.getDescription());
            ps.setString(3, coupon.getDiscountType());
            ps.setBigDecimal(4, coupon.getDiscountValue());
            
            if (coupon.getMinBookingAmount() != null) {
                ps.setBigDecimal(5, coupon.getMinBookingAmount());
            } else {
                ps.setNull(5, Types.DECIMAL);
            }
            
            if (coupon.getMaxDiscountAmount() != null) {
                ps.setBigDecimal(6, coupon.getMaxDiscountAmount());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            
            if (coupon.getRoomTypeID() != null) {
                ps.setInt(7, coupon.getRoomTypeID());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            
            ps.setDate(8, Date.valueOf(coupon.getStartDate()));
            ps.setDate(9, Date.valueOf(coupon.getEndDate()));
            
            if (coupon.getUsageLimit() != null) {
                ps.setInt(10, coupon.getUsageLimit());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            
            ps.setInt(11, coupon.getCreatedBy());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating coupon: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Get coupon by ID
     * 
     * @param couponID Coupon ID
     * @return Coupon object if found, null otherwise
     */
    public Coupon getCouponById(int couponID) {
        String sql = "SELECT * FROM Coupons WHERE CouponID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, couponID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCouponFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting coupon by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get coupon by code
     * 
     * @param couponCode Coupon code
     * @return Coupon object if found, null otherwise
     */
    public Coupon getCouponByCode(String couponCode) {
        String sql = "SELECT * FROM Coupons WHERE CouponCode = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, couponCode.toUpperCase());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCouponFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting coupon by code: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Validate and get coupon with discount calculation
     * Checks if coupon is valid for given booking details
     * 
     * @param couponCode Coupon code
     * @param bookingAmount Booking total amount
     * @param roomTypeID Room type ID
     * @return Coupon object if valid, null otherwise
     */
    public Coupon validateCoupon(String couponCode, BigDecimal bookingAmount, Integer roomTypeID) {
        String sql = "SELECT * FROM Coupons " +
                     "WHERE CouponCode = ? " +
                     "AND IsActive = 1 " +
                     "AND CAST(GETDATE() AS DATE) BETWEEN StartDate AND EndDate " +
                     "AND (UsageLimit IS NULL OR UsedCount < UsageLimit) " +
                     "AND (RoomTypeID IS NULL OR RoomTypeID = ?) " +
                     "AND (MinBookingAmount IS NULL OR ? >= MinBookingAmount)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, couponCode.toUpperCase());
            
            if (roomTypeID != null) {
                ps.setInt(2, roomTypeID);
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            
            ps.setBigDecimal(3, bookingAmount);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCouponFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error validating coupon: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Calculate discount amount for a coupon
     * 
     * @param coupon Coupon object
     * @param bookingAmount Booking total amount
     * @return Discount amount
     */
    public BigDecimal calculateDiscountAmount(Coupon coupon, BigDecimal bookingAmount) {
        if (coupon == null || bookingAmount == null) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal discountAmount = BigDecimal.ZERO;
        
        if ("Percent".equals(coupon.getDiscountType())) {
            // Percentage discount
            discountAmount = bookingAmount.multiply(coupon.getDiscountValue())
                                         .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
            
            // Apply max discount limit if exists
            if (coupon.getMaxDiscountAmount() != null && 
                discountAmount.compareTo(coupon.getMaxDiscountAmount()) > 0) {
                discountAmount = coupon.getMaxDiscountAmount();
            }
        } else if ("FixedAmount".equals(coupon.getDiscountType())) {
            // Fixed amount discount
            discountAmount = coupon.getDiscountValue();
            
            // Don't exceed booking amount
            if (discountAmount.compareTo(bookingAmount) > 0) {
                discountAmount = bookingAmount;
            }
        }
        
        return discountAmount;
    }
    
    /**
     * Get all active coupons with pagination
     * 
     * @param page Page number (1-based)
     * @return List of Coupon objects
     */
    public List<Coupon> getActiveCoupons(int page) {
        List<Coupon> coupons = new ArrayList<>();
        int offset = (page - 1) * RECORDS_PER_PAGE;
        
        String sql = "SELECT * FROM Coupons " +
                     "WHERE IsActive = 1 " +
                     "ORDER BY CreatedDate DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, RECORDS_PER_PAGE);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Coupon coupon = extractCouponFromResultSet(rs);
                    coupons.add(coupon);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting active coupons: " + e.getMessage());
            e.printStackTrace();
        }
        
        return coupons;
    }
    
    /**
     * Get all coupons with pagination
     * 
     * @param page Page number (1-based)
     * @return List of Coupon objects
     */
    public List<Coupon> getAllCoupons(int page) {
        List<Coupon> coupons = new ArrayList<>();
        int offset = (page - 1) * RECORDS_PER_PAGE;
        
        String sql = "SELECT * FROM Coupons " +
                     "ORDER BY CreatedDate DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, RECORDS_PER_PAGE);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Coupon coupon = extractCouponFromResultSet(rs);
                    coupons.add(coupon);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting all coupons: " + e.getMessage());
            e.printStackTrace();
        }
        
        return coupons;
    }
    
    /**
     * Update coupon
     * 
     * @param coupon Coupon object with updated data
     * @return true if update successful, false otherwise
     */
    public boolean updateCoupon(Coupon coupon) {
        String sql = "UPDATE Coupons SET CouponCode = ?, Description = ?, DiscountType = ?, " +
                     "DiscountValue = ?, MinBookingAmount = ?, MaxDiscountAmount = ?, " +
                     "RoomTypeID = ?, StartDate = ?, EndDate = ?, UsageLimit = ?, IsActive = ? " +
                     "WHERE CouponID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, coupon.getCouponCode().toUpperCase());
            ps.setString(2, coupon.getDescription());
            ps.setString(3, coupon.getDiscountType());
            ps.setBigDecimal(4, coupon.getDiscountValue());
            
            if (coupon.getMinBookingAmount() != null) {
                ps.setBigDecimal(5, coupon.getMinBookingAmount());
            } else {
                ps.setNull(5, Types.DECIMAL);
            }
            
            if (coupon.getMaxDiscountAmount() != null) {
                ps.setBigDecimal(6, coupon.getMaxDiscountAmount());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            
            if (coupon.getRoomTypeID() != null) {
                ps.setInt(7, coupon.getRoomTypeID());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            
            ps.setDate(8, Date.valueOf(coupon.getStartDate()));
            ps.setDate(9, Date.valueOf(coupon.getEndDate()));
            
            if (coupon.getUsageLimit() != null) {
                ps.setInt(10, coupon.getUsageLimit());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            
            ps.setBoolean(11, coupon.isActive());
            ps.setInt(12, coupon.getCouponID());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating coupon: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Increment coupon usage count
     * Called when a coupon is used in a booking
     * 
     * @param couponID Coupon ID
     * @return true if increment successful, false otherwise
     */
    public boolean incrementUsageCount(int couponID) {
        String sql = "UPDATE Coupons SET UsedCount = UsedCount + 1 WHERE CouponID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, couponID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error incrementing usage count: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Deactivate a coupon
     * 
     * @param couponID Coupon ID
     * @return true if deactivation successful, false otherwise
     */
    public boolean deactivateCoupon(int couponID) {
        String sql = "UPDATE Coupons SET IsActive = 0 WHERE CouponID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, couponID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deactivating coupon: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a coupon (if not used)
     * 
     * @param couponID Coupon ID to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteCoupon(int couponID) {
        // Check if coupon has been used
        String checkSQL = "SELECT UsedCount FROM Coupons WHERE CouponID = ?";
        
        try (PreparedStatement checkPS = this.getConnection().prepareStatement(checkSQL)) {
            checkPS.setInt(1, couponID);
            
            try (ResultSet rs = checkPS.executeQuery()) {
                if (rs.next() && rs.getInt("UsedCount") > 0) {
                    System.err.println("Cannot delete coupon that has been used");
                    return false;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking coupon usage: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
        
        // Delete coupon
        String sql = "DELETE FROM Coupons WHERE CouponID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, couponID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting coupon: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get total number of coupons
     * 
     * @return Total count of coupons
     */
    public int getTotalRows() {
        String sql = "SELECT COUNT(*) FROM Coupons";
        
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
     * Extract Coupon object from ResultSet
     * 
     * @param rs ResultSet positioned at a coupon record
     * @return Coupon object
     * @throws SQLException if database access error occurs
     */
    private Coupon extractCouponFromResultSet(ResultSet rs) throws SQLException {
        Coupon coupon = new Coupon();
        coupon.setCouponID(rs.getInt("CouponID"));
        coupon.setCouponCode(rs.getString("CouponCode"));
        coupon.setDescription(rs.getString("Description"));
        coupon.setDiscountType(rs.getString("DiscountType"));
        coupon.setDiscountValue(rs.getBigDecimal("DiscountValue"));
        coupon.setMinBookingAmount(rs.getBigDecimal("MinBookingAmount"));
        coupon.setMaxDiscountAmount(rs.getBigDecimal("MaxDiscountAmount"));
        
        int roomTypeID = rs.getInt("RoomTypeID");
        if (!rs.wasNull()) {
            coupon.setRoomTypeID(roomTypeID);
        }
        
        Date startDate = rs.getDate("StartDate");
        if (startDate != null) {
            coupon.setStartDate(startDate.toLocalDate());
        }
        
        Date endDate = rs.getDate("EndDate");
        if (endDate != null) {
            coupon.setEndDate(endDate.toLocalDate());
        }
        
        int usageLimit = rs.getInt("UsageLimit");
        if (!rs.wasNull()) {
            coupon.setUsageLimit(usageLimit);
        }
        
        coupon.setUsedCount(rs.getInt("UsedCount"));
        coupon.setActive(rs.getBoolean("IsActive"));
        coupon.setCreatedBy(rs.getInt("CreatedBy"));
        
        Timestamp createdDate = rs.getTimestamp("CreatedDate");
        if (createdDate != null) {
            coupon.setCreatedDate(createdDate.toLocalDateTime());
        }
        
        return coupon;
    }
}

