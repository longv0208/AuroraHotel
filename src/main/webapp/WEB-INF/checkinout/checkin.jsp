<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Check-in - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-sign-in-alt text-success me-2"></i>
            Check-in
        </h1>
        <a href="${pageContext.request.contextPath}/booking?view=details&id=${booking.bookingID}" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>
            Quay Lại
        </a>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>
            ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-info-circle me-2"></i>
                        Xác Nhận Check-in
                    </h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        Vui lòng kiểm tra thông tin booking trước khi xác nhận check-in.
                    </div>

                    <h6 class="mb-3">Thông tin booking:</h6>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Mã booking:</strong><br>
                            #${booking.bookingID}
                        </div>
                        <div class="col-md-6">
                            <strong>Khách hàng:</strong><br>
                            ${booking.customer.fullName}
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Phòng:</strong><br>
                            ${booking.room.roomNumber} - ${booking.room.roomType.typeName}
                        </div>
                        <div class="col-md-6">
                            <strong>Số khách:</strong><br>
                            ${booking.numberOfGuests} người
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Check-in dự kiến:</strong><br>
                            ${booking.checkInDate}
                        </div>
                        <div class="col-md-6">
                            <strong>Check-out dự kiến:</strong><br>
                            ${booking.checkOutDate}
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Tổng tiền:</strong><br>
                            <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫"/>
                        </div>
                        <div class="col-md-6">
                            <strong>Đã đặt cọc:</strong><br>
                            <fmt:formatNumber value="${booking.depositAmount}" type="currency" currencySymbol="₫"/>
                        </div>
                    </div>

                    <hr>

                    <form method="post" action="${pageContext.request.contextPath}/checkinout">
                        <input type="hidden" name="action" value="checkin">
                        <input type="hidden" name="bookingId" value="${booking.bookingID}">

                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Lưu ý:</strong> Sau khi check-in, trạng thái booking sẽ chuyển sang "Đang sử dụng" 
                            và phòng sẽ được đánh dấu là "Đang sử dụng".
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="fas fa-check me-2"></i>
                                Xác Nhận Check-in
                            </button>
                            <a href="${pageContext.request.contextPath}/booking?view=details&id=${booking.bookingID}" 
                               class="btn btn-outline-secondary btn-lg">
                                <i class="fas fa-times me-2"></i>
                                Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-user me-2"></i>
                        Thông Tin Khách Hàng
                    </h5>
                </div>
                <div class="card-body">
                    <p class="mb-2">
                        <strong>Họ tên:</strong><br>
                        ${booking.customer.fullName}
                    </p>
                    <p class="mb-2">
                        <strong>Số điện thoại:</strong><br>
                        ${booking.customer.phone}
                    </p>
                    <p class="mb-2">
                        <strong>Email:</strong><br>
                        ${booking.customer.email}
                    </p>
                    <c:if test="${not empty booking.customer.idCard}">
                        <p class="mb-2">
                            <strong>CMND/CCCD:</strong><br>
                            ${booking.customer.idCard}
                        </p>
                    </c:if>
                    <c:if test="${not empty booking.customer.address}">
                        <p class="mb-0">
                            <strong>Địa chỉ:</strong><br>
                            ${booking.customer.address}
                        </p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>

