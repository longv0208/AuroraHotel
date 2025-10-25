package controller;

import dao.BookingDAO;
import dao.ReviewDAO;
import model.Booking;
import model.Review;
import model.User;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

/**
 * Servlet for Review management operations
 * Handles create, view, moderate (approve/reply) reviews
 * 
 * @author Aurora Hotel Team
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String view = request.getParameter("view");

        if (view == null || view.equals("list")) {
            // Public: View approved reviews
            showApprovedReviews(request, response);
            
        } else if (view.equals("create")) {
            // User: Create review form
            showCreateForm(request, response);
            
        } else if (view.equals("moderate")) {
            // Admin: Moderate pending reviews
            showModerateReviews(request, response);
            
        } else if (view.equals("my-reviews")) {
            // User: View own reviews
            showMyReviews(request, response);
            
        } else {
            response.sendRedirect(request.getContextPath() + "/review?view=list");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/review?view=list");
            return;
        }

        switch (action) {
            case "create":
                createReview(request, response);
                break;
                
            case "approve":
                approveReview(request, response);
                break;
                
            case "reply":
                addAdminReply(request, response);
                break;
                
            case "delete":
                deleteReview(request, response);
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/review?view=list");
                break;
        }
    }

    /**
     * Show approved reviews (public)
     */
    private void showApprovedReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ex) {
                System.err.println("Invalid page parameter");
            }
        }

        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> reviews = reviewDAO.getApprovedReviews(page);

        int totalRows = reviewDAO.getTotalRows();
        int totalPages = (int) Math.ceil((double) totalRows / 10);

        request.setAttribute("reviews", reviews);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("/WEB-INF/review/list.jsp").forward(request, response);
    }

    /**
     * Show create review form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=my-bookings");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIdStr);
            
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingID);
            
            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/booking?view=my-bookings&error=notfound");
                return;
            }
            
            // Check if booking is checked out
            if (!"Đã checkout".equals(booking.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=notcheckedout");
                return;
            }
            
            // Check if already reviewed
            ReviewDAO reviewDAO = new ReviewDAO();
            if (reviewDAO.hasReviewed(bookingID, booking.getCustomerID())) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=alreadyreviewed");
                return;
            }
            
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/WEB-INF/review/create.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing create review form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=my-bookings");
        }
    }

    /**
     * Show moderate reviews page (Admin only)
     */
    private void showModerateReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/review?view=list&error=unauthorized");
            return;
        }

        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> pendingReviews = reviewDAO.getPendingReviews();

        request.setAttribute("reviews", pendingReviews);
        request.getRequestDispatcher("/WEB-INF/review/moderate.jsp").forward(request, response);
    }

    /**
     * Show user's own reviews
     */
    private void showMyReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user's bookings and their reviews
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getBookingsByUser(loggedInUser.getUserID());
        
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/WEB-INF/review/my-reviews.jsp").forward(request, response);
    }

    /**
     * Create a new review
     */
    private void createReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));
            int customerID = Integer.parseInt(request.getParameter("customerID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Validate rating
            if (rating < 1 || rating > 5) {
                request.setAttribute("errorMessage", "Đánh giá phải từ 1 đến 5 sao");
                showCreateForm(request, response);
                return;
            }

            // Create review
            Review review = new Review();
            review.setBookingID(bookingID);
            review.setCustomerID(customerID);
            review.setRating(rating);
            review.setComment(comment);

            ReviewDAO reviewDAO = new ReviewDAO();
            int reviewID = reviewDAO.createReview(review);

            if (reviewID > 0) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&reviewed=1");
            } else {
                request.setAttribute("errorMessage", "Không thể tạo đánh giá");
                showCreateForm(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error creating review: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    /**
     * Approve a review (Admin only)
     */
    private void approveReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/review?view=list&error=unauthorized");
            return;
        }

        try {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));

            ReviewDAO reviewDAO = new ReviewDAO();
            boolean result = reviewDAO.approveReview(reviewID);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/review?view=moderate&approved=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/review?view=moderate&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error approving review: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/review?view=moderate&error=1");
        }
    }

    /**
     * Add admin reply to a review (Admin only)
     */
    private void addAdminReply(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/review?view=list&error=unauthorized");
            return;
        }

        try {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));
            String adminReply = request.getParameter("adminReply");

            if (adminReply == null || adminReply.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/review?view=moderate&error=emptyreply");
                return;
            }

            ReviewDAO reviewDAO = new ReviewDAO();
            boolean result = reviewDAO.addAdminReply(reviewID, adminReply.trim());

            if (result) {
                response.sendRedirect(request.getContextPath() + "/review?view=moderate&replied=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/review?view=moderate&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error adding admin reply: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/review?view=moderate&error=1");
        }
    }

    /**
     * Delete a review (Admin only)
     */
    private void deleteReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/review?view=list&error=unauthorized");
            return;
        }

        try {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));

            ReviewDAO reviewDAO = new ReviewDAO();
            boolean result = reviewDAO.deleteReview(reviewID);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/review?view=moderate&deleted=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/review?view=moderate&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error deleting review: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/review?view=moderate&error=1");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Review Servlet - Manages customer reviews and admin moderation";
    }
}

