<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Báo Cáo Doanh Thu - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-money-bill-wave text-success me-2"></i>
            Báo Cáo Doanh Thu
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
                <input type="hidden" name="view" value="revenue">
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
                        <label class="form-label">Loại báo cáo</label>
                        <select name="reportType" class="form-select">
                            <option value="daily" ${param.reportType == 'daily' ? 'selected' : ''}>Theo ngày</option>
                            <option value="monthly" ${param.reportType == 'monthly' ? 'selected' : ''}>Theo tháng</option>
                            <option value="yearly" ${param.reportType == 'yearly' ? 'selected' : ''}>Theo năm</option>
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
            <div class="card bg-success text-white">
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

        <div class="col">
            <div class="card bg-info text-white">
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
            <div class="card bg-warning text-dark">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">
                                <fmt:formatNumber value="${averageBookingValue}" type="currency" currencySymbol="₫"/>
                            </h4>
                            <p class="card-text">Giá Trị TB/Booking</p>
                        </div>
                        <div class="align-self-center">
                            <i class="fas fa-calculator fa-2x"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col">
            <div class="card bg-primary text-white">
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
    </div>

    <!-- Revenue Chart -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-line me-2"></i>
                        Biểu Đồ Doanh Thu
                    </h5>
                </div>
                <div class="card-body">
                    <canvas id="revenueChart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Revenue by Room Type -->
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
                    <canvas id="roomTypeChart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-bar me-2"></i>
                        Doanh Thu Theo Tháng
                    </h5>
                </div>
                <div class="card-body">
                    <canvas id="monthlyChart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Revenue Table -->
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-table me-2"></i>
                        Chi Tiết Doanh Thu
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Ngày</th>
                                    <th>Số Booking</th>
                                    <th>Doanh Thu</th>
                                    <th>Tỷ Lệ Lưu Trú</th>
                                    <th>Giá Trị TB/Booking</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="revenue" items="${revenueData}">
                                    <tr>
                                        <td><fmt:formatDate value="${revenue.date}" pattern="dd/MM/yyyy"/></td>
                                        <td>${revenue.bookingCount}</td>
                                        <td><fmt:formatNumber value="${revenue.revenue}" type="currency" currencySymbol="₫"/></td>
                                        <td>${revenue.occupancyRate}%</td>
                                        <td><fmt:formatNumber value="${revenue.averageBookingValue}" type="currency" currencySymbol="₫"/></td>
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

// Monthly Chart
const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
const monthlyChart = new Chart(monthlyCtx, {
    type: 'bar',
    data: {
        labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
        datasets: [{
            label: 'Doanh thu (₫)',
            data: [12000000, 15000000, 18000000, 16000000, 20000000, 22000000],
            backgroundColor: 'rgba(54, 162, 235, 0.6)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
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
</script>

<jsp:include page="../common/footer.jsp"/>

