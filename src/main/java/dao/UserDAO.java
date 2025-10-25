package dao;

import db.DBContext;
import model.User;
import util.MD5Util;

import java.sql.*;
import java.time.LocalDateTime;

/**
 * Data Access Object for Users table
 * Handles all database operations related to users
 */
public class UserDAO extends DBContext {
    
    /**
     * Get user by username
     * 
     * @param username Username to search for
     * @return User object if found, null otherwise
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT UserID, Username, PasswordHash, FullName, Email, Phone, " +
                     "Role, IsActive, CreatedDate, LastLogin " +
                     "FROM Users WHERE Username = ? AND IsActive = 1";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, username);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by username: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get user by ID
     * 
     * @param userID User ID to search for
     * @return User object if found, null otherwise
     */
    public User getUserById(int userID) {
        String sql = "SELECT UserID, Username, PasswordHash, FullName, Email, Phone, " +
                     "Role, IsActive, CreatedDate, LastLogin " +
                     "FROM Users WHERE UserID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, userID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Validate user login credentials
     * 
     * @param username Username
     * @param password Plain text password (will be hashed with MD5)
     * @return User object if credentials are valid, null otherwise
     * 
     * ⚠️ WARNING: Uses MD5 for password hashing which is NOT secure!
     */
    public User validateLogin(String username, String password) {
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            return null;
        }
        
        User user = getUserByUsername(username);
        
        if (user != null) {
            // Verify password using MD5
            if (MD5Util.verifyPassword(password, user.getPasswordHash())) {
                return user;
            }
        }
        
        return null;
    }
    
    /**
     * Update last login timestamp for a user
     * 
     * @param userID User ID to update
     * @return true if update successful, false otherwise
     */
    public boolean updateLastLogin(int userID) {
        String sql = "UPDATE Users SET LastLogin = GETDATE() WHERE UserID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, userID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating last login: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Create a new user
     * 
     * @param user User object with data (password should already be hashed)
     * @return true if creation successful, false otherwise
     */
    public boolean createUser(User user) {
        String sql = "INSERT INTO Users (Username, PasswordHash, FullName, Email, Phone, Role, IsActive) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getRole());
            ps.setBoolean(7, user.isActive());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error creating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update user information
     * 
     * @param user User object with updated data
     * @return true if update successful, false otherwise
     */
    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ?, Role = ?, IsActive = ? " +
                     "WHERE UserID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getRole());
            ps.setBoolean(5, user.isActive());
            ps.setInt(6, user.getUserID());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Change user password
     * 
     * @param userID User ID
     * @param newPasswordHash New password hash (should be MD5 hashed)
     * @return true if update successful, false otherwise
     */
    public boolean changePassword(int userID, String newPasswordHash) {
        String sql = "UPDATE Users SET PasswordHash = ? WHERE UserID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userID);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error changing password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Extract User object from ResultSet
     * 
     * @param rs ResultSet positioned at a user record
     * @return User object
     * @throws SQLException if database access error occurs
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserID(rs.getInt("UserID"));
        user.setUsername(rs.getString("Username"));
        user.setPasswordHash(rs.getString("PasswordHash"));
        user.setFullName(rs.getString("FullName"));
        user.setEmail(rs.getString("Email"));
        user.setPhone(rs.getString("Phone"));
        user.setRole(rs.getString("Role"));
        user.setActive(rs.getBoolean("IsActive"));
        
        Timestamp createdTimestamp = rs.getTimestamp("CreatedDate");
        if (createdTimestamp != null) {
            user.setCreatedDate(createdTimestamp.toLocalDateTime());
        }
        
        Timestamp lastLoginTimestamp = rs.getTimestamp("LastLogin");
        if (lastLoginTimestamp != null) {
            user.setLastLogin(lastLoginTimestamp.toLocalDateTime());
        }
        
        return user;
    }
}

