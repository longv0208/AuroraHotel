# HỆ THỐNG QUẢN LÝ KHÁCH SẠN AURORA - TÀI LIỆU LUỒNG CHÍNH

## 📋 TỔNG QUAN HỆ THỐNG

**Tên dự án:** Aurora Hotel Management System  
**Công nghệ:** Java 17, Jakarta EE 10, JSP/Servlet, SQL Server, Bootstrap  
**Database:** HotelManagement (16 bảng chính)  
**Vai trò người dùng:** Admin, User, System

---

## 🗄️ CẤU TRÚC DATABASE

### Các bảng chính:
1. **Users** - Quản lý người dùng hệ thống
2. **RoomTypes** - Loại phòng (Standard, Deluxe, Suite, etc.)
3. **Rooms** - Danh sách phòng cụ thể
4. **Customers** - Thông tin khách hàng
5. **Bookings** - Đơn đặt phòng
6. **BookingDetails** - Chi tiết đặt phòng
7. **Services** - Dịch vụ khách sạn
8. **BookingServices** - Dịch vụ sử dụng trong booking
9. **Payments** - Thanh toán
10. **Reviews** - Đánh giá của khách
11. **Coupons** - Mã giảm giá
12. **CouponUsage** - Lịch sử sử dụng coupon
13. **Pages** - Quản lý nội dung trang
14. **SystemLogs** - Nhật ký hệ thống
15. **RoomImages** - Hình ảnh phòng
16. **BookingHistory** - Lịch sử thay đổi booking

---

## 🔐 LUỒNG 1: ĐĂNG NHẬP & ĐĂNG XUẤT

### 1.1. Đăng nhập (Login Flow)

**Vai trò:** Admin/User  
**URL:** `/login`  
**Phương thức:** GET, POST

#### Quy trình:
```
1. User truy cập /login
   ↓
2. Hệ thống hiển thị form đăng nhập (username, password)
   ↓
3. User nhập thông tin và submit
   ↓
4. LoginServlet xử lý:
   - Nhận username và password
   - Hash password bằng MD5 (⚠️ Security Warning: MD5 không an toàn)
   - Gọi UserDAO.validateLogin(username, hashedPassword)
   ↓
5. UserDAO kiểm tra database:
   - SELECT * FROM Users WHERE Username = ? AND PasswordHash = ? AND IsActive = 1
   ↓
6a. Nếu thành công:
   - Tạo HttpSession mới (regenerate session ID)
   - Lưu User object vào session: session.setAttribute("loggedInUser", user)
   - Cập nhật LastLogin trong database
   - Redirect đến trang chủ (/aurora)
   
6b. Nếu thất bại:
   - Hiển thị thông báo lỗi "Sai tên đăng nhập hoặc mật khẩu"
   - Quay lại trang login
```

#### Dữ liệu trong Session:
```java
User {
    UserID: int
    Username: String
    FullName: String
    Email: String
    Role: String (Admin/User/System)
}
```

### 1.2. Đăng xuất (Logout Flow)

**URL:** `/logout`  
**Phương thức:** GET

#### Quy trình:
```
1. User click "Logout" trong dropdown menu
   ↓
2. LogoutServlet xử lý:
   - session.invalidate()
   - Xóa toàn bộ session data
   ↓
3. Redirect về /login
```

### 1.3. Bảo vệ tài nguyên (Authentication Filter)

**Filter:** AuthenticationFilter  
**Áp dụng cho:** Tất cả URL trừ /login, /assets/*, /resources/*

#### Quy trình:
```
1. User truy cập URL bất kỳ
   ↓
2. AuthenticationFilter kiểm tra:
   - HttpSession session = request.getSession(false)
   - if (session == null || session.getAttribute("loggedInUser") == null)
   ↓
3a. Nếu chưa đăng nhập:
   - response.sendRedirect("/login")
   
3b. Nếu đã đăng nhập:
   - chain.doFilter(request, response) - Cho phép truy cập
```

---

## 🏨 LUỒNG 2: QUẢN LÝ PHÒNG (ROOM MANAGEMENT)

### 2.1. Xem danh sách phòng (List Rooms)

**Vai trò:** Admin/User  
**URL:** `/room?view=list` hoặc `/room?view=list&page=2`  
**Phương thức:** GET

#### Quy trình:
```
1. User truy cập /room?view=list
   ↓
2. RoomServlet.doGet() xử lý:
   - Kiểm tra session (AuthenticationFilter đã check)
   - Lấy page parameter (default = 1)
   - Gọi RoomDAO.getRoomList(page)
   - Gọi RoomDAO.getTotalRows()
   - Tính totalPages = Math.ceil(totalRows / 10)
   ↓
3. RoomDAO.getRoomList(page):
   - SELECT r.*, rt.TypeName, rt.BasePrice 
     FROM Rooms r 
     INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
     WHERE r.IsActive = 1
     ORDER BY r.RoomNumber
     OFFSET ((page-1) * 10) ROWS FETCH NEXT 10 ROWS ONLY
   ↓
4. Set attributes và forward:
   - request.setAttribute("rooms", roomList)
   - request.setAttribute("currentPage", page)
   - request.setAttribute("totalPages", totalPages)
   - forward to /WEB-INF/room/list.jsp
   ↓
5. list.jsp hiển thị:
   - Bảng danh sách phòng (RoomNumber, TypeName, Floor, Status, BasePrice)
   - Pagination controls
   - Buttons: Create New, Edit, Delete (chỉ Admin)
```

### 2.2. Tạo phòng mới (Create Room)

**Vai trò:** Admin  
**URL:** `/room?view=create` (GET), `/room` (POST)  
**Phương thức:** GET, POST

#### Quy trình GET (Hiển thị form):
```
1. Admin click "Create New Room"
   ↓
2. RoomServlet.doGet() với view=create:
   - Kiểm tra role = Admin
   - Lấy danh sách RoomTypes cho dropdown
   - forward to /WEB-INF/room/create.jsp
   ↓
3. create.jsp hiển thị form:
   - RoomNumber (text input, required)
   - RoomTypeID (dropdown từ RoomTypes)
   - Floor (number input)
   - Status (dropdown: Trống, Đã đặt, Đang sử dụng, Bảo trì)
   - Description (textarea)
   - Submit button
```

#### Quy trình POST (Xử lý tạo mới):
```
1. Admin submit form
   ↓
2. RoomServlet.doPost() với action=create:
   - Nhận parameters: roomNumber, roomTypeId, floor, status, description
   - Validate input (không null, format đúng)
   - Tạo Room object
   - Gọi RoomDAO.create(room)
   ↓
3. RoomDAO.create(room):
   - INSERT INTO Rooms (RoomNumber, RoomTypeID, Floor, Status, Description, IsActive)
     VALUES (?, ?, ?, ?, ?, 1)
   - Return số dòng affected
   ↓
4a. Nếu thành công (result == 1):
   - response.sendRedirect("/room?view=list")
   
4b. Nếu thất bại:
   - response.sendRedirect("/room?view=create&error=1")
```

### 2.3. Chỉnh sửa phòng (Edit Room)

**Vai trò:** Admin  
**URL:** `/room?view=edit&id=5` (GET), `/room` (POST)  
**Phương thức:** GET, POST

#### Quy trình GET (Hiển thị form edit):
```
1. Admin click "Edit" button trên room ID=5
   ↓
2. RoomServlet.doGet() với view=edit&id=5:
   - Kiểm tra role = Admin
   - Gọi RoomDAO.getById(5)
   - Lấy danh sách RoomTypes cho dropdown
   - request.setAttribute("room", room)
   - forward to /WEB-INF/room/edit.jsp
   ↓
3. edit.jsp hiển thị form với dữ liệu pre-filled:
   - Hidden input: roomId
   - RoomNumber (pre-filled, có thể edit)
   - RoomTypeID (dropdown, selected current value)
   - Floor (pre-filled)
   - Status (dropdown, selected current value)
   - Description (pre-filled)
   - Update button
```

#### Quy trình POST (Xử lý cập nhật):
```
1. Admin submit form
   ↓
2. RoomServlet.doPost() với action=edit:
   - Nhận parameters: id, roomNumber, roomTypeId, floor, status, description
   - Validate input
   - Tạo Room object với updated values
   - Gọi RoomDAO.update(room)
   ↓
3. RoomDAO.update(room):
   - UPDATE Rooms 
     SET RoomNumber=?, RoomTypeID=?, Floor=?, Status=?, Description=?
     WHERE RoomID=?
   - Return số dòng affected
   ↓
4a. Nếu thành công:
   - response.sendRedirect("/room?view=list")
   
4b. Nếu thất bại:
   - response.sendRedirect("/room?view=edit&id=" + id + "&error=1")
```

### 2.4. Xóa phòng (Delete Room)

**Vai trò:** Admin  
**URL:** `/room?view=delete&id=5` (GET), `/room` (POST)  
**Phương thức:** GET, POST

#### Quy trình GET (Hiển thị confirmation):
```
1. Admin click "Delete" button trên room ID=5
   ↓
2. RoomServlet.doGet() với view=delete&id=5:
   - Kiểm tra role = Admin
   - Gọi RoomDAO.getById(5)
   - request.setAttribute("room", room)
   - forward to /WEB-INF/room/delete.jsp
   ↓
3. delete.jsp hiển thị:
   - Thông tin phòng cần xóa
   - Warning message
   - Confirm Delete button
   - Cancel button
```

#### Quy trình POST (Xử lý xóa):
```
1. Admin confirm delete
   ↓
2. RoomServlet.doPost() với action=delete:
   - Nhận parameter: id
   - Gọi RoomDAO.delete(id)
   ↓
3. RoomDAO.delete(id):
   - Soft delete: UPDATE Rooms SET IsActive=0 WHERE RoomID=?
   - Hoặc hard delete: DELETE FROM Rooms WHERE RoomID=?
   - Return số dòng affected
   ↓
4a. Nếu thành công:
   - response.sendRedirect("/room?view=list")
   
4b. Nếu thất bại:
   - response.sendRedirect("/room?view=delete&id=" + id + "&error=1")
```

---

## 📅 LUỒNG 3: ĐẶT PHÒNG (BOOKING MANAGEMENT)

### 3.1. Tìm kiếm phòng trống

**Vai trò:** User/Admin  
**URL:** `/booking/search`  
**Phương thức:** GET, POST

#### Quy trình:
```
1. User nhập thông tin tìm kiếm:
   - Check-in date
   - Check-out date
   - Room type (optional)
   - Number of guests
   ↓
2. BookingServlet gọi stored procedure:
   - EXEC sp_SearchAvailableRooms @CheckInDate, @CheckOutDate, @RoomTypeID
   ↓
3. Stored procedure logic:
   - Tìm rooms không có booking conflict trong khoảng thời gian
   - Loại trừ rooms có Status = 'Bảo trì'
   - Return danh sách rooms available
   ↓
4. Hiển thị kết quả:
   - Danh sách phòng trống
   - Thông tin: RoomNumber, TypeName, BasePrice, MaxGuests, Floor
   - Button "Book Now" cho mỗi phòng
```

### 3.2. Tạo booking mới

**Vai trò:** User/Admin  
**URL:** `/booking/create`  
**Phương thức:** GET, POST

#### Quy trình:
```
1. User click "Book Now" trên phòng đã chọn
   ↓
2. Hiển thị booking form:
   - Customer information (nếu User: pre-fill từ profile)
   - Room details (read-only)
   - Check-in/Check-out dates
   - Number of guests
   - Special requests
   - Coupon code (optional)
   ↓
3. User submit booking
   ↓
4. BookingServlet.doPost():
   - Validate dates (check-in < check-out, không quá khứ)
   - Kiểm tra room vẫn available
   - Tạo/Lấy Customer record
   - Tính TotalAmount (gọi sp_CalculateBookingTotal)
   - Áp dụng coupon nếu có
   ↓
5. Transaction processing:
   BEGIN TRANSACTION
   - INSERT INTO Customers (nếu khách mới)
   - INSERT INTO Bookings (Status='Chờ xác nhận')
   - INSERT INTO BookingDetails
   - UPDATE Rooms SET Status='Đã đặt'
   - INSERT INTO CouponUsage (nếu dùng coupon)
   - INSERT INTO BookingHistory (Action='CREATE')
   COMMIT TRANSACTION
   ↓
6. Redirect đến booking confirmation page
```

### 3.3. Xem danh sách booking của khách

**Vai trò:** User
**URL:** `/booking/my-bookings`
**Phương thức:** GET

#### Quy trình:
```
1. User click "My Bookings" trong profile menu
   ↓
2. BookingServlet lấy UserID từ session
   ↓
3. BookingDAO.getBookingsByUser(userId):
   - SELECT b.*, r.RoomNumber, rt.TypeName, c.FullName
     FROM Bookings b
     INNER JOIN Rooms r ON b.RoomID = r.RoomID
     INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
     INNER JOIN Customers c ON b.CustomerID = c.CustomerID
     WHERE b.UserID = ?
     ORDER BY b.BookingDate DESC
   ↓
4. Hiển thị danh sách:
   - BookingID, RoomNumber, TypeName, Check-in/out dates
   - Status (Chờ xác nhận, Đã xác nhận, Đã checkin, Đã checkout, Đã hủy)
   - TotalAmount
   - Actions: View Details, Cancel (nếu Status cho phép)
```

### 3.4. Hủy booking

**Vai trò:** User/Admin
**URL:** `/booking/cancel`
**Phương thức:** POST

#### Quy trình:
```
1. User click "Cancel" trên booking
   ↓
2. Kiểm tra điều kiện hủy:
   - Status phải là 'Chờ xác nhận' hoặc 'Đã xác nhận'
   - Check-in date phải > hiện tại ít nhất 24h
   ↓
3. BookingServlet.doPost():
   BEGIN TRANSACTION
   - UPDATE Bookings SET Status='Đã hủy', UpdatedDate=GETDATE()
   - UPDATE Rooms SET Status='Trống'
   - INSERT INTO BookingHistory (Action='CANCEL')
   - Nếu đã đặt cọc: INSERT INTO Payments (PaymentType='Hoàn tiền')
   COMMIT TRANSACTION
   ↓
4. Gửi email thông báo hủy booking
   ↓
5. Redirect về my-bookings với success message
```

---

## 👥 LUỒNG 4: QUẢN LÝ KHÁCH HÀNG (CUSTOMER MANAGEMENT)

### 4.1. Xem danh sách khách hàng

**Vai trò:** Admin
**URL:** `/customer?view=list`
**Phương thức:** GET

#### Quy trình:
```
1. Admin truy cập customer management
   ↓
2. CustomerDAO.getCustomerList(page):
   - SELECT c.*, COUNT(b.BookingID) as TotalBookings
     FROM Customers c
     LEFT JOIN Bookings b ON c.CustomerID = b.CustomerID
     GROUP BY c.CustomerID, c.FullName, ...
     ORDER BY c.CreatedDate DESC
     OFFSET ((page-1) * 10) ROWS FETCH NEXT 10 ROWS ONLY
   ↓
3. Hiển thị danh sách:
   - FullName, Phone, Email, IDCard
   - TotalBookings, CreatedDate
   - Actions: View Details, Edit, View Booking History
```

### 4.2. Xem lịch sử đặt phòng của khách

**Vai trò:** Admin
**URL:** `/customer/booking-history?id=10`
**Phương thức:** GET

#### Quy trình:
```
1. Admin click "View Booking History" cho customer ID=10
   ↓
2. CustomerDAO.getBookingHistory(customerId):
   - SELECT b.*, r.RoomNumber, rt.TypeName, p.Amount as PaidAmount
     FROM Bookings b
     INNER JOIN Rooms r ON b.RoomID = r.RoomID
     INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
     LEFT JOIN Payments p ON b.BookingID = p.BookingID
     WHERE b.CustomerID = ?
     ORDER BY b.BookingDate DESC
   ↓
3. Hiển thị:
   - Timeline của tất cả bookings
   - Tổng số booking, tổng chi tiêu
   - Reviews đã viết
```

---

## 💳 LUỒNG 5: THANH TOÁN (PAYMENT PROCESSING)

### 5.1. Đặt cọc (Deposit Payment)

**Vai trò:** User/Admin
**URL:** `/payment/deposit`
**Phương thức:** POST

#### Quy trình:
```
1. Sau khi tạo booking, yêu cầu đặt cọc
   ↓
2. PaymentServlet hiển thị:
   - Booking details
   - Deposit amount (thường 30% TotalAmount)
   - Payment methods: Tiền mặt, Chuyển khoản, Thẻ
   ↓
3. User chọn payment method và confirm
   ↓
4. PaymentDAO.createPayment():
   BEGIN TRANSACTION
   - INSERT INTO Payments (
       BookingID, Amount, PaymentMethod, PaymentType='Đặt cọc',
       TransactionID, UserID, Status='Thành công'
     )
   - UPDATE Bookings SET DepositAmount=?, Status='Đã xác nhận'
   - INSERT INTO BookingHistory (Action='DEPOSIT_PAID')
   COMMIT TRANSACTION
   ↓
5. Gửi email xác nhận đặt cọc
   ↓
6. Redirect đến payment confirmation page
```

### 5.2. Thanh toán khi checkout

**Vai trò:** Admin
**URL:** `/payment/checkout`
**Phương thức:** POST

#### Quy trình:
```
1. Admin xử lý checkout cho booking
   ↓
2. Tính toán số tiền còn lại:
   - Gọi sp_CalculateBookingTotal để lấy TotalAmount
   - RemainingAmount = TotalAmount - DepositAmount - ServiceCharges
   ↓
3. PaymentServlet hiển thị invoice:
   - Room charges (số đêm × BasePrice)
   - Service charges (từ BookingServices)
   - Discount (từ Coupons)
   - Deposit paid
   - Total remaining
   ↓
4. Admin nhận thanh toán:
   BEGIN TRANSACTION
   - INSERT INTO Payments (PaymentType='Thanh toán', Amount=RemainingAmount)
   - UPDATE Bookings SET Status='Đã checkout', UpdatedDate=GETDATE()
   - UPDATE Rooms SET Status='Trống'
   - INSERT INTO BookingHistory (Action='CHECKOUT')
   COMMIT TRANSACTION
   ↓
5. In hóa đơn/Receipt
   ↓
6. Gửi email cảm ơn + yêu cầu review
```

---

## ⭐ LUỒNG 6: ĐÁNH GIÁ & PHẢN HỒI (REVIEWS & FEEDBACK)

### 6.1. Khách viết đánh giá

**Vai trò:** User
**URL:** `/review/create?bookingId=15`
**Phương thức:** GET, POST

#### Quy trình:
```
1. Sau checkout, User nhận email với link review
   ↓
2. User click link, hiển thị review form:
   - Rating (1-5 stars)
   - Comment (textarea)
   - Booking details (read-only)
   ↓
3. User submit review
   ↓
4. ReviewDAO.createReview():
   - Validate: chỉ cho phép review sau checkout
   - Validate: mỗi booking chỉ review 1 lần
   - INSERT INTO Reviews (
       BookingID, CustomerID, Rating, Comment,
       ReviewDate, IsApproved=0
     )
   ↓
5. Redirect với success message
   ↓
6. Admin nhận notification để duyệt review
```

### 6.2. Admin duyệt đánh giá

**Vai trò:** Admin
**URL:** `/review/moderate`
**Phương thức:** GET, POST

#### Quy trình:
```
1. Admin truy cập review moderation page
   ↓
2. ReviewDAO.getPendingReviews():
   - SELECT r.*, c.FullName, b.BookingID, rt.TypeName
     FROM Reviews r
     INNER JOIN Customers c ON r.CustomerID = c.CustomerID
     INNER JOIN Bookings b ON r.BookingID = b.BookingID
     INNER JOIN Rooms rm ON b.RoomID = rm.RoomID
     INNER JOIN RoomTypes rt ON rm.RoomTypeID = rt.RoomTypeID
     WHERE r.IsApproved = 0
     ORDER BY r.ReviewDate DESC
   ↓
3. Admin xem review và quyết định:
   - Approve: UPDATE Reviews SET IsApproved=1
   - Reply: UPDATE Reviews SET AdminReply=?, ReplyDate=GETDATE()
   - Reject: DELETE FROM Reviews (hoặc soft delete)
   ↓
4. Nếu approved, review hiển thị trên public pages
```

### 6.3. Hiển thị đánh giá công khai

**Vai trò:** Public
**URL:** `/reviews` hoặc `/room/details?id=5`
**Phương thức:** GET

#### Quy trình:
```
1. User/Guest xem trang reviews
   ↓
2. ReviewDAO.getApprovedReviews():
   - SELECT r.*, c.FullName, rt.TypeName
     FROM Reviews r
     INNER JOIN Customers c ON r.CustomerID = c.CustomerID
     INNER JOIN Bookings b ON r.BookingID = b.BookingID
     INNER JOIN Rooms rm ON b.RoomID = rm.RoomID
     INNER JOIN RoomTypes rt ON rm.RoomTypeID = rt.RoomTypeID
     WHERE r.IsApproved = 1
     ORDER BY r.ReviewDate DESC
   ↓
3. Hiển thị:
   - Customer name, Rating (stars), Comment
   - Room type reviewed
   - Admin reply (nếu có)
   - Review date
```

---

## 🎟️ LUỒNG 7: QUẢN LÝ MÃ GIẢM GIÁ (COUPON MANAGEMENT)

### 7.1. Tạo coupon mới

**Vai trò:** Admin
**URL:** `/coupon?view=create`
**Phương thức:** GET, POST

#### Quy trình:
```
1. Admin truy cập coupon management
   ↓
2. Hiển thị create coupon form:
   - CouponCode (unique, uppercase)
   - Description
   - DiscountType (Percent / FixedAmount)
   - DiscountValue
   - MinBookingAmount (minimum để áp dụng)
   - MaxDiscountAmount (nếu Percent)
   - RoomTypeID (NULL = áp dụng tất cả)
   - StartDate, EndDate
   - UsageLimit (số lần sử dụng tối đa)
   ↓
3. Admin submit
   ↓
4. CouponDAO.createCoupon():
   - Validate: CouponCode unique
   - Validate: StartDate < EndDate
   - Validate: DiscountValue > 0
   - INSERT INTO Coupons (
       CouponCode, Description, DiscountType, DiscountValue,
       MinBookingAmount, MaxDiscountAmount, RoomTypeID,
       StartDate, EndDate, UsageLimit, UsedCount=0,
       IsActive=1, CreatedBy=?, CreatedDate=GETDATE()
     )
   ↓
5. Redirect đến coupon list
```

### 7.2. Áp dụng coupon khi booking

**Vai trò:** User
**URL:** `/booking/apply-coupon`
**Phương thức:** POST (AJAX)

#### Quy trình:
```
1. User nhập coupon code trong booking form
   ↓
2. Click "Apply Coupon" (AJAX request)
   ↓
3. CouponDAO.validateCoupon(code, bookingAmount, roomTypeId):
   - SELECT * FROM Coupons
     WHERE CouponCode = ?
       AND IsActive = 1
       AND GETDATE() BETWEEN StartDate AND EndDate
       AND (UsageLimit IS NULL OR UsedCount < UsageLimit)
       AND (RoomTypeID IS NULL OR RoomTypeID = ?)
       AND (MinBookingAmount IS NULL OR ? >= MinBookingAmount)
   ↓
4a. Nếu valid:
   - Tính discount amount:
     * Nếu Percent: min(bookingAmount * DiscountValue / 100, MaxDiscountAmount)
     * Nếu FixedAmount: DiscountValue
   - Return JSON: {valid: true, discountAmount: X, newTotal: Y}
   - Hiển thị discount trên UI

4b. Nếu invalid:
   - Return JSON: {valid: false, message: "Mã giảm giá không hợp lệ"}
   ↓
5. Khi submit booking:
   - INSERT INTO CouponUsage (CouponID, BookingID, CustomerID, DiscountAmount)
   - UPDATE Coupons SET UsedCount = UsedCount + 1
```

---

## 📊 LUỒNG 8: BÁO CÁO & THỐNG KÊ (REPORTS & ANALYTICS)

### 8.1. Báo cáo doanh thu theo tháng

**Vai trò:** Admin
**URL:** `/report/revenue?month=10&year=2025`
**Phương thức:** GET

#### Quy trình:
```
1. Admin chọn tháng/năm cần xem báo cáo
   ↓
2. ReportDAO sử dụng view vw_MonthlyRevenue:
   - SELECT * FROM vw_MonthlyRevenue
     WHERE Year = ? AND Month = ?
   ↓
3. Hiển thị:
   - Tổng doanh thu (TotalRevenue)
   - Số booking (TotalBookings)
   - Doanh thu trung bình/booking
   - Biểu đồ cột theo ngày trong tháng
```

### 8.2. Báo cáo công suất phòng

**Vai trò:** Admin
**URL:** `/report/occupancy`
**Phương thức:** GET

#### Quy trình:
```
1. Admin truy cập occupancy report
   ↓
2. ReportDAO sử dụng view vw_RoomOccupancy:
   - SELECT * FROM vw_RoomOccupancy
   ↓
3. Hiển thị theo từng loại phòng:
   - TypeName
   - TotalRooms
   - OccupiedRooms
   - AvailableRooms
   - OccupancyRate (%)
   - Biểu đồ tròn
```

### 8.3. Báo cáo công suất theo loại phòng

**Vai trò:** Admin
**URL:** `/report/room-type-performance`
**Phương thức:** GET

#### Quy trình:
```
1. Admin xem performance report
   ↓
2. ReportDAO sử dụng view vw_RoomTypeRevenue:
   - SELECT * FROM vw_RoomTypeRevenue
   ↓
3. Hiển thị:
   - TypeName
   - TotalBookings
   - TotalRevenue
   - AveragePrice
   - Ranking theo revenue
```

---

## 🔒 BẢO MẬT & PHÂN QUYỀN

### Phân quyền theo Role:

#### **Admin:**
- ✅ Tất cả chức năng User
- ✅ Quản lý phòng (CRUD)
- ✅ Quản lý khách hàng
- ✅ Xem tất cả bookings
- ✅ Xử lý checkout/checkin
- ✅ Quản lý coupon
- ✅ Duyệt reviews
- ✅ Xem báo cáo
- ✅ Quản lý users

#### **User:**
- ✅ Xem danh sách phòng
- ✅ Tìm kiếm phòng trống
- ✅ Đặt phòng
- ✅ Xem bookings của mình
- ✅ Hủy booking (trong điều kiện cho phép)
- ✅ Viết review
- ✅ Xem profile
- ❌ Không truy cập management functions

#### **System:**
- ✅ Automated tasks
- ✅ Scheduled jobs
- ✅ System logs

### Security Measures:

1. **Password Hashing:**
   - ⚠️ Hiện tại: MD5 (KHÔNG AN TOÀN)
   - ✅ Khuyến nghị: BCrypt hoặc Argon2

2. **Session Management:**
   - Session timeout: 30 phút
   - Session regeneration sau login
   - HttpOnly và Secure flags

3. **SQL Injection Prevention:**
   - Sử dụng PreparedStatement
   - Validate tất cả input

4. **XSS Prevention:**
   - Escape output trong JSP
   - Content Security Policy headers

5. **CSRF Protection:**
   - CSRF tokens cho state-changing operations

---

## 📝 NOTES & BEST PRACTICES

### Database Triggers:
- `trg_BookingHistory_AfterInsert`: Tự động log khi tạo booking mới
- `trg_BookingHistory_AfterUpdate`: Tự động log khi update booking

### Stored Procedures:
- `sp_SearchAvailableRooms`: Tìm phòng trống theo ngày
- `sp_CalculateBookingTotal`: Tính tổng tiền booking
- `sp_GetBookingHistory`: Lấy lịch sử thay đổi booking
- `sp_GetRoomImages`: Lấy hình ảnh phòng

### Views:
- `vw_AvailableRooms`: Danh sách phòng trống
- `vw_MonthlyRevenue`: Doanh thu theo tháng
- `vw_RoomOccupancy`: Công suất phòng
- `vw_BookingHistoryDetail`: Chi tiết lịch sử booking
- `vw_RoomImagesDetail`: Chi tiết hình ảnh phòng

### Error Handling:
- Try-catch-finally trong tất cả DAO methods
- Proper resource cleanup (close connections, statements, resultsets)
- User-friendly error messages
- Detailed logging cho debugging

### Performance Optimization:
- Indexes trên các cột thường query (Status, Dates, Phone)
- Pagination cho danh sách lớn (10 records/page)
- Connection pooling (khuyến nghị cho production)
- Caching cho static data (RoomTypes, Services)

### UI/UX Guidelines:
- ✅ Sử dụng Bootstrap 5 cho tất cả giao diện
- ✅ Giao diện đơn giản, sạch sẽ, dễ nhìn
- ✅ Không cần nhiều hiệu ứng phức tạp
- ✅ Ưu tiên tính năng và khả năng sử dụng
- ✅ Responsive design cho mobile/tablet
- ✅ Sử dụng Bootstrap components: tables, forms, cards, buttons, alerts
- ✅ Color scheme nhất quán: primary (blue), success (green), danger (red), warning (yellow)
- ✅ Form validation với Bootstrap validation classes
- ✅ Pagination với Bootstrap pagination component
- ✅ Modal dialogs cho confirmations

---

## 🚀 DEPLOYMENT CHECKLIST

- [ ] Database schema deployed
- [ ] Sample data inserted (Users, RoomTypes, Rooms)
- [ ] All entity classes created
- [ ] All DAO classes implemented
- [ ] All servlets configured
- [ ] All JSP pages created
- [ ] Authentication filter configured
- [ ] Session management tested
- [ ] CRUD operations tested
- [ ] Security measures implemented
- [ ] Error handling verified
- [ ] Performance tested
- [ ] Documentation completed

---

**Tài liệu này mô tả các luồng chính của hệ thống Aurora Hotel Management. Để biết chi tiết implementation, xem source code trong các package: controller, dao, model, util, filter.**

**⚠️ SECURITY WARNING: Hệ thống hiện sử dụng MD5 cho password hashing - ĐÂY LÀ RỦI RO BẢO MẬT NGHIÊM TRỌNG. Khuyến nghị chuyển sang BCrypt hoặc Argon2 ngay lập tức.**

