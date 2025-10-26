<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="Feedback - Aurora Hotel" scope="request" />
            <%@include file="../common/head.jsp" %>
                <%@include file="../common/navbar.jsp" %>

                    <main class="container py-5">
                        <div class="row">
                            <div class="col-lg-8 mx-auto">
                                <h1 class="mb-4"><i class="fas fa-comments"></i> Feedback & Đánh Giá</h1>

                                <!-- Success/Error Messages -->
                                <c:if test="${not empty success}">
                                    <div class="alert alert-success alert-dismissible fade show">
                                        <i class="fas fa-check-circle"></i> ${success}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible fade show">
                                        <i class="fas fa-exclamation-circle"></i> ${error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <!-- Feedback Form -->
                                <c:if test="${sessionScope.loggedInUser != null}">
                                    <c:choose>
                                        <c:when test="${not empty availableBookings}">
                                            <div class="card shadow-sm mb-5">
                                                <div class="card-header bg-primary text-white">
                                                    <h5 class="mb-0"><i class="fas fa-edit"></i> Gửi Đánh Giá Của Bạn</h5>
                                                </div>
                                                <div class="card-body">
                                                    <form method="post" action="${pageContext.request.contextPath}/feedback">
                                                        <!-- Booking Selection -->
                                                        <div class="mb-3">
                                                            <label for="bookingID" class="form-label">Chọn Booking Để Đánh Giá <span
                                                                    class="text-danger">*</span></label>
                                                            <select class="form-select" id="bookingID" name="bookingID" required>
                                                                <option value="">-- Chọn booking --</option>
                                                                <c:forEach var="booking" items="${availableBookings}">
                                                                    <option value="${booking.bookingID}" ${selectedBookingID == booking.bookingID ? 'selected' : ''}>
                                                                        Booking #${booking.bookingID} - 
                                                                        <c:if test="${not empty booking.room and not empty booking.room.roomType}">
                                                                            ${booking.room.roomType.typeName}
                                                                        </c:if>
                                                                        <c:if test="${empty booking.room or empty booking.room.roomType}">
                                                                            Phòng ${booking.roomID}
                                                                        </c:if>
                                                                        - 
                                                                        <fmt:formatDate value="${booking.checkInDate}" pattern="dd/MM/yyyy"/> 
                                                                        đến 
                                                                        <fmt:formatDate value="${booking.checkOutDate}" pattern="dd/MM/yyyy"/>
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                            <small class="text-muted">Chỉ hiển thị các booking đã checkout và chưa được đánh giá</small>
                                                        </div>

                                                        <!-- Rating -->
                                                        <div class="mb-3">
                                                            <label class="form-label">Đánh Giá <span
                                                                    class="text-danger">*</span></label>
                                                            <div class="rating-stars">
                                                                <input type="hidden" id="ratingInput" name="rating"
                                                                    value="${not empty rating ? rating : '5'}">
                                                                <c:forEach var="i" begin="1" end="5">
                                                                    <i class="fas fa-star star ${i <= (not empty rating ? rating : 5) ? 'active' : ''}"
                                                                        onclick="setRating(${i})"
                                                                        style="cursor: pointer; font-size: 24px;"></i>
                                                                </c:forEach>
                                                            </div>
                                                        </div>

                                                        <!-- Comment -->
                                                        <div class="mb-3">
                                                            <label for="comment" class="form-label">Nội Dung Đánh Giá <span
                                                                    class="text-danger">*</span></label>
                                                            <textarea class="form-control" id="comment" name="comment" rows="5"
                                                                placeholder="Chia sẻ trải nghiệm của bạn về khách sạn..." required
                                                                minlength="10"
                                                                maxlength="1000">${not empty comment ? comment : ''}</textarea>
                                                            <small class="text-muted">Tối thiểu 10 ký tự, tối đa 1000 ký tự</small>
                                                        </div>

                                                        <button type="submit" class="btn btn-primary">
                                                            <i class="fas fa-paper-plane"></i> Gửi Đánh Giá
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-info mb-5">
                                                <i class="fas fa-info-circle"></i> 
                                                Bạn chưa có booking nào đã checkout để đánh giá. 
                                                <a href="${pageContext.request.contextPath}/booking?view=my-bookings" class="alert-link">Xem bookings của tôi</a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                
                                <c:if test="${sessionScope.loggedInUser == null}">
                                    <div class="alert alert-warning mb-5">
                                        <i class="fas fa-exclamation-triangle"></i> 
                                        Vui lòng <a href="${pageContext.request.contextPath}/login" class="alert-link">đăng nhập</a> 
                                        để đánh giá các booking của bạn.
                                    </div>
                                </c:if>

                                <!-- Approved Reviews List -->
                                <h3 class="mb-4">Đánh Giá Từ Khách Hàng</h3>

                                <c:if test="${not empty approvedReviews}">
                                    <c:forEach var="review" items="${approvedReviews}">
                                        <div class="card mb-3 shadow-sm">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div>
                                                        <h6 class="mb-1">
                                                            <c:choose>
                                                                <c:when test="${review.customerID > 0}">
                                                                    Khách hàng #${review.customerID}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Khách
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </h6>
                                                        <div class="rating-stars-small">
                                                            <c:forEach var="i" begin="1" end="5">
                                                                <i
                                                                    class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${review.reviewDate}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </small>
                                                </div>

                                                <p class="mb-2">${review.comment}</p>

                                                <!-- Admin Reply -->
                                                <c:if test="${not empty review.adminReply}">
                                                    <div
                                                        class="alert alert-light border-start border-primary border-4 mt-3">
                                                        <strong><i class="fas fa-reply"></i> Phản Hồi Từ Quản
                                                            Lý:</strong>
                                                        <p class="mb-0 mt-2">${review.adminReply}</p>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${review.replyDate}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </small>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <!-- Pagination -->
                                    <c:if test="${totalPages > 1}">
                                        <nav>
                                            <ul class="pagination justify-content-center">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="?page=${currentPage - 1}">Trước</a>
                                                </li>

                                                <c:forEach var="i" begin="1" end="${totalPages}">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link" href="?page=${i}">${i}</a>
                                                    </li>
                                                </c:forEach>

                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link" href="?page=${currentPage + 1}">Sau</a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:if>
                                </c:if>

                                <c:if test="${empty approvedReviews}">
                                    <div class="alert alert-info text-center">
                                        <i class="fas fa-info-circle"></i> Chưa có đánh giá nào. Hãy là người đầu tiên
                                        đánh giá!
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </main>

                    <%@include file="../common/footer.jsp" %>

                        <style>
                            .rating-stars .star {
                                color: #ddd;
                                transition: color 0.2s;
                            }

                            .rating-stars .star.active {
                                color: #ffc107;
                            }

                            .rating-stars .star:hover {
                                color: #ffc107;
                            }
                        </style>

                        <script>
                            function setRating(rating) {
                                document.getElementById('ratingInput').value = rating;
                                const stars = document.querySelectorAll('.rating-stars .star');
                                stars.forEach((star, index) => {
                                    if (index < rating) {
                                        star.classList.add('active');
                                    } else {
                                        star.classList.remove('active');
                                    }
                                });
                            }
                        </script>