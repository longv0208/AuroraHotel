package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entity class for Coupons table
 * Represents discount coupons
 */
public class Coupon {
    private int couponID;
    private String couponCode;
    private String description;
    private String discountType; // Percent, FixedAmount
    private BigDecimal discountValue;
    private BigDecimal minBookingAmount;
    private BigDecimal maxDiscountAmount;
    private Integer roomTypeID; // NULL if applies to all room types
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer usageLimit;
    private int usedCount;
    private boolean isActive;
    private int createdBy;
    private LocalDateTime createdDate;

    // No-arg constructor
    public Coupon() {
    }

    // Full constructor
    public Coupon(int couponID, String couponCode, String description, String discountType, 
                  BigDecimal discountValue, BigDecimal minBookingAmount, BigDecimal maxDiscountAmount, 
                  Integer roomTypeID, LocalDate startDate, LocalDate endDate, Integer usageLimit, 
                  int usedCount, boolean isActive, int createdBy, LocalDateTime createdDate) {
        this.couponID = couponID;
        this.couponCode = couponCode;
        this.description = description;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minBookingAmount = minBookingAmount;
        this.maxDiscountAmount = maxDiscountAmount;
        this.roomTypeID = roomTypeID;
        this.startDate = startDate;
        this.endDate = endDate;
        this.usageLimit = usageLimit;
        this.usedCount = usedCount;
        this.isActive = isActive;
        this.createdBy = createdBy;
        this.createdDate = createdDate;
    }

    // Constructor without ID
    public Coupon(String couponCode, String description, String discountType, 
                  BigDecimal discountValue, BigDecimal minBookingAmount, BigDecimal maxDiscountAmount, 
                  Integer roomTypeID, LocalDate startDate, LocalDate endDate, Integer usageLimit, 
                  int createdBy) {
        this.couponCode = couponCode;
        this.description = description;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minBookingAmount = minBookingAmount;
        this.maxDiscountAmount = maxDiscountAmount;
        this.roomTypeID = roomTypeID;
        this.startDate = startDate;
        this.endDate = endDate;
        this.usageLimit = usageLimit;
        this.createdBy = createdBy;
        this.usedCount = 0;
        this.isActive = true;
    }

    // Getters and Setters
    public int getCouponID() {
        return couponID;
    }

    public void setCouponID(int couponID) {
        this.couponID = couponID;
    }

    public String getCouponCode() {
        return couponCode;
    }

    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public BigDecimal getMinBookingAmount() {
        return minBookingAmount;
    }

    public void setMinBookingAmount(BigDecimal minBookingAmount) {
        this.minBookingAmount = minBookingAmount;
    }

    public BigDecimal getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public Integer getRoomTypeID() {
        return roomTypeID;
    }

    public void setRoomTypeID(Integer roomTypeID) {
        this.roomTypeID = roomTypeID;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public Integer getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(Integer usageLimit) {
        this.usageLimit = usageLimit;
    }

    public int getUsedCount() {
        return usedCount;
    }

    public void setUsedCount(int usedCount) {
        this.usedCount = usedCount;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "Coupon{" +
                "couponID=" + couponID +
                ", couponCode='" + couponCode + '\'' +
                ", description='" + description + '\'' +
                ", discountType='" + discountType + '\'' +
                ", discountValue=" + discountValue +
                ", minBookingAmount=" + minBookingAmount +
                ", maxDiscountAmount=" + maxDiscountAmount +
                ", roomTypeID=" + roomTypeID +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", usageLimit=" + usageLimit +
                ", usedCount=" + usedCount +
                ", isActive=" + isActive +
                ", createdBy=" + createdBy +
                ", createdDate=" + createdDate +
                '}';
    }
}

