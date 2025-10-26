<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Xóa dịch vụ - Aurora Hotel" scope="request"/>
<%@include file="../common/head.jsp" %>
<%@include file="../common/navbar.jsp" %>

<main class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <!-- Page Header -->
            <div class="mb-4">
                <h2><i class="fas fa-trash-alt me-2 text-danger"></i> Xóa dịch vụ</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/service?view=list">Dịch vụ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Xóa</li>
                    </ol>
                </nav>
            </div>

            <!-- Confirmation Card -->
            <div class="card shadow border-danger">
                <div class="card-header bg-danger text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Xác nhận xóa dịch vụ
                    </h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-warning" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Đây là thao tác xóa mềm. Dịch vụ sẽ được đánh dấu là không hoạt động 
                        và không hiển thị trong danh sách dịch vụ khả dụng.
                    </div>

                    <!-- Service Details -->
                    <div class="mb-4">
                        <h6 class="text-muted mb-3">Thông tin dịch vụ sẽ bị xóa:</h6>
                        <table class="table table-bordered">
                            <tbody>
                                <tr>
                                    <th width="30%">ID</th>
                                    <td>${service.serviceID}</td>
                                </tr>
                                <tr>
                                    <th>Tên dịch vụ</th>
                                    <td><strong>${service.serviceName}</strong></td>
                                </tr>
                                <tr>
                                    <th>Danh mục</th>
                                    <td><span class="badge bg-info">${service.category}</span></td>
                                </tr>
                                <tr>
                                    <th>Giá</th>
                                    <td>
                                        <fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>Đơn vị</th>
                                    <td>${service.unit}</td>
                                </tr>
                                <tr>
                                    <th>Mô tả</th>
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
                                </tr>
                                <tr>
                                    <th>Trạng thái hiện tại</th>
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
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Confirmation Form -->
                    <form action="${pageContext.request.contextPath}/service" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="serviceId" value="${service.serviceID}">

                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/service?view=list" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-trash me-2"></i> Xác nhận xóa
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../common/footer.jsp" %>

