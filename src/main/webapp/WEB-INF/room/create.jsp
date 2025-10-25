<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Thêm phòng mới - Aurora Hotel" scope="request"/>
<%@include file="../common/head.jsp" %>
<%@include file="../common/navbar.jsp" %>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <!-- Page Header -->
            <div class="mb-4">
                <h2><i class="fas fa-plus-circle me-2"></i> Thêm phòng mới</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/roomManagement?view=list">Quản lý phòng</a>
                        </li>
                        <li class="breadcrumb-item active">Thêm mới</li>
                    </ol>
                </nav>
            </div>

            <!-- Error Message -->
            <c:if test="${param.error == '1'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    Có lỗi xảy ra. Vui lòng kiểm tra lại thông tin!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Create Form -->
            <div class="card shadow">
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/roomManagement" method="POST">
                        <input type="hidden" name="action" value="create">

                        <!-- Room Number -->
                        <div class="mb-3">
                            <label for="roomNumber" class="form-label">
                                <i class="fas fa-door-closed me-1"></i> Số phòng <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="roomNumber" name="roomNumber" 
                                   placeholder="Ví dụ: 101, 102, A201..." required>
                        </div>

                        <!-- Room Type -->
                        <div class="mb-3">
                            <label for="roomTypeID" class="form-label">
                                <i class="fas fa-bed me-1"></i> Loại phòng <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="roomTypeID" name="roomTypeID" required>
                                <option value="">-- Chọn loại phòng --</option>
                                <c:forEach var="roomType" items="${roomTypes}">
                                    <option value="${roomType.roomTypeID}">
                                        ${roomType.typeName} - ${roomType.basePrice} ₫
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Floor -->
                        <div class="mb-3">
                            <label for="floor" class="form-label">
                                <i class="fas fa-building me-1"></i> Tầng <span class="text-danger">*</span>
                            </label>
                            <input type="number" class="form-control" id="floor" name="floor" 
                                   min="1" max="50" value="1" required>
                        </div>

                        <!-- Status -->
                        <div class="mb-3">
                            <label for="status" class="form-label">
                                <i class="fas fa-info-circle me-1"></i> Trạng thái <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="Available" selected>Trống</option>
                                <option value="Occupied">Đã thuê</option>
                                <option value="Maintenance">Bảo trì</option>
                            </select>
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label for="description" class="form-label">
                                <i class="fas fa-align-left me-1"></i> Mô tả
                            </label>
                            <textarea class="form-control" id="description" name="description" 
                                      rows="3" placeholder="Mô tả chi tiết về phòng..."></textarea>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/roomManagement?view=list" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i> Lưu phòng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../common/footer.jsp" %>

