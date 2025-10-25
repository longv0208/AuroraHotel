<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Kết Quả Tìm Kiếm - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
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

    <div class="row mb-3">
        <div class="col-md-8">
            <div class="alert alert-info">
                <i class="fas fa-calendar me-2"></i>
                <strong>Check-in:</strong> <fmt:formatDate value="${checkInDate}" pattern="dd/MM/yyyy"/>
                <span class="mx-3">|</span>
                <strong>Check-out:</strong> <fmt:formatDate value="${checkOutDate}" pattern="dd/MM/yyyy"/>
                <span class="mx-3">|</span>
                <strong>Khách:</strong> ${guests} người
            </div>
        </div>
        <div class="col-md-4 text-end">
            <span class="text-muted">Tìm thấy ${availableRooms.size()} phòng</span>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty availableRooms}">
            <div class="alert alert-warning text-center py-5">
                <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                <h4>Không tìm thấy phòng phù hợp</h4>
                <p>Không có phòng trống trong khoảng thời gian bạn chọn.</p>
                <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-primary">
                    <i class="fas fa-search me-2"></i>
                    Tìm Kiếm Lại
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row row-cols-1 g-4">
                <c:forEach var="room" items="${availableRooms}">
                    <div class="col">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4">
                                        <c:choose>
                                            <c:when test="${not empty room.images}">
                                                <img src="${room.images[0].imageURL}" class="img-fluid rounded" alt="Phòng ${room.roomNumber}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="bg-light rounded d-flex align-items-center justify-content-center" style="height: 200px;">
                                                    <i class="fas fa-image fa-3x text-muted"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <div class="col-md-5">
                                        <h5 class="card-title">
                                            Phòng ${room.roomNumber}
                                            <span class="badge bg-success ms-2">Có sẵn</span>
                                        </h5>
                                        <p class="text-muted mb-2">${room.roomType.typeName}</p>
                                        
                                        <div class="mb-2">
                                            <i class="fas fa-users text-primary me-2"></i>
                                            <span>Tối đa ${room.roomType.maxOccupancy} khách</span>
                                        </div>
                                        
                                        <div class="mb-2">
                                            <i class="fas fa-bed text-info me-2"></i>
                                            <span>${room.roomType.bedType}</span>
                                        </div>
                                        
                                        <div class="mb-2">
                                            <i class="fas fa-expand-arrows-alt text-success me-2"></i>
                                            <span>${room.roomType.roomSize} m²</span>
                                        </div>

                                        <c:if test="${not empty room.roomType.amenities}">
                                            <div class="mb-2">
                                                <i class="fas fa-star text-warning me-2"></i>
                                                <span>${room.roomType.amenities}</span>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <div class="col-md-3 text-end">
                                        <div class="mb-3">
                                            <h4 class="text-primary mb-0">
                                                <fmt:formatNumber value="${room.roomType.pricePerNight}" type="currency" currencySymbol="₫"/>
                                            </h4>
                                            <small class="text-muted">/đêm</small>
                                        </div>
                                        
                                        <div class="d-grid">
                                            <a href="${pageContext.request.contextPath}/booking?view=create&roomId=${room.roomID}&checkInDate=${checkInDate}&checkOutDate=${checkOutDate}&guests=${guests}" 
                                               class="btn btn-primary">
                                                <i class="fas fa-calendar-plus me-2"></i>
                                                Đặt Phòng
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
