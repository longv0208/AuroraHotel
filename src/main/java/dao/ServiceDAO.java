package dao;

import db.DBContext;
import model.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Services table
 * Handles all database operations related to hotel services
 * 
 * @author Aurora Hotel Team
 */
public class ServiceDAO extends DBContext {
    
    private static final int RECORDS_PER_PAGE = 10;
    
    /**
     * Create a new service
     * 
     * @param service Service object with data
     * @return Service ID if successful, -1 otherwise
     */
    public int createService(Service service) {
        String sql = "INSERT INTO Services (ServiceName, Description, Price, Unit, Category, IsActive) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setBigDecimal(3, service.getPrice());
            ps.setString(4, service.getUnit());
            ps.setString(5, service.getCategory());
            ps.setBoolean(6, service.isActive());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating service: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Get service by ID
     * 
     * @param serviceID Service ID
     * @return Service object if found, null otherwise
     */
    public Service getServiceById(int serviceID) {
        String sql = "SELECT * FROM Services WHERE ServiceID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, serviceID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractServiceFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting service by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all active services (without pagination)
     * 
     * @return List of all active Service objects
     */
    public List<Service> getAllActiveServices() {
        List<Service> services = new ArrayList<>();
        
        String sql = "SELECT * FROM Services WHERE IsActive = 1 ORDER BY Category, ServiceName";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Service service = extractServiceFromResultSet(rs);
                services.add(service);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all active services: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }
    
    /**
     * Get all services with pagination
     * 
     * @param page Page number (1-based)
     * @return List of Service objects
     */
    public List<Service> getAllServices(int page) {
        List<Service> services = new ArrayList<>();
        int offset = (page - 1) * RECORDS_PER_PAGE;
        
        String sql = "SELECT * FROM Services " +
                     "ORDER BY Category, ServiceName " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, RECORDS_PER_PAGE);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service service = extractServiceFromResultSet(rs);
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting all services: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }
    
    /**
     * Get services by category
     * 
     * @param category Service category
     * @return List of Service objects
     */
    public List<Service> getServicesByCategory(String category) {
        List<Service> services = new ArrayList<>();
        
        String sql = "SELECT * FROM Services WHERE Category = ? AND IsActive = 1 ORDER BY ServiceName";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, category);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service service = extractServiceFromResultSet(rs);
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting services by category: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }
    
    /**
     * Update a service
     * 
     * @param service Service object with updated data
     * @return true if update successful, false otherwise
     */
    public boolean updateService(Service service) {
        String sql = "UPDATE Services SET ServiceName = ?, Description = ?, Price = ?, " +
                     "Unit = ?, Category = ?, IsActive = ? " +
                     "WHERE ServiceID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setBigDecimal(3, service.getPrice());
            ps.setString(4, service.getUnit());
            ps.setString(5, service.getCategory());
            ps.setBoolean(6, service.isActive());
            ps.setInt(7, service.getServiceID());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating service: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a service (soft delete - set IsActive to 0)
     * 
     * @param serviceID Service ID to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteService(int serviceID) {
        String sql = "UPDATE Services SET IsActive = 0 WHERE ServiceID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, serviceID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting service: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get total number of services
     * 
     * @return Total count of services
     */
    public int getTotalRows() {
        String sql = "SELECT COUNT(*) FROM Services";
        
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
     * Extract Service object from ResultSet
     * 
     * @param rs ResultSet positioned at a service record
     * @return Service object
     * @throws SQLException if database access error occurs
     */
    private Service extractServiceFromResultSet(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setServiceID(rs.getInt("ServiceID"));
        service.setServiceName(rs.getString("ServiceName"));
        service.setDescription(rs.getString("Description"));
        service.setPrice(rs.getBigDecimal("Price"));
        service.setUnit(rs.getString("Unit"));
        service.setCategory(rs.getString("Category"));
        service.setActive(rs.getBoolean("IsActive"));
        
        return service;
    }
}

