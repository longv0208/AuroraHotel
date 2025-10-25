<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Quản Lý Coupon - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-ticket-alt text-primary me-2"></i>
            Quản Lý Coupon
        </h1>
        <a href="${pageContext.request.contextPath}/coupon?view=create" class="btn btn-success">
            <i class="fas fa-plus me-2"></i>
            Tạo Coupon Mới
        </a>
    </div>

    <c:choose>
        <c:when test="${empty coupons}">
            <div class="alert alert-info text-center py-5">
                <i class="fas fa-ticket-alt fa-3x mb-3"></i>
                <h4>Chưa có coupon nào</h4>
                <p>Chưa có coupon nào trong hệ thống.</p>
                <a href="${pageContext.request.contextPath}/coupon?view=create" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>
                    Tạo Coupon Đầu Tiên
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row row-cols-1 g-4">
                <c:forEach var="coupon" items="${coupons}">
                    <div class="col">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <div>
                                                <h5 class="card-title mb-1">
                                                    ${coupon.couponCode}
                                                    <c:choose>
                                                        <c:when test="${coupon.active}">
                                                            <span class="badge bg-success ms-2">Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger ms-2">Đã ẩn</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h5>
                                                <p class="text-muted small mb-0">
                                                    Tạo ngày: ${coupon.createdDate}
                                                </p>
                                            </div>
                                        </div>

                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <i class="fas fa-tag text-primary me-2"></i>
                                                <strong>Loại giảm giá:</strong> ${coupon.discountType}
                                            </div>
                                            <div class="col-md-6">
                                                <i class="fas fa-percentage text-success me-2"></i>
                                                <strong>Giá trị:</strong> 
                                                <c:choose>
                                                    <c:when test="${coupon.discountType == 'Percent'}">
                                                        ${coupon.discountValue}%
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${coupon.discountValue}" type="currency" currencySymbol="₫"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <i class="fas fa-calendar text-info me-2"></i>
                                                <strong>Hiệu lực từ:</strong>
                                                ${coupon.startDate}
                                            </div>
                                            <div class="col-md-6">
                                                <i class="fas fa-calendar-times text-danger me-2"></i>
                                                <strong>Hết hạn:</strong>
                                                ${coupon.endDate}
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <i class="fas fa-users text-warning me-2"></i>
                                                <strong>Số lần sử dụng:</strong> ${coupon.usedCount}/${coupon.usageLimit}
                                            </div>
                                            <div class="col-md-6">
                                                <i class="fas fa-money-bill text-success me-2"></i>
                                                <strong>Giảm tối đa:</strong>
                                                <c:choose>
                                                    <c:when test="${coupon.maxDiscountAmount != null}">
                                                        <fmt:formatNumber value="${coupon.maxDiscountAmount}" type="currency" currencySymbol="₫"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        Không giới hạn
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-4 border-start">
                                        <div class="text-center mb-3">
                                            <div class="d-flex align-items-center justify-content-center mb-2">
                                                <c:choose>
                                                    <c:when test="${coupon.discountType == 'Percent'}">
                                                        <span class="display-6 text-success">${coupon.discountValue}%</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="display-6 text-success">
                                                            <fmt:formatNumber value="${coupon.discountValue}" type="currency" currencySymbol="₫"/>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <small class="text-muted">Giảm giá</small>
                                        </div>

                                        <div class="d-grid gap-2">
                                            <a href="${pageContext.request.contextPath}/coupon?view=edit&id=${coupon.couponID}" 
                                               class="btn btn-outline-warning btn-sm">
                                                <i class="fas fa-edit me-1"></i>
                                                Chỉnh Sửa
                                            </a>
                                            <c:if test="${coupon.active}">
                                                <a href="${pageContext.request.contextPath}/coupon?view=delete&id=${coupon.couponID}" 
                                                   class="btn btn-outline-warning btn-sm"
                                                   onclick="return confirm('Bạn có chắc muốn ẩn coupon này?')">
                                                    <i class="fas fa-eye-slash me-1"></i>
                                                    Ẩn
                                                </a>
                                            </c:if>
                                            <c:if test="${!coupon.active}">
                                                <a href="${pageContext.request.contextPath}/coupon?action=activate&id=${coupon.couponID}" 
                                                   class="btn btn-outline-success btn-sm"
                                                   onclick="return confirm('Bạn có chắc muốn kích hoạt lại coupon này?')">
                                                    <i class="fas fa-eye me-1"></i>
                                                    Kích hoạt
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="../common/footer.jsp"/>

