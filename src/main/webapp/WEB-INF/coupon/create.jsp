<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Tạo Coupon - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-ticket-alt text-primary me-2"></i>
            Tạo Coupon Mới
        </h1>
        <a href="${pageContext.request.contextPath}/coupon?view=list" class="btn btn-outline-secondary">
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
                        Thông Tin Coupon
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/coupon">
                        <input type="hidden" name="action" value="create">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Mã coupon <span class="text-danger">*</span></label>
                                <input type="text" name="couponCode" class="form-control" required placeholder="VD: SUMMER2024">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Tên coupon</label>
                                <input type="text" name="couponName" class="form-control" placeholder="VD: Giảm giá mùa hè">
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Loại giảm giá <span class="text-danger">*</span></label>
                                <select name="discountType" class="form-select" required onchange="toggleDiscountFields()">
                                    <option value="">Chọn loại</option>
                                    <option value="Percent">Phần trăm (%)</option>
                                    <option value="FixedAmount">Số tiền cố định (₫)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Giá trị giảm giá <span class="text-danger">*</span></label>
                                <input type="number" name="discountValue" class="form-control" required step="0.01" min="0">
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Hiệu lực từ <span class="text-danger">*</span></label>
                                <input type="date" name="validFrom" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Hết hạn <span class="text-danger">*</span></label>
                                <input type="date" name="validTo" class="form-control" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Giới hạn sử dụng</label>
                                <input type="number" name="usageLimit" class="form-control" min="1" placeholder="Không giới hạn">
                            </div>
                            <div class="col-md-6" id="maxDiscountField" style="display: none;">
                                <label class="form-label">Giảm tối đa (₫)</label>
                                <input type="number" name="maxDiscountAmount" class="form-control" step="0.01" min="0">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea name="description" class="form-control" rows="3" placeholder="Mô tả về coupon..."></textarea>
                        </div>

                        <div class="mb-3">
                            <div class="form-check">
                                <input type="checkbox" name="isActive" class="form-check-input" checked>
                                <label class="form-check-label">Kích hoạt ngay</label>
                            </div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i>
                                Tạo Coupon
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
                            <li>Mã coupon phải duy nhất</li>
                            <li>Giá trị giảm giá phải hợp lệ</li>
                            <li>Ngày hết hạn phải sau ngày hiệu lực</li>
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
                        Coupon được bảo mật và chỉ sử dụng cho mục đích khuyến mãi.
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function toggleDiscountFields() {
    const discountType = document.querySelector('select[name="discountType"]').value;
    const maxDiscountField = document.getElementById('maxDiscountField');
    const discountValueInput = document.querySelector('input[name="discountValue"]');
    
    if (discountType === 'Percent') {
        maxDiscountField.style.display = 'block';
        discountValueInput.placeholder = 'VD: 20 (cho 20%)';
        discountValueInput.max = 100;
    } else if (discountType === 'FixedAmount') {
        maxDiscountField.style.display = 'none';
        discountValueInput.placeholder = 'VD: 100000 (cho 100,000₫)';
        discountValueInput.removeAttribute('max');
    } else {
        maxDiscountField.style.display = 'none';
        discountValueInput.placeholder = '';
    }
}
</script>

<jsp:include page="../common/footer.jsp"/>

