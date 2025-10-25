<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Chỉnh Sửa Khách Hàng - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-user-edit text-primary me-2"></i>
            Chỉnh Sửa Khách Hàng
        </h1>
        <a href="${pageContext.request.contextPath}/customer?view=details&id=${customer.customerID}" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>
            Quay Lại
        </a>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-info-circle me-2"></i>
                        Thông Tin Khách Hàng
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/customer">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${customer.customerID}">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Họ tên <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" class="form-control" value="${customer.fullName}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="tel" name="phone" class="form-control" value="${customer.phone}" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control" value="${customer.email}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">CMND/CCCD</label>
                                <input type="text" name="idCard" class="form-control" value="${customer.idCard}">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Địa chỉ</label>
                            <textarea name="address" class="form-control" rows="2">${customer.address}</textarea>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Quốc tịch</label>
                                <select name="nationality" class="form-select">
                                    <option value="Việt Nam" ${customer.nationality == 'Việt Nam' ? 'selected' : ''}>Việt Nam</option>
                                    <option value="Mỹ" ${customer.nationality == 'Mỹ' ? 'selected' : ''}>Mỹ</option>
                                    <option value="Hàn Quốc" ${customer.nationality == 'Hàn Quốc' ? 'selected' : ''}>Hàn Quốc</option>
                                    <option value="Nhật Bản" ${customer.nationality == 'Nhật Bản' ? 'selected' : ''}>Nhật Bản</option>
                                    <option value="Trung Quốc" ${customer.nationality == 'Trung Quốc' ? 'selected' : ''}>Trung Quốc</option>
                                    <option value="Thái Lan" ${customer.nationality == 'Thái Lan' ? 'selected' : ''}>Thái Lan</option>
                                    <option value="Singapore" ${customer.nationality == 'Singapore' ? 'selected' : ''}>Singapore</option>
                                    <option value="Malaysia" ${customer.nationality == 'Malaysia' ? 'selected' : ''}>Malaysia</option>
                                    <option value="Philippines" ${customer.nationality == 'Philippines' ? 'selected' : ''}>Philippines</option>
                                    <option value="Indonesia" ${customer.nationality == 'Indonesia' ? 'selected' : ''}>Indonesia</option>
                                    <option value="Khác" ${customer.nationality == 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ngày sinh</label>
                                <input type="date" name="dateOfBirth" class="form-control" value="${customer.dateOfBirth}">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Ghi chú</label>
                            <textarea name="notes" class="form-control" rows="3" placeholder="Ghi chú về khách hàng...">${customer.notes}</textarea>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i>
                                Cập Nhật Thông Tin
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-bar me-2"></i>
                        Thống Kê
                    </h5>
                </div>
                <div class="card-body">
                    <div class="text-center mb-3">
                        <h3 class="text-primary">${customer.totalBookings}</h3>
                        <p class="text-muted mb-0">Tổng số booking</p>
                    </div>
                    
                    <div class="text-center">
                        <small class="text-muted">
                            Tham gia từ: ${customer.createdDate}
                        </small>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm mt-3">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-shield-alt me-2"></i>
                        Bảo Mật
                    </h5>
                </div>
                <div class="card-body">
                    <p class="mb-0 text-muted">
                        <i class="fas fa-lock me-2"></i>
                        Thông tin khách hàng được bảo mật và chỉ sử dụng cho mục đích quản lý khách sạn.
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>

