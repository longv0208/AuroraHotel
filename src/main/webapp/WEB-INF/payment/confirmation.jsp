<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Xác Nhận Thanh Toán - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-check-circle text-success me-2"></i>
            Xác Nhận Thanh Toán
        </h1>
        <a href="${pageContext.request.contextPath}/booking?view=details&id=${payment.booking.bookingID}" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>
            Quay Lại
        </a>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="alert alert-success">
                <h4 class="alert-heading">
                    <i class="fas fa-check-circle me-2"></i>
                    Thanh Toán Thành Công!
                </h4>
                <p>Giao dịch đã được xử lý thành công. Dưới đây là thông tin chi tiết:</p>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-info-circle me-2"></i>
                        Thông Tin Giao Dịch
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Mã giao dịch:</strong><br>
                            #${payment.paymentID}
                        </div>
                        <div class="col-md-6">
                            <strong>Ngày giao dịch:</strong><br>
                            <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Số tiền:</strong><br>
                            <span class="text-success fw-bold">
                                <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₫"/>
                            </span>
                        </div>
                        <div class="col-md-6">
                            <strong>Phương thức:</strong><br>
                            ${payment.paymentMethod}
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Loại thanh toán:</strong><br>
                            <c:choose>
                                <c:when test="${payment.paymentType == 'Deposit'}">
                                    <span class="badge bg-warning text-dark">Cọc</span>
                                </c:when>
                                <c:when test="${payment.paymentType == 'Checkout'}">
                                    <span class="badge bg-success">Checkout</span>
                                </c:when>
                            </c:choose>
                        </div>
                        <div class="col-md-6">
                            <strong>Trạng thái:</strong><br>
                            <span class="badge bg-success">Thành công</span>
                        </div>
                    </div>

                    <c:if test="${not empty payment.referenceNumber}">
                        <div class="mb-3">
                            <strong>Số tham chiếu:</strong><br>
                            ${payment.referenceNumber}
                        </div>
                    </c:if>

                    <c:if test="${not empty payment.notes}">
                        <div class="mb-0">
                            <strong>Ghi chú:</strong><br>
                            <p class="mb-0 text-muted">${payment.notes}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-bed me-2"></i>
                        Thông Tin Booking
                    </h5>
                </div>
                <div class="card-body">
                    <div class="mb-2">
                        <strong>Mã booking:</strong><br>
                        #${payment.booking.bookingID}
                    </div>
                    
                    <div class="mb-2">
                        <strong>Phòng:</strong><br>
                        ${payment.booking.room.roomNumber} - ${payment.booking.room.roomType.typeName}
                    </div>
                    
                    <div class="mb-2">
                        <strong>Check-in:</strong><br>
                        <fmt:formatDate value="${payment.booking.checkInDate}" pattern="dd/MM/yyyy"/>
                    </div>
                    
                    <div class="mb-2">
                        <strong>Check-out:</strong><br>
                        <fmt:formatDate value="${payment.booking.checkOutDate}" pattern="dd/MM/yyyy"/>
                    </div>
                    
                    <div class="mb-0">
                        <strong>Khách hàng:</strong><br>
                        ${payment.booking.customer.fullName}
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
                        <a href="${pageContext.request.contextPath}/booking?view=details&id=${payment.booking.bookingID}" 
                           class="btn btn-primary">
                            <i class="fas fa-eye me-2"></i>
                            Xem Booking
                        </a>
                        <a href="${pageContext.request.contextPath}/payment?view=history" 
                           class="btn btn-outline-primary">
                            <i class="fas fa-history me-2"></i>
                            Lịch Sử Thanh Toán
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
