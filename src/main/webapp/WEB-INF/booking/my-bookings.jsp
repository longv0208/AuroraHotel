<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Booking Của Tôi - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-calendar-alt text-primary me-2"></i>
            Booking Của Tôi
        </h1>
        <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-success">
            <i class="fas fa-plus me-2"></i>
            Đặt Phòng Mới
        </a>
    </div>

    <c:choose>
        <c:when test="${empty bookings}">
            <div class="alert alert-info text-center py-5">
                <i class="fas fa-calendar-times fa-3x mb-3"></i>
                <h4>Chưa có booking nào</h4>
                <p>Bạn chưa có booking nào trong hệ thống.</p>
                <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-primary">
                    <i class="fas fa-search me-2"></i>
                    Tìm Phòng Ngay
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row row-cols-1 g-4">
                <c:forEach var="booking" items="${bookings}">
                    <div class="col">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <div>
                                                <h5 class="card-title mb-1">
                                                    Booking #${booking.bookingID}
                                                    <c:choose>
                                                        <c:when test="${booking.status == 'Chờ xác nhận'}">
                                                            <span class="badge bg-warning text-dark ms-2">${booking.status}</span>
                                                        </c:when>
                                                        <c:when test="${booking.status == 'Đã xác nhận'}">
                                                            <span class="badge bg-info ms-2">${booking.status}</span>
                                                        </c:when>
                                                        <c:when test="${booking.status == 'Đã checkin'}">
                                                            <span class="badge bg-primary ms-2">${booking.status}</span>
                                                        </c:when>
                                                        <c:when test="${booking.status == 'Đã checkout'}">
                                                            <span class="badge bg-success ms-2">${booking.status}</span>
                                                        </c:when>
                                                        <c:when test="${booking.status == 'Đã hủy'}">
                                                            <span class="badge bg-danger ms-2">${booking.status}</span>
                                                        </c:when>
                                                    </c:choose>
                                                </h5>
                                                <p class="text-muted small mb-0">
                                                    Đặt ngày: <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <i class="fas fa-door-open text-primary me-2"></i>
                                                <strong>Phòng:</strong> ${booking.room.roomNumber}
                                                <br>
                                                <small class="text-muted">${booking.room.roomType.typeName}</small>
                                            </div>
                                            <div class="col-md-6">
                                                <i class="fas fa-calendar-check text-success me-2"></i>
                                                <strong>Check-in:</strong>
                                                <fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy"/>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <i class="fas fa-calendar-times text-danger me-2"></i>
                                                <strong>Check-out:</strong>
                                                <fmt:formatDate value="${booking.checkOutDate}" pattern="dd/MM/yyyy"/>
                                            </div>
                                            <div class="col-md-6">
                                                <i class="fas fa-moon text-info me-2"></i>
                                                <strong>Số đêm:</strong> ${booking.nights} đêm
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-4 border-start">
                                        <div class="text-center mb-3">
                                            <small class="text-muted">Tổng tiền</small>
                                            <h4 class="text-primary mb-0">
                                                <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫"/>
                                            </h4>
                                        </div>

                                        <div class="d-grid gap-2">
                                            <a href="${pageContext.request.contextPath}/booking?view=details&id=${booking.bookingID}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye me-1"></i>
                                                Xem Chi Tiết
                                            </a>
                                            <c:if test="${booking.status == 'Chờ xác nhận'}">
                                                <a href="${pageContext.request.contextPath}/booking?action=cancel&id=${booking.bookingID}" 
                                                   class="btn btn-outline-danger btn-sm" 
                                                   onclick="return confirm('Bạn có chắc muốn hủy booking này?')">
                                                    <i class="fas fa-times me-1"></i>
                                                    Hủy Booking
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
