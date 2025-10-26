<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="Kết Quả Tìm Kiếm - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<style>
    .room-result-card {
        border-radius: 15px;
        overflow: hidden;
        transition: all 0.3s;
        border: 1px solid #eee;
    }

    .room-result-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    }

    .room-image-placeholder {
        width: 100%;
        height: 250px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 80px;
    }

    .search-summary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 30px;
    }

    .price-tag {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 10px;
        text-align: center;
    }

    .amenity-badge {
        display: inline-block;
        padding: 5px 10px;
        background: #f0f0f0;
        border-radius: 5px;
        margin: 3px;
        font-size: 12px;
    }
</style>

<main class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-search text-primary me-2"></i>
            Kết Quả Tìm Kiếm
        </h1>
        <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>
            Tìm Lại
        </a>
    </div>

    <!-- Search Summary -->
    <div class="search-summary">
        <div class="row align-items-center">
            <div class="col-md-8">
                <div class="d-flex align-items-center flex-wrap">
                    <div class="me-4 mb-2">
                        <i class="fas fa-calendar-alt me-2"></i>
                        <strong>Check-in:</strong> ${checkInDate}
                    </div>
                    <div class="me-4 mb-2">
                        <i class="fas fa-calendar-check me-2"></i>
                        <strong>Check-out:</strong> ${checkOutDate}
                    </div>
                    <div class="mb-2">
                        <i class="fas fa-users me-2"></i>
                        <strong>Số khách:</strong> ${param.guests != null ? param.guests : 2} người
                    </div>
                </div>
            </div>
            <div class="col-md-4 text-md-end">
                <h5 class="mb-0">
                    <i class="fas fa-check-circle me-2"></i>
                    Tìm thấy <span class="fw-bold">${availableRooms != null ? availableRooms.size() : 0}</span> phòng
                </h5>
            </div>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty availableRooms}">
            <div class="text-center py-5">
                <div class="mb-4">
                    <i class="fas fa-bed" style="font-size: 80px; color: #ddd;"></i>
                </div>
                <h3>Không tìm thấy phòng phù hợp</h3>
                <p class="text-muted">Không có phòng trống trong khoảng thời gian bạn chọn.</p>
                <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-primary btn-lg mt-3">
                    <i class="fas fa-search me-2"></i>
                    Tìm Kiếm Lại
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach var="room" items="${availableRooms}">
                    <div class="col-12">
                        <div class="room-result-card">
                            <div class="card-body p-4">
                                <div class="row">
                                    <!-- Room Image -->
                                    <div class="col-md-4">
                                        <div class="room-image-placeholder rounded">
                                            <i class="fas fa-hotel"></i>
                                        </div>
                                    </div>

                                    <!-- Room Info -->
                                    <div class="col-md-5">
                                        <div class="mb-2">
                                            <h4 class="mb-1">Phòng ${room.roomNumber}</h4>
                                            <span class="badge bg-success">Còn trống</span>
                                        </div>

                                        <h5 class="text-primary mb-3">${room.roomType.typeName}</h5>

                                        <div class="mb-3">
                                            <div class="d-flex align-items-center mb-2">
                                                <i class="fas fa-users text-primary me-2" style="width: 20px;"></i>
                                                <span>Tối đa ${room.roomType.maxGuests} người</span>
                                            </div>
                                            <div class="d-flex align-items-center mb-2">
                                                <i class="fas fa-building text-primary me-2" style="width: 20px;"></i>
                                                <span>Tầng ${room.floor}</span>
                                            </div>
                                            <c:if test="${not empty room.description}">
                                                <div class="d-flex align-items-start mb-2">
                                                    <i class="fas fa-info-circle text-primary me-2 mt-1" style="width: 20px;"></i>
                                                    <span class="text-muted small">${room.description}</span>
                                                </div>
                                            </c:if>
                                        </div>

                                        <c:if test="${not empty room.roomType.amenities}">
                                            <div>
                                                <strong class="small text-muted">Tiện nghi:</strong>
                                                <div class="mt-2">
                                                    <c:forEach var="amenity" items="${fn:split(room.roomType.amenities, ',')}">
                                                        <span class="amenity-badge">${amenity.trim()}</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Pricing & Booking -->
                                    <div class="col-md-3">
                                        <div class="price-tag mb-3">
                                            <div class="text-muted small mb-2">Giá mỗi đêm</div>
                                            <h3 class="text-primary mb-0">
                                                <fmt:formatNumber value="${room.roomType.basePrice}" type="number" groupingUsed="true"/>₫
                                            </h3>
                                        </div>

                                        <div class="d-grid gap-2">
                                            <a href="${pageContext.request.contextPath}/booking?view=create&roomId=${room.roomID}&checkInDate=${checkInDate}&checkOutDate=${checkOutDate}&guests=${param.guests != null ? param.guests : 2}"
                                               class="btn btn-primary btn-lg">
                                                <i class="fas fa-calendar-check me-2"></i>
                                                Đặt Phòng Ngay
                                            </a>

                                            <a href="${pageContext.request.contextPath}/room?view=detail&id=${room.roomID}"
                                               class="btn btn-outline-primary">
                                                <i class="fas fa-eye me-2"></i>
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
