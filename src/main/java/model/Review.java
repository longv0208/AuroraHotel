package model;

import java.time.LocalDateTime;

/**
 * Entity class for Reviews table
 * Represents customer reviews and ratings
 */
public class Review {
    private int reviewID;
    private int bookingID;
    private int customerID;
    private int rating; // 1-5
    private String comment;
    private LocalDateTime reviewDate;
    private boolean isApproved;
    private String adminReply;
    private LocalDateTime replyDate;

    // No-arg constructor
    public Review() {
    }

    // Full constructor
    public Review(int reviewID, int bookingID, int customerID, int rating, 
                  String comment, LocalDateTime reviewDate, boolean isApproved, 
                  String adminReply, LocalDateTime replyDate) {
        this.reviewID = reviewID;
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
        this.isApproved = isApproved;
        this.adminReply = adminReply;
        this.replyDate = replyDate;
    }

    // Constructor without ID
    public Review(int bookingID, int customerID, int rating, String comment) {
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.rating = rating;
        this.comment = comment;
        this.isApproved = false;
    }

    // Getters and Setters
    public int getReviewID() {
        return reviewID;
    }

    public void setReviewID(int reviewID) {
        this.reviewID = reviewID;
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

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDateTime getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(LocalDateTime reviewDate) {
        this.reviewDate = reviewDate;
    }

    public boolean isApproved() {
        return isApproved;
    }

    public void setApproved(boolean approved) {
        isApproved = approved;
    }

    public String getAdminReply() {
        return adminReply;
    }

    public void setAdminReply(String adminReply) {
        this.adminReply = adminReply;
    }

    public LocalDateTime getReplyDate() {
        return replyDate;
    }

    public void setReplyDate(LocalDateTime replyDate) {
        this.replyDate = replyDate;
    }

    @Override
    public String toString() {
        return "Review{" +
                "reviewID=" + reviewID +
                ", bookingID=" + bookingID +
                ", customerID=" + customerID +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", reviewDate=" + reviewDate +
                ", isApproved=" + isApproved +
                ", adminReply='" + adminReply + '\'' +
                ", replyDate=" + replyDate +
                '}';
    }
}

