<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Dashboard - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-chart-line text-primary me-2"></i>
            Dashboard
        </h1>
        <div>
            <a href="${pageContext.request.contextPath}/report?view=revenue" class="btn btn-outline-primary me-2">
                <i class="fas fa-money-bill me-2"></i>
                Báo Cáo Doanh Thu
            </a>
            <a href="${pageContext.request.contextPath}/report?view=occupancy" class="btn btn-outline-success">
                <i class="fas fa-bed me-2"></i>
                Báo Cáo Lưu Trú
            </a>
        </div>
    </div>

    <!-- Summary Cards -->
    <div class="row row-cols-1 row-cols-md-4 g-4 mb-4">
        <div class="col">
            <div class="card bg-primary text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${totalBookings}</h4>
                            <p class="card-text">Tổng Booking</p>
                        </div>
                        <div class="align-self-center">
                            <i class="fas fa-calendar-check fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col">
            <div class="card bg-success text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/>
                            </h4>
                            <p class="card-text">Doanh Thu</p>
                        </div>
                        <div class="align-self-center">
                            <i class="fas fa-money-bill-wave fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col">
            <div class="card bg-info text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${occupancyRate}%</h4>
                            <p class="card-text">Tỷ Lệ Lưu Trú</p>
                        </div>
                        <div class="align-self-center">
                            <i class="fas fa-bed fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col">
            <div class="card bg-warning text-dark">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${totalCustomers}</h4>
                            <p class="card-text">Khách Hàng</p>
                        </div>
                        <div class="align-self-center">
                            <i class="fas fa-users fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts and Reports -->
    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-bar me-2"></i>
                        Doanh Thu Theo Tháng
                    </h5>
                </div>
                <div class="card-body">
                    <canvas id="revenueChart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-pie-chart me-2"></i>
                        Loại Phòng Phổ Biến
                    </h5>
                </div>
                <div class="card-body">
                    <canvas id="roomTypeChart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Bookings -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-clock me-2"></i>
                        Booking Gần Đây
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã Booking</th>
                                    <th>Khách hàng</th>
                                    <th>Phòng</th>
                                    <th>Check-in</th>
                                    <th>Check-out</th>
                                    <th>Trạng thái</th>
                                    <th>Tổng tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${recentBookings}">
                                    <tr>
                                        <td>#${booking.bookingID}</td>
                                        <td>${booking.customer.fullName}</td>
                                        <td>${booking.room.roomNumber}</td>
                                        <td><fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:formatDate value="${booking.checkOutDate}" pattern="dd/MM/yyyy"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${booking.status == 'Chờ xác nhận'}">
                                                    <span class="badge bg-warning text-dark">${booking.status}</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'Đã xác nhận'}">
                                                    <span class="badge bg-info">${booking.status}</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'Đã checkin'}">
                                                    <span class="badge bg-primary">${booking.status}</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'Đã checkout'}">
                                                    <span class="badge bg-success">${booking.status}</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'Đã hủy'}">
                                                    <span class="badge bg-danger">${booking.status}</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
// Revenue Chart
const revenueCtx = document.getElementById('revenueChart').getContext('2d');
const revenueChart = new Chart(revenueCtx, {
    type: 'line',
    data: {
        labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
        datasets: [{
            label: 'Doanh thu (₫)',
            data: [12000000, 15000000, 18000000, 16000000, 20000000, 22000000],
            borderColor: 'rgb(75, 192, 192)',
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            tension: 0.1
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});

// Room Type Chart
const roomTypeCtx = document.getElementById('roomTypeChart').getContext('2d');
const roomTypeChart = new Chart(roomTypeCtx, {
    type: 'doughnut',
    data: {
        labels: ['Standard', 'Deluxe', 'Suite'],
        datasets: [{
            data: [40, 35, 25],
            backgroundColor: [
                'rgb(255, 99, 132)',
                'rgb(54, 162, 235)',
                'rgb(255, 205, 86)'
            ]
        }]
    },
    options: {
        responsive: true
    }
});
</script>

<jsp:include page="../common/footer.jsp"/>

