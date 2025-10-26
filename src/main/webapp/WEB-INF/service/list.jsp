<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Quản lý dịch vụ - Aurora Hotel" scope="request"/>
<%@include file="../common/head.jsp" %>
<%@include file="../common/navbar.jsp" %>

<main class="container my-5">
    <div class="row">
        <div class="col-12">
            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-concierge-bell me-2"></i> Quản lý dịch vụ</h2>
                <a href="${pageContext.request.contextPath}/service?view=create" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i> Thêm dịch vụ mới
                </a>
            </div>

            <!-- Success Messages -->
            <c:if test="${param.created == '1'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    Tạo dịch vụ thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:if test="${param.updated == '1'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    Cập nhật dịch vụ thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:if test="${param.deleted == '1'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    Xóa dịch vụ thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Error Message -->
            <c:if test="${param.error == '1'}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    Có lỗi xảy ra. Vui lòng thử lại!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Service List Table -->
            <div class="card shadow">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên dịch vụ</th>
                                    <th>Danh mục</th>
                                    <th>Giá</th>
                                    <th>Đơn vị</th>
                                    <th>Mô tả</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty services}">
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-4">
                                                <i class="fas fa-inbox fa-3x mb-3 d-block"></i>
                                                Chưa có dịch vụ nào
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="service" items="${services}">
                                            <tr>
                                                <td>${service.serviceID}</td>
                                                <td><strong>${service.serviceName}</strong></td>
                                                <td>
                                                    <span class="badge bg-info">${service.category}</span>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" />
                                                </td>
                                                <td>${service.unit}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty service.description}">
                                                            ${service.description}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${service.active}">
                                                            <span class="badge bg-success">Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Ngừng</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group btn-group-sm" role="group">
                                                        <a href="${pageContext.request.contextPath}/service?view=edit&id=${service.serviceID}" 
                                                           class="btn btn-outline-primary" title="Sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/service?view=delete&id=${service.serviceID}" 
                                                           class="btn btn-outline-danger" title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Service pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <!-- Previous Button -->
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/service?view=list&page=${currentPage - 1}">
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </a>
                                </li>

                                <!-- Page Numbers -->
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/service?view=list&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>

                                <!-- Next Button -->
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/service?view=list&page=${currentPage + 1}">
                                        Sau <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                        
                        <!-- Pagination Info -->
                        <p class="text-center text-muted">
                            Trang ${currentPage} / ${totalPages} - Tổng ${totalRows} dịch vụ
                        </p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../common/footer.jsp" %>

