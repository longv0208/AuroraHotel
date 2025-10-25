<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Đánh Giá Của Tôi - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>
<jsp:include page="../common/navbar.jsp"/>

<main class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="display-6 fw-bold">
            <i class="fas fa-star text-warning me-2"></i>
            Đánh Giá Của Tôi
        </h1>
        <a href="${pageContext.request.contextPath}/review?view=create" class="btn btn-success">
            <i class="fas fa-plus me-2"></i>
            Viết Đánh Giá Mới
        </a>
    </div>

    <c:choose>
        <c:when test="${empty reviews}">
            <div class="alert alert-info text-center py-5">
                <i class="fas fa-star fa-3x mb-3"></i>
                <h4>Chưa có đánh giá nào</h4>
                <p>Bạn chưa viết đánh giá nào trong hệ thống.</p>
                <a href="${pageContext.request.contextPath}/review?view=create" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>
                    Viết Đánh Giá Đầu Tiên
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row row-cols-1 g-4">
                <c:forEach var="review" items="${reviews}">
                    <div class="col">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <div>
                                                <h5 class="card-title mb-1">
                                                    ${review.title}
                                                    <c:choose>
                                                        <c:when test="${review.status == 'Approved'}">
                                                            <span class="badge bg-success ms-2">Đã duyệt</span>
                                                        </c:when>
                                                        <c:when test="${review.status == 'Pending'}">
                                                            <span class="badge bg-warning text-dark ms-2">Chờ duyệt</span>
                                                        </c:when>
                                                        <c:when test="${review.status == 'Rejected'}">
                                                            <span class="badge bg-danger ms-2">Từ chối</span>
                                                        </c:when>
                                                    </c:choose>
                                                </h5>
                                                <p class="text-muted small mb-0">
                                                    <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <div class="d-flex align-items-center mb-2">
                                                <span class="me-2">Đánh giá:</span>
                                                <c:forEach begin="1" end="5" var="star">
                                                    <i class="fas fa-star ${star <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                                </c:forEach>
                                                <span class="ms-2 fw-bold">${review.rating}/5</span>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <strong>Nội dung:</strong><br>
                                            <p class="mb-0">${review.content}</p>
                                        </div>

                                        <c:if test="${not empty review.adminReply}">
                                            <div class="alert alert-info">
                                                <strong>Phản hồi từ quản trị:</strong><br>
                                                ${review.adminReply}
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="col-md-4 border-start">
                                        <div class="text-center mb-3">
                                            <div class="d-flex align-items-center justify-content-center mb-2">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <i class="fas fa-star ${star <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                                </c:forEach>
                                            </div>
                                            <h4 class="text-warning mb-0">${review.rating}/5</h4>
                                        </div>

                                        <div class="d-grid">
                                            <c:if test="${review.status == 'Pending'}">
                                                <a href="${pageContext.request.contextPath}/review?view=edit&id=${review.reviewID}" 
                                                   class="btn btn-outline-warning btn-sm">
                                                    <i class="fas fa-edit me-1"></i>
                                                    Chỉnh Sửa
                                                </a>
                                            </c:if>
                                            <c:if test="${review.status == 'Rejected'}">
                                                <a href="${pageContext.request.contextPath}/review?view=create" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-plus me-1"></i>
                                                    Viết Lại
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="../common/footer.jsp"/>

