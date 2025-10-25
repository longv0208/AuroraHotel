<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Lịch Sử Thanh Toán - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-history text-primary me-2"></i>
            Lịch Sử Thanh Toán
        </h1>
        <a href="${pageContext.request.contextPath}/booking?view=my-bookings" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>
            Quay Lại
        </a>
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
            <form method="get" action="${pageContext.request.contextPath}/payment">
                <input type="hidden" name="view" value="history">
                <div class="row">
                    <div class="col-md-3">
                        <label class="form-label">Loại thanh toán</label>
                        <select name="paymentType" class="form-select">
                            <option value="">Tất cả loại</option>
                            <option value="Deposit" ${param.paymentType == 'Deposit' ? 'selected' : ''}>Cọc</option>
                            <option value="Checkout" ${param.paymentType == 'Checkout' ? 'selected' : ''}>Checkout</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Phương thức</label>
                        <select name="paymentMethod" class="form-select">
                            <option value="">Tất cả phương thức</option>
                            <option value="Tiền mặt" ${param.paymentMethod == 'Tiền mặt' ? 'selected' : ''}>Tiền mặt</option>
                            <option value="Chuyển khoản" ${param.paymentMethod == 'Chuyển khoản' ? 'selected' : ''}>Chuyển khoản</option>
                            <option value="Thẻ tín dụng" ${param.paymentMethod == 'Thẻ tín dụng' ? 'selected' : ''}>Thẻ tín dụng</option>
                            <option value="Ví điện tử" ${param.paymentMethod == 'Ví điện tử' ? 'selected' : ''}>Ví điện tử</option>
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
                </div>
                <div class="row mt-3">
                    <div class="col-md-12">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-2"></i>
                            Lọc
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty payments}">
            <div class="alert alert-info text-center py-5">
                <i class="fas fa-credit-card fa-3x mb-3"></i>
                <h4>Không có giao dịch nào</h4>
                <p>Không tìm thấy giao dịch nào phù hợp với bộ lọc.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row row-cols-1 g-4">
                <c:forEach var="payment" items="${payments}">
                    <div class="col">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <div>
                                                <h5 class="card-title mb-1">
                                                    Giao dịch #${payment.paymentID}
                                                    <c:choose>
                                                        <c:when test="${payment.paymentType == 'Deposit'}">
                                                            <span class="badge bg-warning text-dark ms-2">Cọc</span>
                                                        </c:when>
                                                        <c:when test="${payment.paymentType == 'Checkout'}">
                                                            <span class="badge bg-success ms-2">Checkout</span>
                                                        </c:when>
                                                    </c:choose>
                                                </h5>
                                                <p class="text-muted small mb-0">
                                                    <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <i class="fas fa-credit-card text-primary me-2"></i>
                                                <strong>Phương thức:</strong> ${payment.paymentMethod}
                                            </div>
                                            <div class="col-md-6">
                                                <i class="fas fa-bed text-success me-2"></i>
                                                <strong>Booking:</strong> #${payment.booking.bookingID}
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <i class="fas fa-user text-info me-2"></i>
                                                <strong>Khách hàng:</strong> ${payment.booking.customer.fullName}
                                            </div>
                                            <div class="col-md-6">
                                                <i class="fas fa-door-open text-warning me-2"></i>
                                                <strong>Phòng:</strong> ${payment.booking.room.roomNumber}
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-4 border-start">
                                        <div class="text-center mb-3">
                                            <small class="text-muted">Số tiền</small>
                                            <h4 class="text-primary mb-0">
                                                <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₫"/>
                                            </h4>
                                        </div>

                                        <div class="d-grid">
                                            <a href="${pageContext.request.contextPath}/payment?view=confirmation&id=${payment.paymentID}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye me-1"></i>
                                                Xem Chi Tiết
                                            </a>
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
