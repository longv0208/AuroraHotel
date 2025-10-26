<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Phòng - Aurora Hotel" scope="request"/>
<%@include file="../common/head.jsp" %>
<%@include file="../common/navbar.jsp" %>

<style>
    .room-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 20px;
        margin-top: 20px;
    }
    .room-card {
        border: 1px solid #ddd;
        border-radius: 10px;
        overflow: hidden;
        transition: transform 0.3s, box-shadow 0.3s;
    }
    .room-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }
    .room-image {
        width: 100%;
        height: 200px;
        object-fit: cover;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 48px;
    }
    .room-info {
        padding: 15px;
    }
    .room-name {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 10px;
    }
    .room-price {
        font-size: 24px;
        font-weight: 700;
        color: #667eea;
        margin-bottom: 10px;
    }
    .filter-sidebar {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 10px;
    }
</style>

<main class="container py-5">
    <h1 class="mb-4"><i class="fas fa-bed"></i> Danh Sách Phòng</h1>

    <div class="row">
        <!-- Filter Sidebar -->
        <div class="col-md-3">
            <div class="filter-sidebar">
                <h5>Bộ Lọc</h5>
                <form method="get" action="${pageContext.request.contextPath}/room">
                    <input type="hidden" name="view" value="list">

                    <!-- Room Type -->
                    <div class="mb-3">
                        <label class="form-label">Loại Phòng</label>
                        <select name="roomType" class="form-select">
                            <option value="">Tất cả</option>
                            <c:forEach var="type" items="${roomTypes}">
                                <option value="${type}" ${param.roomType == type ? 'selected' : ''}>${type}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Price Range -->
                    <div class="mb-3">
                        <label class="form-label">Giá</label>
                        <select name="priceRange" class="form-select">
                            <option value="">Tất cả</option>
                            <option value="0-1000000" ${param.priceRange == '0-1000000' ? 'selected' : ''}>Dưới 1 triệu</option>
                            <option value="1000000-2000000" ${param.priceRange == '1000000-2000000' ? 'selected' : ''}>1-2 triệu</option>
                            <option value="2000000-5000000" ${param.priceRange == '2000000-5000000' ? 'selected' : ''}>2-5 triệu</option>
                            <option value="5000000-999999999" ${param.priceRange == '5000000-999999999' ? 'selected' : ''}>Trên 5 triệu</option>
                        </select>
                    </div>

                    <!-- Floor -->
                    <div class="mb-3">
                        <label class="form-label">Tầng</label>
                        <select name="floor" class="form-select">
                            <option value="">Tất cả</option>
                            <c:forEach var="i" begin="1" end="10">
                                <option value="${i}" ${param.floor == i ? 'selected' : ''}>Tầng ${i}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Capacity -->
                    <div class="mb-3">
                        <label class="form-label">Sức Chứa</label>
                        <select name="capacity" class="form-select">
                            <option value="">Tất cả</option>
                            <option value="1" ${param.capacity == '1' ? 'selected' : ''}>1 người</option>
                            <option value="2" ${param.capacity == '2' ? 'selected' : ''}>2 người</option>
                            <option value="3" ${param.capacity == '3' ? 'selected' : ''}>3 người</option>
                            <option value="4" ${param.capacity == '4' ? 'selected' : ''}>4+ người</option>
                        </select>
                    </div>

                    <!-- Sort -->
                    <div class="mb-3">
                        <label class="form-label">Sắp Xếp</label>
                        <select name="sort" class="form-select">
                            <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Giá tăng dần</option>
                            <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Giá giảm dần</option>
                            <option value="capacity_desc" ${param.sort == 'capacity_desc' ? 'selected' : ''}>Sức chứa</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-filter"></i> Áp Dụng
                    </button>
                    <a href="${pageContext.request.contextPath}/room?view=list" class="btn btn-secondary w-100 mt-2">
                        <i class="fas fa-redo"></i> Đặt Lại
                    </a>
                </form>
            </div>
        </div>

        <!-- Room Grid -->
        <div class="col-md-9">
            <c:if test="${not empty rooms}">
                <div class="room-grid">
                    <c:forEach var="room" items="${rooms}">
                        <div class="room-card">
                            <div class="room-image">
                                <i class="fas fa-hotel"></i>
                            </div>
                            <div class="room-info">
                                <div class="room-name">Phòng ${room.roomNumber}</div>
                                <div class="text-muted mb-2">
                                    <i class="fas fa-door-open"></i> ${room.roomType.typeName}
                                </div>
                                <div class="text-muted mb-2">
                                    <i class="fas fa-users"></i> ${room.roomType.maxGuests} người
                                </div>
                                <div class="text-muted mb-2">
                                    <i class="fas fa-building"></i> Tầng ${room.floor}
                                </div>
                                <div class="room-price">
                                    <fmt:formatNumber value="${room.roomType.basePrice}" type="number" groupingUsed="true"/>₫
                                    <small class="text-muted">/đêm</small>
                                </div>
                                <a href="${pageContext.request.contextPath}/room?view=detail&id=${room.roomID}"
                                   class="btn btn-primary w-100">
                                    <i class="fas fa-eye"></i> Xem Chi Tiết
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?view=list&page=${currentPage - 1}&roomType=${param.roomType}&priceRange=${param.priceRange}&floor=${param.floor}&capacity=${param.capacity}&sort=${param.sort}">Trước</a>
                            </li>

                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?view=list&page=${i}&roomType=${param.roomType}&priceRange=${param.priceRange}&floor=${param.floor}&capacity=${param.capacity}&sort=${param.sort}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?view=list&page=${currentPage + 1}&roomType=${param.roomType}&priceRange=${param.priceRange}&floor=${param.floor}&capacity=${param.capacity}&sort=${param.sort}">Sau</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </c:if>

            <c:if test="${empty rooms}">
                <div class="alert alert-info text-center">
                    <i class="fas fa-inbox" style="font-size: 48px; color: #ddd;"></i>
                    <h4 class="mt-3">Không tìm thấy phòng nào</h4>
                    <p>Vui lòng thử lại với bộ lọc khác</p>
                </div>
            </c:if>
        </div>
    </div>
</main>

<%@include file="../common/footer.jsp" %>
