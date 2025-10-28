<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Báo Cáo Doanh Thu - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-chart-line text-primary me-2"></i>
            Báo Cáo Doanh Thu (Đơn Giản)
        </h1>
        <a href="${pageContext.request.contextPath}/report?view=dashboard" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>
            Quay Lại
        </a>
    </div>

    <!-- Revenue by Period Only: Month / Quarter / Year -->
    <div class="row">
        <!-- Monthly Revenue -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-calendar-alt me-2"></i>
                        Doanh Thu & Lợi Nhuận Theo Tháng (Năm ${year})
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Tháng</th>
                                    <th class="text-end">Doanh Thu</th>
                                    <th class="text-end">Lợi Nhuận</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="m" items="${monthlyRevenue}">
                                    <tr>
                                        <td>${m.month}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${m.totalRevenue}" type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${m.totalProfit}" type="currency" currencySymbol="₫"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quarterly Revenue -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-warning">
                    <h5 class="mb-0">
                        <i class="fas fa-calendar me-2"></i>
                        Doanh Thu & Lợi Nhuận Theo Quý (Năm ${year})
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Quý</th>
                                    <th class="text-end">Doanh Thu</th>
                                    <th class="text-end">Lợi Nhuận</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="q" items="${quarterlyRevenue}">
                                    <tr>
                                        <td>Q${q.quarter}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${q.totalRevenue}" type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${q.totalProfit}" type="currency" currencySymbol="₫"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Yearly Revenue -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-calendar-day me-2"></i>
                        Doanh Thu & Lợi Nhuận Theo Năm
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Năm</th>
                                    <th class="text-end">Doanh Thu</th>
                                    <th class="text-end">Lợi Nhuận</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="y" items="${yearlyRevenue}">
                                    <tr>
                                        <td>${y.year}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${y.totalRevenue}" type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${y.totalProfit}" type="currency" currencySymbol="₫"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Room Booking Statistics: monthly vs yearly count per room -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-bed me-2"></i>
                        Số Lần Đặt Của Từng Phòng (Tháng ${month}/${year} & Năm ${year})
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Phòng</th>
                                    <th class="text-end">Tháng</th>
                                    <th class="text-end">Năm</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="room" items="${roomBookingStats}">
                                    <tr>
                                        <td><strong>${room.roomNumber}</strong><br>
                                            <small class="text-muted">${room.typeName}</small>
                                        </td>
                                        <td class="text-end">
                                            <span class="badge bg-primary">${room.monthlyBookings}</span>
                                        </td>
                                        <td class="text-end">
                                            <span class="badge bg-success">${room.yearlyBookings}</span>
                                        </td>
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

<jsp:include page="../common/footer.jsp"/>
