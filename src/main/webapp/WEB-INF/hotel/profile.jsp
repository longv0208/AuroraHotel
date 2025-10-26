<%-- Document : profile Created on : Oct 20, 2025, 10:35:45 AM Author : BA LIEM --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Profile - Aurora Hotel" scope="request" />
<%@include file="../common/head.jsp" %>
<%@include file="../common/navbar.jsp" %>

<main class="container my-5">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="fas fa-user me-2"></i>
                        <c:choose>
                            <c:when test="${editMode}">Chỉnh sửa thông tin cá nhân</c:when>
                            <c:otherwise>Thông tin cá nhân</c:otherwise>
                        </c:choose>
                    </h4>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${editMode}">
                            <form method="POST" action="${pageContext.request.contextPath}/profile">
                                <input type="hidden" name="action" value="update">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone}" required>
                                </div>
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i>Lưu thay đổi</button>
                                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary"><i class="fas fa-times me-2"></i>Hủy</a>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="row mb-4">
                                <div class="col-md-3 text-center">
                                    <img src="https://ui-avatars.com/api/?name=${user.fullName}&amp;size=150&amp;background=random" alt="Avatar" class="rounded-circle" width="150" height="150">
                                </div>
                                <div class="col-md-9">
                                    <div class="mb-3"><label class="form-label fw-bold">Họ và tên</label><p class="form-control-plaintext">${user.fullName}</p></div>
                                    <div class="mb-3"><label class="form-label fw-bold">Email</label><p class="form-control-plaintext">${user.email}</p></div>
                                    <div class="mb-3"><label class="form-label fw-bold">Số điện thoại</label><p class="form-control-plaintext">${user.phone}</p></div>
                                    <div class="mb-3"><label class="form-label fw-bold">Vai trò</label><p class="form-control-plaintext"><span class="badge bg-info">${user.role}</span></p></div>
                                </div>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/profile?action=edit" class="btn btn-primary"><i class="fas fa-edit me-2"></i>Chỉnh sửa</a>
                                <a href="${pageContext.request.contextPath}/booking?view=my-bookings" class="btn btn-secondary"><i class="fas fa-list me-2"></i>Xem đơn đặt phòng</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../common/footer.jsp" %>
