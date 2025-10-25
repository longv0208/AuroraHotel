package model;

import java.time.LocalDateTime;

/**
 * Entity class for Pages table
 * Represents CMS pages
 */
public class Page {
    private int pageID;
    private String pageName;
    private String pageURL;
    private String title;
    private String content;
    private String metaDescription;
    private boolean isActive;
    private int displayOrder;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    // No-arg constructor
    public Page() {
    }

    // Full constructor
    public Page(int pageID, String pageName, String pageURL, String title, String content, 
                String metaDescription, boolean isActive, int displayOrder, 
                LocalDateTime createdDate, LocalDateTime updatedDate) {
        this.pageID = pageID;
        this.pageName = pageName;
        this.pageURL = pageURL;
        this.title = title;
        this.content = content;
        this.metaDescription = metaDescription;
        this.isActive = isActive;
        this.displayOrder = displayOrder;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    // Constructor without ID
    public Page(String pageName, String pageURL, String title, String content, 
                String metaDescription, int displayOrder) {
        this.pageName = pageName;
        this.pageURL = pageURL;
        this.title = title;
        this.content = content;
        this.metaDescription = metaDescription;
        this.displayOrder = displayOrder;
        this.isActive = true;
    }

    // Getters and Setters
    public int getPageID() {
        return pageID;
    }

    public void setPageID(int pageID) {
        this.pageID = pageID;
    }

    public String getPageName() {
        return pageName;
    }

    public void setPageName(String pageName) {
        this.pageName = pageName;
    }

    public String getPageURL() {
        return pageURL;
    }

    public void setPageURL(String pageURL) {
        this.pageURL = pageURL;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getMetaDescription() {
        return metaDescription;
    }

    public void setMetaDescription(String metaDescription) {
        this.metaDescription = metaDescription;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public LocalDateTime getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(LocalDateTime updatedDate) {
        this.updatedDate = updatedDate;
    }

    @Override
    public String toString() {
        return "Page{" +
                "pageID=" + pageID +
                ", pageName='" + pageName + '\'' +
                ", pageURL='" + pageURL + '\'' +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", metaDescription='" + metaDescription + '\'' +
                ", isActive=" + isActive +
                ", displayOrder=" + displayOrder +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                '}';
    }
}

