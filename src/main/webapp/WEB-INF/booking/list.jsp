<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Quản Lý Booking - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container-fluid">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-calendar-alt text-primary me-2"></i>
            Quản Lý Booking
        </h1>
        <div>
            <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-success">
                <i class="fas fa-plus-circle me-2"></i>
                Tạo Booking Mới
            </a>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card bg-warning text-white">
                <div class="card-body">
                    <h5><i class="fas fa-clock me-2"></i>Chờ Xác Nhận</h5>
                    <h2 class="mb-0">
                        <c:set var="pending" value="0"/>
                        <c:forEach var="b" items="${bookings}">
                            <c:if test="${b.status == 'Chờ xác nhận'}">
                                <c:set var="pending" value="${pending + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${pending}
                    </h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white">
                <div class="card-body">
                    <h5><i class="fas fa-check me-2"></i>Đã Xác Nhận</h5>
                    <h2 class="mb-0">
                        <c:set var="confirmed" value="0"/>
                        <c:forEach var="b" items="${bookings}">
                            <c:if test="${b.status == 'Đã xác nhận'}">
                                <c:set var="confirmed" value="${confirmed + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${confirmed}
                    </h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body">
                    <h5><i class="fas fa-door-open me-2"></i>Đã Check-in</h5>
                    <h2 class="mb-0">
                        <c:set var="checkedin" value="0"/>
                        <c:forEach var="b" items="${bookings}">
                            <c:if test="${b.status == 'Đã checkin'}">
                                <c:set var="checkedin" value="${checkedin + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${checkedin}
                    </h2>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body">
                    <h5><i class="fas fa-check-circle me-2"></i>Đã Checkout</h5>
                    <h2 class="mb-0">
                        <c:set var="checkedout" value="0"/>
                        <c:forEach var="b" items="${bookings}">
                            <c:if test="${b.status == 'Đã checkout'}">
                                <c:set var="checkedout" value="${checkedout + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${checkedout}
                    </h2>
                </div>
            </div>
        </div>
    </div>

    <!-- Bookings Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white">
            <h5 class="mb-0">
                <i class="fas fa-list me-2"></i>
                Danh Sách Booking
                <span class="badge bg-secondary">${totalRows} booking</span>
            </h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty bookings}">
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-inbox fa-3x mb-3"></i>
                        <p>Chưa có booking nào</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Ngày Đặt</th>
                                    <th>Khách Hàng</th>
                                    <th>Phòng</th>
                                    <th>Check-in</th>
                                    <th>Check-out</th>
                                    <th>Tổng Tiền</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-center">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${bookings}">
                                    <tr>
                                        <td><strong>#${booking.bookingID}</strong></td>
                                        <td>
                                            <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            ${booking.customer.fullName}<br>
                                            <small class="text-muted">${booking.customer.phone}</small>
                                        </td>
                                        <td>
                                            <strong>${booking.room.roomNumber}</strong><br>
                                            <small class="text-muted">${booking.room.roomType.typeName}</small>
                                        </td>
                                        <td><fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:formatDate value="${booking.checkOutDate}" pattern="dd/MM/yyyy"/></td>
                                        <td>
                                            <strong class="text-primary">
                                                <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫"/>
                                            </strong>
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
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm">
                                                <a href="${pageContext.request.contextPath}/booking?view=details&id=${booking.bookingID}" 
                                                   class="btn btn-outline-primary" title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Booking pagination">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?view=list&page=${currentPage - 1}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="?view=list&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?view=list&page=${currentPage + 1}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>

