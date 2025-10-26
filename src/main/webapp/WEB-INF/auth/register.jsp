<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Đăng Ký - Aurora Hotel" scope="request"/>
<jsp:include page="../common/head.jsp"/>

<body>
<div class="container">
    <div class="row justify-content-center" style="min-height: 100vh; align-items: center;">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow-lg">
                <div class="card-body p-5">
                    <!-- Logo & Title -->
                    <div class="text-center mb-4">
                        <i class="fas fa-hotel fa-3x text-primary mb-3"></i>
                        <h2 class="fw-bold">Đăng Ký Tài Khoản</h2>
                        <p class="text-muted">Aurora Hotel - Trải nghiệm sang trọng</p>
                    </div>

                    <!-- Error Message -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Registration Form -->
                    <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm">
                        <!-- Username -->
                        <div class="mb-3">
                            <label for="username" class="form-label">
                                Tên đăng nhập <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="username" name="username"
                                       required minlength="3" maxlength="50"
                                       pattern="[a-zA-Z0-9_]+"
                                       title="Chỉ chứa chữ cái, số và dấu gạch dưới"
                                       placeholder="Nhập tên đăng nhập">
                            </div>
                        </div>

                        <!-- Full Name -->
                        <div class="mb-3">
                            <label for="fullName" class="form-label">
                                Họ và tên <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                <input type="text" class="form-control" id="fullName" name="fullName"
                                       required maxlength="100"
                                       placeholder="Nhập họ và tên đầy đủ">
                            </div>
                        </div>

                        <!-- Phone -->
                        <div class="mb-3">
                            <label for="phone" class="form-label">
                                Số điện thoại <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                <input type="tel" class="form-control" id="phone" name="phone"
                                       required pattern="0[0-9]{9,10}"
                                       title="Số điện thoại phải bắt đầu bằng 0 và có 10-11 số"
                                       placeholder="Nhập số điện thoại">
                            </div>
                        </div>

                        <!-- Email -->
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email"
                                       maxlength="100"
                                       placeholder="Nhập email (không bắt buộc)">
                            </div>
                        </div>

                        <!-- Password -->
                        <div class="mb-3">
                            <label for="password" class="form-label">
                                Mật khẩu <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password"
                                       required minlength="6" maxlength="50"
                                       placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('password')">
                                    <i class="fas fa-eye" id="togglePasswordIcon"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Confirm Password -->
                        <div class="mb-4">
                            <label for="confirmPassword" class="form-label">
                                Xác nhận mật khẩu <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                       required minlength="6" maxlength="50"
                                       placeholder="Nhập lại mật khẩu">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('confirmPassword')">
                                    <i class="fas fa-eye" id="toggleConfirmPasswordIcon"></i>
                                </button>
                            </div>
                            <div class="invalid-feedback" id="passwordMismatch" style="display: none;">
                                Mật khẩu xác nhận không khớp!
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-user-plus me-2"></i>Đăng Ký
                            </button>
                        </div>

                        <!-- Login Link -->
                        <div class="text-center">
                            <p class="mb-0">
                                Đã có tài khoản?
                                <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-bold">
                                    Đăng nhập ngay
                                </a>
                            </p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Toggle password visibility
    function togglePassword(fieldId) {
        const field = document.getElementById(fieldId);
        const icon = document.getElementById('toggle' + fieldId.charAt(0).toUpperCase() + fieldId.slice(1) + 'Icon');

        if (field.type === 'password') {
            field.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            field.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }

    // Validate password match
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const mismatchMsg = document.getElementById('passwordMismatch');

        if (password !== confirmPassword) {
            e.preventDefault();
            mismatchMsg.style.display = 'block';
            document.getElementById('confirmPassword').classList.add('is-invalid');
        } else {
            mismatchMsg.style.display = 'none';
            document.getElementById('confirmPassword').classList.remove('is-invalid');
        }
    });

    // Clear mismatch message when typing
    document.getElementById('confirmPassword').addEventListener('input', function() {
        const password = document.getElementById('password').value;
        const confirmPassword = this.value;
        const mismatchMsg = document.getElementById('passwordMismatch');

        if (password === confirmPassword) {
            mismatchMsg.style.display = 'none';
            this.classList.remove('is-invalid');
            this.classList.add('is-valid');
        } else {
            mismatchMsg.style.display = 'block';
            this.classList.add('is-invalid');
            this.classList.remove('is-valid');
        }
    });
</script>

</body>
</html>
