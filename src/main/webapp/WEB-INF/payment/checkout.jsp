<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Thanh Toán Checkout - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-credit-card text-primary me-2"></i>
            Thanh Toán Checkout
        </h1>
        <a href="${pageContext.request.contextPath}/booking?view=details&id=${booking.bookingID}" class="btn btn-outline-secondary">
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
                        Thông Tin Thanh Toán
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/payment">
                        <input type="hidden" name="action" value="checkout">
                        <input type="hidden" name="bookingId" value="${booking.bookingID}">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Mã booking</label>
                                <input type="text" class="form-control" value="#${booking.bookingID}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số tiền còn lại</label>
                                <input type="text" class="form-control" value="<fmt:formatNumber value="${remainingAmount}" type="currency" currencySymbol="₫"/>" readonly>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Phương thức thanh toán</label>
                                <select name="paymentMethod" class="form-select" required>
                                    <option value="">Chọn phương thức</option>
                                    <option value="Tiền mặt">Tiền mặt</option>
                                    <option value="Chuyển khoản">Chuyển khoản</option>
                                    <option value="Thẻ tín dụng">Thẻ tín dụng</option>
                                    <option value="Ví điện tử">Ví điện tử</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số tham chiếu</label>
                                <input type="text" name="referenceNumber" class="form-control" placeholder="Mã giao dịch, số thẻ...">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Ghi chú</label>
                            <textarea name="notes" class="form-control" rows="3" placeholder="Ghi chú về giao dịch..."></textarea>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-credit-card me-2"></i>
                                Xác Nhận Thanh Toán
                            </button>
                        </div>
                    </form>
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
                        <span>Tổng tiền booking:</span>
                        <span><fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫"/></span>
                    </div>
                    
                    <div class="d-flex justify-content-between mb-2 text-success">
                        <span>Đã thanh toán:</span>
                        <span><fmt:formatNumber value="${paidAmount}" type="currency" currencySymbol="₫"/></span>
                    </div>
                    
                    <hr>
                    
                    <div class="d-flex justify-content-between">
                        <strong>Còn lại:</strong>
                        <strong class="text-primary">
                            <fmt:formatNumber value="${remainingAmount}" type="currency" currencySymbol="₫"/>
                        </strong>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm mt-3">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-info-circle me-2"></i>
                        Thông Tin Booking
                    </h5>
                </div>
                <div class="card-body">
                    <div class="mb-2">
                        <strong>Phòng:</strong><br>
                        ${booking.room.roomNumber} - ${booking.room.roomType.typeName}
                    </div>
                    
                    <div class="mb-2">
                        <strong>Check-in:</strong><br>
                        ${booking.checkInDate}
                    </div>
                    
                    <div class="mb-2">
                        <strong>Check-out:</strong><br>
                        ${booking.checkOutDate}
                    </div>
                    
                    <div class="mb-0">
                        <strong>Khách hàng:</strong><br>
                        ${booking.customer.fullName}
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>

