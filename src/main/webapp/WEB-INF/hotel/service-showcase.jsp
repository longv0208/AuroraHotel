<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Dịch Vụ - Aurora Hotel" scope="request" />
<%@include file="../common/head.jsp" %>
<%@include file="../common/navbar.jsp" %>

<style>
    .service-hero {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 60px 0;
        text-align: center;
        margin-bottom: 40px;
    }

    .service-hero h1 {
        font-size: 48px;
        font-weight: 700;
        margin-bottom: 15px;
    }

    .category-tabs {
        display: flex;
        gap: 10px;
        margin-bottom: 40px;
        flex-wrap: wrap;
        justify-content: center;
    }

    .category-btn {
        background: #ecf0f1;
        color: #333;
        border: 2px solid transparent;
        padding: 10px 20px;
        border-radius: 25px;
        cursor: pointer;
        transition: all 0.3s;
        font-weight: 500;
        text-decoration: none;
    }

    .category-btn:hover {
        background: #667eea;
        color: white;
        border-color: #667eea;
    }

    .category-btn.active {
        background: #667eea;
        color: white;
        border-color: #667eea;
    }

    .service-card {
        background: white;
        border-radius: 15px;
        padding: 30px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s, box-shadow 0.3s;
        height: 100%;
    }

    .service-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
    }

    .service-icon {
        font-size: 48px;
        color: #667eea;
        margin-bottom: 20px;
    }

    .service-name {
        font-size: 24px;
        font-weight: 600;
        margin-bottom: 15px;
        color: #333;
    }

    .service-description {
        color: #666;
        margin-bottom: 20px;
        line-height: 1.6;
    }

    .service-price {
        font-size: 28px;
        font-weight: 700;
        color: #667eea;
        margin-bottom: 20px;
    }

    .btn-add-service {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 25px;
        font-weight: 600;
        transition: all 0.3s;
        width: 100%;
    }

    .btn-add-service:hover {
        transform: scale(1.05);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }
</style>

<!-- Hero Section -->
<div class="service-hero">
    <div class="container">
        <h1><i class="fas fa-concierge-bell"></i> Dịch Vụ Của Chúng Tôi</h1>
        <p>Trải nghiệm dịch vụ đẳng cấp tại Aurora Hotel</p>
    </div>
</div>

<div class="container py-5">
    <!-- Category Tabs -->
    <div class="category-tabs">
        <a href="${pageContext.request.contextPath}/service?view=showcase"
            class="category-btn ${empty selectedCategory ? 'active' : ''}">
            <i class="fas fa-th"></i> Tất Cả
        </a>

        <c:forEach var="cat" items="${categories}">
            <a href="${pageContext.request.contextPath}/service?view=showcase&category=${cat}"
                class="category-btn ${selectedCategory == cat ? 'active' : ''}">
                <c:choose>
                    <c:when test="${cat == 'Spa'}">
                        <i class="fas fa-spa"></i>
                    </c:when>
                    <c:when test="${cat == 'Dining'}">
                        <i class="fas fa-utensils"></i>
                    </c:when>
                    <c:when test="${cat == 'Transportation'}">
                        <i class="fas fa-car"></i>
                    </c:when>
                    <c:when test="${cat == 'Entertainment'}">
                        <i class="fas fa-music"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-concierge-bell"></i>
                    </c:otherwise>
                </c:choose>
                ${cat}
            </a>
        </c:forEach>
    </div>

    <!-- Services Grid -->
    <c:if test="${not empty services}">
        <div class="row g-4">
            <c:forEach var="service" items="${services}">
                <div class="col-md-6 col-lg-4">
                    <div class="service-card">
                        <div class="service-icon">
                            <c:choose>
                                <c:when test="${service.category == 'Spa'}">
                                    <i class="fas fa-spa"></i>
                                </c:when>
                                <c:when test="${service.category == 'Dining'}">
                                    <i class="fas fa-utensils"></i>
                                </c:when>
                                <c:when test="${service.category == 'Transportation'}">
                                    <i class="fas fa-car"></i>
                                </c:when>
                                <c:when test="${service.category == 'Entertainment'}">
                                    <i class="fas fa-music"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-concierge-bell"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="service-name">${service.serviceName}</div>
                        <div class="service-description">${service.description}</div>
                        <div class="service-price">
                            <fmt:formatNumber value="${service.price}" type="number" groupingUsed="true"/>₫
                            <small class="text-muted">/${service.unit}</small>
                        </div>
                        
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${empty services}">
        <div class="alert alert-info text-center">
            <i class="fas fa-inbox" style="font-size: 48px; color: #ddd;"></i>
            <h4 class="mt-3">Không có dịch vụ nào</h4>
            <p>Vui lòng quay lại sau</p>
        </div>
    </c:if>
</div>

<%@include file="../common/footer.jsp" %>

<script>
    function addServiceToBooking(serviceId) {
        alert('Chức năng thêm dịch vụ vào booking sẽ được cập nhật sớm. Service ID: ' + serviceId);
    }
</script>
