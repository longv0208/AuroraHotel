<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:set var="pageTitle" value="Quản lý phòng - Aurora Hotel" scope="request" />
            <%@include file="../common/head.jsp" %>
                <%@include file="../common/navbar.jsp" %>

                    <main class="container my-5">
                        <div class="row">
                            <div class="col-12">
                                <!-- Page Header -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2><i class="fas fa-door-open me-2"></i> Quản lý phòng</h2>
                                    <a href="${pageContext.request.contextPath}/roomManagement?view=create"
                                        class="btn btn-primary">
                                        <i class="fas fa-plus me-2"></i> Thêm phòng mới
                                    </a>
                                </div>

                                <!-- Error Message -->
                                <c:if test="${param.error == '1'}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="fas fa-exclamation-circle me-2"></i>
                                        Có lỗi xảy ra. Vui lòng thử lại!
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <!-- Room List Table -->
                                <div class="card shadow">
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Số phòng</th>
                                                        <th>Loại phòng</th>
                                                        <th>Tầng</th>
                                                        <th>Trạng thái</th>
                                                        <th>Giá</th>
                                                        <th>Hoạt động</th>
                                                        <th>Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="room" items="${rooms}">
                                                        <tr>
                                                            <td>${room.roomID}</td>
                                                            <td><strong>${room.roomNumber}</strong></td>
                                                            <td>
                                                                <c:if test="${not empty room.roomType}">
                                                                    ${room.roomType.typeName}
                                                                </c:if>
                                                            </td>
                                                            <td>Tầng ${room.floor}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${room.status == 'Trống'}">
                                                                        <span class="badge bg-success">Trống</span>
                                                                    </c:when>
                                                                    <c:when test="${room.status == 'Đã đặt'}">
                                                                        <span class="badge bg-info">Đã đặt</span>
                                                                    </c:when>
                                                                    <c:when test="${room.status == 'Đang sử dụng'}">
                                                                        <span class="badge bg-danger">Đang sử
                                                                            dụng</span>
                                                                    </c:when>
                                                                    <c:when test="${room.status == 'Bảo trì'}">
                                                                        <span class="badge bg-warning">Bảo trì</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="badge bg-secondary">${room.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:if test="${not empty room.roomType}">
                                                                    <fmt:formatNumber value="${room.roomType.basePrice}"
                                                                        type="currency" currencySymbol="₫" />
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${room.active}">
                                                                        <span class="badge bg-success">Hoạt động</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">Ngừng</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <div class="btn-group btn-group-sm" role="group">
                                                                    <a href="${pageContext.request.contextPath}/roomManagement?view=edit&id=${room.roomID}"
                                                                        class="btn btn-outline-primary" title="Sửa">
                                                                        <i class="fas fa-edit"></i>
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/roomManagement?view=delete&id=${room.roomID}"
                                                                        class="btn btn-outline-danger" title="Xóa">
                                                                        <i class="fas fa-trash"></i>
                                                                    </a>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>

                                                    <c:if test="${empty rooms}">
                                                        <tr>
                                                            <td colspan="8" class="text-center text-muted py-4">
                                                                <i class="fas fa-inbox fa-3x mb-3 d-block"></i>
                                                                Không có phòng nào
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Pagination -->
                                        <c:if test="${totalPages > 1}">
                                            <nav aria-label="Page navigation" class="mt-4">
                                                <ul class="pagination justify-content-center">
                                                    <!-- Previous Button -->
                                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                        <a class="page-link"
                                                            href="${pageContext.request.contextPath}/roomManagement?view=list&page=${currentPage - 1}">
                                                            <i class="fas fa-chevron-left"></i>
                                                        </a>
                                                    </li>

                                                    <!-- Page Numbers -->
                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="${pageContext.request.contextPath}/roomManagement?view=list&page=${i}">
                                                                ${i}
                                                            </a>
                                                        </li>
                                                    </c:forEach>

                                                    <!-- Next Button -->
                                                    <li
                                                        class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link"
                                                            href="${pageContext.request.contextPath}/roomManagement?view=list&page=${currentPage + 1}">
                                                            <i class="fas fa-chevron-right"></i>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </nav>

                                            <!-- Page Info -->
                                            <p class="text-center text-muted">
                                                Trang ${currentPage} / ${totalPages} - Tổng ${totalRows} phòng
                                            </p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>

                    <%@include file="../common/footer.jsp" %>