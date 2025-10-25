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
        
        String sql = "SELECT c.*, COUNT(b.BookingID) as TotalBookings " +
                     "FROM Customers c " +
                     "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                     "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                     "         c.Address, c.DateOfBirth, c.Nationality, c.CreatedDate, c.Notes " +
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
     * Get all customers (without pagination)
     * 
     * @return List of all Customer objects
     */
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        
        String sql = "SELECT c.*, COUNT(b.BookingID) as TotalBookings " +
                     "FROM Customers c " +
                     "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                     "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                     "         c.Address, c.DateOfBirth, c.Nationality, c.CreatedDate, c.Notes " +
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
        String sql = "SELECT c.*, COUNT(b.BookingID) as TotalBookings " +
                     "FROM Customers c " +
                     "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                     "WHERE c.CustomerID = ? " +
                     "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                     "         c.Address, c.DateOfBirth, c.Nationality, c.CreatedDate, c.Notes";
        
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
        String sql = "SELECT c.*, COUNT(b.BookingID) as TotalBookings " +
                     "FROM Customers c " +
                     "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                     "WHERE c.Phone = ? " +
                     "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                     "         c.Address, c.DateOfBirth, c.Nationality, c.CreatedDate, c.Notes";
        
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
        String sql = "SELECT c.*, COUNT(b.BookingID) as TotalBookings " +
                     "FROM Customers c " +
                     "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                     "WHERE c.IDCard = ? " +
                     "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                     "         c.Address, c.DateOfBirth, c.Nationality, c.CreatedDate, c.Notes";
        
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
        
        String sql = "SELECT c.*, COUNT(b.BookingID) as TotalBookings " +
                     "FROM Customers c " +
                     "LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID " +
                     "WHERE c.FullName LIKE ? OR c.Phone LIKE ? OR c.IDCard LIKE ? " +
                     "GROUP BY c.CustomerID, c.FullName, c.IDCard, c.Phone, c.Email, " +
                     "         c.Address, c.DateOfBirth, c.Nationality, c.CreatedDate, c.Notes " +
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
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating customer: " + e.getMessage());
            e.printStackTrace();
        }
        
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
                     "Address = ?, DateOfBirth = ?, Nationality = ?, Notes = ? " +
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
            ps.setString(8, customer.getNotes());
            ps.setInt(9, customer.getCustomerID());
            
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

