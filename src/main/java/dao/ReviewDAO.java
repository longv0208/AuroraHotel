package dao;

import db.DBContext;
import model.Review;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Reviews table
 * Handles all database operations related to reviews
 * 
 * @author Aurora Hotel Team
 */
public class ReviewDAO extends DBContext {
    
    private static final int RECORDS_PER_PAGE = 10;
    
    /**
     * Create a new review
     * 
     * @param review Review object with data
     * @return Review ID if successful, -1 otherwise
     */
    public int createReview(Review review) {
        String sql = "INSERT INTO Reviews (BookingID, CustomerID, Rating, Comment) " +
                     "VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, review.getBookingID());
            ps.setInt(2, review.getCustomerID());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating review: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Get review by ID
     * 
     * @param reviewID Review ID
     * @return Review object if found, null otherwise
     */
    public Review getReviewById(int reviewID) {
        String sql = "SELECT * FROM Reviews WHERE ReviewID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, reviewID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractReviewFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting review by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all approved reviews with pagination
     * 
     * @param page Page number (1-based)
     * @return List of Review objects
     */
    public List<Review> getApprovedReviews(int page) {
        List<Review> reviews = new ArrayList<>();
        int offset = (page - 1) * RECORDS_PER_PAGE;
        
        String sql = "SELECT * FROM Reviews " +
                     "WHERE IsApproved = 1 " +
                     "ORDER BY ReviewDate DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, RECORDS_PER_PAGE);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = extractReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting approved reviews: " + e.getMessage());
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    /**
     * Get pending reviews (not yet approved)
     * 
     * @return List of Review objects awaiting moderation
     */
    public List<Review> getPendingReviews() {
        List<Review> reviews = new ArrayList<>();
        
        String sql = "SELECT * FROM Reviews " +
                     "WHERE IsApproved = 0 " +
                     "ORDER BY ReviewDate DESC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Review review = extractReviewFromResultSet(rs);
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.err.println("Error getting pending reviews: " + e.getMessage());
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    /**
     * Get reviews by booking ID
     * 
     * @param bookingID Booking ID
     * @return List of Review objects
     */
    public List<Review> getReviewsByBooking(int bookingID) {
        List<Review> reviews = new ArrayList<>();
        
        String sql = "SELECT * FROM Reviews WHERE BookingID = ? ORDER BY ReviewDate DESC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = extractReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting reviews by booking: " + e.getMessage());
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    /**
     * Get reviews by customer ID
     * 
     * @param customerID Customer ID
     * @return List of Review objects
     */
    public List<Review> getReviewsByCustomer(int customerID) {
        List<Review> reviews = new ArrayList<>();
        
        String sql = "SELECT * FROM Reviews WHERE CustomerID = ? ORDER BY ReviewDate DESC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, customerID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = extractReviewFromResultSet(rs);
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting reviews by customer: " + e.getMessage());
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    /**
     * Approve a review
     * 
     * @param reviewID Review ID
     * @return true if approval successful, false otherwise
     */
    public boolean approveReview(int reviewID) {
        String sql = "UPDATE Reviews SET IsApproved = 1 WHERE ReviewID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, reviewID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error approving review: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Add admin reply to a review
     * 
     * @param reviewID Review ID
     * @param adminReply Admin's reply text
     * @return true if reply added successfully, false otherwise
     */
    public boolean addAdminReply(int reviewID, String adminReply) {
        String sql = "UPDATE Reviews SET AdminReply = ?, ReplyDate = GETDATE() WHERE ReviewID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, adminReply);
            ps.setInt(2, reviewID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding admin reply: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a review
     * 
     * @param reviewID Review ID to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteReview(int reviewID) {
        String sql = "DELETE FROM Reviews WHERE ReviewID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, reviewID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting review: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if customer has already reviewed a booking
     * 
     * @param bookingID Booking ID
     * @param customerID Customer ID
     * @return true if review exists, false otherwise
     */
    public boolean hasReviewed(int bookingID, int customerID) {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE BookingID = ? AND CustomerID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ps.setInt(2, customerID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking if reviewed: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get total number of reviews
     * 
     * @return Total count of reviews
     */
    public int getTotalRows() {
        String sql = "SELECT COUNT(*) FROM Reviews";
        
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
     * Extract Review object from ResultSet
     * 
     * @param rs ResultSet positioned at a review record
     * @return Review object
     * @throws SQLException if database access error occurs
     */
    private Review extractReviewFromResultSet(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewID(rs.getInt("ReviewID"));
        review.setBookingID(rs.getInt("BookingID"));
        review.setCustomerID(rs.getInt("CustomerID"));
        review.setRating(rs.getInt("Rating"));
        review.setComment(rs.getString("Comment"));
        
        Timestamp reviewDate = rs.getTimestamp("ReviewDate");
        if (reviewDate != null) {
            review.setReviewDate(reviewDate.toLocalDateTime());
        }
        
        review.setApproved(rs.getBoolean("IsApproved"));
        review.setAdminReply(rs.getString("AdminReply"));
        
        Timestamp replyDate = rs.getTimestamp("ReplyDate");
        if (replyDate != null) {
            review.setReplyDate(replyDate.toLocalDateTime());
        }
        
        return review;
    }
}

