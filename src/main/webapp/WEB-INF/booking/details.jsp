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

            <div class="card shadow-sm">
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
</main>

<jsp:include page="../common/footer.jsp"/>
