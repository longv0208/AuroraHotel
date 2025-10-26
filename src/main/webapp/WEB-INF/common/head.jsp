<%-- Document : head Created on : Oct 25, 2025 Author : Aurora Hotel Team Description: Common <head> section - Simple,
    clean Bootstrap 5 design
    --%>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <title>${pageTitle != null ? pageTitle : 'Aurora Hotel'}</title>

            <!-- Bootstrap 5 CSS CDN -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            <!-- Font Awesome for icons -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <!-- Custom CSS - Simple and Clean -->
            <style>
                /* Simple, clean design - no complex effects */
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background-color: #f8f9fa;
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                main {
                    flex: 1;
                    padding-top: 2rem;
                    padding-bottom: 2rem;
                }

                /* Navbar - Simple gradient */
                .navbar {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    padding: 0.75rem 1rem;
                }

                .navbar-brand {
                    font-size: 1.5rem;
                    font-weight: 700;
                    color: #fff !important;
                    margin-right: 2rem;
                }

                .navbar-nav {
                    gap: 0.25rem;
                }

                .nav-link {
                    color: rgba(255, 255, 255, 0.9) !important;
                    font-weight: 500;
                    padding: 0.5rem 1rem !important;
                    border-radius: 0.25rem;
                    transition: all 0.2s ease;
                }

                .nav-link:hover {
                    color: #fff !important;
                    background-color: rgba(255, 255, 255, 0.1);
                }

                .nav-link.active {
                    color: #fff !important;
                    font-weight: 600;
                    background-color: rgba(255, 255, 255, 0.15);
                }

                .nav-link i {
                    margin-right: 0.35rem;
                }

                /* Profile image */
                .profile-img-container {
                    width: 35px;
                    height: 35px;
                    overflow: hidden;
                    border: 2px solid rgba(255, 255, 255, 0.3);
                }

                .profile-img-container img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                /* Dropdown */
                .dropdown-menu {
                    border: none;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                    border-radius: 0.5rem;
                    margin-top: 0.5rem;
                }

                .dropdown-item {
                    padding: 0.5rem 1.25rem;
                    transition: all 0.2s ease;
                }

                .dropdown-item:hover {
                    background-color: #f8f9fa;
                    padding-left: 1.5rem;
                }

                .dropdown-item i {
                    width: 20px;
                    text-align: center;
                }

                /* Cards - Simple shadow */
                .card {
                    border: none;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
                }

                .card:hover {
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
                }

                /* Buttons */
                .btn {
                    font-weight: 500;
                    padding: 0.5rem 1.5rem;
                }

                /* Tables */
                .table {
                    background-color: #fff;
                }

                .table thead {
                    background-color: #f8f9fa;
                }

                /* Pagination */
                .pagination {
                    margin-top: 1.5rem;
                }

                /* Alerts */
                .alert {
                    border: none;
                    border-radius: 0.5rem;
                }

                /* Footer */
                footer {
                    background-color: #343a40;
                    color: #fff;
                    padding: 2rem 0;
                    margin-top: auto;
                }

                footer a {
                    color: rgba(255, 255, 255, 0.8);
                    text-decoration: none;
                }

                footer a:hover {
                    color: #fff;
                }
            </style>

            <!-- Bootstrap 5 JS Bundle (includes Popper) -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </head>

        <body>