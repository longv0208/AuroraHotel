<%-- Document : navbar Created on : Oct 25, 2025 Author : Aurora Hotel Team Description: Common navigation bar - simple
    and clean design --%>


<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <!-- Logo and Brand -->
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-hotel me-2"></i>
            Aurora Hotel
        </a>

        <!-- Mobile Toggle Button -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navigation Links -->
        <div class="collapse navbar-collapse" id="mainNavbar">
            <!-- Main Menu (Center) -->
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/home') || pageContext.request.requestURI.endsWith('/') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home me-1"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/about') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/about">
                        <i class="fas fa-info-circle me-1"></i> About
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/room') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/room">
                        <i class="fas fa-bed me-1"></i> Rooms
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/booking') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/booking?view=my-bookings">
                        <i class="fas fa-calendar-check me-1"></i> Booking
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/service') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/service">
                        <i class="fas fa-concierge-bell me-1"></i> Services
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/feedback') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/feedback">
                        <i class="fas fa-comments me-1"></i> Feedback
                    </a>
                </li>

                <!-- Admin Menu (Only for Admin role) -->
                <c:if test="${not empty sessionScope.loggedInUser}">
                    <c:set var="userRole" value="${sessionScope.loggedInUser.role}" />
                    <c:if test="${userRole eq 'Admin'}">
                        <li class="nav-item">
                            <a class="nav-link ${pageContext.request.requestURI.contains('/management') ? 'active' : ''}"
                               href="${pageContext.request.contextPath}/feedback?action=admin">
                                <i class="fas fa-comments me-1"></i> Management
                            </a>
                        </li>
                    </c:if>
                </c:if>
                <!--                        <li class="nav-item dropdown">
                                            <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button"
                                                data-bs-toggle="dropdown" aria-expanded="false">
                                                <i class="fas fa-cog me-1"></i> Management
                                            </a>
                                            <ul class="dropdown-menu" aria-labelledby="adminDropdown">
                                                <li><a class="dropdown-item"
                                                        href="${pageContext.request.contextPath}/roomManagement?view=list">
                                                        <i class="fas fa-door-open me-2"></i> Room Management
                                                    </a></li>
                                                <li><a class="dropdown-item"
                                                        href="${pageContext.request.contextPath}/service?view=list">
                                                        <i class="fas fa-concierge-bell me-2"></i> Service Management
                                                    </a></li>
                                                <li><a class="dropdown-item"
                                                        href="${pageContext.request.contextPath}/customer?view=list">
                                                        <i class="fas fa-users me-2"></i> Customer Management
                                                    </a></li>
                                                <li><a class="dropdown-item"
                                                        href="${pageContext.request.contextPath}/booking?view=list">
                                                        <i class="fas fa-calendar-check me-2"></i> Booking Management
                                                    </a></li>
                                                <li>
                                                    <hr class="dropdown-divider">
                                                </li>
                                                <li><a class="dropdown-item"
                                                        href="${pageContext.request.contextPath}/feedback?action=admin">
                                                        <i class="fas fa-comments me-2"></i> Feedback Management
                                                    </a></li>
                                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/coupon?view=list">
                                                        <i class="fas fa-ticket-alt me-2"></i> Coupon Management
                                                    </a></li>
                                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/report">
                                                        <i class="fas fa-chart-line me-2"></i> Reports
                                                    </a></li>
                                            </ul>
                                        </li>-->
            </ul>

            <!-- User Profile Menu (Right) -->
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedInUser}">
                        <!-- Logged In User -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown"
                               role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <div class="profile-img-container rounded-circle me-2">
                                    <img src="https://ui-avatars.com/api/?name=${sessionScope.loggedInUser.fullName}&background=random"
                                         alt="Profile" class="w-100 h-100 rounded-circle">
                                </div>
                                <span>${sessionScope.loggedInUser.fullName}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                        <i class="fas fa-user me-2"></i> Profile
                                    </a></li>
                                <li><a class="dropdown-item"
                                       href="${pageContext.request.contextPath}/booking?view=my-bookings">
                                        <i class="fas fa-list me-2"></i> My Bookings
                                    </a></li>
<!--                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/settings">
                                        <i class="fas fa-cog me-2"></i> Settings
                                    </a></li>-->
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li><a class="dropdown-item text-danger"
                                       href="${pageContext.request.contextPath}/logout">
                                        <i class="fas fa-sign-out-alt me-2"></i> Logout
                                    </a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <!-- Not Logged In -->
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                <i class="fas fa-sign-in-alt me-1"></i> Login
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>