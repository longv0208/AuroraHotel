<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Tìm Kiếm Phòng - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="row">
        <div class="col-md-4">
            <div class="card shadow-sm sticky-top" style="top: 20px;">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-search me-2"></i>
                        Tìm Kiếm Phòng
                    </h5>
                </div>
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/booking">
                        <input type="hidden" name="view" value="search-results">
                        
                        <div class="mb-3">
                            <label class="form-label">Ngày Check-in</label>
                            <input type="date" name="checkInDate" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Ngày Check-out</label>
                            <input type="date" name="checkOutDate" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Số khách</label>
                            <select name="guests" class="form-select">
                                <option value="1">1 khách</option>
                                <option value="2" selected>2 khách</option>
                                <option value="3">3 khách</option>
                                <option value="4">4 khách</option>
                                <option value="5">5+ khách</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Loại phòng</label>
                            <select name="roomType" class="form-select">
                                <option value="">Tất cả loại phòng</option>
                                <c:forEach var="type" items="${roomTypes}">
                                    <option value="${type.typeID}">${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Giá tối đa (₫/đêm)</label>
                            <input type="number" name="maxPrice" class="form-control" placeholder="Không giới hạn">
                        </div>

                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search me-2"></i>
                            Tìm Kiếm
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="display-6 fw-bold">
                    <i class="fas fa-bed text-primary me-2"></i>
                    Tìm Kiếm Phòng
                </h1>
            </div>

            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                Vui lòng chọn ngày check-in, check-out và số khách để tìm kiếm phòng phù hợp.
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body text-center">
                            <i class="fas fa-calendar-alt fa-3x text-primary mb-3"></i>
                            <h5>Chọn Ngày</h5>
                            <p class="text-muted">Chọn ngày check-in và check-out để tìm phòng trống</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body text-center">
                            <i class="fas fa-users fa-3x text-success mb-3"></i>
                            <h5>Chọn Số Khách</h5>
                            <p class="text-muted">Chọn số lượng khách để tìm phòng phù hợp</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
