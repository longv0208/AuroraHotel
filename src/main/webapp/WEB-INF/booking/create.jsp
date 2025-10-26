<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Đặt Phòng - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-calendar-plus text-primary me-2"></i>
            Đặt Phòng
        </h1>
        <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-outline-secondary">
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
                        Thông Tin Đặt Phòng
                    </h5>
                </div>
                <div class="card-body">
                    <!-- User Status Alert -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <!-- Logged-in User -->
                            <div class="alert alert-info alert-dismissible fade show" role="alert" id="userStatusAlert">
                                <i class="fas fa-user-check me-2"></i>
                                Đặt phòng cho: <strong>${sessionScope.loggedInUser.fullName}</strong>
                                <button type="button" class="btn btn-sm btn-outline-primary ms-3" onclick="toggleBookForOther()">
                                    <i class="fas fa-user-plus me-1"></i>
                                    <span id="toggleBtnText">Đặt cho người khác</span>
                                </button>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Guest User -->
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                <i class="fas fa-info-circle me-2"></i>
                                Bạn đang đặt phòng như khách.
                                <a href="${pageContext.request.contextPath}/register" class="alert-link fw-bold">
                                    Đăng ký tài khoản
                                </a>
                                để quản lý booking dễ hơn!
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/booking" id="bookingForm">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="roomID" value="${room.roomID}">
                        <input type="hidden" name="checkInDate" value="${checkInDate}">
                        <input type="hidden" name="checkOutDate" value="${checkOutDate}">
                        <input type="hidden" name="numberOfGuests" value="${param.guests != null ? param.guests : 1}">
                        <input type="hidden" name="totalAmount" value="${totalAmount}">

                        <!-- Hidden field to track if booking for self -->
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser}">
                                <input type="hidden" name="bookingForSelf" id="bookingForSelf" value="true">
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="bookingForSelf" value="false">
                            </c:otherwise>
                        </c:choose>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Họ tên khách hàng <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" id="fullName" class="form-control" required
                                       pattern="[a-zA-ZÀ-ỹ\s]+"
                                       title="Vui lòng nhập tên hợp lệ (chỉ chữ cái)"
                                       value="${sessionScope.loggedInUser.fullName}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="tel" name="phone" id="phone" class="form-control" required
                                       pattern="0[0-9]{9,10}"
                                       title="Số điện thoại phải bắt đầu bằng 0 và có 10-11 số"
                                       value="${sessionScope.loggedInUser.phone}">
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" id="email" class="form-control"
                                       title="Vui lòng nhập email hợp lệ"
                                       value="${sessionScope.loggedInUser.email}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">CMND/CCCD</label>
                                <input type="text" name="idCard" id="idCard" class="form-control"
                                       pattern="[0-9]{9,12}"
                                       title="CMND/CCCD phải có 9-12 chữ số">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Địa chỉ</label>
                            <textarea name="address" id="address" class="form-control" rows="2"></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Ghi chú đặc biệt</label>
                            <textarea name="notes" class="form-control" rows="2"
                                      placeholder="Yêu cầu đặc biệt (tầng cao, giường đôi, v.v...)"></textarea>
                        </div>

                        <!-- Additional Services Section -->
                        <c:if test="${not empty availableServices}">
                            <div class="mb-4">
                                <h6 class="mb-3">
                                    <i class="fas fa-concierge-bell me-2"></i>
                                    Dịch Vụ Bổ Sung (Tùy Chọn)
                                </h6>
                                <div class="row">
                                    <c:forEach var="service" items="${availableServices}">
                                        <div class="col-md-6 mb-3">
                                            <div class="card h-100">
                                                <div class="card-body">
                                                    <div class="form-check">
                                                        <input class="form-check-input service-checkbox"
                                                               type="checkbox"
                                                               name="selectedServices"
                                                               value="${service.serviceID}"
                                                               id="service_${service.serviceID}"
                                                               data-price="${service.price}">
                                                        <label class="form-check-label" for="service_${service.serviceID}">
                                                            <strong>${service.serviceName}</strong>
                                                            <br>
                                                            <small class="text-muted">${service.category}</small>
                                                            <br>
                                                            <span class="text-primary">
                                                                <fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫"/>
                                                                / ${service.unit}
                                                            </span>
                                                        </label>
                                                    </div>
                                                    <div class="mt-2 quantity-input" id="quantity_container_${service.serviceID}" style="display: none;">
                                                        <label class="form-label small">Số lượng:</label>
                                                        <input type="number"
                                                               name="quantity_${service.serviceID}"
                                                               class="form-control form-control-sm service-quantity"
                                                               min="1"
                                                               value="1"
                                                               data-service-id="${service.serviceID}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- Coupon Section -->
                        <div class="mb-4">
                            <h6 class="mb-3">
                                <i class="fas fa-ticket-alt me-2"></i>
                                Mã Giảm Giá (Tùy Chọn)
                            </h6>
                            <div class="row">
                                <div class="col-md-8">
                                    <input type="text"
                                           name="couponCode"
                                           id="couponCodeInput"
                                           class="form-control"
                                           placeholder="Nhập mã giảm giá"
                                           style="text-transform: uppercase;">
                                </div>
                                <div class="col-md-4">
                                    <button type="button" class="btn btn-outline-success w-100" id="validateCouponBtn">
                                        <i class="fas fa-check me-1"></i>
                                        Áp Dụng
                                    </button>
                                </div>
                            </div>
                            <div id="couponMessage" class="mt-2"></div>
                            <div id="couponDetails" class="mt-2 alert alert-success" style="display: none;">
                                <i class="fas fa-check-circle me-2"></i>
                                <span id="couponDetailsText"></span>
                            </div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-calendar-check me-2"></i>
                                Xác Nhận Đặt Phòng
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
                        <i class="fas fa-bed me-2"></i>
                        Thông Tin Phòng
                    </h5>
                </div>
                <div class="card-body">
                    <h6>Phòng ${room.roomNumber}</h6>
                    <p class="text-muted">${room.roomType.typeName}</p>

                    <div class="mb-3">
                        <strong>Check-in:</strong><br>
                        ${checkInDate}
                    </div>

                    <div class="mb-3">
                        <strong>Check-out:</strong><br>
                        ${checkOutDate}
                    </div>

                    <div class="mb-3">
                        <strong>Số khách:</strong><br>
                        ${param.guests != null ? param.guests : 1} người
                    </div>

                    <div class="mb-3">
                        <strong>Số đêm:</strong><br>
                        ${numberOfNights} đêm
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between mb-2">
                        <span>Giá phòng/đêm:</span>
                        <span><fmt:formatNumber value="${room.roomType.basePrice}" type="number" groupingUsed="true"/>₫</span>
                    </div>

                    <div class="d-flex justify-content-between mb-2">
                        <span>Số đêm:</span>
                        <span>${numberOfNights} đêm</span>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between mb-3">
                        <strong>Tổng cộng:</strong>
                        <strong class="text-primary"><fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true"/>₫</strong>
                    </div>

                    <small class="text-muted">
                        <i class="fas fa-info-circle"></i>
                        Giá chưa bao gồm dịch vụ bổ sung
                    </small>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
// Toggle quantity input when service checkbox is checked
document.querySelectorAll('.service-checkbox').forEach(checkbox => {
    checkbox.addEventListener('change', function() {
        const serviceId = this.value;
        const quantityContainer = document.getElementById('quantity_container_' + serviceId);

        if (this.checked) {
            quantityContainer.style.display = 'block';
        } else {
            quantityContainer.style.display = 'none';
        }
    });
});

// Validate coupon
document.getElementById('validateCouponBtn').addEventListener('click', function() {
    const couponCode = document.getElementById('couponCodeInput').value.trim().toUpperCase();
    const totalAmount = ${totalAmount};
    const roomTypeID = ${room.roomTypeID};

    if (!couponCode) {
        showCouponMessage('Vui lòng nhập mã giảm giá', 'error');
        return;
    }

    // Show loading
    this.disabled = true;
    this.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Đang kiểm tra...';

    // Call AJAX to validate coupon
    fetch('${pageContext.request.contextPath}/booking?action=validateCoupon', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'couponCode=' + encodeURIComponent(couponCode) +
              '&totalAmount=' + totalAmount +
              '&roomTypeID=' + roomTypeID
    })
    .then(response => response.json())
    .then(data => {
        this.disabled = false;
        this.innerHTML = '<i class="fas fa-check me-1"></i> Áp Dụng';

        if (data.valid) {
            showCouponSuccess(data);
        } else {
            showCouponMessage(data.message || 'Mã giảm giá không hợp lệ', 'error');
        }
    })
    .catch(error => {
        this.disabled = false;
        this.innerHTML = '<i class="fas fa-check me-1"></i> Áp Dụng';
        showCouponMessage('Lỗi khi kiểm tra mã giảm giá', 'error');
        console.error('Error:', error);
    });
});

function showCouponMessage(message, type) {
    const messageDiv = document.getElementById('couponMessage');
    const detailsDiv = document.getElementById('couponDetails');

    detailsDiv.style.display = 'none';

    if (type === 'error') {
        messageDiv.innerHTML = '<div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>' + message + '</div>';
    } else {
        messageDiv.innerHTML = '<div class="alert alert-info">' + message + '</div>';
    }
}

function showCouponSuccess(data) {
    const messageDiv = document.getElementById('couponMessage');
    const detailsDiv = document.getElementById('couponDetails');
    const detailsText = document.getElementById('couponDetailsText');

    messageDiv.innerHTML = '';

    let discountText = '';
    if (data.discountType === 'Percent') {
        discountText = 'Giảm ' + data.discountValue + '% (Tối đa: ' + formatCurrency(data.maxDiscountAmount || data.discountAmount) + ')';
    } else {
        discountText = 'Giảm ' + formatCurrency(data.discountAmount);
    }

    detailsText.innerHTML = '<strong>' + data.couponCode + '</strong>: ' + discountText +
                           '<br><small>' + data.description + '</small>';
    detailsDiv.style.display = 'block';
}

function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
}

// Auto uppercase coupon code
document.getElementById('couponCodeInput').addEventListener('input', function() {
    this.value = this.value.toUpperCase();
});

// Toggle booking for self or for other
function toggleBookForOther() {
    const bookingForSelfInput = document.getElementById('bookingForSelf');
    const toggleBtn = document.getElementById('toggleBtnText');
    const fullNameInput = document.getElementById('fullName');
    const phoneInput = document.getElementById('phone');
    const emailInput = document.getElementById('email');

    if (bookingForSelfInput.value === 'true') {
        // Switch to booking for others
        bookingForSelfInput.value = 'false';
        toggleBtn.textContent = 'Đặt cho chính mình';

        // Clear pre-filled values
        fullNameInput.value = '';
        phoneInput.value = '';
        emailInput.value = '';

        // Enable all fields
        fullNameInput.removeAttribute('readonly');
        phoneInput.removeAttribute('readonly');
        emailInput.removeAttribute('readonly');
    } else {
        // Switch back to booking for self
        bookingForSelfInput.value = 'true';
        toggleBtn.textContent = 'Đặt cho người khác';

        // Restore user info
        <c:if test="${not empty sessionScope.loggedInUser}">
        fullNameInput.value = '${sessionScope.loggedInUser.fullName}';
        phoneInput.value = '${sessionScope.loggedInUser.phone}';
        emailInput.value = '${sessionScope.loggedInUser.email}' || '';
        </c:if>
    }
}
</script>

<jsp:include page="../common/footer.jsp"/>
