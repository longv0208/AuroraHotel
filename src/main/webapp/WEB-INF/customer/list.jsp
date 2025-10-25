<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Quản Lý Khách Hàng - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-users text-primary me-2"></i>
            Quản Lý Khách Hàng
        </h1>
        <a href="${pageContext.request.contextPath}/customer?view=create" class="btn btn-success">
            <i class="fas fa-user-plus me-2"></i>
            Thêm Khách Hàng
        </a>
    </div>

    <!-- Search Form -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/customer" method="post" class="row g-3">
                <input type="hidden" name="action" value="search">
                <div class="col-md-10">
                    <input type="text" class="form-control" name="searchTerm" 
                           placeholder="Tìm theo tên, số điện thoại hoặc CMND..." 
                           value="${searchTerm}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search me-2"></i>Tìm Kiếm
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Customers Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white">
            <h5 class="mb-0">
                <i class="fas fa-list me-2"></i>
                Danh Sách Khách Hàng
                <span class="badge bg-secondary">${totalRows} khách hàng</span>
            </h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty customers}">
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-user-slash fa-3x mb-3"></i>
                        <p>Không tìm thấy khách hàng nào</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Họ Tên</th>
                                    <th>Điện Thoại</th>
                                    <th>Email</th>
                                    <th>CMND/CCCD</th>
                                    <th>Số Booking</th>
                                    <th>Ngày Tạo</th>
                                    <th class="text-center">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="customer" items="${customers}">
                                    <tr>
                                        <td><strong>#${customer.customerID}</strong></td>
                                        <td>${customer.fullName}</td>
                                        <td>
                                            <i class="fas fa-phone text-success me-1"></i>
                                            ${customer.phone}
                                        </td>
                                        <td>${customer.email}</td>
                                        <td>${customer.idCard}</td>
                                        <td>
                                            <span class="badge bg-info">${customer.totalBookings}</span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${customer.createdDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm">
                                                <a href="${pageContext.request.contextPath}/customer?view=details&id=${customer.customerID}" 
                                                   class="btn btn-outline-info" title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/customer?view=booking-history&id=${customer.customerID}" 
                                                   class="btn btn-outline-primary" title="Lịch sử booking">
                                                    <i class="fas fa-history"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/customer?view=edit&id=${customer.customerID}" 
                                                   class="btn btn-outline-warning" title="Chỉnh sửa">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav>
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?view=list&page=${currentPage - 1}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="?view=list&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?view=list&page=${currentPage + 1}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>

