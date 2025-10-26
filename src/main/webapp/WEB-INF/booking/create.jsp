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
                    <form method="post" action="${pageContext.request.contextPath}/booking">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="roomId" value="${room.roomID}">
                        <input type="hidden" name="checkInDate" value="${checkInDate}">
                        <input type="hidden" name="checkOutDate" value="${checkOutDate}">
                        <input type="hidden" name="guests" value="${guests}">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Họ tên khách hàng</label>
                                <input type="text" name="customerName" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" name="customerPhone" class="form-control" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" name="customerEmail" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">CMND/CCCD</label>
                                <input type="text" name="customerIdCard" class="form-control">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Địa chỉ</label>
                            <textarea name="customerAddress" class="form-control" rows="2"></textarea>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Quốc tịch</label>
                                <input type="text" name="customerNationality" class="form-control" value="Việt Nam">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ghi chú đặc biệt</label>
                                <textarea name="specialRequests" class="form-control" rows="2" placeholder="Yêu cầu đặc biệt..."></textarea>
                            </div>
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
                        <fmt:formatDate value="${checkInDate}" pattern="dd/MM/yyyy"/>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Check-out:</strong><br>
                        <fmt:formatDate value="${checkOutDate}" pattern="dd/MM/yyyy"/>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Số khách:</strong><br>
                        ${guests} người
                    </div>
                    
                    <div class="mb-3">
                        <strong>Số đêm:</strong><br>
                        ${nights} đêm
                    </div>
                    
                    <hr>
                    
                    <div class="d-flex justify-content-between">
                        <span>Giá/đêm:</span>
                        <span><fmt:formatNumber value="${room.roomType.pricePerNight}" type="currency" currencySymbol="₫"/></span>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <span>Tổng cộng:</span>
                        <strong><fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="₫"/></strong>
                    </div>
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
</script>

<jsp:include page="../common/footer.jsp"/>
