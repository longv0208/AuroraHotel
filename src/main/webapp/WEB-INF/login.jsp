<%-- Document : login Created on : Oct 20, 2025, 10:36:12 AM Author : BA LIEM --%>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <c:set var="pageTitle" value="Đăng nhập - Aurora Hotel" scope="request" />
            <%@include file="common/head.jsp" %>

                <!-- Login page doesn't need navbar -->
                <main class="container my-5">
                    <div class="row justify-content-center">
                        <div class="col-md-5 col-lg-4">
                            <div class="card shadow">
                                <div class="card-body p-4">
                                    <!-- Logo and Title -->
                                    <div class="text-center mb-4">
                                        <i class="fas fa-hotel fa-3x text-primary mb-3"></i>
                                        <h2 class="fw-bold">Aurora Hotel</h2>
                                        <p class="text-muted">Đăng nhập vào hệ thống</p>
                                    </div>

                                    <!-- Success Message (Logout or Registration) -->
                                    <c:if test="${param.logout == 'success'}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <i class="fas fa-check-circle me-2"></i>
                                            Đăng xuất thành công!
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                aria-label="Close"></button>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty successMessage}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <i class="fas fa-check-circle me-2"></i>
                                            ${successMessage}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                aria-label="Close"></button>
                                        </div>
                                    </c:if>

                                    <!-- Error Message -->
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <i class="fas fa-exclamation-circle me-2"></i>
                                            ${errorMessage}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                aria-label="Close"></button>
                                        </div>
                                    </c:if>

                                    <!-- Login Form -->
                                    <form action="${pageContext.request.contextPath}/login" method="POST">
                                        <!-- Username -->
                                        <div class="mb-3">
                                            <label for="username" class="form-label">
                                                <i class="fas fa-user me-1"></i> Tên đăng nhập
                                            </label>
                                            <input type="text" class="form-control" id="username" name="username"
                                                placeholder="Nhập tên đăng nhập" value="${username}" required autofocus>
                                        </div>

                                        <!-- Password -->
                                        <div class="mb-3">
                                            <label for="password" class="form-label">
                                                <i class="fas fa-lock me-1"></i> Mật khẩu
                                            </label>
                                            <input type="password" class="form-control" id="password" name="password"
                                                placeholder="Nhập mật khẩu" required>
                                        </div>

                                        <!-- Remember Me -->
                                        <div class="mb-3 form-check">
                                            <input type="checkbox" class="form-check-input" id="rememberMe"
                                                name="rememberMe">
                                            <label class="form-check-label" for="rememberMe">
                                                Ghi nhớ đăng nhập
                                            </label>
                                        </div>

                                        <!-- Hidden redirect parameter -->
                                        <c:if test="${not empty param.redirect}">
                                            <input type="hidden" name="redirect" value="${param.redirect}">
                                        </c:if>

                                        <!-- Submit Button -->
                                        <div class="d-grid">
                                            <button type="submit" class="btn btn-primary btn-lg">
                                                <i class="fas fa-sign-in-alt me-2"></i> Đăng nhập
                                            </button>
                                        </div>
                                    </form>

                                    <!-- Additional Links -->
                                    <div class="text-center mt-3">
                                        <p class="mb-0">
                                            Chưa có tài khoản?
                                            <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-bold">
                                                Đăng ký ngay
                                            </a>
                                        </p>
                                    </div>

                                    <div class="text-center mt-3">
                                        <a href="${pageContext.request.contextPath}/home"
                                            class="text-decoration-none text-muted">
                                            <i class="fas fa-arrow-left me-1"></i> Quay lại trang chủ
                                        </a>
                                    </div>


                                </div>
                            </div>


                        </div>
                    </div>
                </main>

                <%@include file="common/footer.jsp" %>