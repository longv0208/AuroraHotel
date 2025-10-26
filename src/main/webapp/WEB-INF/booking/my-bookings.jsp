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
                                                    Đặt ngày: ${booking.bookingDate.toString().substring(0, 10)} ${booking.bookingDate.toString().substring(11, 16)}
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
                                                ${booking.checkInDate}
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <i class="fas fa-calendar-times text-danger me-2"></i>
                                                <strong>Check-out:</strong>
                                                ${booking.checkOutDate}
                                            </div>
                                            <div class="col-md-6">
                                                <i class="fas fa-users text-info me-2"></i>
                                                <strong>Số khách:</strong> ${booking.numberOfGuests} người
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-4 border-start">
                                        <div class="text-center mb-3">
                                            <small class="text-muted">Tổng tiền</small>
                                            <h4 class="text-primary mb-0">
                                                <fmt:formatNumber value="${finalTotals[booking.bookingID]}" type="currency" currencySymbol="₫"/>
                                            </h4>
                                            <c:if test="${serviceTotals[booking.bookingID] ne null && serviceTotals[booking.bookingID] gt 0}">
                                                <small class="text-muted d-block">
                                                    (Phòng: <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫"/>
                                                    + DV: <fmt:formatNumber value="${serviceTotals[booking.bookingID]}" type="currency" currencySymbol="₫"/>)
                                                </small>
                                            </c:if>
                                        </div>

                                        <div class="d-grid gap-2">
                                            <a href="${pageContext.request.contextPath}/booking?view=details&id=${booking.bookingID}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye me-1"></i>
                                                Xem Chi Tiết
                                            </a>
                                            <c:if test="${booking.status == 'Chờ xác nhận'}">
                                                <button type="button"
                                                        class="btn btn-outline-danger btn-sm"
                                                        onclick="showCancelModal(${booking.bookingID}, '${booking.room.roomNumber}', '${booking.checkInDate}')">
                                                    <i class="fas fa-times me-1"></i>
                                                    Hủy Booking
                                                </button>
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

<!-- Cancel Booking Confirmation Modal -->
<div class="modal fade" id="cancelBookingModal" tabindex="-1" aria-labelledby="cancelBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="cancelBookingModalLabel">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    Xác Nhận Hủy Booking
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p><strong>Bạn có chắc chắn muốn hủy booking này?</strong></p>
                <div class="alert alert-warning">
                    <i class="fas fa-info-circle me-2"></i>
                    Hành động này không thể hoàn tác!
                </div>
                <div class="alert alert-info mb-0">
                    <strong>Thông tin booking:</strong><br>
                    <i class="fas fa-door-open me-2"></i>Phòng: <span id="cancelModalRoom"></span><br>
                    <i class="fas fa-calendar-check me-2"></i>Check-in: <span id="cancelModalDate"></span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-arrow-left me-2"></i>Quay Lại
                </button>
                <form id="cancelBookingForm" method="post" action="${pageContext.request.contextPath}/booking" style="display: inline;">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="id" id="cancelModalBookingId" value="">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-times me-2"></i>Hủy Booking
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    let cancelModal;

    document.addEventListener('DOMContentLoaded', function() {
        cancelModal = new bootstrap.Modal(document.getElementById('cancelBookingModal'));
    });

    function showCancelModal(bookingId, roomNumber, checkInDate) {
        // Update modal content
        document.getElementById('cancelModalRoom').textContent = roomNumber;
        document.getElementById('cancelModalDate').textContent = checkInDate;
        document.getElementById('cancelModalBookingId').value = bookingId;

        // Show modal
        cancelModal.show();
    }
</script>

<jsp:include page="../common/footer.jsp"/>
