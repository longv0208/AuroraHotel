package controller;

import dao.CouponDAO;
import dao.RoomTypeDAO;
import model.Coupon;
import model.RoomType;
import model.User;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import com.google.gson.Gson;

/**
 * Servlet for Coupon management operations
 * Handles CRUD operations and coupon validation
 * 
 * @author Aurora Hotel Team
 */
@WebServlet(name = "CouponServlet", urlPatterns = {"/coupon"})
public class CouponServlet extends HttpServlet {

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

        // Check if user is Admin (coupon management is Admin-only)
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/aurora?error=unauthorized");
            return;
        }

        String view = request.getParameter("view");

        if (view == null || view.equals("list")) {
            // List all coupons with pagination
            showCouponList(request, response);
            
        } else if (view.equals("create")) {
            // Create new coupon form
            showCreateForm(request, response);
            
        } else if (view.equals("edit")) {
            // Edit coupon form
            showEditForm(request, response);
            
        } else if (view.equals("delete")) {
            // Delete coupon confirmation
            showDeleteConfirmation(request, response);
            
        } else {
            response.sendRedirect(request.getContextPath() + "/coupon?view=list");
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
            response.sendRedirect(request.getContextPath() + "/coupon?view=list");
            return;
        }

        switch (action) {
            case "create":
                createCoupon(request, response);
                break;
                
            case "edit":
                editCoupon(request, response);
                break;
                
            case "delete":
                deleteCoupon(request, response);
                break;
                
            case "validate":
                validateCoupon(request, response);
                break;
                
            case "deactivate":
                deactivateCoupon(request, response);
                break;
                
            case "activate":
                activateCoupon(request, response);
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/coupon?view=list");
                break;
        }
    }

    /**
     * Show coupon list with pagination
     */
    private void showCouponList(HttpServletRequest request, HttpServletResponse response)
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

        CouponDAO couponDAO = new CouponDAO();
        List<Coupon> coupons = couponDAO.getAllCoupons(page);

        int totalRows = couponDAO.getTotalRows();
        int totalPages = (int) Math.ceil((double) totalRows / 10);

        request.setAttribute("coupons", coupons);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalRows", totalRows);
        request.getRequestDispatcher("/WEB-INF/coupon/list.jsp").forward(request, response);
    }

    /**
     * Show create coupon form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
        List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
        
        request.setAttribute("roomTypes", roomTypes);
        request.getRequestDispatcher("/WEB-INF/coupon/create.jsp").forward(request, response);
    }

    /**
     * Show edit coupon form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/coupon?view=list");
            return;
        }

        try {
            int couponID = Integer.parseInt(idStr);
            CouponDAO couponDAO = new CouponDAO();
            Coupon coupon = couponDAO.getCouponById(couponID);

            if (coupon == null) {
                response.sendRedirect(request.getContextPath() + "/coupon?view=list&error=notfound");
                return;
            }

            RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
            List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();

            request.setAttribute("coupon", coupon);
            request.setAttribute("roomTypes", roomTypes);
            request.getRequestDispatcher("/WEB-INF/coupon/edit.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing edit form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/coupon?view=list");
        }
    }

    /**
     * Show delete confirmation
     */
    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/coupon?view=list");
            return;
        }

        try {
            int couponID = Integer.parseInt(idStr);
            CouponDAO couponDAO = new CouponDAO();
            Coupon coupon = couponDAO.getCouponById(couponID);

            if (coupon == null) {
                response.sendRedirect(request.getContextPath() + "/coupon?view=list&error=notfound");
                return;
            }

            request.setAttribute("coupon", coupon);
            request.getRequestDispatcher("/WEB-INF/coupon/delete.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing delete confirmation: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/coupon?view=list");
        }
    }

    /**
     * Create new coupon
     */
    private void createCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        try {
            String couponCode = request.getParameter("couponCode");
            String couponName = request.getParameter("couponName");
            String description = request.getParameter("description");
            String discountType = request.getParameter("discountType");
            BigDecimal discountValue = new BigDecimal(request.getParameter("discountValue"));
            
            String minBookingAmountStr = request.getParameter("minBookingAmount");
            BigDecimal minBookingAmount = (minBookingAmountStr != null && !minBookingAmountStr.isEmpty()) 
                ? new BigDecimal(minBookingAmountStr) : null;
            
            String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
            BigDecimal maxDiscountAmount = (maxDiscountAmountStr != null && !maxDiscountAmountStr.isEmpty()) 
                ? new BigDecimal(maxDiscountAmountStr) : null;
            
            String roomTypeIdStr = request.getParameter("roomTypeID");
            Integer roomTypeID = (roomTypeIdStr != null && !roomTypeIdStr.isEmpty() && !"0".equals(roomTypeIdStr)) 
                ? Integer.parseInt(roomTypeIdStr) : null;
            
            LocalDate startDate = LocalDate.parse(request.getParameter("validFrom"));
            LocalDate endDate = LocalDate.parse(request.getParameter("validTo"));
            
            String usageLimitStr = request.getParameter("usageLimit");
            Integer usageLimit = (usageLimitStr != null && !usageLimitStr.isEmpty()) 
                ? Integer.parseInt(usageLimitStr) : null;
            
            boolean isActive = "on".equals(request.getParameter("isActive"));

            // Validate dates
            if (endDate.isBefore(startDate) || endDate.isEqual(startDate)) {
                request.setAttribute("errorMessage", "Ngày kết thúc phải sau ngày bắt đầu");
                showCreateForm(request, response);
                return;
            }

            // Create coupon
            String finalDescription = (couponName != null && !couponName.isEmpty()) ? couponName : 
                (description != null && !description.isEmpty()) ? description : "";
            
            Coupon coupon = new Coupon(couponCode.toUpperCase(), finalDescription, 
                discountType, discountValue, minBookingAmount, maxDiscountAmount, roomTypeID, 
                startDate, endDate, usageLimit, loggedInUser.getUserID());

            CouponDAO couponDAO = new CouponDAO();
            int couponID = couponDAO.createCoupon(coupon);

            if (couponID > 0) {
                response.sendRedirect(request.getContextPath() + "/coupon?view=list&success=1");
            } else {
                request.setAttribute("errorMessage", "Không thể tạo coupon");
                showCreateForm(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error creating coupon: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    /**
     * Edit coupon
     */
    private void editCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int couponID = Integer.parseInt(request.getParameter("id"));
            String couponCode = request.getParameter("couponCode");
            String couponName = request.getParameter("couponName");
            String description = request.getParameter("description");
            String discountType = request.getParameter("discountType");
            BigDecimal discountValue = new BigDecimal(request.getParameter("discountValue"));
            
            String minBookingAmountStr = request.getParameter("minBookingAmount");
            BigDecimal minBookingAmount = (minBookingAmountStr != null && !minBookingAmountStr.isEmpty()) 
                ? new BigDecimal(minBookingAmountStr) : null;
            
            String maxDiscountAmountStr = request.getParameter("maxDiscountAmount");
            BigDecimal maxDiscountAmount = (maxDiscountAmountStr != null && !maxDiscountAmountStr.isEmpty()) 
                ? new BigDecimal(maxDiscountAmountStr) : null;
            
            String roomTypeIdStr = request.getParameter("roomTypeID");
            Integer roomTypeID = (roomTypeIdStr != null && !roomTypeIdStr.isEmpty() && !"0".equals(roomTypeIdStr)) 
                ? Integer.parseInt(roomTypeIdStr) : null;
            
            LocalDate startDate = LocalDate.parse(request.getParameter("validFrom"));
            LocalDate endDate = LocalDate.parse(request.getParameter("validTo"));
            
            String usageLimitStr = request.getParameter("usageLimit");
            Integer usageLimit = (usageLimitStr != null && !usageLimitStr.isEmpty()) 
                ? Integer.parseInt(usageLimitStr) : null;
            
            boolean isActive = "on".equals(request.getParameter("isActive"));

            // Get existing coupon
            CouponDAO couponDAO = new CouponDAO();
            Coupon coupon = couponDAO.getCouponById(couponID);
            
            if (coupon == null) {
                response.sendRedirect(request.getContextPath() + "/coupon?view=list&error=notfound");
                return;
            }

            // Update fields
            coupon.setCouponCode(couponCode.toUpperCase());
            String finalDescription = (couponName != null && !couponName.isEmpty()) ? couponName : 
                (description != null && !description.isEmpty()) ? description : "";
            coupon.setDescription(finalDescription);
            coupon.setDiscountType(discountType);
            coupon.setDiscountValue(discountValue);
            coupon.setMinBookingAmount(minBookingAmount);
            coupon.setMaxDiscountAmount(maxDiscountAmount);
            coupon.setRoomTypeID(roomTypeID);
            coupon.setStartDate(startDate);
            coupon.setEndDate(endDate);
            coupon.setUsageLimit(usageLimit);
            coupon.setActive(isActive);

            boolean result = couponDAO.updateCoupon(coupon);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/coupon?view=list&updated=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/coupon?view=edit&id=" + couponID + "&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error editing coupon: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/coupon?view=list&error=1");
        }
    }

    /**
     * Delete coupon
     */
    private void deleteCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int couponID = Integer.parseInt(request.getParameter("id"));

            CouponDAO couponDAO = new CouponDAO();
            boolean result = couponDAO.deleteCoupon(couponID);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/coupon?view=list&hidden=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/coupon?view=delete&id=" + couponID + "&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error deleting coupon: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/coupon?view=list&error=1");
        }
    }

    /**
     * Deactivate coupon
     */
    private void deactivateCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int couponID = Integer.parseInt(request.getParameter("id"));

            CouponDAO couponDAO = new CouponDAO();
            boolean result = couponDAO.deactivateCoupon(couponID);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/coupon?view=list&deactivated=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/coupon?view=list&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error deactivating coupon: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/coupon?view=list&error=1");
        }
    }
    
    /**
     * Activate coupon
     */
    private void activateCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int couponID = Integer.parseInt(request.getParameter("id"));

            CouponDAO couponDAO = new CouponDAO();
            boolean result = couponDAO.activateCoupon(couponID);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/coupon?view=list&activated=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/coupon?view=list&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error activating coupon: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/coupon?view=list&error=1");
        }
    }

    /**
     * Validate coupon (AJAX request)
     * Returns JSON response
     */
    private void validateCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            String couponCode = request.getParameter("couponCode");
            String bookingAmountStr = request.getParameter("bookingAmount");
            String roomTypeIdStr = request.getParameter("roomTypeID");

            if (couponCode == null || couponCode.trim().isEmpty() || 
                bookingAmountStr == null || bookingAmountStr.isEmpty()) {
                
                Map<String, Object> json = new HashMap<>();
                json.put("valid", false);
                json.put("message", "Thông tin không đầy đủ");
                out.print(new Gson().toJson(json));
                return;
            }

            BigDecimal bookingAmount = new BigDecimal(bookingAmountStr);
            Integer roomTypeID = (roomTypeIdStr != null && !roomTypeIdStr.isEmpty()) 
                ? Integer.parseInt(roomTypeIdStr) : null;

            CouponDAO couponDAO = new CouponDAO();
            Coupon coupon = couponDAO.validateCoupon(couponCode.trim(), bookingAmount, roomTypeID);

            Map<String, Object> json = new HashMap<>();
            
            if (coupon != null) {
                BigDecimal discountAmount = couponDAO.calculateDiscountAmount(coupon, bookingAmount);
                BigDecimal newTotal = bookingAmount.subtract(discountAmount);
                
                json.put("valid", true);
                json.put("discountAmount", discountAmount.toString());
                json.put("newTotal", newTotal.toString());
                json.put("message", "Mã giảm giá hợp lệ");
            } else {
                json.put("valid", false);
                json.put("message", "Mã giảm giá không hợp lệ hoặc đã hết hạn");
            }

            out.print(new Gson().toJson(json));

        } catch (Exception e) {
            System.err.println("Error validating coupon: " + e.getMessage());
            e.printStackTrace();
            
            try (PrintWriter out = response.getWriter()) {
                Map<String, Object> json = new HashMap<>();
                json.put("valid", false);
                json.put("message", "Có lỗi xảy ra khi kiểm tra mã giảm giá");
                out.print(new Gson().toJson(json));
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Coupon Servlet - Manages discount coupons and validation";
    }
}

