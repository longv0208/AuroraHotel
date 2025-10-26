package controller;

import model.User;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import db.DBContext;

/**
 * Servlet for generating reports and analytics
 * Handles revenue, occupancy, and performance reports
 * 
 * @author Aurora Hotel Team
 */
@WebServlet(name = "ReportServlet", urlPatterns = { "/report" })
public class ReportServlet extends HttpServlet {

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

        // Check if user is Admin (reports are Admin-only)
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/aurora?error=unauthorized");
            return;
        }

        String view = request.getParameter("view");

        if (view == null || view.equals("dashboard")) {
            // Dashboard with overview
            showDashboard(request, response);

        } else if (view.equals("revenue")) {
            // Monthly revenue report
            showRevenueReport(request, response);

        } else if (view.equals("occupancy")) {
            // Room occupancy report
            showOccupancyReport(request, response);

        } else if (view.equals("room-type-performance")) {
            // Room type performance report
            showRoomTypePerformance(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/report?view=dashboard");
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

        // POST requests redirect to GET
        doGet(request, response);
    }

    /**
     * Show dashboard with overview statistics
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DBContext dbContext = new DBContext();

        try (Connection conn = dbContext.getConnection()) {
            // Get total bookings
            int totalBookings = getCount(conn, "SELECT COUNT(*) FROM Bookings");

            // Get total customers
            int totalCustomers = getCount(conn, "SELECT COUNT(*) FROM Customers");

            // Get total rooms
            int totalRooms = getCount(conn, "SELECT COUNT(*) FROM Rooms WHERE IsActive = 1");

            // Get occupied rooms
            int occupiedRooms = getCount(conn,
                    "SELECT COUNT(DISTINCT RoomID) FROM Bookings " +
                            "WHERE Status IN ('Đã xác nhận', 'Đã checkin') " +
                            "AND CheckInDate <= CAST(GETDATE() AS DATE) " +
                            "AND CheckOutDate > CAST(GETDATE() AS DATE)");

            // Get today's check-ins
            int todayCheckIns = getCount(conn,
                    "SELECT COUNT(*) FROM Bookings " +
                            "WHERE CheckInDate = CAST(GETDATE() AS DATE)");

            // Get today's check-outs
            int todayCheckOuts = getCount(conn,
                    "SELECT COUNT(*) FROM Bookings " +
                            "WHERE CheckOutDate = CAST(GETDATE() AS DATE)");

            // Get pending bookings
            int pendingBookings = getCount(conn,
                    "SELECT COUNT(*) FROM Bookings WHERE Status = 'Chờ xác nhận'");

            // Get this month's revenue
            String revenueQuery = "SELECT ISNULL(SUM(Amount), 0) FROM Payments " +
                    "WHERE YEAR(PaymentDate) = YEAR(GETDATE()) " +
                    "AND MONTH(PaymentDate) = MONTH(GETDATE()) " +
                    "AND Status = 'Thành công'";
            double monthlyRevenue = getDecimalValue(conn, revenueQuery);

            // Calculate occupancy rate
            double occupancyRate = (totalRooms > 0) ? ((double) occupiedRooms / totalRooms) * 100 : 0;

            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("occupiedRooms", occupiedRooms);
            request.setAttribute("todayCheckIns", todayCheckIns);
            request.setAttribute("todayCheckOuts", todayCheckOuts);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("occupancyRate", String.format("%.1f", occupancyRate));

            request.getRequestDispatcher("/WEB-INF/report/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("Error showing dashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải dashboard");
            response.sendRedirect(request.getContextPath() + "/aurora");
        }
    }

    /**
     * Show monthly revenue report
     */
    private void showRevenueReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get month and year parameters (default to current)
        LocalDate now = LocalDate.now();
        int month = now.getMonthValue();
        int year = now.getYear();

        String monthStr = request.getParameter("month");
        String yearStr = request.getParameter("year");

        if (monthStr != null && !monthStr.isEmpty()) {
            try {
                month = Integer.parseInt(monthStr);
            } catch (NumberFormatException e) {
                // Use default
            }
        }

        if (yearStr != null && !yearStr.isEmpty()) {
            try {
                year = Integer.parseInt(yearStr);
            } catch (NumberFormatException e) {
                // Use default
            }
        }

        DBContext dbContext = new DBContext();

        try (Connection conn = dbContext.getConnection()) {
            // Get monthly revenue data
            String query = "SELECT " +
                    "COUNT(DISTINCT b.BookingID) as TotalBookings, " +
                    "ISNULL(SUM(p.Amount), 0) as TotalRevenue, " +
                    "ISNULL(AVG(b.TotalAmount), 0) as AverageBookingAmount " +
                    "FROM Bookings b " +
                    "LEFT JOIN Payments p ON b.BookingID = p.BookingID AND p.Status = 'Thành công' " +
                    "WHERE YEAR(b.BookingDate) = ? AND MONTH(b.BookingDate) = ? " +
                    "AND b.Status NOT IN ('Đã hủy')";

            Map<String, Object> revenueData = new HashMap<>();

            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, year);
                ps.setInt(2, month);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        revenueData.put("totalBookings", rs.getInt("TotalBookings"));
                        revenueData.put("totalRevenue", rs.getDouble("TotalRevenue"));
                        revenueData.put("averageAmount", rs.getDouble("AverageBookingAmount"));
                    }
                }
            }

            // Get daily revenue for the month
            String dailyQuery = "SELECT DAY(b.BookingDate) as Day, " +
                    "COUNT(b.BookingID) as Bookings, " +
                    "ISNULL(SUM(p.Amount), 0) as Revenue " +
                    "FROM Bookings b " +
                    "LEFT JOIN Payments p ON b.BookingID = p.BookingID AND p.Status = 'Thành công' " +
                    "WHERE YEAR(b.BookingDate) = ? AND MONTH(b.BookingDate) = ? " +
                    "AND b.Status NOT IN ('Đã hủy') " +
                    "GROUP BY DAY(b.BookingDate) " +
                    "ORDER BY DAY(b.BookingDate)";

            List<Map<String, Object>> dailyRevenue = new ArrayList<>();

            try (PreparedStatement ps = conn.prepareStatement(dailyQuery)) {
                ps.setInt(1, year);
                ps.setInt(2, month);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> day = new HashMap<>();
                        day.put("day", rs.getInt("Day"));
                        day.put("bookings", rs.getInt("Bookings"));
                        day.put("revenue", rs.getDouble("Revenue"));
                        dailyRevenue.add(day);
                    }
                }
            }

            request.setAttribute("month", month);
            request.setAttribute("year", year);
            request.setAttribute("revenueData", revenueData);
            request.setAttribute("dailyRevenue", dailyRevenue);

            request.getRequestDispatcher("/WEB-INF/report/revenue.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("Error showing revenue report: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải báo cáo doanh thu");
            response.sendRedirect(request.getContextPath() + "/report?view=dashboard");
        }
    }

    /**
     * Show room occupancy report
     */
    private void showOccupancyReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DBContext dbContext = new DBContext();

        try (Connection conn = dbContext.getConnection()) {
            String query = "SELECT " +
                    "rt.TypeName, " +
                    "COUNT(r.RoomID) as TotalRooms, " +
                    "SUM(CASE WHEN r.Status IN ('Đã đặt', 'Đang sử dụng') THEN 1 ELSE 0 END) as OccupiedRooms, " +
                    "SUM(CASE WHEN r.Status = 'Trống' THEN 1 ELSE 0 END) as AvailableRooms " +
                    "FROM Rooms r " +
                    "INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                    "WHERE r.IsActive = 1 " +
                    "GROUP BY rt.TypeName " +
                    "ORDER BY rt.TypeName";

            List<Map<String, Object>> occupancyData = new ArrayList<>();

            try (PreparedStatement ps = conn.prepareStatement(query);
                    ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Map<String, Object> roomType = new HashMap<>();
                    int totalRooms = rs.getInt("TotalRooms");
                    int occupiedRooms = rs.getInt("OccupiedRooms");
                    double occupancyRate = (totalRooms > 0) ? ((double) occupiedRooms / totalRooms) * 100 : 0;

                    roomType.put("typeName", rs.getString("TypeName"));
                    roomType.put("totalRooms", totalRooms);
                    roomType.put("occupiedRooms", occupiedRooms);
                    roomType.put("availableRooms", rs.getInt("AvailableRooms"));
                    roomType.put("occupancyRate", String.format("%.1f", occupancyRate));

                    occupancyData.add(roomType);
                }
            }

            request.setAttribute("occupancyData", occupancyData);
            request.getRequestDispatcher("/WEB-INF/report/occupancy.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("Error showing occupancy report: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải báo cáo công suất");
            response.sendRedirect(request.getContextPath() + "/report?view=dashboard");
        }
    }

    /**
     * Show room type performance report
     */
    private void showRoomTypePerformance(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DBContext dbContext = new DBContext();

        try (Connection conn = dbContext.getConnection()) {
            String query = "SELECT " +
                    "rt.TypeName, " +
                    "COUNT(DISTINCT b.BookingID) as TotalBookings, " +
                    "ISNULL(SUM(p.Amount), 0) as TotalRevenue, " +
                    "ISNULL(AVG(b.TotalAmount), 0) as AveragePrice " +
                    "FROM RoomTypes rt " +
                    "LEFT JOIN Rooms r ON rt.RoomTypeID = r.RoomTypeID " +
                    "LEFT JOIN Bookings b ON r.RoomID = b.RoomID AND b.Status NOT IN ('Đã hủy') " +
                    "LEFT JOIN Payments p ON b.BookingID = p.BookingID AND p.Status = 'Thành công' " +
                    "GROUP BY rt.TypeName " +
                    "ORDER BY TotalRevenue DESC";

            List<Map<String, Object>> performanceData = new ArrayList<>();

            try (PreparedStatement ps = conn.prepareStatement(query);
                    ResultSet rs = ps.executeQuery()) {

                int rank = 1;
                while (rs.next()) {
                    Map<String, Object> roomType = new HashMap<>();
                    roomType.put("rank", rank++);
                    roomType.put("typeName", rs.getString("TypeName"));
                    roomType.put("totalBookings", rs.getInt("TotalBookings"));
                    roomType.put("totalRevenue", rs.getDouble("TotalRevenue"));
                    roomType.put("averagePrice", rs.getDouble("AveragePrice"));

                    performanceData.add(roomType);
                }
            }

            request.setAttribute("performanceData", performanceData);
            request.getRequestDispatcher("/WEB-INF/report/room-type-performance.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("Error showing room type performance: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải báo cáo hiệu suất");
            response.sendRedirect(request.getContextPath() + "/report?view=dashboard");
        }
    }

    /**
     * Get available rooms using vw_AvailableRooms view
     */
    public List<Map<String, Object>> getAvailableRoomsFromView(Connection conn) throws SQLException {
        List<Map<String, Object>> rooms = new ArrayList<>();
        String sql = "SELECT * FROM vw_AvailableRooms ORDER BY RoomNumber";

        try (Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("roomId", rs.getInt("RoomID"));
                room.put("roomNumber", rs.getString("RoomNumber"));
                room.put("typeName", rs.getString("TypeName"));
                room.put("floor", rs.getInt("Floor"));
                room.put("basePrice", rs.getBigDecimal("BasePrice"));
                room.put("maxGuests", rs.getInt("MaxGuests"));
                rooms.add(room);
            }
        }
        return rooms;
    }

    /**
     * Get monthly revenue using vw_MonthlyRevenue view
     */
    public List<Map<String, Object>> getMonthlyRevenueFromView(Connection conn) throws SQLException {
        List<Map<String, Object>> revenue = new ArrayList<>();
        String sql = "SELECT * FROM vw_MonthlyRevenue ORDER BY RevenueMonth DESC";

        try (Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("month", rs.getString("RevenueMonth"));
                data.put("totalRevenue", rs.getBigDecimal("TotalRevenue"));
                data.put("bookingCount", rs.getInt("BookingCount"));
                data.put("averageBookingValue", rs.getBigDecimal("AverageBookingValue"));
                revenue.add(data);
            }
        }
        return revenue;
    }

    /**
     * Get room occupancy using vw_RoomOccupancy view
     */
    public List<Map<String, Object>> getRoomOccupancyFromView(Connection conn) throws SQLException {
        List<Map<String, Object>> occupancy = new ArrayList<>();
        String sql = "SELECT * FROM vw_RoomOccupancy ORDER BY OccupancyPercentage DESC";

        try (Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("roomNumber", rs.getString("RoomNumber"));
                data.put("typeName", rs.getString("TypeName"));
                data.put("totalDays", rs.getInt("TotalDays"));
                data.put("occupiedDays", rs.getInt("OccupiedDays"));
                data.put("occupancyPercentage", rs.getDouble("OccupancyPercentage"));
                occupancy.add(data);
            }
        }
        return occupancy;
    }

    /**
     * Get booking history detail using vw_BookingHistoryDetail view
     */
    public List<Map<String, Object>> getBookingHistoryFromView(Connection conn) throws SQLException {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "SELECT * FROM vw_BookingHistoryDetail ORDER BY BookingDate DESC";

        try (Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("bookingId", rs.getInt("BookingID"));
                data.put("customerName", rs.getString("CustomerName"));
                data.put("roomNumber", rs.getString("RoomNumber"));
                data.put("checkInDate", rs.getDate("CheckInDate"));
                data.put("checkOutDate", rs.getDate("CheckOutDate"));
                data.put("totalPrice", rs.getBigDecimal("TotalPrice"));
                data.put("status", rs.getString("Status"));
                history.add(data);
            }
        }
        return history;
    }

    /**
     * Get room images detail using vw_RoomImagesDetail view
     */
    public List<Map<String, Object>> getRoomImagesFromView(Connection conn) throws SQLException {
        List<Map<String, Object>> images = new ArrayList<>();
        String sql = "SELECT * FROM vw_RoomImagesDetail ORDER BY RoomNumber, IsPrimary DESC";

        try (Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("imageId", rs.getInt("ImageID"));
                data.put("roomNumber", rs.getString("RoomNumber"));
                data.put("imageUrl", rs.getString("ImageURL"));
                data.put("imageTitle", rs.getString("ImageTitle"));
                data.put("isPrimary", rs.getBoolean("IsPrimary"));
                data.put("uploadedDate", rs.getTimestamp("UploadedDate"));
                images.add(data);
            }
        }
        return images;
    }

    /**
     * Helper method to get count from query
     */
    private int getCount(Connection conn, String query) throws SQLException {
        try (Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Helper method to get decimal value from query
     */
    private double getDecimalValue(Connection conn, String query) throws SQLException {
        try (Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Report Servlet - Generates business reports and analytics";
    }
}
