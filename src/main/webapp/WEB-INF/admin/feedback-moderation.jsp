<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản Lý Feedback - Aurora Hotel" scope="request"/>
<%@include file="../common/head.jsp" %>
<%@include file="../common/navbar.jsp" %>

<main class="container py-5">
    <h1 class="mb-4"><i class="fas fa-comments"></i> Quản Lý Feedback</h1>

    <!-- Success/Error Messages -->
    <c:if test="${param.approved == '1'}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="fas fa-check-circle"></i> Đã duyệt feedback thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.replied == '1'}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="fas fa-check-circle"></i> Đã phản hồi feedback thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.deleted == '1'}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="fas fa-check-circle"></i> Đã xóa feedback thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.error == '1'}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="fas fa-exclamation-circle"></i> Có lỗi xảy ra. Vui lòng thử lại!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.error == 'emptyreply'}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="fas fa-exclamation-circle"></i> Nội dung phản hồi không được để trống!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Pending Reviews -->
    <c:if test="${not empty pendingReviews}">
        <div class="row">
            <c:forEach var="review" items="${pendingReviews}">
                <div class="col-md-6 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-warning text-dark">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-0">
                                    <i class="fas fa-clock"></i> Chờ Duyệt
                                </h6>
                                <small>
                                    ${review.reviewDate}
                                </small>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- Customer Info -->
                            <div class="mb-3">
                                <strong>Khách hàng:</strong>
                                <c:choose>
                                    <c:when test="${review.customerID > 0}">
                                        #${review.customerID}
                                    </c:when>
                                    <c:otherwise>
                                        Khách (chưa đăng nhập)
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Rating -->
                            <div class="mb-3">
                                <strong>Đánh giá:</strong>
                                <div class="rating-stars-small d-inline-block ms-2">
                                    <c:forEach var="i" begin="1" end="5">
                                        <i class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Comment -->
                            <div class="mb-3">
                                <strong>Nội dung:</strong>
                                <p class="mt-2">${review.comment}</p>
                            </div>

                            <!-- Actions -->
                            <div class="btn-group w-100" role="group">
                                <form method="post" action="${pageContext.request.contextPath}/feedback" class="d-inline">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="reviewId" value="${review.reviewID}">
                                    <button type="submit" class="btn btn-success btn-sm">
                                        <i class="fas fa-check"></i> Duyệt
                                    </button>
                                </form>

                                <button type="button" class="btn btn-primary btn-sm" onclick="toggleReplyForm(${review.reviewID})">
                                    <i class="fas fa-reply"></i> Phản Hồi
                                </button>

                                <form method="post" action="${pageContext.request.contextPath}/feedback" class="d-inline"
                                      onsubmit="return confirm('Bạn có chắc muốn xóa feedback này?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="reviewId" value="${review.reviewID}">
                                    <button type="submit" class="btn btn-danger btn-sm">
                                        <i class="fas fa-trash"></i> Xóa
                                    </button>
                                </form>
                            </div>

                            <!-- Reply Form (Hidden by default) -->
                            <div id="replyForm${review.reviewID}" class="reply-form mt-3" style="display: none;">
                                <form method="post" action="${pageContext.request.contextPath}/feedback">
                                    <input type="hidden" name="action" value="reply">
                                    <input type="hidden" name="reviewId" value="${review.reviewID}">
                                    <div class="mb-2">
                                        <textarea class="form-control" name="adminReply" rows="3" 
                                                  placeholder="Nhập phản hồi của bạn..." required></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-primary btn-sm">
                                        <i class="fas fa-paper-plane"></i> Gửi Phản Hồi
                                    </button>
                                    <button type="button" class="btn btn-secondary btn-sm" onclick="toggleReplyForm(${review.reviewID})">
                                        Hủy
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${empty pendingReviews}">
        <div class="alert alert-info text-center">
            <i class="fas fa-inbox" style="font-size: 48px; color: #ddd;"></i>
            <p class="mt-3">Không có feedback nào chờ duyệt</p>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-primary mt-3">
                <i class="fas fa-arrow-left"></i> Quay Lại
            </a>
        </div>
    </c:if>
</main>

<%@include file="../common/footer.jsp" %>

<script>
    function toggleReplyForm(reviewId) {
        const form = document.getElementById('replyForm' + reviewId);
        if (form.style.display === 'none') {
            form.style.display = 'block';
        } else {
            form.style.display = 'none';
        }
    }
</script>

