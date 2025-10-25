<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Chi Tiết Khách Hàng - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-user text-primary me-2"></i>
            Chi Tiết Khách Hàng
        </h1>
        <a href="${pageContext.request.contextPath}/customer?view=list" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>
            Quay Lại
        </a>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
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
                            <strong>CMND/CCCD:</strong><br>
                            ${customer.idCard}
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Địa chỉ:</strong><br>
                            ${customer.address}
                        </div>
                        <div class="col-md-6">
                            <strong>Quốc tịch:</strong><br>
                            ${customer.nationality}
                        </div>
                    </div>

                    <c:if test="${not empty customer.notes}">
                        <div class="mb-0">
                            <strong>Ghi chú:</strong><br>
                            <p class="mb-0 text-muted">${customer.notes}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-bar me-2"></i>
                        Thống Kê
                    </h5>
                </div>
                <div class="card-body">
                    <div class="text-center mb-3">
                        <h3 class="text-primary">${customer.totalBookings}</h3>
                        <p class="text-muted mb-0">Tổng số booking</p>
                    </div>
                    
                    <div class="text-center">
                        <small class="text-muted">
                            Tham gia từ: <fmt:formatDate value="${customer.createdDate}" pattern="dd/MM/yyyy"/>
                        </small>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm mt-3">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-tasks me-2"></i>
                        Thao Tác
                    </h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/customer?view=booking-history&id=${customer.customerID}" 
                           class="btn btn-primary">
                            <i class="fas fa-history me-2"></i>
                            Lịch Sử Booking
                        </a>
                        <a href="${pageContext.request.contextPath}/customer?view=edit&id=${customer.customerID}" 
                           class="btn btn-warning">
                            <i class="fas fa-edit me-2"></i>
                            Chỉnh Sửa
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>

