<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Xóa Khách Hàng - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-user-times text-danger me-2"></i>
            Xóa Khách Hàng
        </h1>
        <a href="${pageContext.request.contextPath}/customer?view=details&id=${customer.customerID}" class="btn btn-outline-secondary">
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
                <p>Bạn đang chuẩn bị xóa khách hàng <strong>${customer.fullName}</strong>. Hành động này sẽ:</p>
                <ul>
                    <li>Xóa vĩnh viễn thông tin khách hàng</li>
                    <li>Không thể khôi phục dữ liệu</li>
                    <li>Có thể ảnh hưởng đến các booking liên quan</li>
                </ul>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-danger text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-info-circle me-2"></i>
                        Thông Tin Khách Hàng
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Họ tên:</strong><br>
                            ${customer.fullName}
                        </div>
                        <div class="col-md-6">
                            <strong>Điện thoại:</strong><br>
                            ${customer.phone}
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Email:</strong><br>
                            ${customer.email}
                        </div>
                        <div class="col-md-6">
                            <strong>Quốc tịch:</strong><br>
                            ${customer.nationality}
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Địa chỉ:</strong><br>
                            ${customer.address}
                        </div>
                        <div class="col-md-6">
                            <strong>Số booking:</strong><br>
                            <span class="badge bg-primary">${customer.totalBookings}</span>
                        </div>
                    </div>

                    <c:if test="${customer.totalBookings > 0}">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Lưu ý:</strong> Khách hàng này có ${customer.totalBookings} booking. 
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
                    <form method="post" action="${pageContext.request.contextPath}/customer">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${customer.customerID}">
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-danger" 
                                    onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng này? Hành động này không thể hoàn tác!')">
                                <i class="fas fa-trash me-2"></i>
                                Xóa Khách Hàng
                            </button>
                            <a href="${pageContext.request.contextPath}/customer?view=details&id=${customer.customerID}" 
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
                        Thông tin khách hàng được bảo mật và chỉ sử dụng cho mục đích quản lý khách sạn.
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>

