<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Hiệu Suất Loại Phòng - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-chart-pie text-warning me-2"></i>
            Hiệu Suất Loại Phòng
        </h1>
        <a href="${pageContext.request.contextPath}/report?view=dashboard" class="btn btn-outline-secondary">
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
            <form method="get" action="${pageContext.request.contextPath}/report">
                <input type="hidden" name="view" value="room-type-performance">
                <div class="row">
                    <div class="col-md-3">
                        <label class="form-label">Từ ngày</label>
                        <input type="date" name="fromDate" class="form-control" value="${param.fromDate}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Đến ngày</label>
                        <input type="date" name="toDate" class="form-control" value="${param.toDate}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Loại phòng</label>
                        <select name="roomType" class="form-select">
                            <option value="">Tất cả loại phòng</option>
                            <c:forEach var="type" items="${roomTypes}">
                                <option value="${type.typeID}" ${param.roomType == type.typeID ? 'selected' : ''}>${type.typeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search me-2"></i>
                                Lọc
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Summary Cards -->
    <div class="row row-cols-1 row-cols-md-4 g-4 mb-4">
        <div class="col">
            <div class="card bg-primary text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${totalRoomTypes}</h4>
                            <p class="card-text">Tổng Loại Phòng</p>
                        </div>
                        <div class="align-self-center">
                            <i class="fas fa-bed fa-2x"></i>
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
                            <h4 class="card-title">${totalRooms}</h4>
                            <p class="card-text">Tổng Số Phòng</p>
                        </div>
                        <div class="align-self-center">
                            <i class="fas fa-door-open fa-2x"></i>
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
                            <h4 class="card-title">${averageOccupancyRate}%</h4>
                            <p class="card-text">Tỷ Lệ Lưu Trú TB</p>
                        </div>
                        <div class="align-self-center">
                            <i class="fas fa-chart-line fa-2x"></i>
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
                            <h4 class="card-title">
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/>
                            </h4>
                            <p class="card-text">Tổng Doanh Thu</p>
                        </div>
                        <div class="align-self-center">
                            <i class="fas fa-money-bill-wave fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Performance Chart -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-bar me-2"></i>
                        Hiệu Suất Theo Loại Phòng
                    </h5>
                </div>
                <div class="card-body">
                    <canvas id="performanceChart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Revenue and Occupancy Charts -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-pie-chart me-2"></i>
                        Doanh Thu Theo Loại Phòng
                    </h5>
                </div>
                <div class="card-body">
                    <canvas id="revenueChart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-line me-2"></i>
                        Tỷ Lệ Lưu Trú Theo Loại Phòng
                    </h5>
                </div>
                <div class="card-body">
                    <canvas id="occupancyChart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Performance Table -->
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-table me-2"></i>
                        Chi Tiết Hiệu Suất
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Loại Phòng</th>
                                    <th>Số Phòng</th>
                                    <th>Tỷ Lệ Lưu Trú</th>
                                    <th>Doanh Thu</th>
                                    <th>Giá TB/Đêm</th>
                                    <th>Số Booking</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="performance" items="${roomTypePerformance}">
                                    <tr>
                                        <td>
                                            <strong>${performance.roomType.typeName}</strong>
                                            <br>
                                            <small class="text-muted">${performance.roomType.description}</small>
                                        </td>
                                        <td>${performance.roomCount}</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="progress me-2" style="width: 100px;">
                                                    <div class="progress-bar" role="progressbar" 
                                                         style="width: ${performance.occupancyRate}%"
                                                         aria-valuenow="${performance.occupancyRate}" 
                                                         aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                                <span>${performance.occupancyRate}%</span>
                                            </div>
                                        </td>
                                        <td><fmt:formatNumber value="${performance.revenue}" type="currency" currencySymbol="₫"/></td>
                                        <td><fmt:formatNumber value="${performance.averagePrice}" type="currency" currencySymbol="₫"/></td>
                                        <td>${performance.bookingCount}</td>
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
// Performance Chart
const performanceCtx = document.getElementById('performanceChart').getContext('2d');
const performanceChart = new Chart(performanceCtx, {
    type: 'bar',
    data: {
        labels: ['Standard', 'Deluxe', 'Suite'],
        datasets: [{
            label: 'Tỷ lệ lưu trú (%)',
            data: [70, 80, 90],
            backgroundColor: 'rgba(54, 162, 235, 0.6)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: {
                beginAtZero: true,
                max: 100
            }
        }
    }
});

// Revenue Chart
const revenueCtx = document.getElementById('revenueChart').getContext('2d');
const revenueChart = new Chart(revenueCtx, {
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

// Occupancy Chart
const occupancyCtx = document.getElementById('occupancyChart').getContext('2d');
const occupancyChart = new Chart(occupancyCtx, {
    type: 'line',
    data: {
        labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
        datasets: [{
            label: 'Standard',
            data: [65, 70, 75, 80, 85, 90],
            borderColor: 'rgb(255, 99, 132)',
            backgroundColor: 'rgba(255, 99, 132, 0.2)',
            tension: 0.1
        }, {
            label: 'Deluxe',
            data: [70, 75, 80, 85, 90, 95],
            borderColor: 'rgb(54, 162, 235)',
            backgroundColor: 'rgba(54, 162, 235, 0.2)',
            tension: 0.1
        }, {
            label: 'Suite',
            data: [75, 80, 85, 90, 95, 100],
            borderColor: 'rgb(255, 205, 86)',
            backgroundColor: 'rgba(255, 205, 86, 0.2)',
            tension: 0.1
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: {
                beginAtZero: true,
                max: 100
            }
        }
    }
});
</script>

<jsp:include page="../common/footer.jsp"/>

