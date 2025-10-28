package dao;

import db.DBContext;
import model.Customer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Customers table
 * Handles all database operations related to customers
 * 
 * @author Aurora Hotel Team
 */
public class CustomerDAO extends DBContext {

    private static final int RECORDS_PER_PAGE = 10;

    /**
     * Get paginated list of customers with booking count
     * 
     * @param page Page number (1-based)
     * @return List of Customer objects
     */
    public List<Customer> getCustomerList(int page) {
        List<Customer> customers = new ArrayList<>();
        int offset = (page - 1) * RECORDS_PER_PAGE;

        String sql = "SELECT c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "       c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes, " +
                "       COUNT(b.BookingID) as TotalBookings " +
                "FROM Customers c " +
                "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "         c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes " +
                "ORDER BY c.CreatedDate DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, RECORDS_PER_PAGE);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customer customer = extractCustomerFromResultSet(rs);
                    customers.add(customer);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting customer list: " + e.getMessage());
            e.printStackTrace();
        }

        return customers;
    }

    /**
     * Get paginated, filtered and sortable list of customers.
     *
     * @param page Page number (1-based)
     * @param search Search term for name/phone/email/idCard (nullable)
     * @param nationality Exact nationality filter (nullable or empty for all)
     * @param sortBy One of: fullName, createdDate, totalBookings
     * @return List of Customer objects
     */
    public List<Customer> getCustomerListFiltered(int page, String search, String nationality, String sortBy) {
        List<Customer> customers = new ArrayList<>();
        int offset = (page - 1) * RECORDS_PER_PAGE;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, ")
           .append("       c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes, ")
           .append("       COUNT(b.BookingID) as TotalBookings ")
           .append("FROM Customers c ")
           .append("LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID ");

        List<String> conditions = new ArrayList<>();
        boolean hasSearch = search != null && !search.trim().isEmpty();
        boolean hasNationality = nationality != null && !nationality.trim().isEmpty();

        if (hasSearch) {
            conditions.add("(c.FullName LIKE ? OR c.Phone LIKE ? OR c.Email LIKE ? OR c.IDCard LIKE ?)");
        }
        if (hasNationality) {
            conditions.add("c.Nationality = ?");
        }

        if (!conditions.isEmpty()) {
            sql.append("WHERE ").append(String.join(" AND ", conditions)).append(' ');
        }

        sql.append("GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, ")
           .append("         c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes ");

        sql.append(buildOrderByClause(sortBy)).append(' ')
           .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql.toString())) {
            if (hasSearch) {
                String pattern = "%" + search.trim() + "%";
                // FullName, Phone, Email, IDCard
                ps.setString(1, pattern);
                ps.setString(2, pattern);
                ps.setString(3, pattern);
                ps.setString(4, pattern);
            }
            int nextIndex = hasSearch ? 5 : 1;
            if (hasNationality) {
                ps.setString(nextIndex, nationality.trim());
                nextIndex++;
            }
            ps.setInt(nextIndex, offset);
            ps.setInt(nextIndex + 1, RECORDS_PER_PAGE);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(extractCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting filtered customer list: " + e.getMessage());
            e.printStackTrace();
        }

        return customers;
    }

    /**
     * Get total number of customers for current filters.
     */
    public int getTotalRowsFiltered(String search, String nationality) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT c.CustomerID) ")
           .append("FROM Customers c ")
           .append("LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID ");

        List<String> conditions = new ArrayList<>();
        boolean hasSearch = search != null && !search.trim().isEmpty();
        boolean hasNationality = nationality != null && !nationality.trim().isEmpty();

        if (hasSearch) {
            conditions.add("(c.FullName LIKE ? OR c.Phone LIKE ? OR c.Email LIKE ? OR c.IDCard LIKE ?)");
        }
        if (hasNationality) {
            conditions.add("c.Nationality = ?");
        }
        if (!conditions.isEmpty()) {
            sql.append("WHERE ").append(String.join(" AND ", conditions));
        }

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql.toString())) {
            if (hasSearch) {
                String pattern = "%" + search.trim() + "%";
                ps.setString(1, pattern);
                ps.setString(2, pattern);
                ps.setString(3, pattern);
                ps.setString(4, pattern);
            }
            int nextIndex = hasSearch ? 5 : 1;
            if (hasNationality) {
                ps.setString(nextIndex, nationality.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting filtered total rows: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    private String buildOrderByClause(String sortBy) {
        if ("fullName".equalsIgnoreCase(sortBy)) {
            return "ORDER BY c.FullName ASC";
        }
        if ("totalBookings".equalsIgnoreCase(sortBy)) {
            return "ORDER BY TotalBookings DESC, c.FullName ASC";
        }
        // Default to createdDate
        return "ORDER BY c.CreatedDate DESC";
    }

    /**
     * Get all customers (without pagination)
     * 
     * @return List of all Customer objects
     */
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();

        String sql = "SELECT c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "       c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes, " +
                "       COUNT(b.BookingID) as TotalBookings " +
                "FROM Customers c " +
                "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "         c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes " +
                "ORDER BY c.FullName";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Customer customer = extractCustomerFromResultSet(rs);
                customers.add(customer);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all customers: " + e.getMessage());
            e.printStackTrace();
        }

        return customers;
    }

    /**
     * Get customer by ID
     * 
     * @param customerID Customer ID
     * @return Customer object if found, null otherwise
     */
    public Customer getCustomerById(int customerID) {
        String sql = "SELECT c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "       c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes, " +
                "       COUNT(b.BookingID) as TotalBookings " +
                "FROM Customers c " +
                "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                "WHERE c.CustomerID = ? " +
                "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "         c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, customerID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCustomerFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting customer by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get customer by phone number
     * 
     * @param phone Phone number
     * @return Customer object if found, null otherwise
     */
    public Customer getCustomerByPhone(String phone) {
        String sql = "SELECT c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "       c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes, " +
                "       COUNT(b.BookingID) as TotalBookings " +
                "FROM Customers c " +
                "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                "WHERE c.Phone = ? " +
                "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "         c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, phone);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCustomerFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting customer by phone: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get customer by ID card number
     * 
     * @param idCard ID card number (CMND/CCCD)
     * @return Customer object if found, null otherwise
     */
    public Customer getCustomerByIdCard(String idCard) {
        String sql = "SELECT c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "       c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes, " +
                "       COUNT(b.BookingID) as TotalBookings " +
                "FROM Customers c " +
                "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                "WHERE c.IDCard = ? " +
                "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "         c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, idCard);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCustomerFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting customer by ID card: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Search customers by name, phone, or ID card
     * 
     * @param searchTerm Search term
     * @return List of matching Customer objects
     */
    public List<Customer> searchCustomers(String searchTerm) {
        List<Customer> customers = new ArrayList<>();

        String sql = "SELECT c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "       c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes, " +
                "       COUNT(b.BookingID) as TotalBookings " +
                "FROM Customers c " +
                "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                "WHERE c.FullName LIKE ? OR c.Phone LIKE ? OR c.IDCard LIKE ? " +
                "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "         c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes " +
                "ORDER BY c.FullName";

        String searchPattern = "%" + searchTerm + "%";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customer customer = extractCustomerFromResultSet(rs);
                    customers.add(customer);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching customers: " + e.getMessage());
            e.printStackTrace();
        }

        return customers;
    }

    /**
     * Create a new customer
     *
     * @param customer Customer object with data
     * @return Customer ID if successful, -1 otherwise
     */
    public int createCustomer(Customer customer) {
        // Try with UserID first (for databases that have the column)
        String sqlWithUserID = "INSERT INTO Customers (FullName, IDCard, Phone, Email, Address, " +
                "DateOfBirth, Nationality, UserID, Notes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sqlWithUserID, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getIdCard());
            ps.setString(3, customer.getPhone());
            ps.setString(4, customer.getEmail());
            ps.setString(5, customer.getAddress());

            if (customer.getDateOfBirth() != null) {
                ps.setDate(6, Date.valueOf(customer.getDateOfBirth()));
            } else {
                ps.setNull(6, Types.DATE);
            }

            ps.setString(7, customer.getNationality());

            // Set UserID (can be 0 for guest customers)
            if (customer.getUserID() > 0) {
                ps.setInt(8, customer.getUserID());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            ps.setString(9, customer.getNotes());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            // If UserID column doesn't exist, try without it
            String errorMsg = e.getMessage();
            System.err.println("DEBUG: SQLException caught in createCustomer: " + errorMsg);
            
            // Check for UserID column error (case insensitive)
            boolean isUserIDError = errorMsg != null && 
                (errorMsg.toLowerCase().contains("userid") || 
                 errorMsg.toLowerCase().contains("invalid column"));
            
            System.err.println("DEBUG: isUserIDError = " + isUserIDError);
            
            if (isUserIDError) {
                System.out.println("UserID column not found, attempting insert without UserID...");
                return createCustomerWithoutUserID(customer);
            } else {
                System.err.println("Error creating customer: " + e.getMessage());
            }
        }

        return -1;
    }

    /**
     * Create customer without UserID column (fallback for older database schema)
     *
     * @param customer Customer object with data
     * @return Customer ID if successful, -1 otherwise
     */
    private int createCustomerWithoutUserID(Customer customer) {
        System.out.println("Attempting to create customer without UserID...");
        String sql = "INSERT INTO Customers (FullName, IDCard, Phone, Email, Address, " +
                "DateOfBirth, Nationality, Notes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getIdCard());
            ps.setString(3, customer.getPhone());
            ps.setString(4, customer.getEmail());
            ps.setString(5, customer.getAddress());

            if (customer.getDateOfBirth() != null) {
                ps.setDate(6, Date.valueOf(customer.getDateOfBirth()));
            } else {
                ps.setNull(6, Types.DATE);
            }

            ps.setString(7, customer.getNationality());
            ps.setString(8, customer.getNotes());

            System.out.println("Executing INSERT without UserID...");
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int customerID = rs.getInt(1);
                        System.out.println("Customer created successfully with ID: " + customerID);
                        return customerID;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating customer (without UserID): " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("Failed to create customer without UserID, returning -1");
        return -1;
    }

    /**
     * Update an existing customer
     *
     * @param customer Customer object with updated data
     * @return true if update successful, false otherwise
     */
    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE Customers SET FullName = ?, IDCard = ?, Phone = ?, Email = ?, " +
                "Address = ?, DateOfBirth = ?, Nationality = ?, UserID = ?, Notes = ? " +
                "WHERE CustomerID = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getIdCard());
            ps.setString(3, customer.getPhone());
            ps.setString(4, customer.getEmail());
            ps.setString(5, customer.getAddress());

            if (customer.getDateOfBirth() != null) {
                ps.setDate(6, Date.valueOf(customer.getDateOfBirth()));
            } else {
                ps.setNull(6, Types.DATE);
            }

            ps.setString(7, customer.getNationality());

            // Update UserID
            if (customer.getUserID() > 0) {
                ps.setInt(8, customer.getUserID());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            ps.setString(9, customer.getNotes());
            ps.setInt(10, customer.getCustomerID());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a customer (if no bookings)
     * 
     * @param customerID Customer ID to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteCustomer(int customerID) {
        // Check if customer has any bookings
        String checkSQL = "SELECT COUNT(*) FROM Bookings WHERE CustomerID = ?";

        try (PreparedStatement checkPS = this.getConnection().prepareStatement(checkSQL)) {
            checkPS.setInt(1, customerID);

            try (ResultSet rs = checkPS.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    System.err.println("Cannot delete customer with existing bookings");
                    return false;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking customer bookings: " + e.getMessage());
            e.printStackTrace();
            return false;
        }

        // Delete customer
        String sql = "DELETE FROM Customers WHERE CustomerID = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, customerID);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get total number of customers
     * 
     * @return Total count of customers
     */
    public int getTotalRows() {
        String sql = "SELECT COUNT(*) FROM Customers";

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
     * Get customer by User ID (linked account)
     *
     * @param userID User ID
     * @return Customer object if found, null otherwise
     */
    public Customer getCustomerByUserID(int userID) {
        // Try with UserID column first
        String sql = "SELECT c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "       c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes, " +
                "       COUNT(b.BookingID) as TotalBookings " +
                "FROM Customers c " +
                "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                "WHERE c.UserID = ? " +
                "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                "         c.Address, c.DateOfBirth, c.Nationality, c.UserID, c.CreatedDate, c.Notes";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCustomerFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            // If UserID column doesn't exist, return null (no linked customers)
            if (e.getMessage() != null && e.getMessage().contains("UserID")) {
                System.out.println("UserID column not found, returning null for getCustomerByUserID");
                return null;
            }
            System.err.println("Error getting customer by UserID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Create customer from User account info
     * Automatically links the customer to the user
     *
     * @param user User object
     * @return Customer ID if successful, -1 otherwise
     */
    public int createCustomerFromUser(model.User user) {
        Customer customer = new Customer();
        customer.setFullName(user.getFullName());
        customer.setPhone(user.getPhone());
        customer.setEmail(user.getEmail());
        customer.setUserID(user.getUserID());

        return createCustomer(customer);
    }

    /**
     * Link existing customer to a user account
     *
     * @param customerID Customer ID
     * @param userID User ID
     * @return true if link successful, false otherwise
     */
    public boolean linkCustomerToUser(int customerID, int userID) {
        String sql = "UPDATE Customers SET UserID = ? WHERE CustomerID = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, customerID);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            // If UserID column doesn't exist, return false (can't link)
            if (e.getMessage() != null && e.getMessage().contains("UserID")) {
                System.out.println("UserID column not found, cannot link customer to user");
                return false;
            }
            System.err.println("Error linking customer to user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if a user already has a linked customer
     *
     * @param userID User ID
     * @return true if user has linked customer, false otherwise
     */
    public boolean hasLinkedCustomer(int userID) {
        String sql = "SELECT COUNT(*) FROM Customers WHERE UserID = ?";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            // If UserID column doesn't exist, return false (no linked customers possible)
            if (e.getMessage() != null && e.getMessage().contains("UserID")) {
                System.out.println("UserID column not found, returning false for hasLinkedCustomer");
                return false;
            }
            System.err.println("Error checking linked customer: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Extract Customer object from ResultSet
     *
     * @param rs ResultSet positioned at a customer record
     * @return Customer object
     * @throws SQLException if database access error occurs
     */
    private Customer extractCustomerFromResultSet(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerID(rs.getInt("CustomerID"));
        customer.setFullName(rs.getString("FullName"));
        customer.setIdCard(rs.getString("IDCard"));
        customer.setPhone(rs.getString("Phone"));
        customer.setEmail(rs.getString("Email"));
        customer.setAddress(rs.getString("Address"));

        Date dateOfBirth = rs.getDate("DateOfBirth");
        if (dateOfBirth != null) {
            customer.setDateOfBirth(dateOfBirth.toLocalDate());
        }

        customer.setNationality(rs.getString("Nationality"));

        // Get UserID (if column exists)
        try {
            int userID = rs.getInt("UserID");
            if (!rs.wasNull()) {
                customer.setUserID(userID);
            }
        } catch (SQLException e) {
            // UserID column doesn't exist, skip it
            // This is fine for older database schemas
        }

        Timestamp createdDate = rs.getTimestamp("CreatedDate");
        if (createdDate != null) {
            customer.setCreatedDate(createdDate.toLocalDateTime());
        }

        customer.setNotes(rs.getString("Notes"));

        // Get total bookings if available
        try {
            customer.setTotalBookings(rs.getInt("TotalBookings"));
        } catch (SQLException e) {
            // TotalBookings column not in result set, ignore
        }

        return customer;
    }
}
