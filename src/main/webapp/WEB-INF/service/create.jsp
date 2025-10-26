<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Thêm dịch vụ mới - Aurora Hotel" scope="request"/>
<%@include file="../common/head.jsp" %>
<%@include file="../common/navbar.jsp" %>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <!-- Page Header -->
            <div class="mb-4">
                <h2><i class="fas fa-plus-circle me-2"></i> Thêm dịch vụ mới</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/service?view=list">Dịch vụ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Thêm mới</li>
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

            <!-- Create Form -->
            <div class="card shadow">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/service" method="post">
                        <input type="hidden" name="action" value="create">

                        <!-- Service Name -->
                        <div class="mb-3">
                            <label for="serviceName" class="form-label">
                                Tên dịch vụ <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="serviceName" name="serviceName" 
                                   value="${param.serviceName}" required maxlength="100"
                                   placeholder="Ví dụ: Giặt ủi, Massage, Buffet sáng...">
                        </div>

                        <!-- Category -->
                        <div class="mb-3">
                            <label for="category" class="form-label">
                                Danh mục <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="category" name="category" required>
                                <option value="">-- Chọn danh mục --</option>
                                <option value="Ăn uống" ${param.category == 'Ăn uống' ? 'selected' : ''}>Ăn uống</option>
                                <option value="Giặt ủi" ${param.category == 'Giặt ủi' ? 'selected' : ''}>Giặt ủi</option>
                                <option value="Spa & Massage" ${param.category == 'Spa & Massage' ? 'selected' : ''}>Spa & Massage</option>
                                <option value="Vận chuyển" ${param.category == 'Vận chuyển' ? 'selected' : ''}>Vận chuyển</option>
                                <option value="Giải trí" ${param.category == 'Giải trí' ? 'selected' : ''}>Giải trí</option>
                                <option value="Khác" ${param.category == 'Khác' ? 'selected' : ''}>Khác</option>
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
                                               value="${param.price}" required min="0" step="1000"
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
                                           value="${param.unit}" maxlength="50"
                                           placeholder="Ví dụ: lần, kg, giờ, suất...">
                                </div>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" 
                                      rows="4" maxlength="500"
                                      placeholder="Mô tả chi tiết về dịch vụ...">${param.description}</textarea>
                            <div class="form-text">Tối đa 500 ký tự</div>
                        </div>

                        <!-- Form Actions -->
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/service?view=list" class="btn btn-secondary">
                                <i class="fas fa-times me-2"></i> Hủy
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i> Lưu dịch vụ
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../common/footer.jsp" %>

