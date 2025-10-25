<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Chỉnh Sửa Đánh Giá - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-star text-warning me-2"></i>
            Chỉnh Sửa Đánh Giá
        </h1>
        <a href="${pageContext.request.contextPath}/review?view=my-reviews" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-2"></i>
            Quay Lại
        </a>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0">
                        <i class="fas fa-info-circle me-2"></i>
                        Chỉnh Sửa Đánh Giá
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/review">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${review.reviewID}">

                        <div class="mb-3">
                            <label class="form-label">Đánh giá <span class="text-danger">*</span></label>
                            <div class="rating-input">
                                <input type="hidden" name="rating" id="rating" value="${review.rating}" required>
                                <div class="d-flex align-items-center">
                                    <c:forEach begin="1" end="5" var="star">
                                        <i class="fas fa-star fa-2x ${star <= review.rating ? 'text-warning' : 'text-muted'} me-2" 
                                           data-rating="${star}" 
                                           style="cursor: pointer;"
                                           onmouseover="highlightStars(${star})"
                                           onmouseout="resetStars()"
                                           onclick="setRating(${star})"></i>
                                    </c:forEach>
                                    <span class="ms-3" id="rating-text">${review.rating}/5</span>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" value="${review.title}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Nội dung <span class="text-danger">*</span></label>
                            <textarea name="content" class="form-control" rows="5" required>${review.content}</textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Ghi chú thêm</label>
                            <textarea name="notes" class="form-control" rows="3" placeholder="Ghi chú thêm (không bắt buộc)...">${review.notes}</textarea>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-warning btn-lg">
                                <i class="fas fa-save me-2"></i>
                                Cập Nhật Đánh Giá
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
                        Thông Tin
                    </h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <strong>Trạng thái:</strong><br>
                        <c:choose>
                            <c:when test="${review.status == 'Approved'}">
                                <span class="badge bg-success">Đã duyệt</span>
                            </c:when>
                            <c:when test="${review.status == 'Pending'}">
                                <span class="badge bg-warning text-dark">Chờ duyệt</span>
                            </c:when>
                            <c:when test="${review.status == 'Rejected'}">
                                <span class="badge bg-danger">Từ chối</span>
                            </c:when>
                        </c:choose>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Ngày đánh giá:</strong><br>
                        <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                    </div>

                    <c:if test="${not empty review.adminReply}">
                        <div class="mb-0">
                            <strong>Phản hồi từ quản trị:</strong><br>
                            <p class="mb-0 text-muted">${review.adminReply}</p>
                        </div>
                    </c:if>
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
                        Thông tin đánh giá được bảo mật và chỉ sử dụng cho mục đích cải thiện dịch vụ.
                    </p>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function highlightStars(rating) {
    for (let i = 1; i <= 5; i++) {
        const star = document.querySelector(`[data-rating="${i}"]`);
        if (i <= rating) {
            star.classList.remove('text-muted');
            star.classList.add('text-warning');
        } else {
            star.classList.remove('text-warning');
            star.classList.add('text-muted');
        }
    }
    document.getElementById('rating-text').textContent = `${rating}/5`;
}

function resetStars() {
    const currentRating = document.getElementById('rating').value;
    if (currentRating) {
        highlightStars(parseInt(currentRating));
    } else {
        for (let i = 1; i <= 5; i++) {
            const star = document.querySelector(`[data-rating="${i}"]`);
            star.classList.remove('text-warning');
            star.classList.add('text-muted');
        }
        document.getElementById('rating-text').textContent = 'Chọn đánh giá';
    }
}

function setRating(rating) {
    document.getElementById('rating').value = rating;
    highlightStars(rating);
}
</script>

<jsp:include page="../common/footer.jsp"/>

