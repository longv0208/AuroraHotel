<%-- Document : room Created on : Oct 20, 2025, 11:16:06 AM Author : BA LIEM --%>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <c:set var="pageTitle" value="Rooms - Aurora Hotel" scope="request" />
            <%@include file="../common/head.jsp" %>
                <%@include file="../common/navbar.jsp" %>

                    <main class="container my-5">
                        <form action="${pageContext.request.contextPath}/aurora" method="POST">
                            <input type="hidden" name="action" value="edit" />
                            <style>
                                .room-card {
                                    background-color: #f7f7f7;
                                    border-radius: 10px;
                                    overflow: hidden;
                                    margin-bottom: 2rem;
                                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                                }

                                .room-img {
                                    width: 100%;
                                    height: 100%;
                                    object-fit: cover;
                                }

                                .room-info {
                                    padding: 30px;
                                }

                                .room-info h3 {
                                    font-weight: 600;
                                    margin-bottom: 1rem;
                                }

                                .room-features i {
                                    font-size: 20px;
                                    margin-right: 8px;
                                    color: #555;
                                }

                                .btn-view {
                                    background-color: #c08c5a;
                                    color: white;
                                    font-weight: 600;
                                    border: none;
                                    padding: 10px 25px;
                                    border-radius: 5px;
                                }

                                .btn-view:hover {
                                    background-color: #a97546;
                                }
                            </style>
                            <div class="container py-5">
                                <div class="room-card row">
                                    <!-- Cột ảnh -->
                                    <div class="col-md-6 p-0">
                                        <img src="https://i.pinimg.com/1200x/3a/e7/a4/3ae7a4f55428966f74c2a87dc589263f.jpg"
                                            alt="Standard Room" class="room-img">
                                    </div>

                                    <!-- Cột thông tin -->
                                    <div class="col-md-6 room-info d-flex flex-column justify-content-center">
                                        <h3>STANDARD ROOM</h3>
                                        <div class="room-features mb-3">
                                            <p><i class="bi bi-aspect-ratio"></i>Diện tích: 20 m²</p>
                                            <p><i class="bi bi-person"></i>Sức chứa: 2 người</p>
                                            <p><i class="bi bi-laptop"></i>Bàn làm việc</p>
                                            <p><i class="bi bi-cup-hot"></i>Trà & cà phê miễn phí</p>
                                        </div>

                                        <p class="mb-3">
                                            Phòng Standard mang đến cho bạn không gian thoải mái và tiện nghi,
                                            là lựa chọn lý tưởng để thư giãn trong chuyến công tác hoặc nghỉ dưỡng.
                                        </p>

                                        <h5 class="text-success mb-3">Giá: 1.200.000 VND / đêm</h5>

                                        <div>
                                            <a href="${pageContext.request.contextPath}/aurora"
                                                class="btn btn-view">Booking</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </main>
                    <%@include file="../common/footer.jsp" %>