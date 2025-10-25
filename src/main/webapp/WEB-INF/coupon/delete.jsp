<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Xóa Coupon - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-ticket-alt text-danger me-2"></i>
            Xóa Coupon
        </h1>
        <a href="${pageContext.request.contextPath}/coupon?view=list" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>
            Quay Lại
        </a>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="alert alert-danger">
                <h4 class="alert-heading">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    Cảnh Báo!
                </h4>
                <p>Bạn đang chuẩn bị xóa coupon <strong>${coupon.couponCode}</strong>. Hành động này sẽ:</p>
                <ul>
                    <li>Xóa vĩnh viễn coupon</li>
                    <li>Không thể khôi phục dữ liệu</li>
                    <li>Có thể ảnh hưởng đến các booking đã sử dụng coupon</li>
                </ul>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-danger text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-info-circle me-2"></i>
                        Thông Tin Coupon
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Mã coupon:</strong><br>
                            ${coupon.couponCode}
                        </div>
                        <div class="col-md-6">
                            <strong>Tên coupon:</strong><br>
                            ${coupon.description}
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Loại giảm giá:</strong><br>
                            ${coupon.discountType}
                        </div>
                        <div class="col-md-6">
                            <strong>Giá trị:</strong><br>
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
                            <strong>Hiệu lực từ:</strong><br>
                            ${coupon.startDate}
                        </div>
                        <div class="col-md-6">
                            <strong>Hết hạn:</strong><br>
                            ${coupon.endDate}
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Số lần sử dụng:</strong><br>
                            <span class="badge bg-primary">${coupon.usedCount}/${coupon.usageLimit}</span>
                        </div>
                        <div class="col-md-6">
                            <strong>Trạng thái:</strong><br>
                            <c:choose>
                                <c:when test="${coupon.active}">
                                    <span class="badge bg-success">Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Không hoạt động</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <c:if test="${coupon.usedCount > 0}">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Lưu ý:</strong> Coupon này đã được sử dụng ${coupon.usedCount} lần. 
                            Việc xóa có thể ảnh hưởng đến dữ liệu booking.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-tasks me-2"></i>
                        Thao Tác
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/coupon">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${coupon.couponID}">
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-danger" 
                                    onclick="return confirm('Bạn có chắc chắn muốn xóa coupon này? Hành động này không thể hoàn tác!')">
                                <i class="fas fa-trash me-2"></i>
                                Xóa Coupon
                            </button>
                            <a href="${pageContext.request.contextPath}/coupon?view=list" 
                               class="btn btn-outline-secondary">
                                <i class="fas fa-times me-2"></i>
                                Hủy Bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card shadow-sm mt-3">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-shield-alt me-2"></i>
                        Bảo Mật
                    </h5>
                </div>
                <div class="card-body">
                    <p class="mb-0 text-muted">
                        <i class="fas fa-lock me-2"></i>
                        Coupon được bảo mật và chỉ sử dụng cho mục đích khuyến mãi.
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>

