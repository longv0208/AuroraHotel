<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Thêm Khách Hàng - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-user-plus text-primary me-2"></i>
            Thêm Khách Hàng
        </h1>
        <a href="${pageContext.request.contextPath}/customer?view=list" class="btn btn-outline-secondary">
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
                        <input type="hidden" name="action" value="create">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Họ tên <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="tel" name="phone" class="form-control" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">CMND/CCCD</label>
                                <input type="text" name="idCard" class="form-control">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Địa chỉ</label>
                            <textarea name="address" class="form-control" rows="2"></textarea>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Quốc tịch</label>
                                <select name="nationality" class="form-select">
                                    <option value="Việt Nam" selected>Việt Nam</option>
                                    <option value="Mỹ">Mỹ</option>
                                    <option value="Hàn Quốc">Hàn Quốc</option>
                                    <option value="Nhật Bản">Nhật Bản</option>
                                    <option value="Trung Quốc">Trung Quốc</option>
                                    <option value="Thái Lan">Thái Lan</option>
                                    <option value="Singapore">Singapore</option>
                                    <option value="Malaysia">Malaysia</option>
                                    <option value="Philippines">Philippines</option>
                                    <option value="Indonesia">Indonesia</option>
                                    <option value="Khác">Khác</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ngày sinh</label>
                                <input type="date" name="dateOfBirth" class="form-control">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Ghi chú</label>
                            <textarea name="notes" class="form-control" rows="3" placeholder="Ghi chú về khách hàng..."></textarea>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i>
                                Lưu Khách Hàng
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
                        <i class="fas fa-info-circle me-2"></i>
                        Hướng Dẫn
                    </h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <h6 class="alert-heading">
                            <i class="fas fa-lightbulb me-2"></i>
                            Lưu ý
                        </h6>
                        <ul class="mb-0">
                            <li>Họ tên và số điện thoại là bắt buộc</li>
                            <li>Email và CMND/CCCD giúp xác thực khách hàng</li>
                            <li>Ghi chú giúp lưu thông tin đặc biệt về khách hàng</li>
                        </ul>
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

