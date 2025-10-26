# ⚡ QUICK START GUIDE - Aurora Hotel Linked Account System

## 🎯 Chỉ 10 Phút Deploy Xong!

---

## ✅ Prerequisites Check

```bash
☐ SQL Server đang chạy
☐ Database "AuroraHotel" tồn tại
☐ Tomcat 10.x đã cài đặt
☐ Java 17+ đã cài đặt
☐ Maven đã cài đặt (nếu build từ source)
```

---

## 🚀 OPTION 1: Deploy Ngay (Đã Build Sẵn)

### Step 1: Database (3 phút)

```sql
-- 1. Mở SQL Server Management Studio
-- 2. Connect tới server
-- 3. Select database: AuroraHotel
-- 4. Open file: migration_add_userid_to_customer.sql
-- 5. Click Execute (F5)
-- 6. Check messages: Should see "Command completed successfully"
```

**Verify:**
```sql
-- Kiểm tra column mới
SELECT TOP 1 CustomerID, FullName, UserID FROM Customers;
-- Kết quả: Should see UserID column
```

---

### Step 2: Deploy WAR (2 phút)

**Option A - Tomcat Manager (Recommended):**
```
1. Open browser: http://localhost:8080/manager
2. Login với Tomcat credentials
3. Section "WAR file to deploy"
4. Choose file: target/Aurora-1.0-SNAPSHOT.war
5. Click "Deploy"
6. Wait for "OK - Deployed application"
```

**Option B - Manual Copy:**
```bash
# Stop Tomcat
cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\bin"
shutdown.bat

# Backup old deployment (optional)
cd ..\webapps
rename Aurora Aurora.backup

# Copy new WAR
copy "f:\ChayNgayDi\PRJ\AuroraHotel_ver2.1\AuroraHotel\target\Aurora-1.0-SNAPSHOT.war" .

# Start Tomcat
cd ..\bin
startup.bat

# Wait 30 seconds for deployment
```

**Option C - IDE Deploy:**
```
Right-click project → Run As → Run on Server
Select: Tomcat 10.1
Click: Finish
```

---

### Step 3: Test (5 phút)

#### Test 1: Homepage (30 seconds)
```
URL: http://localhost:8080/Aurora/
✅ Page loads
✅ Navbar shows "Register" link
✅ No errors
```

#### Test 2: Registration (2 minutes)
```
URL: http://localhost:8080/Aurora/register

Fill form:
Username:        testuser2025
Full Name:       Test User
Phone:           0901234567
Email:           test@aurora.com
Password:        test123
Confirm:         test123

Click: Đăng ký

✅ Redirects to login page
✅ Shows success message
```

#### Test 3: Login (1 minute)
```
URL: http://localhost:8080/Aurora/login

Username: testuser2025
Password: test123

Click: Đăng nhập

✅ Redirects to homepage
✅ Navbar shows "Test User" dropdown
✅ No "Login" link anymore
```

#### Test 4: Booking (2 minutes)
```
1. Click: Rooms
2. Click: Search (leave dates default)
3. Click any "Đặt Phòng" button
4. ✅ Form shows blue alert: "Đặt phòng cho: Test User"
5. ✅ Form pre-filled with your info
6. Fill CMND: 123456789
7. Fill Address: 123 Test Street
8. Click: Xác Nhận Đặt Phòng
9. ✅ Booking successful
```

---

## 🎉 DONE!

Nếu tất cả ✅ đều passed → **Deploy thành công!**

---

## 🚀 OPTION 2: Build Từ Source (Nếu Chưa Build)

### Step 1: Build Project (5 phút)

```bash
# Navigate to project
cd f:\ChayNgayDi\PRJ\AuroraHotel_ver2.1\AuroraHotel

# Clean and build
mvn clean package -DskipTests

# Wait for "BUILD SUCCESS"
# Output: target/Aurora-1.0-SNAPSHOT.war (6.4 MB)
```

### Step 2-3: Same as Option 1

---

## 🔧 Troubleshooting

### ❌ Problem: "Column UserID not found"
```
✔ Solution: Database migration chưa chạy
→ Chạy migration_add_userid_to_customer.sql
```

---

### ❌ Problem: "Cannot connect to database"
```
✔ Check:
1. SQL Server đang chạy?
2. Connection string đúng?
3. Database "AuroraHotel" tồn tại?

✔ File kiểm tra: src/main/java/util/DatabaseUtil.java
```

---

### ❌ Problem: "Page 404 Not Found"
```
✔ Check:
1. Tomcat đang chạy? → http://localhost:8080/
2. Application deployed? → Check webapps/Aurora/
3. Context path đúng? → Should be /Aurora
```

---

### ❌ Problem: "Login failed after registration"
```
✔ Solution: Password hash mismatch (already fixed)
✔ Verify: RegisterServlet uses MD5Util (line 95)

String passwordHash = MD5Util.hashPassword(password);
```

---

### ❌ Problem: "Form not pre-filling"
```
✔ Check:
1. User logged in successfully?
2. Browser console: Any JavaScript errors?
3. JSTL working? Check: ${sessionScope.loggedInUser.fullName}

✔ Debug:
<!-- Add to create.jsp -->
<c:if test="${not empty sessionScope.loggedInUser}">
    <p>Debug: User = ${sessionScope.loggedInUser.fullName}</p>
</c:if>
```

---

## 📊 Verify Database

### After Migration
```sql
-- Check Users table
SELECT COUNT(*) as TotalUsers FROM Users;

-- Check Customers table
SELECT
    COUNT(*) as TotalCustomers,
    COUNT(UserID) as LinkedCustomers,
    COUNT(*) - COUNT(UserID) as GuestCustomers
FROM Customers;

-- Check new indexes
EXEC sp_helpindex 'Customers';
-- Should see: IX_Customer_UserID, IX_Customer_Phone
```

### After Registration
```sql
-- Find your test user
SELECT * FROM Users WHERE Username = 'testuser2025';

-- Find linked customer
SELECT c.*, u.Username
FROM Customers c
INNER JOIN Users u ON c.UserID = u.UserID
WHERE u.Username = 'testuser2025';
```

### After Booking
```sql
-- Find your test booking
SELECT
    b.BookingID,
    b.Status,
    c.FullName as Customer,
    u.Username as BookedBy,
    r.RoomNumber
FROM Bookings b
INNER JOIN Customers c ON b.CustomerID = c.CustomerID
INNER JOIN Users u ON b.UserID = u.UserID
INNER JOIN Rooms r ON b.RoomID = r.RoomID
WHERE u.Username = 'testuser2025'
ORDER BY b.BookingDate DESC;
```

---

## 🎯 Success Indicators

All these should be ✅:

```
Database:
✅ Column Customers.UserID exists
✅ Foreign key FK_Customer_User exists
✅ Indexes created

Application:
✅ /register page loads
✅ Can create new account
✅ Can login with new account
✅ Form pre-fills for logged-in users
✅ Guest can book without login

No Errors:
✅ No compilation errors
✅ No deployment errors in Tomcat logs
✅ No JavaScript errors in browser console
✅ No SQL errors
```

---

## 📚 Need More Info?

**Quick Reference:**
- All changes: [CHANGES_SUMMARY.md](CHANGES_SUMMARY.md)
- Deploy guide: [READY_TO_DEPLOY.md](READY_TO_DEPLOY.md)
- Database info: [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)
- All URLs: [URL_ROUTES.md](URL_ROUTES.md)

**Detailed Docs:**
- Full guide: [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)
- Checklist: [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

---

## 🎊 Test All Features

### Guest Booking Test
```
1. Logout (or open incognito)
2. Go to: http://localhost:8080/Aurora/booking?view=search
3. Select a room
4. ✅ See yellow alert: "Bạn đang đặt phòng như khách"
5. ✅ See link: "Đăng ký tài khoản"
6. Fill form manually
7. Submit
8. ✅ Booking successful (as guest)
```

### Toggle Booking Test
```
1. Login as testuser2025
2. Go to booking form
3. ✅ Form pre-filled
4. Click "Đặt cho người khác"
5. ✅ Form clears
6. Fill different person's info
7. Submit
8. ✅ Booking successful (for other person)
```

### View My Bookings Test
```
1. Login as testuser2025
2. Click profile dropdown → "My Bookings"
3. ✅ See all bookings you created
4. ✅ See bookings for yourself
5. ✅ See bookings for others
```

---

## 💡 Pro Tips

### Tip 1: Check Tomcat Logs
```bash
# Windows
tail -f "C:\Program Files\Apache Software Foundation\Tomcat 10.1\logs\catalina.out"

# Or open file in Notepad++
"C:\Program Files\Apache Software Foundation\Tomcat 10.1\logs\catalina.2025-10-26.log"
```

### Tip 2: Clear Browser Cache
```
If form not pre-filling:
1. Ctrl + Shift + Delete
2. Clear cache and cookies
3. Close and reopen browser
```

### Tip 3: Database Backup
```sql
-- Before running migration
BACKUP DATABASE AuroraHotel
TO DISK = 'C:\Backup\AuroraHotel_BeforeMigration.bak'
WITH FORMAT, NAME = 'Before Linked Account Migration';
```

### Tip 4: Quick Rollback (If Needed)
```sql
-- If something goes wrong
ALTER TABLE Customers DROP CONSTRAINT FK_Customer_User;
ALTER TABLE Customers DROP COLUMN UserID;

-- Then restore from backup
RESTORE DATABASE AuroraHotel
FROM DISK = 'C:\Backup\AuroraHotel_BeforeMigration.bak'
WITH REPLACE;
```

---

## ⏱️ Timeline Summary

```
⏱️ Database Migration:      3 minutes
⏱️ WAR Deployment:           2 minutes
⏱️ Testing:                  5 minutes
─────────────────────────────────────
   Total:                   10 minutes
```

---

## 🎉 READY, SET, GO!

Just follow the steps above, and you'll have the Linked Account System running in 10 minutes!

**Good luck! 🚀**

---

**Last Updated**: 2025-10-26
**Version**: 1.0
**Status**: ✅ PRODUCTION READY
