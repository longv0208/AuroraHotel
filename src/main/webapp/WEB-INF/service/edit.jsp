<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Chỉnh sửa dịch vụ - Aurora Hotel" scope="request"/>
<%@include file="../common/head.jsp" %>
<%@include file="../common/navbar.jsp" %>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <!-- Page Header -->
            <div class="mb-4">
                <h2><i class="fas fa-edit me-2"></i> Chỉnh sửa dịch vụ</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/service?view=list">Dịch vụ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Chỉnh sửa</li>
                    </ol>
                </nav>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Edit Form -->
            <div class="card shadow">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/service" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="serviceId" value="${service.serviceID}">

                        <!-- Service Name -->
                        <div class="mb-3">
                            <label for="serviceName" class="form-label">
                                Tên dịch vụ <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="serviceName" name="serviceName" 
                                   value="${service.serviceName}" required maxlength="100"
                                   placeholder="Ví dụ: Giặt ủi, Massage, Buffet sáng...">
                        </div>

                        <!-- Category -->
                        <div class="mb-3">
                            <label for="category" class="form-label">
                                Danh mục <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="category" name="category" required>
                                <option value="">-- Chọn danh mục --</option>
                                <option value="Ăn uống" ${service.category == 'Ăn uống' ? 'selected' : ''}>Ăn uống</option>
                                <option value="Giặt ủi" ${service.category == 'Giặt ủi' ? 'selected' : ''}>Giặt ủi</option>
                                <option value="Spa & Massage" ${service.category == 'Spa & Massage' ? 'selected' : ''}>Spa & Massage</option>
                                <option value="Vận chuyển" ${service.category == 'Vận chuyển' ? 'selected' : ''}>Vận chuyển</option>
                                <option value="Giải trí" ${service.category == 'Giải trí' ? 'selected' : ''}>Giải trí</option>
                                <option value="Khác" ${service.category == 'Khác' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>

                        <!-- Price and Unit Row -->
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="price" class="form-label">
                                        Giá <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="price" name="price" 
                                               value="${service.price}" required min="0" step="1000"
                                               placeholder="0">
                                        <span class="input-group-text">₫</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="unit" class="form-label">
                                        Đơn vị tính
                                    </label>
                                    <input type="text" class="form-control" id="unit" name="unit" 
                                           value="${service.unit}" maxlength="50"
                                           placeholder="Ví dụ: lần, kg, giờ, suất...">
                                </div>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" 
                                      rows="4" maxlength="500"
                                      placeholder="Mô tả chi tiết về dịch vụ...">${service.description}</textarea>
                            <div class="form-text">Tối đa 500 ký tự</div>
                        </div>

                        <!-- Active Status -->
                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="isActive" name="isActive" 
                                       ${service.active ? 'checked' : ''}>
                                <label class="form-check-label" for="isActive">
                                    Dịch vụ đang hoạt động
                                </label>
                            </div>
                            <div class="form-text">
                                Bỏ chọn để tạm ngừng cung cấp dịch vụ này
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/service?view=list" class="btn btn-secondary">
                                <i class="fas fa-times me-2"></i> Hủy
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i> Cập nhật
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Service Info Card -->
            <div class="card mt-3">
                <div class="card-body">
                    <h6 class="card-subtitle mb-2 text-muted">Thông tin dịch vụ</h6>
                    <p class="mb-1"><strong>ID:</strong> ${service.serviceID}</p>
                    <p class="mb-0">
                        <strong>Trạng thái:</strong> 
                        <c:choose>
                            <c:when test="${service.active}">
                                <span class="badge bg-success">Hoạt động</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Ngừng</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../common/footer.jsp" %>

