package controller;

import dao.BookingDAO;
import dao.BookingHistoryDAO;
import dao.BookingServiceDAO;
import dao.CouponDAO;
import dao.CouponUsageDAO;
import dao.CustomerDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import dao.ServiceDAO;
import model.Booking;
import model.BookingHistory;
import model.BookingService;
import model.Coupon;
import model.CouponUsage;
import model.Customer;
import model.Room;
import model.RoomType;
import model.Service;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for Booking management operations
 * Handles search, create, view, cancel booking flows
 * 
 * @author Aurora Hotel Team
 */
@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {

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

        if (view == null || view.equals("list")) {
            // List all bookings (Admin) or user's bookings (User)
            showBookingList(request, response);
            
        } else if (view.equals("search")) {
            // Search available rooms
            showSearchForm(request, response);
            
        } else if (view.equals("search-results")) {
            // Display search results
            showSearchResults(request, response);
            
        } else if (view.equals("create")) {
            // Create booking form
            showCreateForm(request, response);
            
        } else if (view.equals("details")) {
            // View booking details
            showBookingDetails(request, response);
            
        } else if (view.equals("my-bookings")) {
            // View user's own bookings
            showUserBookings(request, response);
            
        } else {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
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
            case "create":
                createBooking(request, response);
                break;

            case "cancel":
                cancelBooking(request, response);
                break;

            case "confirm":
                confirmBooking(request, response);
                break;

            case "checkin":
                checkinBooking(request, response);
                break;

            case "checkout":
                checkoutBooking(request, response);
                break;

            case "validateCoupon":
                validateCouponAjax(request, response);
                break;

            case "update-status":
                updateBookingStatus(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/booking?view=list");
                break;
        }
    }

    /**
     * Show booking list page
     */
    private void showBookingList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

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

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings;

        // Admin sees all bookings, User sees only their bookings
        if ("Admin".equals(loggedInUser.getRole())) {
            bookings = bookingDAO.getAllBookings(page);
        } else {
            bookings = bookingDAO.getBookingsByUser(loggedInUser.getUserID());
        }

        // Calculate total amount including services for each booking
        BookingServiceDAO bookingServiceDAO = new BookingServiceDAO();
        Map<Integer, BigDecimal> serviceTotals = new HashMap<>();
        Map<Integer, BigDecimal> finalTotals = new HashMap<>();

        for (Booking booking : bookings) {
            List<BookingService> services = bookingServiceDAO.getServicesByBooking(booking.getBookingID());
            BigDecimal serviceTotal = services.stream()
                .map(BookingService::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
            serviceTotals.put(booking.getBookingID(), serviceTotal);
            finalTotals.put(booking.getBookingID(),
                booking.getTotalAmount().add(serviceTotal));
        }

        int totalRows = bookingDAO.getTotalRows();
        int totalPages = (int) Math.ceil((double) totalRows / 10);

        request.setAttribute("bookings", bookings);
        request.setAttribute("serviceTotals", serviceTotals);
        request.setAttribute("finalTotals", finalTotals);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalRows", totalRows);
        request.getRequestDispatcher("/WEB-INF/booking/list.jsp").forward(request, response);
    }

    /**
     * Show search form for available rooms
     */
    private void showSearchForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
        List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
        
        request.setAttribute("roomTypes", roomTypes);
        request.getRequestDispatcher("/WEB-INF/booking/search.jsp").forward(request, response);
    }

    /**
     * Show search results
     */
    private void showSearchResults(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String checkInStr = request.getParameter("checkInDate");
        String checkOutStr = request.getParameter("checkOutDate");
        String roomTypeIdStr = request.getParameter("roomTypeID");

        // Validate dates
        if (checkInStr == null || checkOutStr == null || 
            checkInStr.isEmpty() || checkOutStr.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ ngày check-in và check-out");
            showSearchForm(request, response);
            return;
        }

        try {
            LocalDate checkInDate = LocalDate.parse(checkInStr);
            LocalDate checkOutDate = LocalDate.parse(checkOutStr);
            
            // Validate date logic
            if (checkInDate.isBefore(LocalDate.now())) {
                request.setAttribute("errorMessage", "Ngày check-in không được là quá khứ");
                showSearchForm(request, response);
                return;
            }
            
            if (checkOutDate.isBefore(checkInDate) || checkOutDate.isEqual(checkInDate)) {
                request.setAttribute("errorMessage", "Ngày check-out phải sau ngày check-in");
                showSearchForm(request, response);
                return;
            }

            Integer roomTypeID = null;
            if (roomTypeIdStr != null && !roomTypeIdStr.isEmpty() && !"0".equals(roomTypeIdStr)) {
                roomTypeID = Integer.parseInt(roomTypeIdStr);
            }

            BookingDAO bookingDAO = new BookingDAO();
            List<Room> availableRooms = bookingDAO.searchAvailableRooms(checkInDate, checkOutDate, roomTypeID);

            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("checkInDate", checkInDate);
            request.setAttribute("checkOutDate", checkOutDate);
            request.setAttribute("roomTypeID", roomTypeID);
            
            RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
            List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
            request.setAttribute("roomTypes", roomTypes);
            
            request.getRequestDispatcher("/WEB-INF/booking/search-results.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error searching available rooms: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tìm kiếm phòng");
            showSearchForm(request, response);
        }
    }

    /**
     * Show create booking form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String roomIdStr = request.getParameter("roomId");
        String checkInStr = request.getParameter("checkInDate");
        String checkOutStr = request.getParameter("checkOutDate");

        if (roomIdStr == null || checkInStr == null || checkOutStr == null) {
            response.sendRedirect(request.getContextPath() + "/booking?view=search");
            return;
        }

        try {
            int roomID = Integer.parseInt(roomIdStr);
            LocalDate checkInDate = LocalDate.parse(checkInStr);
            LocalDate checkOutDate = LocalDate.parse(checkOutStr);

            RoomDAO roomDAO = new RoomDAO();
            Room room = roomDAO.getById(roomID);

            if (room == null) {
                request.setAttribute("errorMessage", "Không tìm thấy phòng");
                showSearchForm(request, response);
                return;
            }

            // Calculate total amount
            long numberOfNights = checkOutDate.toEpochDay() - checkInDate.toEpochDay();
            BigDecimal totalAmount = room.getRoomType().getBasePrice().multiply(BigDecimal.valueOf(numberOfNights));

            // Load available services
            ServiceDAO serviceDAO = new ServiceDAO();
            List<Service> availableServices = serviceDAO.getAllActiveServices();

            request.setAttribute("room", room);
            request.setAttribute("availableServices", availableServices);
            request.setAttribute("checkInDate", checkInDate);
            request.setAttribute("checkOutDate", checkOutDate);
            request.setAttribute("numberOfNights", numberOfNights);
            request.setAttribute("totalAmount", totalAmount);
            
            request.getRequestDispatcher("/WEB-INF/booking/create.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing create booking form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=search");
        }
    }

    /**
     * Create a new booking
     */
    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        try {
            // Get booking parameters
            int roomID = Integer.parseInt(request.getParameter("roomID"));
            LocalDate checkInDate = LocalDate.parse(request.getParameter("checkInDate"));
            LocalDate checkOutDate = LocalDate.parse(request.getParameter("checkOutDate"));
            int numberOfGuests = Integer.parseInt(request.getParameter("numberOfGuests"));
            String notes = request.getParameter("notes");
            BigDecimal totalAmount = new BigDecimal(request.getParameter("totalAmount"));
            String couponCode = request.getParameter("couponCode");

            // Get customer information
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String idCard = request.getParameter("idCard");
            String address = request.getParameter("address");

            // Check or create customer
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerByPhone(phone);
            
            int customerID;
            if (customer == null) {
                // Create new customer
                customer = new Customer();
                customer.setFullName(fullName);
                customer.setPhone(phone);
                customer.setEmail(email);
                customer.setIdCard(idCard);
                customer.setAddress(address);
                customer.setNationality("Việt Nam");
                
                customerID = customerDAO.createCustomer(customer);
                if (customerID == -1) {
                    request.setAttribute("errorMessage", "Không thể tạo thông tin khách hàng");
                    showCreateForm(request, response);
                    return;
                }
            } else {
                customerID = customer.getCustomerID();
            }

            // Process coupon if provided
            BigDecimal discountAmount = BigDecimal.ZERO;
            Coupon validCoupon = null;

            if (couponCode != null && !couponCode.trim().isEmpty()) {
                CouponDAO couponDAO = new CouponDAO();
                RoomDAO roomDAO = new RoomDAO();
                Room room = roomDAO.getById(roomID);

                // Validate coupon
                validCoupon = couponDAO.validateCoupon(couponCode.trim(), totalAmount, room.getRoomTypeID());

                if (validCoupon != null) {
                    // Calculate discount amount
                    discountAmount = couponDAO.calculateDiscountAmount(validCoupon, totalAmount);
                } else {
                    // Coupon invalid - set error message but still allow booking
                    request.setAttribute("couponError", "Mã giảm giá không hợp lệ hoặc đã hết hạn");
                }
            }

            // Create booking
            Booking booking = new Booking();
            booking.setCustomerID(customerID);
            booking.setRoomID(roomID);
            booking.setUserID(loggedInUser.getUserID());
            booking.setCheckInDate(checkInDate);
            booking.setCheckOutDate(checkOutDate);
            booking.setNumberOfGuests(numberOfGuests);
            booking.setTotalAmount(totalAmount);
            booking.setDepositAmount(BigDecimal.ZERO);
            booking.setNotes(notes);
            booking.setStatus("Chờ xác nhận");

            BookingDAO bookingDAO = new BookingDAO();
            int bookingID = bookingDAO.createBooking(booking);

            if (bookingID > 0) {
                // Update room status to 'Đã đặt'
                RoomDAO roomDAO = new RoomDAO();
                Room room = roomDAO.getById(roomID);
                room.setStatus("Đã đặt");
                roomDAO.update(room);

                // Add selected services to booking
                String[] selectedServices = request.getParameterValues("selectedServices");
                if (selectedServices != null && selectedServices.length > 0) {
                    BookingServiceDAO bookingServiceDAO = new BookingServiceDAO();
                    ServiceDAO serviceDAO = new ServiceDAO();

                    for (String serviceIdStr : selectedServices) {
                        try {
                            int serviceID = Integer.parseInt(serviceIdStr);
                            String quantityStr = request.getParameter("quantity_" + serviceID);
                            int quantity = (quantityStr != null && !quantityStr.isEmpty()) ?
                                          Integer.parseInt(quantityStr) : 1;

                            // Get service to get current price
                            Service service = serviceDAO.getServiceById(serviceID);
                            if (service != null && quantity > 0) {
                                bookingServiceDAO.addServiceToBooking(bookingID, serviceID, quantity, service.getPrice());
                            }
                        } catch (NumberFormatException e) {
                            System.err.println("Invalid service ID or quantity: " + e.getMessage());
                        }
                    }
                }

                // Apply coupon if valid
                if (validCoupon != null && discountAmount.compareTo(BigDecimal.ZERO) > 0) {
                    // Record coupon usage
                    CouponUsageDAO couponUsageDAO = new CouponUsageDAO();
                    CouponUsage couponUsage = new CouponUsage();
                    couponUsage.setCouponID(validCoupon.getCouponID());
                    couponUsage.setBookingID(bookingID);
                    couponUsage.setCustomerID(customerID);
                    couponUsage.setDiscountAmount(discountAmount);

                    couponUsageDAO.create(couponUsage);

                    // Increment coupon usage count
                    CouponDAO couponDAO = new CouponDAO();
                    couponDAO.incrementUsageCount(validCoupon.getCouponID());
                }

                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&success=1");
            } else {
                request.setAttribute("errorMessage", "Không thể tạo booking");
                showCreateForm(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error creating booking: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo booking: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    /**
     * Show booking details
     */
    private void showBookingDetails(HttpServletRequest request, HttpServletResponse response)
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

            // Load booking services
            BookingServiceDAO bookingServiceDAO = new BookingServiceDAO();
            List<BookingService> bookingServices = bookingServiceDAO.getServicesByBooking(bookingID);
            BigDecimal servicesTotal = bookingServiceDAO.calculateServicesTotal(bookingID);

            // Load coupon usage if any
            CouponUsageDAO couponUsageDAO = new CouponUsageDAO();
            CouponUsage couponUsage = couponUsageDAO.getByBookingId(bookingID);
            BigDecimal discountAmount = (couponUsage != null) ? couponUsage.getDiscountAmount() : BigDecimal.ZERO;

            // Load booking history
            BookingHistoryDAO bookingHistoryDAO = new BookingHistoryDAO();
            List<BookingHistory> bookingHistory = bookingHistoryDAO.getHistoryByBooking(bookingID);

            request.setAttribute("booking", booking);
            request.setAttribute("bookingServices", bookingServices);
            request.setAttribute("servicesTotal", servicesTotal);
            request.setAttribute("couponUsage", couponUsage);
            request.setAttribute("discountAmount", discountAmount);
            request.setAttribute("bookingHistory", bookingHistory);
            request.getRequestDispatcher("/WEB-INF/booking/details.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing booking details: " + e.getMessage());
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/booking?view=list");
            }
        }
    }

    /**
     * Show user's own bookings
     */
    private void showUserBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getBookingsByUser(loggedInUser.getUserID());

        // Calculate total amount including services for each booking
        BookingServiceDAO bookingServiceDAO = new BookingServiceDAO();
        Map<Integer, BigDecimal> serviceTotals = new HashMap<>();
        Map<Integer, BigDecimal> finalTotals = new HashMap<>();

        for (Booking booking : bookings) {
            List<BookingService> services = bookingServiceDAO.getServicesByBooking(booking.getBookingID());
            BigDecimal serviceTotal = services.stream()
                .map(BookingService::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
            serviceTotals.put(booking.getBookingID(), serviceTotal);
            finalTotals.put(booking.getBookingID(),
                booking.getTotalAmount().add(serviceTotal));
        }

        request.setAttribute("bookings", bookings);
        request.setAttribute("serviceTotals", serviceTotals);
        request.setAttribute("finalTotals", finalTotals);
        request.getRequestDispatcher("/WEB-INF/booking/my-bookings.jsp").forward(request, response);
    }

    /**
     * Cancel a booking
     */
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
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
                response.sendRedirect(request.getContextPath() + "/booking?view=list&error=notfound");
                return;
            }
            
            // Check if booking can be canceled
            if ("Đã hủy".equals(booking.getStatus()) || "Đã checkout".equals(booking.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=cannotcancel");
                return;
            }

            // Check if check-in date has not passed (can cancel before check-in date)
            if (booking.getCheckInDate().isBefore(LocalDate.now())) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=toolate");
                return;
            }
            
            boolean result = bookingDAO.cancelBooking(bookingID);
            
            if (result) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&canceled=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error canceling booking: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=1");
        }
    }

    /**
     * Update booking status (Admin only)
     */
    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        // Check if user is Admin
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=unauthorized");
            return;
        }

        try {
            int bookingID = Integer.parseInt(request.getParameter("id"));
            String newStatus = request.getParameter("status");

            BookingDAO bookingDAO = new BookingDAO();
            boolean result = bookingDAO.updateBookingStatus(bookingID, newStatus);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&updated=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error updating booking status: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=1");
        }
    }

    /**
     * Validate coupon via AJAX
     */
    private void validateCouponAjax(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String couponCode = request.getParameter("couponCode");
            String totalAmountStr = request.getParameter("totalAmount");
            String roomTypeIDStr = request.getParameter("roomTypeID");

            if (couponCode == null || couponCode.trim().isEmpty()) {
                response.getWriter().write("{\"valid\": false, \"message\": \"Vui lòng nhập mã giảm giá\"}");
                return;
            }

            BigDecimal totalAmount = new BigDecimal(totalAmountStr);
            Integer roomTypeID = roomTypeIDStr != null ? Integer.parseInt(roomTypeIDStr) : null;

            CouponDAO couponDAO = new CouponDAO();
            Coupon coupon = couponDAO.validateCoupon(couponCode.trim(), totalAmount, roomTypeID);

            if (coupon != null) {
                BigDecimal discountAmount = couponDAO.calculateDiscountAmount(coupon, totalAmount);

                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"valid\": true,");
                json.append("\"couponCode\": \"").append(coupon.getCouponCode()).append("\",");
                json.append("\"description\": \"").append(coupon.getDescription() != null ? coupon.getDescription() : "").append("\",");
                json.append("\"discountType\": \"").append(coupon.getDiscountType()).append("\",");
                json.append("\"discountValue\": ").append(coupon.getDiscountValue()).append(",");
                json.append("\"discountAmount\": ").append(discountAmount).append(",");
                if (coupon.getMaxDiscountAmount() != null) {
                    json.append("\"maxDiscountAmount\": ").append(coupon.getMaxDiscountAmount()).append(",");
                }
                json.append("\"finalAmount\": ").append(totalAmount.subtract(discountAmount));
                json.append("}");

                response.getWriter().write(json.toString());
            } else {
                response.getWriter().write("{\"valid\": false, \"message\": \"Mã giảm giá không hợp lệ hoặc không áp dụng được cho phòng này\"}");
            }

        } catch (Exception e) {
            System.err.println("Error validating coupon: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"valid\": false, \"message\": \"Lỗi khi kiểm tra mã giảm giá\"}");
        }
    }

    /**
     * Confirm booking (Admin only)
     */
    private void confirmBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // Check if user is Admin
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=unauthorized");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(idStr);
            BookingDAO bookingDAO = new BookingDAO();

            boolean result = bookingDAO.updateBookingStatus(bookingID, "Đã xác nhận");

            if (result) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&confirmed=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error confirming booking: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=1");
        }
    }

    /**
     * Check-in booking (Admin only)
     */
    private void checkinBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // Check if user is Admin
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=unauthorized");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(idStr);
            BookingDAO bookingDAO = new BookingDAO();

            // Update booking status and room status
            boolean result = bookingDAO.checkinBooking(bookingID);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&checkedin=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error checking in booking: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=1");
        }
    }

    /**
     * Check-out booking (Admin only)
     */
    private void checkoutBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // Check if user is Admin
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=unauthorized");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking?view=list");
            return;
        }

        try {
            int bookingID = Integer.parseInt(idStr);
            BookingDAO bookingDAO = new BookingDAO();

            // Update booking status and room status
            boolean result = bookingDAO.checkoutBooking(bookingID);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&checkedout=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/booking?view=details&id=" + bookingID + "&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error checking out booking: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking?view=list&error=1");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Booking Servlet - Manages booking search, creation, viewing, and cancellation";
    }
}

