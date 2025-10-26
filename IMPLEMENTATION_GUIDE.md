# Aurora Hotel - Linked Account System Implementation Guide

## Tổng quan

Hệ thống đã được cập nhật để hỗ trợ **liên kết tài khoản User và Customer**, cho phép:
- ✅ Khách tự đăng ký tài khoản online
- ✅ Khách đặt phòng mà không cần đăng nhập (Guest Booking)
- ✅ User đặt phòng cho chính mình hoặc người khác
- ✅ Tự động tạo Customer record khi đăng ký User
- ✅ Tracking booking history theo account

---

## 🚀 Các bước triển khai

### Bước 1: Chạy Database Migration

```sql
-- File: migration_add_userid_to_customer.sql
-- Chạy script này trên SQL Server Management Studio

-- Script sẽ:
-- 1. Thêm cột UserID vào bảng Customers
-- 2. Tạo foreign key constraint
-- 3. Tạo indexes để tối ưu
-- 4. Migrate dữ liệu existing (link Users-Customers by phone)
-- 5. Tạo Customer records cho Users chưa có
```

**Chạy migration:**
1. Mở file `migration_add_userid_to_customer.sql`
2. Connect tới database `AuroraHotel`
3. Execute script
4. Kiểm tra kết quả verification ở cuối

---

### Bước 2: Deploy Code Changes

**Files đã thay đổi:**

#### Models:
- `model/Customer.java` - Thêm field `userID`

#### DAOs:
- `dao/CustomerDAO.java` - Thêm methods:
  - `getCustomerByUserID(int userID)`
  - `createCustomerFromUser(User user)`
  - `linkCustomerToUser(int customerID, int userID)`
  - `hasLinkedCustomer(int userID)`

- `dao/UserDAO.java` - Update:
  - `createUser()` - Return userID thay vì boolean
  - `getUserByPhone(String phone)` - Method mới

#### Controllers:
- `controller/RegisterServlet.java` - **NEW** - Xử lý đăng ký
- `controller/BookingServlet.java` - Update để support guest booking

#### Views:
- `WEB-INF/auth/register.jsp` - **NEW** - Trang đăng ký
- `WEB-INF/booking/create.jsp` - Cần update (xem bước 3)

---

### Bước 3: Update Booking Create Form UI

File `WEB-INF/booking/create.jsp` cần thêm logic để:
1. Pre-fill thông tin nếu user đã login
2. Hiện thông báo suggest đăng ký nếu là guest
3. Thêm hidden field `bookingForSelf`

**Ví dụ code cần thêm vào đầu form:**

```jsp
<c:choose>
    <c:when test="${not empty sessionScope.loggedInUser}">
        <!-- User đã login -->
        <div class="alert alert-info">
            <i class="fas fa-user-check me-2"></i>
            Đặt phòng cho: <strong>${sessionScope.loggedInUser.fullName}</strong>
            <button type="button" class="btn btn-sm btn-outline-primary ms-3"
                    onclick="toggleBookForOther()">
                Đặt cho người khác
            </button>
        </div>
        <input type="hidden" name="bookingForSelf" id="bookingForSelf" value="true">

        <!-- Pre-fill fields -->
        <script>
            document.getElementById('fullName').value = '${sessionScope.loggedInUser.fullName}';
            document.getElementById('phone').value = '${sessionScope.loggedInUser.phone}';
            document.getElementById('email').value = '${sessionScope.loggedInUser.email}';
        </script>
    </c:when>
    <c:otherwise>
        <!-- Guest -->
        <div class="alert alert-warning">
            <i class="fas fa-info-circle me-2"></i>
            Bạn đang đặt phòng như khách.
            <a href="${pageContext.request.contextPath}/register">Đăng ký tài khoản</a>
            để quản lý booking dễ hơn!
        </div>
        <input type="hidden" name="bookingForSelf" value="false">
    </c:otherwise>
</c:choose>
```

---

### Bước 4: Thêm Links Đăng Ký

#### A. Navbar (WEB-INF/common/navbar.jsp)

Cập nhật phần "Not Logged In":

```jsp
<c:otherwise>
    <!-- Not Logged In -->
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/register">
            <i class="fas fa-user-plus me-1"></i> Đăng Ký
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/login">
            <i class="fas fa-sign-in-alt me-1"></i> Đăng Nhập
        </a>
    </li>
</c:otherwise>
```

#### B. Login Page (WEB-INF/auth/login.jsp)

Thêm link đăng ký ở cuối form:

```jsp
<div class="text-center mt-3">
    <p>Chưa có tài khoản?
        <a href="${pageContext.request.contextPath}/register">
            Đăng ký ngay
        </a>
    </p>
</div>
```

---

## 📊 Database Schema Changes

### Before:
```
Users                    Customers                Bookings
├─ UserID (PK)          ├─ CustomerID (PK)       ├─ BookingID (PK)
├─ Username             ├─ FullName              ├─ CustomerID (FK)
├─ PasswordHash         ├─ Phone                 ├─ RoomID (FK)
├─ FullName             ├─ Email                 ├─ UserID (FK)
├─ Phone                ├─ IDCard                └─ ...
└─ ...                  └─ ...
```

### After:
```
Users                    Customers                Bookings
├─ UserID (PK)          ├─ CustomerID (PK)       ├─ BookingID (PK)
├─ Username             ├─ FullName              ├─ CustomerID (FK)
├─ PasswordHash         ├─ Phone                 ├─ RoomID (FK)
├─ FullName             ├─ Email                 ├─ UserID (FK) *nullable
├─ Phone                ├─ IDCard                └─ ...
└─ ...                  ├─ UserID (FK) *NEW
                        └─ ...

Relationships:
- Users 1:1 Customers (via UserID)
- Customers 1:N Bookings
- Users 0:N Bookings (có thể null for guest)
```

---

## 🔄 User Flows

### Flow 1: Đăng Ký Mới
```
User điền form đăng ký
    ↓
POST /register
    ↓
Validate input
    ↓
Check username/phone đã tồn tại chưa
    ↓
Hash password (SHA-256)
    ↓
INSERT INTO Users → Get userID
    ↓
Tự động CREATE Customer với UserID = userID
    ↓
Redirect to /login với success message
```

### Flow 2: Guest Booking
```
Guest vào trang search rooms
    ↓
Chọn phòng → /booking?view=create
    ↓
Nhập thông tin customer (không login)
    ↓
POST /booking?action=create
    ↓
Check Customer by phone:
  - Nếu có → Dùng luôn
  - Nếu chưa → CREATE Customer với UserID = NULL
    ↓
CREATE Booking với UserID = NULL
    ↓
Success → Suggest đăng ký account
```

### Flow 3: Registered User Booking (Cho chính mình)
```
User đã login → Search rooms
    ↓
Chọn phòng → /booking?view=create
    ↓
Form được pre-fill với thông tin User
    ↓
User bổ sung CMND, địa chỉ
    ↓
POST /booking với bookingForSelf=true
    ↓
Get Customer by UserID:
  - Nếu có → UPDATE thông tin
  - Nếu chưa → CREATE Customer với UserID = user.userID
    ↓
CREATE Booking với CustomerID & UserID
    ↓
Success
```

### Flow 4: Registered User Booking (Cho người khác)
```
User đã login → Search rooms
    ↓
Click "Đặt cho người khác"
    ↓
Nhập thông tin customer khác
    ↓
POST /booking với bookingForSelf=false
    ↓
Check Customer by phone:
  - Nếu có → Dùng luôn
  - Nếu chưa → CREATE Customer với UserID = NULL
    ↓
CREATE Booking với:
  - CustomerID = customer đó
  - UserID = current user
    ↓
Success (User đặt giúp, Customer nhận phòng)
```

---

## 🧪 Testing Scenarios

### Test 1: Đăng Ký Tài Khoản Mới
1. Vào `/register`
2. Điền form với thông tin hợp lệ
3. Submit
4. **Expected**:
   - User record được tạo
   - Customer record được tạo tự động với UserID linked
   - Redirect to login page với success message

### Test 2: Guest Booking
1. **Không login**, vào `/booking?view=search`
2. Tìm phòng và chọn
3. Điền thông tin customer
4. Submit booking
5. **Expected**:
   - Customer được tạo với UserID = NULL
   - Booking được tạo với UserID = NULL
   - Success message suggest đăng ký

### Test 3: User Booking For Self
1. Login với tài khoản đã đăng ký
2. Search và chọn phòng
3. Form được pre-fill với user info
4. Bổ sung CMND, địa chỉ
5. Submit
6. **Expected**:
   - Customer info được update
   - Booking được tạo với cả CustomerID và UserID
   - Success

### Test 4: User Booking For Others
1. Login
2. Search và chọn phòng
3. Click "Đặt cho người khác"
4. Nhập thông tin người khác
5. Submit
6. **Expected**:
   - Customer mới được tạo (hoặc dùng existing)
   - Booking có CustomerID = người khác, UserID = current user

### Test 5: Duplicate Phone Registration
1. Đăng ký với SĐT đã tồn tại
2. **Expected**: Error "Số điện thoại đã được đăng ký"

### Test 6: View My Bookings
1. Login
2. Vào "My Bookings"
3. **Expected**: Hiện tất cả bookings mà UserID = current user

---

## 🔐 Security Notes

⚠️ **WARNING**: Code hiện tại sử dụng **SHA-256** cho password (trong RegisterServlet) nhưng LoginServlet vẫn dùng **MD5** (qua MD5Util).

**CẦN FIX**:
1. Thống nhất sử dụng 1 algorithm (khuyến nghị: bcrypt hoặc Argon2)
2. Hoặc update LoginServlet để check cả 2 formats (backward compatible)

**Temporary fix** (nếu cần nhanh):
```java
// RegisterServlet.java - Đổi sang MD5 để tương thích
String passwordHash = MD5Util.hashPassword(password);
```

---

## 📝 Notes & Best Practices

1. **UserID trong Customer table**:
   - NULL = Guest customer (chưa có account)
   - Có giá trị = Linked account

2. **UserID trong Bookings table**:
   - NULL = Guest booking
   - Có giá trị = User đã login đặt booking này

3. **Customer lookup priority**:
   - Đã login + bookForSelf → Lookup by UserID
   - Còn lại → Lookup by Phone

4. **Data integrity**:
   - Migration script đã tự động link existing data by phone matching
   - Foreign keys ensure referential integrity

5. **Future enhancements**:
   - Email verification cho registered users
   - SMS OTP cho guest bookings
   - Convert guest customer to registered user
   - Merge duplicate customer records

---

## ❓ FAQ

**Q: Khách vãng lai (walk-in) vẫn book được không?**
A: Có, Admin/Staff vẫn có thể tạo booking cho bất kỳ customer nào.

**Q: Một User có thể có nhiều Customer không?**
A: Không, 1 User chỉ link với 1 Customer (quan hệ 1:1). Nhưng User có thể đặt booking cho nhiều Customers khác nhau.

**Q: Guest booking có tracking history không?**
A: Có, track qua Phone number trong Customer table.

**Q: Làm sao upgrade guest → registered user?**
A: Dùng method `CustomerDAO.linkCustomerToUser(customerID, userID)` để link existing customer với user mới đăng ký.

---

## 📞 Support

Nếu có vấn đề trong quá trình triển khai:
1. Check migration script đã chạy thành công chưa
2. Verify các foreign keys đã được tạo
3. Check logs trong console khi test
4. Ensure password hashing algorithm consistent

---

**Generated**: 2025-10-26
**Version**: 2.1
**Author**: Aurora Hotel Team
