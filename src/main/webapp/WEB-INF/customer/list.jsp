<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Quản Lý Khách Hàng - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-users text-primary me-2"></i>
            Quản Lý Khách Hàng
        </h1>
        <a href="${pageContext.request.contextPath}/customer?view=create" class="btn btn-success">
            <i class="fas fa-plus me-2"></i>
            Thêm Khách Hàng
        </a>
    </div>

    <!-- Search and Filters -->
    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-search me-2"></i>
                Tìm Kiếm & Bộ Lọc
            </h5>
        </div>
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/customer">
                <input type="hidden" name="view" value="list">
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label">Tìm kiếm</label>
                        <input type="text" name="search" class="form-control" placeholder="Họ tên, SĐT, Email..." value="${param.search}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Quốc tịch</label>
                        <select name="nationality" class="form-select">
                            <option value="">Tất cả quốc tịch</option>
                            <option value="Việt Nam" ${param.nationality == 'Việt Nam' ? 'selected' : ''}>Việt Nam</option>
                            <option value="Mỹ" ${param.nationality == 'Mỹ' ? 'selected' : ''}>Mỹ</option>
                            <option value="Hàn Quốc" ${param.nationality == 'Hàn Quốc' ? 'selected' : ''}>Hàn Quốc</option>
                            <option value="Nhật Bản" ${param.nationality == 'Nhật Bản' ? 'selected' : ''}>Nhật Bản</option>
                            <option value="Trung Quốc" ${param.nationality == 'Trung Quốc' ? 'selected' : ''}>Trung Quốc</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Sắp xếp</label>
                        <select name="sortBy" class="form-select">
                            <option value="fullName" ${param.sortBy == 'fullName' ? 'selected' : ''}>Họ tên</option>
                            <option value="createdDate" ${param.sortBy == 'createdDate' ? 'selected' : ''}>Ngày tạo</option>
                            <option value="totalBookings" ${param.sortBy == 'totalBookings' ? 'selected' : ''}>Số booking</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search me-2"></i>
                                Tìm
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty customers}">
            <div class="alert alert-info text-center py-5">
                <i class="fas fa-users fa-3x mb-3"></i>
                <h4>Không có khách hàng nào</h4>
                <p>Không tìm thấy khách hàng nào phù hợp với bộ lọc.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Họ tên</th>
                                    <th>Liên hệ</th>
                                    <th>Địa chỉ</th>
                                    <th>Quốc tịch</th>
                                    <th>Số booking</th>
                                    <th>Tham gia</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="customer" items="${customers}">
                                    <tr>
                                        <td>
                                            <strong>${customer.fullName}</strong>
                                            <c:if test="${not empty customer.notes}">
                                                <br>
                                                <small class="text-muted">
                                                    <i class="fas fa-sticky-note me-1"></i>
                                                    ${customer.notes}
                                                </small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <i class="fas fa-phone text-primary me-1"></i>
                                            ${customer.phone}
                                            <c:if test="${not empty customer.email}">
                                                <br>
                                                <i class="fas fa-envelope text-info me-1"></i>
                                                ${customer.email}
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty customer.address}">
                                                    ${customer.address}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Chưa cập nhật</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary">${customer.nationality}</span>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary">${customer.totalBookings}</span>
                                        </td>
                                        <td>
                                            ${customer.createdDate}
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/customer?view=details&id=${customer.customerID}" 
                                                   class="btn btn-outline-primary btn-sm" title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/customer?view=booking-history&id=${customer.customerID}" 
                                                   class="btn btn-outline-info btn-sm" title="Lịch sử đặt phòng">
                                                    <i class="fas fa-history"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/customer?view=edit&id=${customer.customerID}" 
                                                   class="btn btn-outline-warning btn-sm" title="Sửa thông tin">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="../common/footer.jsp"/>
