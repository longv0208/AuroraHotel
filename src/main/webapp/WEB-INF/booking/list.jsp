<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Quản Lý Booking - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-calendar-check text-primary me-2"></i>
            Quản Lý Booking
        </h1>
        <div>
            <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-success me-2">
                <i class="fas fa-plus me-2"></i>
                Tạo Booking Mới
            </a>
            <a href="${pageContext.request.contextPath}/booking?view=my-bookings" class="btn btn-outline-primary">
                <i class="fas fa-user me-2"></i>
                Booking Của Tôi
            </a>
        </div>
    </div>

    <!-- Filters -->
    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-filter me-2"></i>
                Bộ Lọc
            </h5>
        </div>
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/booking">
                <input type="hidden" name="view" value="list">
                <div class="row">
                    <div class="col-md-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Chờ xác nhận" ${param.status == 'Chờ xác nhận' ? 'selected' : ''}>Chờ xác nhận</option>
                            <option value="Đã xác nhận" ${param.status == 'Đã xác nhận' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="Đã checkin" ${param.status == 'Đã checkin' ? 'selected' : ''}>Đã checkin</option>
                            <option value="Đã checkout" ${param.status == 'Đã checkout' ? 'selected' : ''}>Đã checkout</option>
                            <option value="Đã hủy" ${param.status == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Từ ngày</label>
                        <input type="date" name="fromDate" class="form-control" value="${param.fromDate}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Đến ngày</label>
                        <input type="date" name="toDate" class="form-control" value="${param.toDate}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search me-2"></i>
                                Lọc
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty bookings}">
            <div class="alert alert-info text-center py-5">
                <i class="fas fa-calendar-times fa-3x mb-3"></i>
                <h4>Không có booking nào</h4>
                <p>Không tìm thấy booking nào phù hợp với bộ lọc.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã Booking</th>
                                    <th>Khách hàng</th>
                                    <th>Phòng</th>
                                    <th>Check-in</th>
                                    <th>Check-out</th>
                                    <th>Trạng thái</th>
                                    <th>Tổng tiền</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${bookings}">
                                    <tr>
                                        <td>
                                            <strong>#${booking.bookingID}</strong>
                                            <br>
                                            <small class="text-muted">
                                                ${booking.bookingDate.toString().substring(0, 10)} ${booking.bookingDate.toString().substring(11, 16)}
                                            </small>
                                        </td>
                                        <td>
                                            ${booking.customer.fullName}
                                            <br>
                                            <small class="text-muted">${booking.customer.phone}</small>
                                        </td>
                                        <td>
                                            ${booking.room.roomNumber}
                                            <br>
                                            <small class="text-muted">${booking.room.roomType.typeName}</small>
                                        </td>
                                        <td>
                                            ${booking.checkInDate}
                                        </td>
                                        <td>
                                            ${booking.checkOutDate}
                                        </td>
                                        <td>
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
                                        </td>
                                        <td>
                                            <strong>
                                                <fmt:formatNumber value="${finalTotals[booking.bookingID]}" type="currency" currencySymbol="₫"/>
                                            </strong>
                                            <c:if test="${serviceTotals[booking.bookingID] ne null && serviceTotals[booking.bookingID] gt 0}">
                                                <br>
                                                <small class="text-muted">
                                                    + DV: <fmt:formatNumber value="${serviceTotals[booking.bookingID]}" type="currency" currencySymbol="₫"/>
                                                </small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/booking?view=details&id=${booking.bookingID}" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <c:if test="${booking.status == 'Chờ xác nhận'}">
                                                    <button type="button"
                                                            class="btn btn-outline-success btn-sm"
                                                            onclick="showStatusModal('confirm', ${booking.bookingID}, '${booking.customer.fullName}', '${booking.room.roomNumber}')">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                </c:if>
                                                <c:if test="${booking.status == 'Đã xác nhận'}">
                                                    <button type="button"
                                                            class="btn btn-outline-info btn-sm"
                                                            onclick="showStatusModal('checkin', ${booking.bookingID}, '${booking.customer.fullName}', '${booking.room.roomNumber}')">
                                                        <i class="fas fa-sign-in-alt"></i>
                                                    </button>
                                                </c:if>
                                                <c:if test="${booking.status == 'Đã checkin'}">
                                                    <button type="button"
                                                            class="btn btn-outline-warning btn-sm"
                                                            onclick="showStatusModal('checkout', ${booking.bookingID}, '${booking.customer.fullName}', '${booking.room.roomNumber}')">
                                                        <i class="fas fa-sign-out-alt"></i>
                                                    </button>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<!-- Status Change Confirmation Modal -->
<div class="modal fade" id="statusChangeModal" tabindex="-1" aria-labelledby="statusChangeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="statusChangeModalLabel">
                    <i class="fas fa-exclamation-circle text-warning me-2"></i>
                    Xác Nhận Thay Đổi Trạng Thái
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="modalMessage"></p>
                <div class="alert alert-info mb-0">
                    <strong>Thông tin booking:</strong><br>
                    <i class="fas fa-user me-2"></i><span id="modalCustomer"></span><br>
                    <i class="fas fa-door-open me-2"></i>Phòng: <span id="modalRoom"></span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Hủy
                </button>
                <form id="statusChangeForm" method="post" action="${pageContext.request.contextPath}/booking" style="display: inline;">
                    <input type="hidden" name="action" id="modalAction" value="">
                    <input type="hidden" name="id" id="modalBookingId" value="">
                    <button type="submit" class="btn btn-primary" id="modalConfirmBtn">
                        <i class="fas fa-check me-2"></i>Xác Nhận
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    let statusModal;

    document.addEventListener('DOMContentLoaded', function() {
        statusModal = new bootstrap.Modal(document.getElementById('statusChangeModal'));
    });

    function showStatusModal(action, bookingId, customerName, roomNumber) {
        console.log('showStatusModal called with:', { action, bookingId, customerName, roomNumber });

        const messages = {
            'confirm': {
                title: 'Xác Nhận Booking',
                message: 'Bạn có chắc chắn muốn xác nhận booking này?',
                btnClass: 'btn-success',
                btnText: '<i class="fas fa-check me-2"></i>Xác Nhận Booking'
            },
            'checkin': {
                title: 'Check-in',
                message: 'Bạn có chắc chắn muốn check-in booking này?',
                btnClass: 'btn-info',
                btnText: '<i class="fas fa-sign-in-alt me-2"></i>Check-in'
            },
            'checkout': {
                title: 'Check-out',
                message: 'Bạn có chắc chắn muốn check-out booking này?',
                btnClass: 'btn-warning',
                btnText: '<i class="fas fa-sign-out-alt me-2"></i>Check-out'
            }
        };

        const config = messages[action];

        // Update modal content
        document.getElementById('statusChangeModalLabel').innerHTML =
            '<i class="fas fa-exclamation-circle text-warning me-2"></i>' + config.title;
        document.getElementById('modalMessage').textContent = config.message;
        document.getElementById('modalCustomer').textContent = customerName;
        document.getElementById('modalRoom').textContent = roomNumber;

        // Update form
        document.getElementById('modalAction').value = action;
        document.getElementById('modalBookingId').value = bookingId;

        console.log('Form values set:', {
            action: document.getElementById('modalAction').value,
            id: document.getElementById('modalBookingId').value
        });

        // Update button
        const confirmBtn = document.getElementById('modalConfirmBtn');
        confirmBtn.className = 'btn ' + config.btnClass;
        confirmBtn.innerHTML = config.btnText;

        // Show modal
        statusModal.show();
    }

    // Add form submit listener to track submission
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('statusChangeForm');
        if (form) {
            form.addEventListener('submit', function(e) {
                console.log('Form submitting with data:', {
                    action: document.getElementById('modalAction').value,
                    id: document.getElementById('modalBookingId').value,
                    method: form.method,
                    url: form.action
                });
            });
        }
    });
</script>

<jsp:include page="../common/footer.jsp"/>
