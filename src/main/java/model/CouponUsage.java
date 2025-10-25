package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entity class for CouponUsage table
 * Tracks coupon usage history
 */
public class CouponUsage {
    private int usageID;
    private int couponID;
    private int bookingID;
    private int customerID;
    private BigDecimal discountAmount;
    private LocalDateTime usedDate;

    // No-arg constructor
    public CouponUsage() {
    }

    // Full constructor
    public CouponUsage(int usageID, int couponID, int bookingID, int customerID, 
                       BigDecimal discountAmount, LocalDateTime usedDate) {
        this.usageID = usageID;
        this.couponID = couponID;
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.discountAmount = discountAmount;
        this.usedDate = usedDate;
    }

    // Constructor without ID
    public CouponUsage(int couponID, int bookingID, int customerID, BigDecimal discountAmount) {
        this.couponID = couponID;
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.discountAmount = discountAmount;
    }

    // Getters and Setters
    public int getUsageID() {
        return usageID;
    }

    public void setUsageID(int usageID) {
        this.usageID = usageID;
    }

    public int getCouponID() {
        return couponID;
    }

    public void setCouponID(int couponID) {
        this.couponID = couponID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public LocalDateTime getUsedDate() {
        return usedDate;
    }

    public void setUsedDate(LocalDateTime usedDate) {
        this.usedDate = usedDate;
    }

    @Override
    public String toString() {
        return "CouponUsage{" +
                "usageID=" + usageID +
                ", couponID=" + couponID +
                ", bookingID=" + bookingID +
                ", customerID=" + customerID +
                ", discountAmount=" + discountAmount +
                ", usedDate=" + usedDate +
                '}';
    }
}

