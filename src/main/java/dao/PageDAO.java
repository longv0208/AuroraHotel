package dao;

import db.DBContext;
import model.Page;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Pages table
 * Handles all database operations related to page management
 */
public class PageDAO extends DBContext {
    
    /**
     * Create a new page
     * 
     * @param page Page object with data
     * @return true if creation successful, false otherwise
     */
    public boolean create(Page page) {
        String sql = "INSERT INTO Pages (PageName, PageURL, Title, Content, MetaDescription, IsActive, DisplayOrder) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, page.getPageName());
            ps.setString(2, page.getPageURL());
            ps.setString(3, page.getTitle());
            ps.setString(4, page.getContent());
            ps.setString(5, page.getMetaDescription());
            ps.setBoolean(6, page.isActive());
            ps.setInt(7, page.getDisplayOrder());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error creating page: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get page by ID
     * 
     * @param pageId Page ID
     * @return Page object if found, null otherwise
     */
    public Page getById(int pageId) {
        String sql = "SELECT PageID, PageName, PageURL, Title, Content, MetaDescription, IsActive, DisplayOrder, CreatedDate, UpdatedDate " +
                     "FROM Pages WHERE PageID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, pageId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractPageFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting page by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get page by URL
     * 
     * @param pageURL Page URL
     * @return Page object if found, null otherwise
     */
    public Page getByURL(String pageURL) {
        String sql = "SELECT PageID, PageName, PageURL, Title, Content, MetaDescription, IsActive, DisplayOrder, CreatedDate, UpdatedDate " +
                     "FROM Pages WHERE PageURL = ? AND IsActive = 1";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, pageURL);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractPageFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting page by URL: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all active pages
     * 
     * @return List of active Page objects
     */
    public List<Page> getActivePages() {
        List<Page> pages = new ArrayList<>();
        
        String sql = "SELECT PageID, PageName, PageURL, Title, Content, MetaDescription, IsActive, DisplayOrder, CreatedDate, UpdatedDate " +
                     "FROM Pages WHERE IsActive = 1 ORDER BY DisplayOrder, PageName";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Page page = extractPageFromResultSet(rs);
                pages.add(page);
            }
        } catch (SQLException e) {
            System.err.println("Error getting active pages: " + e.getMessage());
            e.printStackTrace();
        }
        
        return pages;
    }
    
    /**
     * Get all pages
     * 
     * @return List of all Page objects
     */
    public List<Page> getAll() {
        List<Page> pages = new ArrayList<>();
        
        String sql = "SELECT PageID, PageName, PageURL, Title, Content, MetaDescription, IsActive, DisplayOrder, CreatedDate, UpdatedDate " +
                     "FROM Pages ORDER BY DisplayOrder, PageName";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Page page = extractPageFromResultSet(rs);
                pages.add(page);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all pages: " + e.getMessage());
            e.printStackTrace();
        }
        
        return pages;
    }
    
    /**
     * Update page
     * 
     * @param page Page object with updated data
     * @return true if update successful, false otherwise
     */
    public boolean update(Page page) {
        String sql = "UPDATE Pages SET PageName = ?, PageURL = ?, Title = ?, Content = ?, MetaDescription = ?, IsActive = ?, DisplayOrder = ?, UpdatedDate = GETDATE() " +
                     "WHERE PageID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, page.getPageName());
            ps.setString(2, page.getPageURL());
            ps.setString(3, page.getTitle());
            ps.setString(4, page.getContent());
            ps.setString(5, page.getMetaDescription());
            ps.setBoolean(6, page.isActive());
            ps.setInt(7, page.getDisplayOrder());
            ps.setInt(8, page.getPageID());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating page: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete page (soft delete)
     * 
     * @param pageId Page ID
     * @return true if deletion successful, false otherwise
     */
    public boolean delete(int pageId) {
        String sql = "UPDATE Pages SET IsActive = 0 WHERE PageID = ?";
        
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, pageId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting page: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Extract Page from ResultSet
     */
    private Page extractPageFromResultSet(ResultSet rs) throws SQLException {
        Page page = new Page();
        page.setPageID(rs.getInt("PageID"));
        page.setPageName(rs.getString("PageName"));
        page.setPageURL(rs.getString("PageURL"));
        page.setTitle(rs.getString("Title"));
        page.setContent(rs.getString("Content"));
        page.setMetaDescription(rs.getString("MetaDescription"));
        page.setActive(rs.getBoolean("IsActive"));
        page.setDisplayOrder(rs.getInt("DisplayOrder"));
        
        Timestamp createdDate = rs.getTimestamp("CreatedDate");
        if (createdDate != null) {
            page.setCreatedDate(createdDate.toLocalDateTime());
        }
        
        Timestamp updatedDate = rs.getTimestamp("UpdatedDate");
        if (updatedDate != null) {
            page.setUpdatedDate(updatedDate.toLocalDateTime());
        }
        
        return page;
    }
}

