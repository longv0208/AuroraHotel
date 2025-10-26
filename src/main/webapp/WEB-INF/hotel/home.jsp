<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="Home - Aurora Hotel" scope="request" />
        <%@include file="../common/head.jsp" %>
            <%@include file="../common/navbar.jsp" %>
                <main class="container mt-4">
                    <div id="hotelCarousel" class="carousel slide shadow-lg mb-5" data-bs-ride="carousel">
                        <div class="carousel-inner rounded-3">

                            <div class="carousel-item active">

                                <img src="https://i.pinimg.com/1200x/37/51/a5/3751a54794ee85629c7881c205cb614e.jpg"
                                    class="d-block w-100" alt="Phòng Hot">
                                <div class="carousel-caption d-none d-md-block">
                                    <h2 class="fw-bold bg-dark p-1 bg-opacity-75 rounded">ƯU ĐÃI ĐẶC BIỆT!</h2>
                                    <p class="bg-dark p-1 bg-opacity-75 rounded">Giảm 20% khi đặt phòng Suite 3 đêm đầu
                                        tiên.</p>
                                </div>
                            </div>

                            <div class="carousel-item">

                                <img src="https://i.pinimg.com/1200x/11/f5/1c/11f51cc2eae71f4ae1ff495a577627c6.jpg"
                                    class="d-block w-100" alt="Giá Tốt">
                                <div class="carousel-caption d-none d-md-block">
                                    <h2 class="fw-bold bg-dark p-1 bg-opacity-75 rounded">CHỈ TỪ 500K/ĐÊM</h2>
                                    <p class="bg-dark p-1 bg-opacity-75 rounded">Áp dụng cho phòng tiêu chuẩn vào ngày
                                        thường.</p>
                                </div>
                            </div>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#hotelCarousel"
                            data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Previous</span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#hotelCarousel"
                            data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Next</span>
                        </button>
                    </div>


                    <div class="text-center my-5">
                        <a href="${pageContext.request.contextPath}/booking?view=search"
                            class="btn btn-success btn-lg fw-bold shadow-sm px-5">
                            <i class="fas fa-search me-2"></i>
                            Tìm Kiếm Phòng
                        </a>
                        <c:if test="${sessionScope.loggedInUser != null}">
                            <a href="${pageContext.request.contextPath}/booking?view=my-bookings"
                                class="btn btn-primary btn-lg fw-bold shadow-sm px-5 ms-3">
                                <i class="fas fa-list me-2"></i>
                                Booking Của Tôi
                            </a>
                        </c:if>
                    </div>


                    <h2 class="text-center mb-4 text-primary fw-bold">PHÒNG NỔI BẬT</h2>
                    <div class="row row-cols-1 row-cols-md-3 g-4">

                        <div class="col">
                            <div class="card h-100 shadow-sm border-0">

                                <img src="https://i.pinimg.com/1200x/e0/15/6d/e0156d8697cb8748b2e72b333e5d9669.jpg"
                                    class="card-img-top" alt="Phòng View Biển">
                                <div class="card-body">
                                    <h5 class="card-title text-success fw-bold">Phòng Deluxe View Biển</h5>
                                    <p class="card-text">Tận hưởng bình minh từ ban công riêng, tiện nghi sang trọng. <i
                                            class="fas fa-star text-warning"></i> 4.5/5</p>
                                    <p class="fw-bold text-danger mb-4">2.500K/đêm</p>
                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/room" class="btn btn-primary">Xem Chi Tiết</a>
                                        <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-outline-success">Đặt Phòng</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col">
                            <div class="card h-100 shadow-sm border-0">

                                <img src="https://i.pinimg.com/1200x/f9/c1/5f/f9c15f9a87479ee1fd537182d004cceb.jpg"
                                    class="card-img-top" alt="Phòng Gia Đình">
                                <div class="card-body">
                                    <h5 class="card-title text-success fw-bold">Phòng Family Suite</h5>
                                    <p class="card-text">Không gian rộng rãi, lý tưởng cho gia đình 4 người. <i
                                            class="fas fa-star text-warning"></i> 4.8/5</p>
                                    <p class="fw-bold text-danger mb-4">3.200K/đêm</p>
                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/room" class="btn btn-primary">Xem Chi Tiết</a>
                                        <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-outline-success">Đặt Phòng</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col">
                            <div class="card h-100 shadow-sm border-0">

                                <img src="https://i.pinimg.com/1200x/42/b6/8c/42b68cd2490f7a0467234a71b4d4d6fb.jpg"
                                    class="card-img-top" alt="Phòng Tiêu Chuẩn">
                                <div class="card-body">
                                    <h5 class="card-title text-success fw-bold">Phòng Standard King</h5>
                                    <p class="card-text">Lựa chọn kinh tế, tiện nghi cơ bản, sạch sẽ. <i
                                            class="fas fa-star text-warning"></i> 4.2/5</p>
                                    <p class="fw-bold text-danger mb-4">1.500K/đêm</p>
                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/room" class="btn btn-primary">Xem Chi Tiết</a>
                                        <a href="${pageContext.request.contextPath}/booking?view=search" class="btn btn-outline-success">Đặt Phòng</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

                <%@include file="../common/footer.jsp" %>