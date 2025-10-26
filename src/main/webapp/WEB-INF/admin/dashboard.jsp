<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Admin Dashboard - Aurora Hotel" scope="request" />
<%@include file="../common/head.jsp" %>
<%@include file="../common/navbar.jsp" %>

<main class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <h1 class="display-6 fw-bold">
                    <i class="fas fa-tachometer-alt text-primary me-2"></i>
                    Admin Dashboard
                </h1>
                <span class="badge bg-success">Admin</span>
            </div>
        </div>
    </div>

    <!-- Management Features Grid -->
    <div class="row g-4">
        <!-- Room Management -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 hover-card">
                <div class="card-body text-center">
                    <i class="fas fa-door-open fa-3x text-primary mb-3"></i>
                    <h5 class="card-title">Room Management</h5>
                    <p class="card-text text-muted">Manage hotel rooms, types, and availability</p>
                    <a href="${pageContext.request.contextPath}/roomManagement?view=list" class="btn btn-primary btn-sm">
                        <i class="fas fa-arrow-right me-1"></i> Go to Management
                    </a>
                </div>
            </div>
        </div>

        <!-- Service Management -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 hover-card">
                <div class="card-body text-center">
                    <i class="fas fa-concierge-bell fa-3x text-success mb-3"></i>
                    <h5 class="card-title">Service Management</h5>
                    <p class="card-text text-muted">Manage hotel services and pricing</p>
                    <a href="${pageContext.request.contextPath}/service?view=list" class="btn btn-success btn-sm">
                        <i class="fas fa-arrow-right me-1"></i> Go to Management
                    </a>
                </div>
            </div>
        </div>

        <!-- Customer Management -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 hover-card">
                <div class="card-body text-center">
                    <i class="fas fa-users fa-3x text-info mb-3"></i>
                    <h5 class="card-title">Customer Management</h5>
                    <p class="card-text text-muted">Manage customer information and profiles</p>
                    <a href="${pageContext.request.contextPath}/customer?view=list" class="btn btn-info btn-sm">
                        <i class="fas fa-arrow-right me-1"></i> Go to Management
                    </a>
                </div>
            </div>
        </div>

        <!-- Booking Management -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 hover-card">
                <div class="card-body text-center">
                    <i class="fas fa-calendar-check fa-3x text-warning mb-3"></i>
                    <h5 class="card-title">Booking Management</h5>
                    <p class="card-text text-muted">Manage bookings and reservations</p>
                    <a href="${pageContext.request.contextPath}/booking?view=list" class="btn btn-warning btn-sm">
                        <i class="fas fa-arrow-right me-1"></i> Go to Management
                    </a>
                </div>
            </div>
        </div>

        <!-- Feedback Management -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 hover-card">
                <div class="card-body text-center">
                    <i class="fas fa-comments fa-3x text-danger mb-3"></i>
                    <h5 class="card-title">Feedback Management</h5>
                    <p class="card-text text-muted">Moderate and manage customer feedback</p>
                    <a href="${pageContext.request.contextPath}/feedback?action=admin" class="btn btn-danger btn-sm">
                        <i class="fas fa-arrow-right me-1"></i> Go to Management
                    </a>
                </div>
            </div>
        </div>

        <!-- Coupon Management -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 hover-card">
                <div class="card-body text-center">
                    <i class="fas fa-ticket-alt fa-3x text-secondary mb-3"></i>
                    <h5 class="card-title">Coupon Management</h5>
                    <p class="card-text text-muted">Create and manage discount coupons</p>
                    <a href="${pageContext.request.contextPath}/coupon?view=list" class="btn btn-secondary btn-sm">
                        <i class="fas fa-arrow-right me-1"></i> Go to Management
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Reports Section -->
    <div class="row mt-5">
        <div class="col-12">
            <h3 class="mb-4">
                <i class="fas fa-chart-line text-primary me-2"></i>
                Reports & Analytics
            </h3>
        </div>
    </div>

    <div class="row g-4">
        <!-- Dashboard Report -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 hover-card">
                <div class="card-body text-center">
                    <i class="fas fa-chart-pie fa-3x text-primary mb-3"></i>
                    <h5 class="card-title">Dashboard</h5>
                    <p class="card-text text-muted">View overall statistics and metrics</p>
                    <a href="${pageContext.request.contextPath}/report?view=dashboard" class="btn btn-primary btn-sm">
                        <i class="fas fa-arrow-right me-1"></i> View Report
                    </a>
                </div>
            </div>
        </div>

        <!-- Revenue Report -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 hover-card">
                <div class="card-body text-center">
                    <i class="fas fa-money-bill-wave fa-3x text-success mb-3"></i>
                    <h5 class="card-title">Revenue Report</h5>
                    <p class="card-text text-muted">View revenue by month, quarter, and year</p>
                    <a href="${pageContext.request.contextPath}/report?view=revenue" class="btn btn-success btn-sm">
                        <i class="fas fa-arrow-right me-1"></i> View Report
                    </a>
                </div>
            </div>
        </div>

        <!-- Occupancy Report -->
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm h-100 hover-card">
                <div class="card-body text-center">
                    <i class="fas fa-bed fa-3x text-info mb-3"></i>
                    <h5 class="card-title">Occupancy Report</h5>
                    <p class="card-text text-muted">View room occupancy rates and trends</p>
                    <a href="${pageContext.request.contextPath}/report?view=occupancy" class="btn btn-info btn-sm">
                        <i class="fas fa-arrow-right me-1"></i> View Report
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../common/footer.jsp" %>

<style>
    .hover-card {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .hover-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
    }
</style>