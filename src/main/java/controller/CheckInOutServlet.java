package controller;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.RoomDAO;
import model.Booking;
import model.Room;
import model.User;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Servlet for Check-in and Check-out operations
 * Handles check-in, check-out, and invoice generation
 * 
 * @author Aurora Hotel Team
 */
@WebServlet(name = "CheckInOutServlet", urlPatterns = {"/checkinout"})
public class CheckInOutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String view = request.getParameter("view");

        if ("checkin".equals(view)) {
            showCheckInForm(request, response);
        } else if ("checkout".equals(view)) {
            showCheckOutForm(request, response);
        } else if ("invoice".equals(view)) {
            showInvoice(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = request.getParameter("action");

        if ("checkin".equals(action)) {
            processCheckIn(request, response);
        } else if ("checkout".equals(action)) {
            processCheckOut(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
        }
    }

    /**
     * Show check-in form
     */
    private void showCheckInForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(idStr);
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingID);

            if (booking == null) {
                request.setAttribute("errorMessage", "Không tìm thấy booking");
                response.sendRedirect(request.getContextPath() + "/booking?view=list");
                return;
            }

            // Validate booking can be checked in
            if (!"Đã xác nhận".equals(booking.getStatus())) {
                request.setAttribute("errorMessage", "Chỉ có thể check-in booking đã xác nhận");
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID);
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/WEB-INF/checkinout/checkin.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing check-in form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
        }
    }

    /**
     * Process check-in
     */
    private void processCheckIn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("bookingId");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(idStr);
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingID);

            if (booking == null) {
                request.setAttribute("errorMessage", "Không tìm thấy booking");
                response.sendRedirect(request.getContextPath() + "/booking?view=list");
                return;
            }

            // Validate booking status
            if (!"Đã xác nhận".equals(booking.getStatus())) {
                request.setAttribute("errorMessage", "Chỉ có thể check-in booking đã xác nhận");
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID);
                return;
            }

            // Update booking status
            booking.setStatus("Đang sử dụng");
            booking.setActualCheckInDate(LocalDateTime.now());
            boolean bookingUpdated = bookingDAO.updateBooking(booking);

            if (bookingUpdated) {
                // Update room status
                RoomDAO roomDAO = new RoomDAO();
                Room room = roomDAO.getById(booking.getRoomID());
                if (room != null) {
                    room.setStatus("Đang sử dụng");
                    roomDAO.update(room);
                }

                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&success=checkin");
            } else {
                request.setAttribute("errorMessage", "Không thể check-in");
                showCheckInForm(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error processing check-in: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            showCheckInForm(request, response);
        }
    }

    /**
     * Show check-out form
     */
    private void showCheckOutForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(idStr);
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingID);

            if (booking == null) {
                request.setAttribute("errorMessage", "Không tìm thấy booking");
                response.sendRedirect(request.getContextPath() + "/booking?view=list");
                return;
            }

            // Validate booking can be checked out
            if (!"Đang sử dụng".equals(booking.getStatus())) {
                request.setAttribute("errorMessage", "Chỉ có thể check-out booking đang sử dụng");
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID);
                return;
            }

            // Calculate total charges
            BookingServiceDAO bookingServiceDAO = new BookingServiceDAO();
            BigDecimal servicesTotal = bookingServiceDAO.calculateServicesTotal(bookingID);
            BigDecimal grandTotal = booking.getTotalAmount().add(servicesTotal);
            BigDecimal remainingAmount = grandTotal.subtract(booking.getDepositAmount());

            request.setAttribute("booking", booking);
            request.setAttribute("servicesTotal", servicesTotal);
            request.setAttribute("grandTotal", grandTotal);
            request.setAttribute("remainingAmount", remainingAmount);
            request.getRequestDispatcher("/WEB-INF/checkinout/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing check-out form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
        }
    }

    /**
     * Process check-out
     */
    private void processCheckOut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("bookingId");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(idStr);
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingID);

            if (booking == null) {
                request.setAttribute("errorMessage", "Không tìm thấy booking");
                response.sendRedirect(request.getContextPath() + "/booking?view=list");
                return;
            }

            // Update booking status
            booking.setStatus("Đã hoàn thành");
            booking.setActualCheckOutDate(LocalDateTime.now());
            boolean bookingUpdated = bookingDAO.updateBooking(booking);

            if (bookingUpdated) {
                // Update room status
                RoomDAO roomDAO = new RoomDAO();
                Room room = roomDAO.getById(booking.getRoomID());
                if (room != null) {
                    room.setStatus("Trống");
                    roomDAO.update(room);
                }

                // Redirect to invoice
                response.sendRedirect(request.getContextPath() + "/checkinout?view=invoice&id=" + bookingID);
            } else {
                request.setAttribute("errorMessage", "Không thể check-out");
                showCheckOutForm(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error processing check-out: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            showCheckOutForm(request, response);
        }
    }

    /**
     * Show invoice
     */
    private void showInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(idStr);
            BookingDAO bookingDAO = new BookingDAO();
            Booking booking = bookingDAO.getBookingById(bookingID);

            if (booking == null) {
                request.setAttribute("errorMessage", "Không tìm thấy booking");
                response.sendRedirect(request.getContextPath() + "/booking?view=list");
                return;
            }

            // Calculate totals
            BookingServiceDAO bookingServiceDAO = new BookingServiceDAO();
            BigDecimal servicesTotal = bookingServiceDAO.calculateServicesTotal(bookingID);
            BigDecimal grandTotal = booking.getTotalAmount().add(servicesTotal);
            BigDecimal remainingAmount = grandTotal.subtract(booking.getDepositAmount());

            request.setAttribute("booking", booking);
            request.setAttribute("servicesTotal", servicesTotal);
            request.setAttribute("grandTotal", grandTotal);
            request.setAttribute("remainingAmount", remainingAmount);
            request.getRequestDispatcher("/WEB-INF/checkinout/invoice.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing invoice: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
        }
    }
}

