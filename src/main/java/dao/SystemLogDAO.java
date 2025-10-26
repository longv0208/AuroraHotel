package dao;

import db.DBContext;
import model.SystemLog;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for SystemLogs table
 * Handles all database operations related to system logging
 */
public class SystemLogDAO extends DBContext {
    
    private static final int RECORDS_PER_PAGE = 20;
    
    /**
     * Create a new system log entry
     * 
     * @param log SystemLog object with data
     * @return true if creation successful, false otherwise
     */
    public boolean createLog(SystemLog log) {
        String sql = "INSERT INTO SystemLogs (UserID, Action, TableName, RecordID, OldValue, NewValue, IPAddress) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, log.getUserID());
            ps.setString(2, log.getAction());
            ps.setString(3, log.getTableName());
            ps.setInt(4, log.getRecordID());
            ps.setString(5, log.getOldValue());
            ps.setString(6, log.getNewValue());
            ps.setString(7, log.getIpAddress());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error creating system log: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get logs by user ID with pagination
     * 
     * @param userId User ID
     * @param page Page number (1-based)
     * @return List of SystemLog objects
     */
    public List<SystemLog> getLogsByUser(int userId, int page) {
        List<SystemLog> logs = new ArrayList<>();
        
        String sql = "SELECT LogID, UserID, Action, TableName, RecordID, OldValue, NewValue, IPAddress, LogDate " +
                     "FROM SystemLogs WHERE UserID = ? " +
                     "ORDER BY LogDate DESC " +
                     "OFFSET (? - 1) * ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, page);
            ps.setInt(3, RECORDS_PER_PAGE);
            ps.setInt(4, RECORDS_PER_PAGE);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SystemLog log = extractSystemLogFromResultSet(rs);
                    logs.add(log);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting logs by user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return logs;
    }
    
    /**
     * Get logs by table name with pagination
     * 
     * @param tableName Table name
     * @param page Page number (1-based)
     * @return List of SystemLog objects
     */
    public List<SystemLog> getLogsByTable(String tableName, int page) {
        List<SystemLog> logs = new ArrayList<>();
        
        String sql = "SELECT LogID, UserID, Action, TableName, RecordID, OldValue, NewValue, IPAddress, LogDate " +
                     "FROM SystemLogs WHERE TableName = ? " +
                     "ORDER BY LogDate DESC " +
                     "OFFSET (? - 1) * ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, tableName);
            ps.setInt(2, page);
            ps.setInt(3, RECORDS_PER_PAGE);
            ps.setInt(4, RECORDS_PER_PAGE);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SystemLog log = extractSystemLogFromResultSet(rs);
                    logs.add(log);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting logs by table: " + e.getMessage());
            e.printStackTrace();
        }
        
        return logs;
    }
    
    /**
     * Get logs by date range
     * 
     * @param fromDate Start date
     * @param toDate End date
     * @return List of SystemLog objects
     */
    public List<SystemLog> getLogsByDateRange(LocalDate fromDate, LocalDate toDate) {
        List<SystemLog> logs = new ArrayList<>();
        
        String sql = "SELECT LogID, UserID, Action, TableName, RecordID, OldValue, NewValue, IPAddress, LogDate " +
                     "FROM SystemLogs WHERE CAST(LogDate AS DATE) BETWEEN ? AND ? " +
                     "ORDER BY LogDate DESC";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(fromDate));
            ps.setDate(2, java.sql.Date.valueOf(toDate));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SystemLog log = extractSystemLogFromResultSet(rs);
                    logs.add(log);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting logs by date range: " + e.getMessage());
            e.printStackTrace();
        }
        
        return logs;
    }
    
    /**
     * Get all logs with pagination
     * 
     * @param page Page number (1-based)
     * @return List of SystemLog objects
     */
    public List<SystemLog> getAllLogs(int page) {
        List<SystemLog> logs = new ArrayList<>();
        
        String sql = "SELECT LogID, UserID, Action, TableName, RecordID, OldValue, NewValue, IPAddress, LogDate " +
                     "FROM SystemLogs " +
                     "ORDER BY LogDate DESC " +
                     "OFFSET (? - 1) * ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, page);
            ps.setInt(2, RECORDS_PER_PAGE);
            ps.setInt(3, RECORDS_PER_PAGE);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SystemLog log = extractSystemLogFromResultSet(rs);
                    logs.add(log);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting all logs: " + e.getMessage());
            e.printStackTrace();
        }
        
        return logs;
    }
    
    /**
     * Get total log count
     * 
     * @return Total number of logs
     */
    public int getTotalLogs() {
        String sql = "SELECT COUNT(*) as TotalLogs FROM SystemLogs";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("TotalLogs");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total logs: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Extract SystemLog from ResultSet
     */
    private SystemLog extractSystemLogFromResultSet(ResultSet rs) throws SQLException {
        SystemLog log = new SystemLog();
        log.setLogID(rs.getInt("LogID"));
        log.setUserID(rs.getInt("UserID"));
        log.setAction(rs.getString("Action"));
        log.setTableName(rs.getString("TableName"));
        log.setRecordID(rs.getInt("RecordID"));
        log.setOldValue(rs.getString("OldValue"));
        log.setNewValue(rs.getString("NewValue"));
        log.setIpAddress(rs.getString("IPAddress"));
        
        Timestamp logDate = rs.getTimestamp("LogDate");
        if (logDate != null) {
            log.setLogDate(logDate.toLocalDateTime());
        }
        
        return log;
    }
}

