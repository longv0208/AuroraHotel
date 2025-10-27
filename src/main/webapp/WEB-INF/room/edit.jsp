<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="Sửa phòng - Aurora Hotel" scope="request" />
        <%@include file="../common/head.jsp" %>
            <%@include file="../common/navbar.jsp" %>

                <main class="container my-5">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <!-- Page Header -->
                            <div class="mb-4">
                                <h2><i class="fas fa-edit me-2"></i> Sửa thông tin phòng</h2>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item">
                                            <a href="${pageContext.request.contextPath}/roomManagement?view=list">Quản
                                                lý phòng</a>
                                        </li>
                                        <li class="breadcrumb-item active">Sửa phòng ${room.roomNumber}</li>
                                    </ol>
                                </nav>
                            </div>

                            <!-- Error Message -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    ${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>

                            <!-- Success Message -->
                            <c:if test="${not empty success}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>
                                    ${success}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>

                            <!-- Edit Form -->
                            <div class="card shadow">
                                <div class="card-body p-4">
                                    <form action="${pageContext.request.contextPath}/roomManagement" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" name="roomID" value="${room.roomID}">

                                        <!-- Room Number -->
                                        <div class="mb-3">
                                            <label for="roomNumber" class="form-label">
                                                <i class="fas fa-door-closed me-1"></i> Số phòng <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <input type="text"
                                                class="form-control ${not empty error ? 'is-invalid' : ''}"
                                                id="roomNumber" name="roomNumber" value="${room.roomNumber}" required>
                                            <c:if test="${not empty error}">
                                                <div class="invalid-feedback d-block">
                                                    ${error}
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Room Type -->
                                        <div class="mb-3">
                                            <label for="roomTypeID" class="form-label">
                                                <i class="fas fa-bed me-1"></i> Loại phòng <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" id="roomTypeID" name="roomTypeID" required>
                                                <option value="">-- Chọn loại phòng --</option>
                                                <c:forEach var="roomType" items="${roomTypes}">
                                                    <option value="${roomType.roomTypeID}"
                                                        ${roomType.roomTypeID==room.roomTypeID ? 'selected' : '' }>
                                                        ${roomType.typeName} - ${roomType.basePrice} ₫
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Floor -->
                                        <div class="mb-3">
                                            <label for="floor" class="form-label">
                                                <i class="fas fa-building me-1"></i> Tầng <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="floor" name="floor" min="1"
                                                max="50" value="${room.floor}" required>
                                        </div>

                                        <!-- Status -->
                                        <div class="mb-3">
                                            <label for="status" class="form-label">
                                                <i class="fas fa-info-circle me-1"></i> Trạng thái <span
                                                    class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="Trống" ${room.status=='Trống' ? 'selected' : '' }>Trống
                                                </option>
                                                <option value="Đã đặt" ${room.status=='Đã đặt' ? 'selected' : '' }>Đã
                                                    đặt</option>
                                                <option value="Đang sử dụng" ${room.status=='Đang sử dụng' ? 'selected'
                                                    : '' }>Đang sử dụng</option>
                                                <option value="Bảo trì" ${room.status=='Bảo trì' ? 'selected' : '' }>Bảo
                                                    trì</option>
                                            </select>
                                        </div>

                                        <!-- Description -->
                                        <div class="mb-3">
                                            <label for="description" class="form-label">
                                                <i class="fas fa-align-left me-1"></i> Mô tả
                                            </label>
                                            <textarea class="form-control" id="description" name="description"
                                                rows="3">${room.description}</textarea>
                                        </div>

                                        <!-- Is Active -->
                                        <div class="mb-3">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="isActive"
                                                    name="isActive" value="1" ${room.active ? 'checked' : '' }>
                                                <label class="form-check-label" for="isActive">
                                                    <i class="fas fa-check-circle me-1"></i> Phòng đang hoạt động
                                                </label>
                                            </div>
                                        </div>

                                        <!-- Buttons -->
                                        <div class="d-flex justify-content-between">
                                            <a href="${pageContext.request.contextPath}/roomManagement?view=list"
                                                class="btn btn-secondary">
                                                <i class="fas fa-arrow-left me-2"></i> Quay lại
                                            </a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-2"></i> Cập nhật
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Room Images Management Section -->
                            <div class="card shadow mt-4">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0">
                                        <i class="fas fa-images me-2"></i> Quản lý ảnh phòng
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <!-- Upload Image Form -->
                                    <form action="${pageContext.request.contextPath}/roomManagement" method="POST" 
                                          enctype="multipart/form-data" class="mb-4">
                                        <input type="hidden" name="action" value="uploadImage">
                                        <input type="hidden" name="roomID" value="${room.roomID}">
                                        
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label for="imageFile" class="form-label">
                                                    <i class="fas fa-upload me-1"></i> Chọn ảnh
                                                </label>
                                                <input type="file" class="form-control" id="imageFile" name="imageFile" 
                                                       accept="image/*" required>
                                            </div>
                                            <div class="col-md-3">
                                                <label for="imageTitle" class="form-label">
                                                    Tiêu đề ảnh
                                                </label>
                                                <input type="text" class="form-control" id="imageTitle" name="imageTitle" 
                                                       placeholder="Ví dụ: Phòng ${room.roomNumber}">
                                            </div>
                                            <div class="col-md-3">
                                                <label for="isPrimary" class="form-label">Ảnh chính</label>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="isPrimary" 
                                                           name="isPrimary" value="true">
                                                    <label class="form-check-label" for="isPrimary">
                                                        Đặt làm ảnh chính
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col-md-2 d-flex align-items-end">
                                                <button type="submit" class="btn btn-success w-100">
                                                    <i class="fas fa-cloud-upload-alt me-1"></i> Upload
                                                </button>
                                            </div>
                                        </div>
                                    </form>

                                    <!-- Existing Images -->
                                    <div class="border-top pt-3">
                                        <h6 class="mb-3">Ảnh hiện có:</h6>
                                        <div id="imagesContainer" class="row">
                                            <c:forEach var="image" items="${roomImages}">
                                                <div class="col-md-3 mb-3 image-item" data-image-id="${image.imageID}">
                                                    <div class="card">
                                                        <div class="position-relative">
                                                            <img src="${pageContext.request.contextPath}/assets/img/${image.imageURL}" 
                                                                 class="card-img-top" style="height: 150px; object-fit: cover;"
                                                                 alt="${image.imageTitle}"
                                                                 onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                            <div class="bg-light d-flex align-items-center justify-content-center" 
                                                                 style="height: 150px; display: none;">
                                                                <i class="fas fa-image text-muted"></i>
                                                            </div>
                                                            <span class="badge ${image.primary ? 'bg-success' : 'bg-secondary'} position-absolute top-0 start-0 m-2">
                                                                ${image.primary ? 'Ảnh chính' : 'Ảnh phụ'}
                                                            </span>
                                                        </div>
                                                        <div class="card-body p-2">
                                                            <p class="card-text small mb-1">${image.imageTitle}</p>
                                                            <div class="btn-group w-100" role="group">
                                                                <button type="button" class="btn btn-sm btn-primary set-primary-btn"
                                                                        data-image-id="${image.imageID}" 
                                                                        data-room-id="${room.roomID}">
                                                                    <i class="fas fa-star"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-danger delete-image-btn"
                                                                        data-image-id="${image.imageID}">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                            
                                            <c:if test="${empty roomImages}">
                                                <div class="col-12">
                                                    <p class="text-muted text-center">
                                                        <i class="fas fa-image me-2"></i>Chưa có ảnh nào được tải lên
                                                    </p>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Hidden form for deleting images -->
                            <form id="deleteImageForm" action="${pageContext.request.contextPath}/roomManagement" 
                                  method="POST" style="display: none;">
                                <input type="hidden" name="action" value="deleteImage">
                                <input type="hidden" name="imageID" id="deleteImageID">
                                <input type="hidden" name="roomID" value="${room.roomID}">
                            </form>

                            <!-- Hidden form for setting primary image -->
                            <form id="setPrimaryImageForm" action="${pageContext.request.contextPath}/roomManagement" 
                                  method="POST" style="display: none;">
                                <input type="hidden" name="action" value="setPrimaryImage">
                                <input type="hidden" name="imageID" id="setPrimaryImageID">
                                <input type="hidden" name="roomID" id="setPrimaryRoomID">
                            </form>
                        </div>
                    </div>
                </main>

                <script>
                    // Delete image handler
                    document.querySelectorAll('.delete-image-btn').forEach(btn => {
                        btn.addEventListener('click', function() {
                            const imageID = this.getAttribute('data-image-id');
                            if (confirm('Bạn có chắc chắn muốn xóa ảnh này?')) {
                                document.getElementById('deleteImageID').value = imageID;
                                document.getElementById('deleteImageForm').submit();
                            }
                        });
                    });

                    // Set primary image handler
                    document.querySelectorAll('.set-primary-btn').forEach(btn => {
                        btn.addEventListener('click', function() {
                            const imageID = this.getAttribute('data-image-id');
                            const roomID = this.getAttribute('data-room-id');
                            document.getElementById('setPrimaryImageID').value = imageID;
                            document.getElementById('setPrimaryRoomID').value = roomID;
                            document.getElementById('setPrimaryImageForm').submit();
                        });
                    });
                </script>

                <%@include file="../common/footer.jsp" %>