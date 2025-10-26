package controller;

import dao.ReviewDAO;
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
 * Servlet for Feedback operations using Review table
 * Handles user feedback submission and admin moderation
 *
 * @author Aurora Hotel Team
 */
@WebServlet(name = "FeedbackServlet", urlPatterns = { "/feedback" })
public class FeedbackServlet extends HttpServlet {

    private ReviewDAO reviewDAO = new ReviewDAO();

    /**
     * Handles GET requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action != null && action.equals("admin")) {
            showAdminModeration(request, response);
        } else {
            showFeedbackPage(request, response);
        }
    }

    /**
     * Handles POST requests
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            submitFeedback(request, response);
        } else if (action.equals("approve")) {
            approveFeedback(request, response);
        } else if (action.equals("reply")) {
            replyFeedback(request, response);
        } else if (action.equals("delete")) {
            deleteFeedback(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/feedback");
        }
    }

    /**
     * Show feedback page with form and approved feedback list
     */
    private void showFeedbackPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1)
                        page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            List<Review> approvedReviews = reviewDAO.getApprovedReviews(page);
            int totalRows = reviewDAO.getTotalApprovedReviews();
            int totalPages = (int) Math.ceil((double) totalRows / 10);

            request.setAttribute("approvedReviews", approvedReviews);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/WEB-INF/hotel/feedback.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing feedback page: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang");
            request.getRequestDispatcher("/WEB-INF/hotel/home.jsp").forward(request, response);
        }
    }

    /**
     * Submit new feedback
     */
    private void submitFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setCharacterEncoding("UTF-8");

            HttpSession session = request.getSession();
            User loggedInUser = (User) session.getAttribute("loggedInUser");
            int customerID = 0;
            if (loggedInUser != null) {
                customerID = loggedInUser.getUserID();
            }

            String comment = request.getParameter("comment");
            String ratingStr = request.getParameter("rating");

            // Validation
            if (comment == null || comment.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập nội dung đánh giá");
                request.setAttribute("comment", comment);
                request.setAttribute("rating", ratingStr);
                showFeedbackPage(request, response);
                return;
            }

            if (comment.trim().length() < 10) {
                request.setAttribute("error", "Nội dung đánh giá phải có ít nhất 10 ký tự");
                request.setAttribute("comment", comment);
                request.setAttribute("rating", ratingStr);
                showFeedbackPage(request, response);
                return;
            }

            if (comment.trim().length() > 1000) {
                request.setAttribute("error", "Nội dung đánh giá không được vượt quá 1000 ký tự");
                request.setAttribute("comment", comment);
                request.setAttribute("rating", ratingStr);
                showFeedbackPage(request, response);
                return;
            }

            int rating = 5;
            if (ratingStr != null && !ratingStr.isEmpty()) {
                try {
                    rating = Integer.parseInt(ratingStr);
                    if (rating < 1 || rating > 5)
                        rating = 5;
                } catch (NumberFormatException e) {
                    rating = 5;
                }
            }

            // Create review
            Review review = new Review();
            review.setBookingID(0); // No booking required for public feedback
            review.setCustomerID(customerID); // 0 for guests
            review.setRating(rating);
            review.setComment(comment.trim());
            review.setApproved(false); // Requires admin approval

            int reviewId = reviewDAO.createReview(review);

            if (reviewId > 0) {
                request.setAttribute("success",
                        "Cảm ơn bạn đã gửi đánh giá! Đánh giá của bạn sẽ được hiển thị sau khi được duyệt.");
                showFeedbackPage(request, response);
            } else {
                request.setAttribute("error", "Không thể gửi đánh giá. Vui lòng thử lại.");
                request.setAttribute("comment", comment);
                request.setAttribute("rating", ratingStr);
                showFeedbackPage(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error submitting feedback: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showFeedbackPage(request, response);
        }
    }

    /**
     * Show admin moderation page
     */
    private void showAdminModeration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null || !loggedInUser.getRole().equals("Admin")) {
            response.sendRedirect(request.getContextPath() + "/feedback");
            return;
        }

        try {
            List<Review> pendingReviews = reviewDAO.getPendingReviews();
            request.setAttribute("pendingReviews", pendingReviews);
            request.getRequestDispatcher("/WEB-INF/admin/feedback-moderation.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing admin moderation: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin");
        }
    }

    /**
     * Approve feedback
     */
    private void approveFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null || !loggedInUser.getRole().equals("Admin")) {
            response.sendRedirect(request.getContextPath() + "/feedback");
            return;
        }

        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            boolean success = reviewDAO.approveReview(reviewId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/feedback?action=admin&approved=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/feedback?action=admin&error=1");
            }
        } catch (Exception e) {
            System.err.println("Error approving feedback: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/feedback?action=admin&error=1");
        }
    }

    /**
     * Reply to feedback
     */
    private void replyFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null || !loggedInUser.getRole().equals("Admin")) {
            response.sendRedirect(request.getContextPath() + "/feedback");
            return;
        }

        try {
            request.setCharacterEncoding("UTF-8");

            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            String adminReply = request.getParameter("adminReply");

            if (adminReply == null || adminReply.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/feedback?action=admin&error=emptyreply");
                return;
            }

            boolean success = reviewDAO.addAdminReply(reviewId, adminReply.trim());

            if (success) {
                response.sendRedirect(request.getContextPath() + "/feedback?action=admin&replied=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/feedback?action=admin&error=1");
            }
        } catch (Exception e) {
            System.err.println("Error replying to feedback: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/feedback?action=admin&error=1");
        }
    }

    /**
     * Delete feedback
     */
    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null || !loggedInUser.getRole().equals("Admin")) {
            response.sendRedirect(request.getContextPath() + "/feedback");
            return;
        }

        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            boolean success = reviewDAO.deleteReview(reviewId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/feedback?action=admin&deleted=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/feedback?action=admin&error=1");
            }
        } catch (Exception e) {
            System.err.println("Error deleting feedback: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/feedback?action=admin&error=1");
        }
    }
}
