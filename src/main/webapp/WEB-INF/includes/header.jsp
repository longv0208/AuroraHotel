<%-- 
    Document   : header
    Created on : Oct 17, 2025, 12:21:54 PM
    Author     : BA LIEM
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Aurora Hotel</title>

        <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
        <style>
            /* Tùy chỉnh nhỏ để đảm bảo ảnh đại diện hiển thị tốt */
            .profile-img-container {
                width: 30px;
                height: 30px;
                overflow: hidden;
                /* Tùy chọn: Thêm viền nhỏ cho ảnh đại diện */
                border: 1px solid #ccc;
            }
            .navbar{
                background: radial-gradient(circle at 20% 30%, #FFD43B, #7B2FF7, #1E3A8A);
            }
            .profile-img-container {
                width: 40px;
                height: 40px;
                overflow: hidden; /* tránh ảnh bị tràn */
            }
            .navbar-brand {
                font-size: 28px;      /* tăng kích thước chữ */
                font-weight: 800;     /* in đậm rõ hơn */
                color: #000000 !important; /* màu chữ trắng (đẹp trên nền bg-info) */
                letter-spacing: 1px;  /* giãn nhẹ chữ cho sang hơn */
                text-shadow: 1px 1px 2px rgba(0,0,0,0.3); /* tạo bóng nhẹ cho nổi bật */
            }
            .nav-item {
                font-size: 20px;
                font-weight: 500;
                color: #000000 !important; /* màu chữ trắng (đẹp trên nền bg-info) */
                letter-spacing: 1px;  /* giãn nhẹ chữ cho sang hơn */
                text-shadow: 1px 1px 2px rgba(0,0,0,0.3); /* tạo bóng nhẹ cho nổi bật */
            }
            .nav-link {
                color: #000 !important; /* chữ mặc định đen */
                font-weight: 500;
                padding: 8px 16px;
                border-radius: 8px;
                transition: all 0.3s ease; /* hiệu ứng mượt */
            }

            /* Khi rê chuột */
            .nav-link:hover {
                background-color: rgba(255, 255, 255, 0.3); /* nền nhạt */
                color: #fff !important;
            }

            /* Khi tab đang được chọn (active) */
/*            .nav-link.active {
                background-color: #FF3333;  nền đỏ cà chua Bootstrap 
                color: #fff !important;    chữ trắng 
                font-weight: 600;
                border-radius: 8px;
                box-shadow: 0 0 8px rgba(0, 0, 0, 0.15);  đổ bóng nhẹ cho nổi 
            }*/
            /* Tùy chỉnh riêng cho phần profile ở góc phải */
            .nav-profile {
                color: #000; /* màu chữ đen */
                font-weight: 600;
                text-decoration: none;
                cursor: pointer;
                display: flex;
                align-items: center; /* căn giữa theo chiều dọc */
            }

            /* Khi hover thì không đổi màu nền */
            .nav-profile:hover,
            .nav-profile:focus {
                background-color: transparent !important;
                color: #000 !important;
                text-decoration: underline; /* tuỳ chọn: gạch chân khi hover */
            }

            /* Dropdown items cũng bỏ nền */
            .dropdown-menu .dropdown-item:hover,
            .dropdown-menu .dropdown-item:focus {
                background-color: transparent !important;
                color: #000 !important;
                font-weight: 600;
            }
            .profile-img-container img {
                display: block; /* loại bỏ khoảng trống mặc định dưới ảnh */
            }
            

        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg navbar-light">

            <div class="container-fluid">
                <div class="profile-img-container rounded-circle me-2">
                    <img 
                        src="${pageContext.request.contextPath}/assets/img/img_logo.png" 
                        alt="Ảnh đại diện" 
                        width="100%" 
                        height="100%" 
                        class="rounded-circle"
                        >
                </div>
                <a class="navbar-brand" href="${pageContext.request.contextPath}/aurora" >Aurora Hotel</a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar" aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>



                <div class="collapse navbar-collapse" id="mainNavbar">
                    <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page" href="${pageContext.request.contextPath}/aurora">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/about">About</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/room">Room</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/service">Service</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/feedback">Feedback</a>
                        </li>
                    </ul>
                </div>

                <ul class="navbar-nav">
                    <li class="nav-item dropdown">

                        <a class="nav-profile d-flex align-items-center dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">

                            <div class="profile-img-container rounded-circle me-2">
                                <img 
                                    src="https://i.pinimg.com/736x/ac/b0/76/acb076e352a186f0568c08f7f9d88f70.jpg" 
                                    alt="Avt Profile" 
                                    width="100%" 
                                    height="100%" 
                                    class="active"
                                    >
                            </div>

                            Xin chào, Nguyễn Văn A</a>

                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="#">Profile</a></li>
                            <li><a class="dropdown-item" href="#">Setting</a></li>
                            <li><a class="dropdown-item" href="#">Management</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>
