<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Duyệt Đánh Giá - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-check-circle text-warning me-2"></i>
            Duyệt Đánh Giá
        </h1>
        <a href="${pageContext.request.contextPath}/review?view=list" class="btn btn-outline-secondary">
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
                        Thông Tin Đánh Giá
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Khách hàng:</strong><br>
                            ${review.customer.fullName}
                        </div>
                        <div class="col-md-6">
                            <strong>Ngày đánh giá:</strong><br>
                            <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong>Đánh giá:</strong><br>
                            <div class="d-flex align-items-center">
                                <c:forEach begin="1" end="5" var="star">
                                    <i class="fas fa-star ${star <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                </c:forEach>
                                <span class="ms-2 fw-bold">${review.rating}/5</span>
                            </div>
                        </div>
                        <div class="col-md-6">
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
                    </div>

                    <div class="mb-3">
                        <strong>Tiêu đề:</strong><br>
                        <p class="mb-0">${review.title}</p>
                    </div>

                    <div class="mb-3">
                        <strong>Nội dung:</strong><br>
                        <p class="mb-0">${review.content}</p>
                    </div>

                    <c:if test="${not empty review.notes}">
                        <div class="mb-3">
                            <strong>Ghi chú:</strong><br>
                            <p class="mb-0 text-muted">${review.notes}</p>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/review">
                        <input type="hidden" name="action" value="moderate">
                        <input type="hidden" name="id" value="${review.reviewID}">

                        <div class="mb-3">
                            <label class="form-label">Phản hồi từ quản trị</label>
                            <textarea name="adminReply" class="form-control" rows="3" placeholder="Phản hồi từ quản trị (không bắt buộc)...">${review.adminReply}</textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="form-select" required>
                                <option value="Pending" ${review.status == 'Pending' ? 'selected' : ''}>Chờ duyệt</option>
                                <option value="Approved" ${review.status == 'Approved' ? 'selected' : ''}>Duyệt</option>
                                <option value="Rejected" ${review.status == 'Rejected' ? 'selected' : ''}>Từ chối</option>
                            </select>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-warning btn-lg">
                                <i class="fas fa-check-circle me-2"></i>
                                Cập Nhật Trạng Thái
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
                        <h3 class="text-warning">${review.rating}/5</h3>
                        <p class="text-muted mb-0">Đánh giá</p>
                    </div>
                    
                    <div class="text-center">
                        <small class="text-muted">
                            Đánh giá ngày: <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy"/>
                        </small>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm mt-3">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-tasks me-2"></i>
                        Thao Tác
                    </h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/review?view=list" 
                           class="btn btn-outline-primary">
                            <i class="fas fa-list me-2"></i>
                            Danh Sách Đánh Giá
                        </a>
                        <a href="${pageContext.request.contextPath}/review?view=my-reviews" 
                           class="btn btn-outline-info">
                            <i class="fas fa-user me-2"></i>
                            Đánh Giá Của Tôi
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>

