package model;

import java.math.BigDecimal;

/**
 * Entity class for Services table
 * Represents hotel services (food, laundry, spa, etc.)
 */
public class Service {
    private int serviceID;
    private String serviceName;
    private String description;
    private BigDecimal price;
    private String unit; // Unit of measurement
    private String category; // Food, Laundry, Spa, etc.
    private boolean isActive;

    // No-arg constructor
    public Service() {
    }

    // Full constructor
    public Service(int serviceID, String serviceName, String description, 
                   BigDecimal price, String unit, String category, boolean isActive) {
        this.serviceID = serviceID;
        this.serviceName = serviceName;
        this.description = description;
        this.price = price;
        this.unit = unit;
        this.category = category;
        this.isActive = isActive;
    }

    // Constructor without ID
    public Service(String serviceName, String description, BigDecimal price, 
                   String unit, String category) {
        this.serviceName = serviceName;
        this.description = description;
        this.price = price;
        this.unit = unit;
        this.category = category;
        this.isActive = true;
    }

    // Getters and Setters
    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "Service{" +
                "serviceID=" + serviceID +
                ", serviceName='" + serviceName + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", unit='" + unit + '\'' +
                ", category='" + category + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}

