package dao;

import db.DBContext;
import model.Booking;
import model.Customer;
import model.Room;
import model.RoomType;
import model.User;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Bookings table
 * Handles all database operations related to bookings
 * 
 * @author Aurora Hotel Team
 */
public class BookingDAO extends DBContext {

    private static final int RECORDS_PER_PAGE = 10;

    /**
     * Search available rooms by date range and room type
     *
     * @param checkInDate  Check-in date
     * @param checkOutDate Check-out date
     * @param roomTypeID   Room type ID (null for all types)
     * @return List of available Room objects
     */
    public List<Room> searchAvailableRooms(LocalDate checkInDate, LocalDate checkOutDate, Integer roomTypeID) {
        List<Room> availableRooms = new ArrayList<>();

        String sql = "SELECT r.RoomID, r.RoomNumber, r.RoomTypeID, r.Floor, r.Status, r.Description, r.IsActive, " +
                     "rt.TypeName, rt.Description AS RoomTypeDescription, rt.BasePrice, rt.MaxGuests, rt.Amenities, rt.IsActive AS RoomTypeIsActive " +
                     "FROM Rooms r " +
                     "INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                     "WHERE r.IsActive = 1 " +
                     "AND rt.IsActive = 1 " +
                     "AND r.Status = N'Trống' " +
                     "AND (? IS NULL OR r.RoomTypeID = ?) " +
                     "AND r.RoomID NOT IN (" +
                     "    SELECT RoomID FROM Bookings " +
                     "    WHERE Status NOT IN (N'Đã hủy', N'Đã checkout') " +
                     "    AND ((? BETWEEN CheckInDate AND CheckOutDate) " +
                     "         OR (? BETWEEN CheckInDate AND CheckOutDate) " +
                     "         OR (CheckInDate BETWEEN ? AND ?))" +
                     ") " +
                     "ORDER BY r.RoomNumber";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            // Set roomTypeID parameters (positions 1 and 2)
            if (roomTypeID != null) {
                ps.setInt(1, roomTypeID);
                ps.setInt(2, roomTypeID);
            } else {
                ps.setNull(1, Types.INTEGER);
                ps.setNull(2, Types.INTEGER);
            }

            // Set date parameters (positions 3, 4, 5, 6)
            ps.setDate(3, Date.valueOf(checkInDate));
            ps.setDate(4, Date.valueOf(checkOutDate));
            ps.setDate(5, Date.valueOf(checkInDate));
            ps.setDate(6, Date.valueOf(checkOutDate));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = extractRoomFromResultSet(rs);
                    availableRooms.add(room);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching available rooms: " + e.getMessage());
            e.printStackTrace();
        }

        return availableRooms;
    }

    /**
     * Create a new booking
     * 
     * @param booking Booking object with data
     * @return Booking ID if successful, -1 otherwise
     */
    public int createBooking(Booking booking) {
        String sql = "INSERT INTO Bookings (CustomerID, RoomID, UserID, CheckInDate, CheckOutDate, " +
                "NumberOfGuests, Status, TotalAmount, DepositAmount, Notes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getCustomerID());
            ps.setInt(2, booking.getRoomID());
            ps.setInt(3, booking.getUserID());
            ps.setDate(4, Date.valueOf(booking.getCheckInDate()));
            ps.setDate(5, Date.valueOf(booking.getCheckOutDate()));
            ps.setInt(6, booking.getNumberOfGuests());
            ps.setString(7, booking.getStatus() != null ? booking.getStatus() : "Chờ xác nhận");
            ps.setBigDecimal(8, booking.getTotalAmount());
            ps.setBigDecimal(9, booking.getDepositAmount());
            ps.setString(10, booking.getNotes());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating booking: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    /**
     * Get booking by ID with joined data
     * 
     * @param bookingID Booking ID
     * @return Booking object if found, null otherwise
     */
    public Booking getBookingById(int bookingID) {
        String sql = "SELECT b.*, " +
                "c.FullName, c.IDCard, c.Phone, c.Email, " +
                "r.RoomNumber, r.Floor, r.Status as RoomStatus, " +
                "rt.TypeName, rt.BasePrice, rt.MaxGuests, " +
                "u.Username, u.FullName as UserFullName " +
                "FROM Bookings b " +
                "INNER JOIN Customers c ON b.CustomerID = c.CustomerID " +
                "INNER JOIN Rooms r ON b.RoomID = r.RoomID " +
                "INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                "LEFT JOIN Users u ON b.UserID = u.UserID " +
                "WHERE b.BookingID = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, bookingID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractBookingFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get all bookings with pagination
     * 
     * @param page Page number (1-based)
     * @return List of Booking objects
     */
    public List<Booking> getAllBookings(int page) {
        List<Booking> bookings = new ArrayList<>();
        int offset = (page - 1) * RECORDS_PER_PAGE;

        String sql = "SELECT b.*, " +
                "c.FullName as CustomerName, c.Phone, " +
                "r.RoomNumber, rt.TypeName " +
                "FROM Bookings b " +
                "INNER JOIN Customers c ON b.CustomerID = c.CustomerID " +
                "INNER JOIN Rooms r ON b.RoomID = r.RoomID " +
                "INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                "ORDER BY b.BookingDate DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, RECORDS_PER_PAGE);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = extractBookingFromResultSet(rs);
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting all bookings: " + e.getMessage());
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Get bookings by user ID
     * 
     * @param userID User ID
     * @return List of Booking objects
     */
    public List<Booking> getBookingsByUser(int userID) {
        List<Booking> bookings = new ArrayList<>();

        String sql = "SELECT b.*, " +
                "c.FullName as CustomerName, c.Phone, " +
                "r.RoomNumber, rt.TypeName " +
                "FROM Bookings b " +
                "INNER JOIN Customers c ON b.CustomerID = c.CustomerID " +
                "INNER JOIN Rooms r ON b.RoomID = r.RoomID " +
                "INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                "WHERE b.UserID = ? " +
                "ORDER BY b.BookingDate DESC";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = extractBookingFromResultSet(rs);
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting bookings by user: " + e.getMessage());
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Get bookings by customer ID
     *
     * @param customerID Customer ID
     * @return List of Booking objects
     */
    public List<Booking> getBookingsByCustomer(int customerID) {
        List<Booking> bookings = new ArrayList<>();

        String sql = "SELECT b.*, " +
                "c.FullName as CustomerName, c.Phone, " +
                "r.RoomID, r.RoomNumber, r.RoomTypeID, r.Floor, r.Status as RoomStatus, " +
                "rt.TypeName, rt.BasePrice, rt.MaxGuests, " +
                "u.UserID, u.Username, u.FullName as UserFullName " +
                "FROM Bookings b " +
                "INNER JOIN Customers c ON b.CustomerID = c.CustomerID " +
                "LEFT JOIN Rooms r ON b.RoomID = r.RoomID " +
                "LEFT JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                "LEFT JOIN Users u ON b.UserID = u.UserID " +
                "WHERE b.CustomerID = ? " +
                "ORDER BY b.BookingDate DESC";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, customerID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = extractBookingFromResultSet(rs);
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting bookings by customer: " + e.getMessage());
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Get booking history using stored procedure sp_GetBookingHistory
     *
     * @param customerID Customer ID
     * @return List of Booking objects with history details
     */
    public List<Booking> getBookingHistory(int customerID) {
        List<Booking> bookings = new ArrayList<>();

        String sql = "{CALL sp_GetBookingHistory(?)}";

        try (CallableStatement cs = this.getConnection().prepareCall(sql)) {
            cs.setInt(1, customerID);

            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    Booking booking = extractBookingFromResultSet(rs);
                    bookings.add(booking);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking history: " + e.getMessage());
            e.printStackTrace();
        }

        return bookings;
    }

    /**
     * Update booking
     * 
     * @param booking Booking object with updated data
     * @return true if update successful, false otherwise
     */
    public boolean updateBooking(Booking booking) {
        String sql = "UPDATE Bookings SET CustomerID = ?, RoomID = ?, CheckInDate = ?, " +
                "CheckOutDate = ?, NumberOfGuests = ?, Status = ?, TotalAmount = ?, " +
                "DepositAmount = ?, Notes = ?, UpdatedDate = GETDATE() " +
                "WHERE BookingID = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, booking.getCustomerID());
            ps.setInt(2, booking.getRoomID());
            ps.setDate(3, Date.valueOf(booking.getCheckInDate()));
            ps.setDate(4, Date.valueOf(booking.getCheckOutDate()));
            ps.setInt(5, booking.getNumberOfGuests());
            ps.setString(6, booking.getStatus());
            ps.setBigDecimal(7, booking.getTotalAmount());
            ps.setBigDecimal(8, booking.getDepositAmount());
            ps.setString(9, booking.getNotes());
            ps.setInt(10, booking.getBookingID());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating booking: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update booking status
     * 
     * @param bookingID Booking ID
     * @param status    New status
     * @return true if update successful, false otherwise
     */
    public boolean updateBookingStatus(int bookingID, String status) {
        String sql = "UPDATE Bookings SET Status = ?, UpdatedDate = GETDATE() WHERE BookingID = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingID);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating booking status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cancel booking
     * Updates booking status to 'Đã hủy' and room status to 'Trống'
     * 
     * @param bookingID Booking ID
     * @return true if cancellation successful, false otherwise
     */
    public boolean cancelBooking(int bookingID) {
        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            conn = this.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Update booking status
            String sql1 = "UPDATE Bookings SET Status = N'Đã hủy', UpdatedDate = GETDATE() WHERE BookingID = ?";
            ps1 = conn.prepareStatement(sql1);
            ps1.setInt(1, bookingID);
            ps1.executeUpdate();

            // Update room status to available
            String sql2 = "UPDATE Rooms SET Status = N'Trống' " +
                    "WHERE RoomID = (SELECT RoomID FROM Bookings WHERE BookingID = ?)";
            ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, bookingID);
            ps2.executeUpdate();

            conn.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            System.err.println("Error canceling booking: " + e.getMessage());
            e.printStackTrace();

            try {
                if (conn != null) {
                    conn.rollback(); // Rollback transaction on error
                }
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }

            return false;

        } finally {
            try {
                if (ps1 != null)
                    ps1.close();
                if (ps2 != null)
                    ps2.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }

    /**
     * Check-in booking
     * Updates booking status to 'Đã checkin' and room status to 'Đang sử dụng'
     *
     * @param bookingID Booking ID
     * @return true if check-in successful, false otherwise
     */
    public boolean checkinBooking(int bookingID) {
        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            conn = this.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Update booking status
            String sql1 = "UPDATE Bookings SET Status = N'Đã checkin', UpdatedDate = GETDATE() WHERE BookingID = ?";
            ps1 = conn.prepareStatement(sql1);
            ps1.setInt(1, bookingID);
            ps1.executeUpdate();

            // Update room status to occupied
            String sql2 = "UPDATE Rooms SET Status = N'Đang sử dụng' " +
                    "WHERE RoomID = (SELECT RoomID FROM Bookings WHERE BookingID = ?)";
            ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, bookingID);
            ps2.executeUpdate();

            conn.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            System.err.println("Error checking in booking: " + e.getMessage());
            e.printStackTrace();

            try {
                if (conn != null) {
                    conn.rollback(); // Rollback transaction on error
                }
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }

            return false;

        } finally {
            try {
                if (ps1 != null)
                    ps1.close();
                if (ps2 != null)
                    ps2.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }

    /**
     * Check-out booking
     * Updates booking status to 'Đã checkout' and room status to 'Trống'
     *
     * @param bookingID Booking ID
     * @return true if check-out successful, false otherwise
     */
    public boolean checkoutBooking(int bookingID) {
        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            conn = this.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Update booking status
            String sql1 = "UPDATE Bookings SET Status = N'Đã checkout', UpdatedDate = GETDATE() WHERE BookingID = ?";
            ps1 = conn.prepareStatement(sql1);
            ps1.setInt(1, bookingID);
            ps1.executeUpdate();

            // Update room status to available
            String sql2 = "UPDATE Rooms SET Status = N'Trống' " +
                    "WHERE RoomID = (SELECT RoomID FROM Bookings WHERE BookingID = ?)";
            ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, bookingID);
            ps2.executeUpdate();

            conn.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            System.err.println("Error checking out booking: " + e.getMessage());
            e.printStackTrace();

            try {
                if (conn != null) {
                    conn.rollback(); // Rollback transaction on error
                }
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }

            return false;

        } finally {
            try {
                if (ps1 != null)
                    ps1.close();
                if (ps2 != null)
                    ps2.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }

    /**
     * Get total number of bookings
     *
     * @return Total count of bookings
     */
    public int getTotalRows() {
        String sql = "SELECT COUNT(*) FROM Bookings";

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
     * Check if room is available for booking in date range
     * 
     * @param roomID           Room ID
     * @param checkInDate      Check-in date
     * @param checkOutDate     Check-out date
     * @param excludeBookingID Booking ID to exclude (for updates)
     * @return true if room is available, false otherwise
     */
    public boolean isRoomAvailable(int roomID, LocalDate checkInDate, LocalDate checkOutDate,
            Integer excludeBookingID) {
        String sql = "SELECT COUNT(*) FROM Bookings " +
                "WHERE RoomID = ? " +
                "AND Status NOT IN ('Đã hủy', 'Đã checkout') " +
                "AND ((CheckInDate <= ? AND CheckOutDate > ?) OR " +
                "     (CheckInDate < ? AND CheckOutDate >= ?) OR " +
                "     (CheckInDate >= ? AND CheckOutDate <= ?)) ";

        if (excludeBookingID != null) {
            sql += "AND BookingID != ? ";
        }

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, roomID);
            ps.setDate(2, Date.valueOf(checkInDate));
            ps.setDate(3, Date.valueOf(checkInDate));
            ps.setDate(4, Date.valueOf(checkOutDate));
            ps.setDate(5, Date.valueOf(checkOutDate));
            ps.setDate(6, Date.valueOf(checkInDate));
            ps.setDate(7, Date.valueOf(checkOutDate));

            if (excludeBookingID != null) {
                ps.setInt(8, excludeBookingID);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking room availability: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Extract Booking object from ResultSet
     * 
     * @param rs ResultSet positioned at a booking record
     * @return Booking object
     * @throws SQLException if database access error occurs
     */
    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingID(rs.getInt("BookingID"));
        booking.setCustomerID(rs.getInt("CustomerID"));
        booking.setRoomID(rs.getInt("RoomID"));
        booking.setUserID(rs.getInt("UserID"));

        Timestamp bookingDateTS = rs.getTimestamp("BookingDate");
        if (bookingDateTS != null) {
            booking.setBookingDate(bookingDateTS.toLocalDateTime());
        }

        Date checkInDate = rs.getDate("CheckInDate");
        if (checkInDate != null) {
            booking.setCheckInDate(checkInDate.toLocalDate());
        }

        Date checkOutDate = rs.getDate("CheckOutDate");
        if (checkOutDate != null) {
            booking.setCheckOutDate(checkOutDate.toLocalDate());
        }

        booking.setNumberOfGuests(rs.getInt("NumberOfGuests"));
        booking.setStatus(rs.getString("Status"));
        booking.setTotalAmount(rs.getBigDecimal("TotalAmount"));
        booking.setDepositAmount(rs.getBigDecimal("DepositAmount"));
        booking.setNotes(rs.getString("Notes"));

        Timestamp createdDateTS = rs.getTimestamp("CreatedDate");
        if (createdDateTS != null) {
            booking.setCreatedDate(createdDateTS.toLocalDateTime());
        }

        Timestamp updatedDateTS = rs.getTimestamp("UpdatedDate");
        if (updatedDateTS != null) {
            booking.setUpdatedDate(updatedDateTS.toLocalDateTime());
        }

        // Extract joined data if available
        try {
            String customerName = rs.getString("CustomerName");
            if (customerName != null) {
                Customer customer = new Customer();
                customer.setCustomerID(rs.getInt("CustomerID"));
                customer.setFullName(customerName);
                customer.setPhone(rs.getString("Phone"));
                try {
                    customer.setEmail(rs.getString("Email"));
                    customer.setIdCard(rs.getString("IDCard"));
                } catch (SQLException e) {
                    // Columns not in result set, ignore
                }
                booking.setCustomer(customer);
            }
        } catch (SQLException e) {
            // Customer columns not in result set, ignore
        }

        try {
            String roomNumber = rs.getString("RoomNumber");
            if (roomNumber != null) {
                Room room = new Room();
                room.setRoomID(rs.getInt("RoomID"));
                room.setRoomNumber(roomNumber);
                try {
                    room.setFloor(rs.getInt("Floor"));
                    room.setStatus(rs.getString("RoomStatus"));
                } catch (SQLException e) {
                    // Columns not in result set, ignore
                }

                // Extract RoomType if available
                try {
                    String typeName = rs.getString("TypeName");
                    if (typeName != null) {
                        RoomType roomType = new RoomType();
                        roomType.setTypeName(typeName);
                        try {
                            roomType.setBasePrice(rs.getBigDecimal("BasePrice"));
                            roomType.setMaxGuests(rs.getInt("MaxGuests"));
                        } catch (SQLException e) {
                            // Columns not in result set, ignore
                        }
                        room.setRoomType(roomType);
                    }
                } catch (SQLException e) {
                    // RoomType columns not in result set, ignore
                }

                booking.setRoom(room);
            }
        } catch (SQLException e) {
            // Room columns not in result set, ignore
        }

        try {
            String username = rs.getString("Username");
            if (username != null) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setUsername(username);
                try {
                    user.setFullName(rs.getString("UserFullName"));
                } catch (SQLException e) {
                    // Column not in result set, ignore
                }
                booking.setUser(user);
            }
        } catch (SQLException e) {
            // User columns not in result set, ignore
        }

        return booking;
    }

    /**
     * Extract Room object from ResultSet (for search results)
     * 
     * @param rs ResultSet positioned at a room record
     * @return Room object
     * @throws SQLException if database access error occurs
     */
    private Room extractRoomFromResultSet(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomID(rs.getInt("RoomID"));
        room.setRoomNumber(rs.getString("RoomNumber"));
        room.setRoomTypeID(rs.getInt("RoomTypeID"));
        room.setFloor(rs.getInt("Floor"));
        room.setStatus(rs.getString("Status"));
        room.setDescription(rs.getString("Description"));
        room.setActive(rs.getBoolean("IsActive"));

        // Extract RoomType if joined
        try {
            String typeName = rs.getString("TypeName");
            if (typeName != null) {
                RoomType roomType = new RoomType();
                roomType.setRoomTypeID(rs.getInt("RoomTypeID"));
                roomType.setTypeName(typeName);
                roomType.setBasePrice(rs.getBigDecimal("BasePrice"));
                roomType.setMaxGuests(rs.getInt("MaxGuests"));
                room.setRoomType(roomType);
            }
        } catch (SQLException e) {
            // RoomType columns not in result set, ignore
        }

        return room;
    }
}
