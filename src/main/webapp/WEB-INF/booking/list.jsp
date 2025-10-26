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
                                                    <a href="${pageContext.request.contextPath}/booking?action=confirm&id=${booking.bookingID}" 
                                                       class="btn btn-outline-success btn-sm"
                                                       onclick="return confirm('Xác nhận booking này?')">
                                                        <i class="fas fa-check"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${booking.status == 'Đã xác nhận'}">
                                                    <a href="${pageContext.request.contextPath}/booking?action=checkin&id=${booking.bookingID}" 
                                                       class="btn btn-outline-info btn-sm"
                                                       onclick="return confirm('Check-in booking này?')">
                                                        <i class="fas fa-sign-in-alt"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${booking.status == 'Đã checkin'}">
                                                    <a href="${pageContext.request.contextPath}/booking?action=checkout&id=${booking.bookingID}" 
                                                       class="btn btn-outline-warning btn-sm"
                                                       onclick="return confirm('Check-out booking này?')">
                                                        <i class="fas fa-sign-out-alt"></i>
                                                    </a>
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

<jsp:include page="../common/footer.jsp"/>
