<%-- Document : addbooking Created on : Oct 22, 2025, 2:24:49 PM Author : BA LIEM --%>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <c:set var="pageTitle" value="Add Booking - Aurora Hotel" scope="request" />
            <%@include file="common/head.jsp" %>
                <%@include file="common/navbar.jsp" %>
                    <main class="container my-5">
                        <form action="${pageContext.request.contextPath}/aurora" method="POST"
                            class="responsive-form shadow-lg p-4 rounded-4 bg-light">
                            <input type="hidden" name="action" value="add" />

                            <h2 class="text-center mb-4 text-primary fw-bold">Booking Information</h2>

                            <style>
                                * {
                                    box-sizing: border-box;
                                }

                                .responsive-form {
                                    max-width: 700px;
                                    margin: 0 auto;
                                    border: 2px solid #04AA6D;
                                    background-color: #f2f2f2;
                                }

                                label {
                                    font-weight: 600;
                                    margin-bottom: 6px;
                                    display: block;
                                }

                                input[type=text],
                                input[type=email],
                                input[type=tel],
                                input[type=date],
                                select {
                                    width: 100%;
                                    margin-bottom: 16px;
                                    border: 1px solid #ccc;
                                    border-radius: 6px;
                                    padding: 10px;
                                    font-size: 16px;
                                    transition: all 0.2s ease-in-out;
                                }

                                input:focus,
                                select:focus {
                                    border-color: #04AA6D;
                                    box-shadow: 0 0 5px rgba(4, 170, 109, 0.4);
                                    outline: none;
                                }

                                input[type=submit] {
                                    width: 100%;
                                    background-color: #04AA6D;
                                    color: white;
                                    padding: 14px;
                                    margin-top: 10px;
                                    border: none;
                                    border-radius: 6px;
                                    font-size: 18px;
                                    font-weight: bold;
                                    cursor: pointer;
                                    transition: 0.3s;
                                }

                                input[type=submit]:hover {
                                    background-color: #038a5d;
                                }

                                @media screen and (max-width: 600px) {
                                    .responsive-form {
                                        padding: 15px;
                                    }
                                }
                            </style>

                            <!-- Full Name -->
                            <div class="mb-3">
                                <label for="fullName">Full Name:</label>
                                <input type="text" id="fullName" name="fullName" placeholder="Enter your full name"
                                    required>
                            </div>

                            <!-- Country -->
                            <div class="mb-3">
                                <label for="country">Country:</label>
                                <select id="country" name="country" required>
                                    <option value="">Select your country</option>
                                    <option value="Vietnam">Vietnam</option>
                                    <option value="Japan">Japan</option>
                                    <option value="USA">USA</option>
                                    <option value="Australia">Australia</option>
                                    <option value="France">France</option>
                                    <option value="Canada">Canada</option>
                                </select>
                            </div>

                            <!-- Phone -->
                            <div class="mb-3">
                                <label for="phone">Phone Number:</label>
                                <input type="tel" id="phone" name="phone" placeholder="Enter your phone number" required
                                    pattern="[0-9]{9,15}">
                            </div>

                            <!-- Email -->
                            <div class="mb-3">
                                <label for="email">Email:</label>
                                <input type="email" id="email" name="email" placeholder="Enter your email" required>
                            </div>

                            <!-- Check-in -->
                            <div class="mb-3">
                                <label for="checkIn">Check-in Date:</label>
                                <input type="date" id="checkIn" name="checkIn" required>
                            </div>

                            <!-- Check-out -->
                            <div class="mb-3">
                                <label for="checkOut">Check-out Date:</label>
                                <input type="date" id="checkOut" name="checkOut" required>
                            </div>

                            <!-- Submit -->
                            <input type="submit" value="Submit Booking">
                        </form>
                    </main>


                    <%@include file="common/footer.jsp" %>