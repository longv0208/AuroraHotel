<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:set var="pageTitle" value="Xóa phòng - Aurora Hotel" scope="request" />
            <%@include file="../common/head.jsp" %>
                <%@include file="../common/navbar.jsp" %>

                    <main class="container my-5">
                        <div class="row justify-content-center">
                            <div class="col-md-6">
                                <!-- Page Header -->
                                <div class="mb-4">
                                    <h2><i class="fas fa-trash-alt me-2 text-danger"></i> Xóa phòng</h2>
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item">
                                                <a href="${pageContext.request.contextPath}/roomManagement?view=list">Quản
                                                    lý phòng</a>
                                            </li>
                                            <li class="breadcrumb-item active">Xóa phòng ${room.roomNumber}</li>
                                        </ol>
                                    </nav>
                                </div>

                                <!-- Error Message -->
                                <c:if test="${param.error == '1'}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="fas fa-exclamation-circle me-2"></i>
                                        Có lỗi xảy ra. Không thể xóa phòng này!
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <!-- Delete Confirmation -->
                                <div class="card shadow border-danger">
                                    <div class="card-header bg-danger text-white">
                                        <h5 class="mb-0">
                                            <i class="fas fa-exclamation-triangle me-2"></i> Xác nhận xóa
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="alert alert-info">
                                            <i class="fas fa-info-circle me-2"></i>
                                            <strong>Lưu ý:</strong> Đây là thao tác xóa mềm. Phòng sẽ được đánh dấu là không hoạt động nhưng dữ liệu vẫn được lưu giữ trong hệ thống.
                                        </div>
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            Bạn có chắc chắn muốn xóa phòng này?
                                        </div>

                                        <!-- Room Details -->
                                        <div class="mb-3">
                                            <h6 class="text-muted mb-3">Thông tin phòng:</h6>
                                            <table class="table table-bordered">
                                                <tr>
                                                    <th width="40%">Số phòng:</th>
                                                    <td><strong>${room.roomNumber}</strong></td>
                                                </tr>
                                                <tr>
                                                    <th>Loại phòng:</th>
                                                    <td>
                                                        <c:if test="${not empty room.roomType}">
                                                            ${room.roomType.typeName}
                                                        </c:if>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Tầng:</th>
                                                    <td>Tầng ${room.floor}</td>
                                                </tr>
                                                <tr>
                                                    <th>Trạng thái:</th>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${room.status == 'Trống'}">
                                                                <span class="badge bg-success">Trống</span>
                                                            </c:when>
                                                            <c:when test="${room.status == 'Đã đặt'}">
                                                                <span class="badge bg-info">Đã đặt</span>
                                                            </c:when>
                                                            <c:when test="${room.status == 'Đang sử dụng'}">
                                                                <span class="badge bg-danger">Đang sử dụng</span>
                                                            </c:when>
                                                            <c:when test="${room.status == 'Bảo trì'}">
                                                                <span class="badge bg-warning">Bảo trì</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${room.status}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Giá:</th>
                                                    <td>
                                                        <c:if test="${not empty room.roomType}">
                                                            <fmt:formatNumber value="${room.roomType.basePrice}"
                                                                type="currency" currencySymbol="₫" />
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                        <!-- Delete Form -->
                                        <form action="${pageContext.request.contextPath}/roomManagement" method="POST">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${room.roomID}">

                                            <div class="d-flex justify-content-between">
                                                <a href="${pageContext.request.contextPath}/roomManagement?view=list"
                                                    class="btn btn-secondary">
                                                    <i class="fas fa-arrow-left me-2"></i> Hủy
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