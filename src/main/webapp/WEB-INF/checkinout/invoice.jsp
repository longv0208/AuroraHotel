<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Hóa Đơn - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-file-invoice text-primary me-2"></i>
            Hóa Đơn Thanh Toán
        </h1>
        <div>
            <button onclick="window.print()" class="btn btn-primary me-2">
                <i class="fas fa-print me-2"></i>
                In Hóa Đơn
            </button>
            <a href="${pageContext.request.contextPath}/booking?view=list" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>
                Quay Lại
            </a>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-5">
            <!-- Hotel Header -->
            <div class="text-center mb-5">
                <h2 class="text-primary mb-2">AURORA HOTEL</h2>
                <p class="text-muted mb-1">123 Đường ABC, Quận XYZ, TP. Hồ Chí Minh</p>
                <p class="text-muted mb-1">Điện thoại: (028) 1234 5678 | Email: info@aurorahotel.com</p>
                <hr class="my-4">
                <h4 class="text-uppercase">HÓA ĐƠN THANH TOÁN</h4>
                <p class="text-muted">Mã hóa đơn: #INV-${booking.bookingID}</p>
            </div>

            <!-- Customer and Booking Info -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <h6 class="text-uppercase text-muted mb-3">Thông Tin Khách Hàng</h6>
                    <p class="mb-1"><strong>Họ tên:</strong> ${booking.customer.fullName}</p>
                    <p class="mb-1"><strong>Số điện thoại:</strong> ${booking.customer.phone}</p>
                    <p class="mb-1"><strong>Email:</strong> ${booking.customer.email}</p>
                    <c:if test="${not empty booking.customer.address}">
                        <p class="mb-1"><strong>Địa chỉ:</strong> ${booking.customer.address}</p>
                    </c:if>
                </div>
                <div class="col-md-6 text-end">
                    <h6 class="text-uppercase text-muted mb-3">Thông Tin Booking</h6>
                    <p class="mb-1"><strong>Mã booking:</strong> #${booking.bookingID}</p>
                    <p class="mb-1"><strong>Phòng:</strong> ${booking.room.roomNumber}</p>
                    <p class="mb-1"><strong>Loại phòng:</strong> ${booking.room.roomType.typeName}</p>
                    <p class="mb-1">
                        <strong>Check-in:</strong> 
                        <fmt:formatDate value="${booking.actualCheckInDate}" pattern="dd/MM/yyyy HH:mm"/>
                    </p>
                    <p class="mb-1">
                        <strong>Check-out:</strong> 
                        <fmt:formatDate value="${booking.actualCheckOutDate}" pattern="dd/MM/yyyy HH:mm"/>
                    </p>
                </div>
            </div>

            <!-- Invoice Details -->
            <div class="table-responsive mb-4">
                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>Mô tả</th>
                            <th class="text-center">Số lượng</th>
                            <th class="text-end">Đơn giá</th>
                            <th class="text-end">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <strong>Tiền phòng</strong><br>
                                <small class="text-muted">
                                    ${booking.room.roomType.typeName} - ${booking.room.roomNumber}
                                </small>
                            </td>
                            <td class="text-center">${booking.nights} đêm</td>
                            <td class="text-end">
                                <fmt:formatNumber value="${booking.room.roomType.pricePerNight}" type="currency" currencySymbol="₫"/>
                            </td>
                            <td class="text-end">
                                <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫"/>
                            </td>
                        </tr>

                        <c:if test="${servicesTotal > 0}">
                            <tr>
                                <td colspan="4" class="table-active">
                                    <strong>Dịch vụ bổ sung</strong>
                                </td>
                            </tr>
                            <c:forEach var="bs" items="${booking.bookingServices}">
                                <tr>
                                    <td>
                                        ${bs.service.serviceName}<br>
                                        <small class="text-muted">${bs.service.category}</small>
                                    </td>
                                    <td class="text-center">${bs.quantity} ${bs.service.unit}</td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${bs.unitPrice}" type="currency" currencySymbol="₫"/>
                                    </td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${bs.totalPrice}" type="currency" currencySymbol="₫"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Payment Summary -->
            <div class="row">
                <div class="col-md-6 offset-md-6">
                    <table class="table table-sm">
                        <tr>
                            <td><strong>Tổng tiền phòng:</strong></td>
                            <td class="text-end">
                                <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫"/>
                            </td>
                        </tr>
                        <c:if test="${servicesTotal > 0}">
                            <tr>
                                <td><strong>Tổng dịch vụ:</strong></td>
                                <td class="text-end">
                                    <fmt:formatNumber value="${servicesTotal}" type="currency" currencySymbol="₫"/>
                                </td>
                            </tr>
                        </c:if>
                        <tr class="table-active">
                            <td><strong>Tổng cộng:</strong></td>
                            <td class="text-end">
                                <strong><fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/></strong>
                            </td>
                        </tr>
                        <tr class="text-success">
                            <td>Đã thanh toán (đặt cọc):</td>
                            <td class="text-end">
                                -<fmt:formatNumber value="${booking.depositAmount}" type="currency" currencySymbol="₫"/>
                            </td>
                        </tr>
                        <tr class="table-primary">
                            <td><strong>Còn phải thanh toán:</strong></td>
                            <td class="text-end">
                                <strong><fmt:formatNumber value="${remainingAmount}" type="currency" currencySymbol="₫"/></strong>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <!-- Footer -->
            <div class="text-center mt-5 pt-4 border-top">
                <p class="text-muted mb-1">Cảm ơn quý khách đã sử dụng dịch vụ của Aurora Hotel!</p>
                <p class="text-muted mb-0">Hẹn gặp lại quý khách trong những lần tiếp theo.</p>
            </div>

            <!-- Signatures -->
            <div class="row mt-5 pt-4">
                <div class="col-md-6 text-center">
                    <p class="mb-5"><strong>Khách hàng</strong></p>
                    <p class="text-muted">(Ký và ghi rõ họ tên)</p>
                </div>
                <div class="col-md-6 text-center">
                    <p class="mb-5"><strong>Nhân viên thu ngân</strong></p>
                    <p class="text-muted">(Ký và ghi rõ họ tên)</p>
                </div>
            </div>
        </div>
    </div>
</main>

<style>
@media print {
    .navbar, .btn, footer {
        display: none !important;
    }
    .container {
        max-width: 100% !important;
    }
}
</style>

<jsp:include page="../common/footer.jsp"/>

