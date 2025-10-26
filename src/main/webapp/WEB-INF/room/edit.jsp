<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="Sửa phòng - Aurora Hotel" scope="request" />
        <%@include file="../common/head.jsp" %>
            <%@include file="../common/navbar.jsp" %>

                <main class="container my-5">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <!-- Page Header -->
                            <div class="mb-4">
                                <h2><i class="fas fa-edit me-2"></i> Sửa thông tin phòng</h2>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item">
                                            <a href="${pageContext.request.contextPath}/roomManagement?view=list">Quản
                                                lý phòng</a>
                                        </li>
                                        <li class="breadcrumb-item active">Sửa phòng ${room.roomNumber}</li>
                                    </ol>
                                </nav>
                            </div>

                            <!-- Error Message -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    ${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>

                            <!-- Success Message -->
                            <c:if test="${not empty success}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>
                                    ${success}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>

                            <!-- Edit Form -->
                            <div class="card shadow">
                                <div class="card-body p-4">
                                    <form action="${pageContext.request.contextPath}/roomManagement" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" name="roomID" value="${room.roomID}">

                                        <!-- Room Number -->
                                        <div class="mb-3">
                                            <label for="roomNumber" class="form-label">
                                                <i class="fas fa-door-closed me-1"></i> Số phòng <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <input type="text"
                                                class="form-control ${not empty error ? 'is-invalid' : ''}"
                                                id="roomNumber" name="roomNumber" value="${room.roomNumber}" required>
                                            <c:if test="${not empty error}">
                                                <div class="invalid-feedback d-block">
                                                    ${error}
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Room Type -->
                                        <div class="mb-3">
                                            <label for="roomTypeID" class="form-label">
                                                <i class="fas fa-bed me-1"></i> Loại phòng <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" id="roomTypeID" name="roomTypeID" required>
                                                <option value="">-- Chọn loại phòng --</option>
                                                <c:forEach var="roomType" items="${roomTypes}">
                                                    <option value="${roomType.roomTypeID}"
                                                        ${roomType.roomTypeID==room.roomTypeID ? 'selected' : '' }>
                                                        ${roomType.typeName} - ${roomType.basePrice} ₫
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Floor -->
                                        <div class="mb-3">
                                            <label for="floor" class="form-label">
                                                <i class="fas fa-building me-1"></i> Tầng <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="floor" name="floor" min="1"
                                                max="50" value="${room.floor}" required>
                                        </div>

                                        <!-- Status -->
                                        <div class="mb-3">
                                            <label for="status" class="form-label">
                                                <i class="fas fa-info-circle me-1"></i> Trạng thái <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="Trống" ${room.status=='Trống' ? 'selected' : '' }>Trống
                                                </option>
                                                <option value="Đã đặt" ${room.status=='Đã đặt' ? 'selected' : '' }>Đã
                                                    đặt</option>
                                                <option value="Đang sử dụng" ${room.status=='Đang sử dụng' ? 'selected'
                                                    : '' }>Đang sử dụng</option>
                                                <option value="Bảo trì" ${room.status=='Bảo trì' ? 'selected' : '' }>Bảo
                                                    trì</option>
                                            </select>
                                        </div>

                                        <!-- Description -->
                                        <div class="mb-3">
                                            <label for="description" class="form-label">
                                                <i class="fas fa-align-left me-1"></i> Mô tả
                                            </label>
                                            <textarea class="form-control" id="description" name="description"
                                                rows="3">${room.description}</textarea>
                                        </div>

                                        <!-- Is Active -->
                                        <div class="mb-3">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="isActive"
                                                    name="isActive" value="1" ${room.active ? 'checked' : '' }>
                                                <label class="form-check-label" for="isActive">
                                                    <i class="fas fa-check-circle me-1"></i> Phòng đang hoạt động
                                                </label>
                                            </div>
                                        </div>

                                        <!-- Buttons -->
                                        <div class="d-flex justify-content-between">
                                            <a href="${pageContext.request.contextPath}/roomManagement?view=list"
                                                class="btn btn-secondary">
                                                <i class="fas fa-arrow-left me-2"></i> Quay lại
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-2"></i> Cập nhật
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

                <%@include file="../common/footer.jsp" %>