<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Chi Tiết Booking - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-calendar-check text-primary me-2"></i>
            Chi Tiết Booking #${booking.bookingID}
        </h1>
        <div>
            <a href="${pageContext.request.contextPath}/booking?view=my-bookings" class="btn btn-outline-secondary me-2">
                <i class="fas fa-arrow-left me-2"></i>
                Quay Lại
            </a>
            <c:if test="${booking.status == 'Chờ xác nhận'}">
                <a href="${pageContext.request.contextPath}/booking?action=cancel&id=${booking.bookingID}" 
                   class="btn btn-danger" onclick="return confirm('Bạn có chắc muốn hủy booking này?')">
                    <i class="fas fa-times me-2"></i>
                    Hủy Booking
                </a>
            </c:if>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-info-circle me-2"></i>
                        Thông Tin Booking
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Mã booking:</strong><br>
                            #${booking.bookingID}
                        </div>
                        <div class="col-md-6">
                            <strong>Trạng thái:</strong><br>
                            <c:choose>
                                <c:when test="${booking.status == 'Chờ xác nhận'}">
                                    <span class="badge bg-warning text-dark">${booking.status}</span>
                                </c:when>
                                <c:when test="${booking.status == 'Đã xác nhận'}">
                                    <span class="badge bg-info">${booking.status}</span>
                                </c:when>
                                <c:when test="${booking.status == 'Đã checkin'}">
                                    <span class="badge bg-primary">${booking.status}</span>
                                </c:when>
                                <c:when test="${booking.status == 'Đã checkout'}">
                                    <span class="badge bg-success">${booking.status}</span>
                                </c:when>
                                <c:when test="${booking.status == 'Đã hủy'}">
                                    <span class="badge bg-danger">${booking.status}</span>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Ngày đặt:</strong><br>
                            <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                        <div class="col-md-6">
                            <strong>Người đặt:</strong><br>
                            ${booking.user.fullName}
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Check-in:</strong><br>
                            <fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy"/>
                        </div>
                        <div class="col-md-6">
                            <strong>Check-out:</strong><br>
                            <fmt:formatDate value="${booking.checkOutDate}" pattern="dd/MM/yyyy"/>
                        </div>
                    </div>

                    <c:if test="${not empty booking.specialRequests}">
                        <div class="mb-0">
                            <strong>Yêu cầu đặc biệt:</strong><br>
                            <p class="mb-0 text-muted">${booking.specialRequests}</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="card shadow-sm mb-4">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-bed me-2"></i>
                        Thông Tin Phòng
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <strong>Phòng:</strong><br>
                            ${booking.room.roomNumber}
                        </div>
                        <div class="col-md-6">
                            <strong>Loại phòng:</strong><br>
                            ${booking.room.roomType.typeName}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Booking Services -->
            <c:if test="${not empty bookingServices}">
                <div class="card shadow-sm">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-concierge-bell me-2"></i>
                            Dịch Vụ Bổ Sung
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead>
                                    <tr>
                                        <th>Dịch vụ</th>
                                        <th>Danh mục</th>
                                        <th class="text-end">Đơn giá</th>
                                        <th class="text-center">SL</th>
                                        <th class="text-end">Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="bs" items="${bookingServices}">
                                        <tr>
                                            <td>${bs.service.serviceName}</td>
                                            <td><small class="text-muted">${bs.service.category}</small></td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${bs.unitPrice}" type="currency" currencySymbol="₫"/>
                                            </td>
                                            <td class="text-center">${bs.quantity}</td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${bs.totalPrice}" type="currency" currencySymbol="₫"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr class="table-active">
                                        <td colspan="4" class="text-end"><strong>Tổng dịch vụ:</strong></td>
                                        <td class="text-end">
                                            <strong>
                                                <fmt:formatNumber value="${servicesTotal}" type="currency" currencySymbol="₫"/>
                                            </strong>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-calculator me-2"></i>
                        Chi Phí
                    </h5>
                </div>
                <div class="card-body">
                    <div class="d-flex justify-content-between mb-2">
                        <span>Giá/đêm:</span>
                        <span><fmt:formatNumber value="${booking.room.roomType.pricePerNight}" type="currency" currencySymbol="₫"/></span>
                    </div>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <span>Số đêm:</span>
                        <span>${booking.nights} đêm</span>
                    </div>
                    
                    <c:if test="${booking.discountAmount > 0}">
                        <div class="d-flex justify-content-between mb-2 text-success">
                            <span>Giảm giá:</span>
                            <span>-<fmt:formatNumber value="${booking.discountAmount}" type="currency" currencySymbol="₫"/></span>
                        </div>
                    </c:if>
                    
                    <hr>
                    
                    <div class="d-flex justify-content-between">
                        <strong>Tổng cộng:</strong>
                        <strong class="text-primary">
                            <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫"/>
                        </strong>
                    </div>
                </div>
            </div>

            <c:if test="${booking.status == 'Chờ xác nhận'}">
                <div class="card shadow-sm mt-3">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Lưu Ý
                        </h5>
                    </div>
                    <div class="card-body">
                        <p class="mb-0">Booking đang chờ xác nhận. Vui lòng chờ nhân viên liên hệ để xác nhận.</p>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Booking History Timeline -->
    <c:if test="${not empty bookingHistory}">
        <div class="row mt-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-history me-2"></i>
                            Lịch Sử Thay Đổi
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="timeline">
                            <c:forEach var="history" items="${bookingHistory}">
                                <div class="timeline-item mb-3">
                                    <div class="row">
                                        <div class="col-md-2 text-muted small">
                                            <fmt:formatDate value="${history.changedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                        <div class="col-md-10">
                                            <div class="d-flex align-items-start">
                                                <div class="timeline-icon me-3">
                                                    <c:choose>
                                                        <c:when test="${history.action == 'CREATE'}">
                                                            <i class="fas fa-plus-circle text-success"></i>
                                                        </c:when>
                                                        <c:when test="${history.action == 'UPDATE'}">
                                                            <i class="fas fa-edit text-primary"></i>
                                                        </c:when>
                                                        <c:when test="${history.action == 'CANCEL'}">
                                                            <i class="fas fa-times-circle text-danger"></i>
                                                        </c:when>
                                                        <c:when test="${history.action == 'CHECKIN'}">
                                                            <i class="fas fa-sign-in-alt text-success"></i>
                                                        </c:when>
                                                        <c:when test="${history.action == 'CHECKOUT'}">
                                                            <i class="fas fa-sign-out-alt text-danger"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-circle text-secondary"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${history.action == 'CREATE'}">Tạo booking</c:when>
                                                            <c:when test="${history.action == 'UPDATE'}">Cập nhật booking</c:when>
                                                            <c:when test="${history.action == 'CANCEL'}">Hủy booking</c:when>
                                                            <c:when test="${history.action == 'CHECKIN'}">Check-in</c:when>
                                                            <c:when test="${history.action == 'CHECKOUT'}">Check-out</c:when>
                                                            <c:otherwise>${history.action}</c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                    <c:if test="${not empty history.fieldChanged}">
                                                        <br>
                                                        <small class="text-muted">
                                                            Trường: <strong>${history.fieldChanged}</strong>
                                                        </small>
                                                        <c:if test="${not empty history.oldValue}">
                                                            <br>
                                                            <small class="text-muted">
                                                                Giá trị cũ: <span class="text-decoration-line-through">${history.oldValue}</span>
                                                            </small>
                                                        </c:if>
                                                        <c:if test="${not empty history.newValue}">
                                                            <br>
                                                            <small class="text-muted">
                                                                Giá trị mới: <strong class="text-primary">${history.newValue}</strong>
                                                            </small>
                                                        </c:if>
                                                    </c:if>
                                                    <c:if test="${not empty history.notes}">
                                                        <br>
                                                        <small class="text-muted fst-italic">${history.notes}</small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</main>

<style>
.timeline-item {
    padding-left: 20px;
    border-left: 2px solid #dee2e6;
    position: relative;
}

.timeline-item:last-child {
    border-left: none;
}

.timeline-icon {
    font-size: 1.2rem;
}
</style>

<jsp:include page="../common/footer.jsp"/>
