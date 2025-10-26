<%@ page language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="Chi Tiết Phòng - Aurora Hotel" scope="request" />
            <%@include file="../common/head.jsp" %>
                <%@include file="../common/navbar.jsp" %>

                    <style>
                        .room-detail-card {
                            background: white;
                            border-radius: 15px;
                            padding: 30px;
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                        }

                        .room-image-large {
                            width: 100%;
                            height: 400px;
                            object-fit: cover;
                            border-radius: 10px;
                            margin-bottom: 20px;
                        }

                        .room-info-grid {
                            display: grid;
                            grid-template-columns: repeat(2, 1fr);
                            gap: 15px;
                            margin-bottom: 20px;
                        }

                        .info-item {
                            padding: 15px;
                            background: #f8f9fa;
                            border-radius: 8px;
                        }

                        .info-label {
                            font-weight: 600;
                            color: #666;
                            font-size: 14px;
                            margin-bottom: 5px;
                        }

                        .info-value {
                            font-size: 18px;
                            color: #333;
                        }

                        .price-box {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                            padding: 20px;
                            border-radius: 10px;
                            text-align: center;
                            margin-bottom: 20px;
                        }

                        .price-amount {
                            font-size: 36px;
                            font-weight: 700;
                        }

                        .amenities-list {
                            list-style: none;
                            padding: 0;
                        }

                        .amenities-list li {
                            padding: 10px;
                            border-bottom: 1px solid #eee;
                        }

                        .amenities-list li:last-child {
                            border-bottom: none;
                        }
                    </style>

                    <main class="container py-5">
                        <c:if test="${not empty room}">
                            <div class="row">
                                <div class="col-lg-8">
                                    <div class="room-detail-card">
                                        <h1 class="mb-4">Phòng ${room.roomNumber}</h1>

                                        <img src="${pageContext.request.contextPath}/images/rooms/${room.roomID}.jpg"
                                            alt="${room.roomType}" class="room-image-large"
                                            onerror="this.src='${pageContext.request.contextPath}/images/default-room.jpg'">

                                        <div class="room-info-grid">
                                            <div class="info-item">
                                                <div class="info-label">Loại Phòng</div>
                                                <div class="info-value">
                                                    <i class="fas fa-door-open text-primary"></i> ${room.roomType}
                                                </div>
                                            </div>

                                            <div class="info-item">
                                                <div class="info-label">Sức Chứa</div>
                                                <div class="info-value">
                                                    <i class="fas fa-users text-primary"></i> ${room.capacity} người
                                                </div>
                                            </div>

                                            <div class="info-item">
                                                <div class="info-label">Tầng</div>
                                                <div class="info-value">
                                                    <i class="fas fa-building text-primary"></i> Tầng ${room.floor}
                                                </div>
                                            </div>

                                            <div class="info-item">
                                                <div class="info-label">Trạng Thái</div>
                                                <div class="info-value">
                                                    <c:choose>
                                                        <c:when test="${room.status == 'Available'}">
                                                            <span class="badge bg-success">Còn Trống</span>
                                                        </c:when>
                                                        <c:when test="${room.status == 'Occupied'}">
                                                            <span class="badge bg-danger">Đã Đặt</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning">Bảo Trì</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <h4 class="mt-4 mb-3">Tiện Nghi</h4>
                                        <ul class="amenities-list">
                                            <li><i class="fas fa-wifi text-primary"></i> WiFi miễn phí</li>
                                            <li><i class="fas fa-tv text-primary"></i> TV màn hình phẳng</li>
                                            <li><i class="fas fa-snowflake text-primary"></i> Điều hòa nhiệt độ</li>
                                            <li><i class="fas fa-bath text-primary"></i> Phòng tắm riêng</li>
                                            <li><i class="fas fa-coffee text-primary"></i> Minibar</li>
                                            <li><i class="fas fa-concierge-bell text-primary"></i> Dịch vụ phòng 24/7
                                            </li>
                                        </ul>
                                    </div>
                                </div>

                                <div class="col-lg-4">
                                    <div class="room-detail-card">
                                        <div class="price-box">
                                            <div class="price-amount">
                                                <fmt:formatNumber value="${room.pricePerNight}" type="number"
                                                    groupingUsed="true" />₫
                                            </div>
                                            <div>mỗi đêm</div>
                                        </div>

                                        <c:choose>
                                            <c:when test="${room.status == 'Available'}">
                                                <a href="${pageContext.request.contextPath}/booking?roomId=${room.roomID}"
                                                    class="btn btn-primary w-100 btn-lg mb-3">
                                                    <i class="fas fa-calendar-check"></i> Đặt Phòng Ngay
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-secondary w-100 btn-lg mb-3" disabled>
                                                    <i class="fas fa-ban"></i> Phòng Không Khả Dụng
                                                </button>
                                            </c:otherwise>
                                        </c:choose>

                                        <a href="${pageContext.request.contextPath}/room?view=list"
                                            class="btn btn-outline-primary w-100">
                                            <i class="fas fa-arrow-left"></i> Quay Lại Danh Sách
                                        </a>


                                        <hr class="my-4">

                                        <h5 class="mb-3">Thông Tin Liên Hệ</h5>
                                        <p class="mb-2">
                                            <i class="fas fa-phone text-primary"></i>
                                            <a href="tel:+84123456789">+84 123 456 789</a>
                                        </p>
                                        <p class="mb-2">
                                            <i class="fas fa-envelope text-primary"></i>
                                            <a href="mailto:info@aurorahotel.com">info@aurorahotel.com</a>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${empty room}">
                            <div class="alert alert-danger text-center">
                                <i class="fas fa-exclamation-triangle" style="font-size: 48px;"></i>
                                <h4 class="mt-3">Không tìm thấy phòng</h4>
                                <p>Phòng bạn đang tìm không tồn tại hoặc đã bị xóa</p>
                                <a href="${pageContext.request.contextPath}/room?view=list"
                                    class="btn btn-primary mt-3">
                                    <i class="fas fa-arrow-left"></i> Quay Lại Danh Sách
                                </a>
                            </div>
                        </c:if>
                    </main>

                    <%@include file="../common/footer.jsp" %>