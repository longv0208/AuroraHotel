<%-- Document : about Created on : Oct 20, 2025, 10:34:41 AM Author : BA LIEM --%>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <c:set var="pageTitle" value="About - Aurora Hotel" scope="request" />
            <%@include file="../common/head.jsp" %>
                <%@include file="../common/navbar.jsp" %>


                    <main class="container my-5">
                        <form action="${pageContext.request.contextPath}/aurora" method="POST">
                            <input type="hidden" name="action" value="edit" />
                            <div class="row align-items-center mb-5">
                                <div class="col-md-6">
                                    <img src="https://i.pinimg.com/1200x/ec/50/f5/ec50f55df02a0f379af1454878261532.jpg"
                                        class="img-fluid rounded-4 shadow-sm" alt="Aurora Hotel View">
                                </div>
                                <div class="col-md-6">
                                    <h2 class="fw-bold text-primary mb-3">Về Aurora Hotel</h2>
                                    <p class="text-muted">
                                        Chào mừng bạn đến với <strong>Aurora Hotel</strong> – nơi nghỉ dưỡng đẳng cấp
                                        bên bờ
                                        biển.
                                        Khách sạn của chúng tôi mang đến trải nghiệm sang trọng, yên bình và đầy cảm
                                        hứng
                                        với tầm nhìn hướng biển tuyệt đẹp.
                                    </p>
                                    <p class="text-muted">
                                        Tại Aurora, mỗi buổi sáng bạn sẽ được đón bình minh rực rỡ, thưởng thức bữa sáng
                                        phong phú,
                                        và thư giãn trong không gian tinh tế được thiết kế theo phong cách hiện đại hòa
                                        quyện cùng thiên nhiên.
                                    </p>
                                </div>
                            </div>

                            <section class="text-center my-5">
                                <h3 class="fw-bold text-primary mb-4">Tầm Nhìn & Sứ Mệnh</h3>
                                <div class="row g-4">
                                    <div class="col-md-4">
                                        <div class="card h-100 border-0 shadow-sm p-4">
                                            <i class="fas fa-sun text-warning fa-3x mb-3"></i>
                                            <h5 class="fw-bold">Tầm Nhìn</h5>
                                            <p class="text-muted">
                                                Trở thành biểu tượng của sự thanh lịch và thoải mái bên bờ biển, nơi mọi
                                                khoảnh khắc đều trở nên đáng nhớ.
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="card h-100 border-0 shadow-sm p-4">
                                            <i class="fas fa-hand-holding-heart text-danger fa-3x mb-3"></i>
                                            <h5 class="fw-bold">Sứ Mệnh</h5>
                                            <p class="text-muted">
                                                Mang đến trải nghiệm nghỉ dưỡng trọn vẹn với dịch vụ chuyên nghiệp, thân
                                                thiện và tận tâm đến từng chi tiết.
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="card h-100 border-0 shadow-sm p-4">
                                            <i class="fas fa-leaf text-success fa-3x mb-3"></i>
                                            <h5 class="fw-bold">Giá Trị Cốt Lõi</h5>
                                            <p class="text-muted">
                                                Chân thành – Chất lượng – Sáng tạo – Bền vững, hướng đến sự hài lòng tối
                                                đa
                                                của khách hàng.
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <section class="mt-5 text-center">
                                <h3 class="fw-bold text-primary mb-4">Liên Hệ Với Chúng Tôi</h3>
                                <p class="text-muted mb-1"><i class="fas fa-map-marker-alt text-danger me-2"></i>123
                                    Đường
                                    Biển Xanh, TP. Nha Trang</p>
                                <p class="text-muted mb-1"><i class="fas fa-phone-alt text-success me-2"></i>+84 123 456
                                    789
                                </p>
                                <p class="text-muted"><i
                                        class="fas fa-envelope text-primary me-2"></i>contact@aurorahotel.vn</p>
                            </section>
                        </form>

                    </main>


                    <%@include file="../common/footer.jsp" %>