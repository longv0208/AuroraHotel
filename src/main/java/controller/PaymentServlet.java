package controller;

import dao.BookingDAO;
import dao.PaymentDAO;
import model.Booking;
import model.Payment;
import model.User;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

/**
 * Servlet for Payment processing operations
 * Handles deposit and checkout payments
 * 
 * @author Aurora Hotel Team
 */
@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {

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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String view = request.getParameter("view");

        if (view == null) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        switch (view) {
            case "deposit":
                showDepositForm(request, response);
                break;
                
            case "checkout":
                showCheckoutForm(request, response);
                break;
                
            case "confirmation":
                showPaymentConfirmation(request, response);
                break;
                
            case "history":
                showPaymentHistory(request, response);
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/booking?view=list");
                break;
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
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        switch (action) {
            case "process-deposit":
                processDepositPayment(request, response);
                break;
                
            case "process-checkout":
                processCheckoutPayment(request, response);
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/booking?view=list");
                break;
        }
    }

    /**
     * Show deposit payment form
     */
    private void showDepositForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIdStr);
            
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingID);
            
            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/booking?view=list&error=notfound");
                return;
            }
            
            // Check if booking status allows deposit
            if (!"Chờ xác nhận".equals(booking.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=invalidstatus");
                return;
            }
            
            // Calculate deposit amount (30% of total)
            BigDecimal depositAmount = booking.getTotalAmount().multiply(new BigDecimal("0.30"));
            
            request.setAttribute("booking", booking);
            request.setAttribute("depositAmount", depositAmount);
            request.getRequestDispatcher("/WEB-INF/payment/deposit.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing deposit form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
        }
    }

    /**
     * Show checkout payment form
     */
    private void showCheckoutForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        // Only Admin can process checkout
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=unauthorized");
            return;
        }
        
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIdStr);
            
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingID);
            
            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/booking?view=list&error=notfound");
                return;
            }
            
            // Check if booking status allows checkout
            if (!"Đã checkin".equals(booking.getStatus()) && !"Đã xác nhận".equals(booking.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=invalidstatus");
                return;
            }
            
            // Calculate remaining amount
            BigDecimal remainingAmount = booking.getTotalAmount().subtract(
                booking.getDepositAmount() != null ? booking.getDepositAmount() : BigDecimal.ZERO
            );
            
            // Get payment history
            PaymentDAO paymentDAO = new PaymentDAO();
            List<Payment> payments = paymentDAO.getPaymentsByBooking(bookingID);
            
            request.setAttribute("booking", booking);
            request.setAttribute("remainingAmount", remainingAmount);
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/WEB-INF/payment/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing checkout form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
        }
    }

    /**
     * Process deposit payment
     */
    private void processDepositPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        try {
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));
            BigDecimal depositAmount = new BigDecimal(request.getParameter("depositAmount"));
            String paymentMethod = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");
            
            // Generate transaction ID
            String transactionID = "DEP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            
            // Create payment object
            Payment payment = new Payment();
            payment.setBookingID(bookingID);
            payment.setAmount(depositAmount);
            payment.setPaymentMethod(paymentMethod);
            payment.setPaymentType("Đặt cọc");
            payment.setTransactionID(transactionID);
            payment.setUserID(loggedInUser.getUserID());
            payment.setNotes(notes);
            payment.setStatus("Thành công");
            
            // Process payment
            PaymentDAO paymentDAO = new PaymentDAO();
            boolean result = paymentDAO.processDepositPayment(payment);
            
            if (result) {
                response.sendRedirect(request.getContextPath() + "/payment?view=confirmation&bookingId=" + bookingID + "&type=deposit");
            } else {
                request.setAttribute("errorMessage", "Không thể xử lý thanh toán đặt cọc");
                showDepositForm(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error processing deposit payment: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            showDepositForm(request, response);
        }
    }

    /**
     * Process checkout payment
     */
    private void processCheckoutPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        // Only Admin can process checkout
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=unauthorized");
            return;
        }

        try {
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));
            BigDecimal remainingAmount = new BigDecimal(request.getParameter("remainingAmount"));
            String paymentMethod = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");
            
            // Generate transaction ID
            String transactionID = "CHK-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            
            // Create payment object
            Payment payment = new Payment();
            payment.setBookingID(bookingID);
            payment.setAmount(remainingAmount);
            payment.setPaymentMethod(paymentMethod);
            payment.setPaymentType("Thanh toán");
            payment.setTransactionID(transactionID);
            payment.setUserID(loggedInUser.getUserID());
            payment.setNotes(notes);
            payment.setStatus("Thành công");
            
            // Process payment
            PaymentDAO paymentDAO = new PaymentDAO();
            boolean result = paymentDAO.processCheckoutPayment(payment);
            
            if (result) {
                response.sendRedirect(request.getContextPath() + "/payment?view=confirmation&bookingId=" + bookingID + "&type=checkout");
            } else {
                request.setAttribute("errorMessage", "Không thể xử lý thanh toán checkout");
                showCheckoutForm(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error processing checkout payment: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            showCheckoutForm(request, response);
        }
    }

    /**
     * Show payment confirmation page
     */
    private void showPaymentConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        String type = request.getParameter("type");
        
        if (bookingIdStr == null || type == null) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIdStr);
            
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingID);
            
            PaymentDAO paymentDAO = new PaymentDAO();
            List<Payment> payments = paymentDAO.getPaymentsByBooking(bookingID);
            
            request.setAttribute("booking", booking);
            request.setAttribute("payments", payments);
            request.setAttribute("paymentType", type);
            request.getRequestDispatcher("/WEB-INF/payment/confirmation.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing payment confirmation: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
        }
    }

    /**
     * Show payment history for a booking
     */
    private void showPaymentHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(bookingIdStr);
            
            PaymentDAO paymentDAO = new PaymentDAO();
            List<Payment> payments = paymentDAO.getPaymentsByBooking(bookingID);
            
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingID);
            
            request.setAttribute("payments", payments);
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/WEB-INF/payment/history.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing payment history: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Payment Servlet - Handles deposit and checkout payment processing";
    }
}

