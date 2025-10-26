<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Tìm Kiếm Phòng - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<style>
    .search-hero {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 60px 0;
        text-align: center;
        margin-bottom: 40px;
        border-radius: 15px;
    }

    .search-card {
        background: white;
        border-radius: 15px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        margin-top: -50px;
        position: relative;
        z-index: 10;
    }

    .feature-card {
        background: white;
        border-radius: 15px;
        padding: 30px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s;
        height: 100%;
    }

    .feature-card:hover {
        transform: translateY(-5px);
    }

    .feature-icon {
        font-size: 48px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        margin-bottom: 20px;
    }
</style>

<main class="container py-5">
    <div class="search-hero">
        <h1 class="display-4 fw-bold mb-3">Tìm Phòng Lý Tưởng</h1>
        <p class="lead">Khám phá không gian nghỉ dưỡng hoàn hảo tại Aurora Hotel</p>
    </div>

    <div class="search-card">
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form method="get" action="${pageContext.request.contextPath}/booking" id="searchForm">
            <input type="hidden" name="view" value="search-results">

            <div class="row g-3">
                <div class="col-md-6 col-lg-3">
                    <label class="form-label">
                        <i class="fas fa-calendar-alt text-primary me-2"></i>Ngày Nhận Phòng
                    </label>
                    <input type="date" name="checkInDate" class="form-control form-control-lg"
                           id="checkInDate" required
                           min="<%= java.time.LocalDate.now() %>">
                </div>

                <div class="col-md-6 col-lg-3">
                    <label class="form-label">
                        <i class="fas fa-calendar-check text-primary me-2"></i>Ngày Trả Phòng
                    </label>
                    <input type="date" name="checkOutDate" class="form-control form-control-lg"
                           id="checkOutDate" required
                           min="<%= java.time.LocalDate.now().plusDays(1) %>">
                </div>

                <div class="col-md-6 col-lg-3">
                    <label class="form-label">
                        <i class="fas fa-users text-primary me-2"></i>Số Khách
                    </label>
                    <select name="guests" class="form-select form-select-lg">
                        <option value="1">1 khách</option>
                        <option value="2" selected>2 khách</option>
                        <option value="3">3 khách</option>
                        <option value="4">4 khách</option>
                        <option value="5">5+ khách</option>
                    </select>
                </div>

                <div class="col-md-6 col-lg-3">
                    <label class="form-label">
                        <i class="fas fa-door-open text-primary me-2"></i>Loại Phòng
                    </label>
                    <select name="roomTypeID" class="form-select form-select-lg">
                        <option value="">Tất cả</option>
                        <c:forEach var="type" items="${roomTypes}">
                            <option value="${type.roomTypeID}">${type.typeName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-12">
                    <button type="submit" class="btn btn-primary btn-lg w-100">
                        <i class="fas fa-search me-2"></i>Tìm Phòng Trống
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Features Section -->
    <div class="row mt-5 g-4">
        <div class="col-md-4">
            <div class="feature-card text-center">
                <div class="feature-icon">
                    <i class="fas fa-tag"></i>
                </div>
                <h5>Giá Tốt Nhất</h5>
                <p class="text-muted">Cam kết giá tốt nhất trên thị trường với nhiều ưu đãi hấp dẫn</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card text-center">
                <div class="feature-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h5>Đặt Phòng An Toàn</h5>
                <p class="text-muted">Hệ thống đặt phòng bảo mật cao, thông tin được mã hóa</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card text-center">
                <div class="feature-icon">
                    <i class="fas fa-clock"></i>
                </div>
                <h5>Hỗ Trợ 24/7</h5>
                <p class="text-muted">Đội ngũ hỗ trợ luôn sẵn sàng phục vụ bạn mọi lúc mọi nơi</p>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>

<script>
    // Date validation
    document.getElementById('checkInDate').addEventListener('change', function() {
        const checkInDate = new Date(this.value);
        const checkOutInput = document.getElementById('checkOutDate');
        const minCheckOut = new Date(checkInDate);
        minCheckOut.setDate(minCheckOut.getDate() + 1);
        checkOutInput.min = minCheckOut.toISOString().split('T')[0];

        // Reset checkOut if it's before new checkIn
        if (checkOutInput.value && new Date(checkOutInput.value) <= checkInDate) {
            checkOutInput.value = '';
        }
    });

    // Set default dates (today and tomorrow)
    window.addEventListener('DOMContentLoaded', function() {
        const today = new Date();
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);

        document.getElementById('checkInDate').valueAsDate = today;
        document.getElementById('checkOutDate').valueAsDate = tomorrow;
    });
</script>
