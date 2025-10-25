-- =============================================
-- Test Data for Aurora Hotel Management System
-- =============================================
-- This script inserts test data including users with MD5 hashed passwords
-- 
-- ⚠️ SECURITY WARNING: MD5 is NOT secure for password hashing!
-- This is for TESTING PURPOSES ONLY. Do NOT use in production!
-- 
-- Test Credentials:
-- Admin: admin / admin123 (MD5: 0192023a7bbd73250516f069df18b500)
-- User:  user / user123   (MD5: 482c811da5d5b4bc6d497ffa98491e38)
-- =============================================

USE HotelManagement;
GO

-- =============================================
-- 1. INSERT TEST USERS
-- =============================================
-- Clear existing users (optional - comment out if you want to keep existing data)
-- DELETE FROM Users;

-- Insert Admin User
-- Username: admin, Password: admin123
INSERT INTO Users (Username, PasswordHash, FullName, Email, Phone, Role, IsActive, CreatedDate)
VALUES ('admin', '0192023a7bbd73250516f069df18b500', N'Quản trị viên', 'admin@aurorahotel.com', '0901234567', 'Admin', 1, GETDATE());

-- Insert Regular User
-- Username: user, Password: user123
INSERT INTO Users (Username, PasswordHash, FullName, Email, Phone, Role, IsActive, CreatedDate)
VALUES ('user', '482c811da5d5b4bc6d497ffa98491e38', N'Nguyễn Văn A', 'user@example.com', '0912345678', 'User', 1, GETDATE());

-- Insert System User
-- Username: system, Password: system123
INSERT INTO Users (Username, PasswordHash, FullName, Email, Phone, Role, IsActive, CreatedDate)
VALUES ('system', 'e10adc3949ba59abbe56e057f20f883e', N'System Account', 'system@aurorahotel.com', '0923456789', 'System', 1, GETDATE());

-- Insert Additional Test Users
-- Username: manager, Password: manager123
INSERT INTO Users (Username, PasswordHash, FullName, Email, Phone, Role, IsActive, CreatedDate)
VALUES ('manager', '5f4dcc3b5aa765d61d8327deb882cf99', N'Trần Thị B', 'manager@aurorahotel.com', '0934567890', 'Admin', 1, GETDATE());

-- Username: staff, Password: staff123
INSERT INTO Users (Username, PasswordHash, FullName, Email, Phone, Role, IsActive, CreatedDate)
VALUES ('staff', '5d93ceb70e2bf5daa84ec3d0cd2c731a', N'Lê Văn C', 'staff@aurorahotel.com', '0945678901', 'User', 1, GETDATE());

GO

-- =============================================
-- 2. INSERT ROOM TYPES
-- =============================================
-- Clear existing room types (optional)
-- DELETE FROM RoomTypes;

INSERT INTO RoomTypes (TypeName, Description, BasePrice, MaxGuests, Amenities, IsActive)
VALUES 
(N'Standard Single', N'Phòng đơn tiêu chuẩn với 1 giường đơn', 500000, 1, N'WiFi, TV, Điều hòa, Tủ lạnh mini', 1),
(N'Standard Double', N'Phòng đôi tiêu chuẩn với 1 giường đôi', 700000, 2, N'WiFi, TV, Điều hòa, Tủ lạnh mini, Bàn làm việc', 1),
(N'Deluxe', N'Phòng cao cấp với view đẹp', 1200000, 2, N'WiFi, Smart TV, Điều hòa, Tủ lạnh, Ban công, Bồn tắm', 1),
(N'Suite', N'Phòng suite sang trọng', 2000000, 4, N'WiFi, Smart TV, Điều hòa, Tủ lạnh, Ban công, Bồn tắm, Phòng khách riêng', 1),
(N'Family Room', N'Phòng gia đình rộng rãi', 1500000, 4, N'WiFi, TV, Điều hòa, Tủ lạnh, 2 giường đôi', 1);

GO

-- =============================================
-- 3. INSERT SAMPLE ROOMS
-- =============================================
-- Clear existing rooms (optional)
-- DELETE FROM Rooms;

DECLARE @StandardSingleID INT = (SELECT RoomTypeID FROM RoomTypes WHERE TypeName = N'Standard Single');
DECLARE @StandardDoubleID INT = (SELECT RoomTypeID FROM RoomTypes WHERE TypeName = N'Standard Double');
DECLARE @DeluxeID INT = (SELECT RoomTypeID FROM RoomTypes WHERE TypeName = N'Deluxe');
DECLARE @SuiteID INT = (SELECT RoomTypeID FROM RoomTypes WHERE TypeName = N'Suite');
DECLARE @FamilyID INT = (SELECT RoomTypeID FROM RoomTypes WHERE TypeName = N'Family Room');

-- Floor 1 - Standard Rooms
INSERT INTO Rooms (RoomNumber, RoomTypeID, Floor, Status, Description, IsActive)
VALUES 
('101', @StandardSingleID, 1, 'Available', N'Phòng đơn tầng 1, gần lễ tân', 1),
('102', @StandardSingleID, 1, 'Available', N'Phòng đơn tầng 1', 1),
('103', @StandardDoubleID, 1, 'Available', N'Phòng đôi tầng 1', 1),
('104', @StandardDoubleID, 1, 'Occupied', N'Phòng đôi tầng 1', 1),
('105', @StandardDoubleID, 1, 'Available', N'Phòng đôi tầng 1', 1);

-- Floor 2 - Deluxe Rooms
INSERT INTO Rooms (RoomNumber, RoomTypeID, Floor, Status, Description, IsActive)
VALUES 
('201', @DeluxeID, 2, 'Available', N'Phòng Deluxe view thành phố', 1),
('202', @DeluxeID, 2, 'Available', N'Phòng Deluxe view thành phố', 1),
('203', @DeluxeID, 2, 'Maintenance', N'Phòng Deluxe đang bảo trì', 1),
('204', @DeluxeID, 2, 'Available', N'Phòng Deluxe view vườn', 1),
('205', @FamilyID, 2, 'Available', N'Phòng gia đình tầng 2', 1);

-- Floor 3 - Suite and Premium Rooms
INSERT INTO Rooms (RoomNumber, RoomTypeID, Floor, Status, Description, IsActive)
VALUES 
('301', @SuiteID, 3, 'Available', N'Suite cao cấp view panorama', 1),
('302', @SuiteID, 3, 'Available', N'Suite cao cấp', 1),
('303', @DeluxeID, 3, 'Available', N'Phòng Deluxe tầng cao', 1),
('304', @FamilyID, 3, 'Available', N'Phòng gia đình tầng 3', 1),
('305', @FamilyID, 3, 'Available', N'Phòng gia đình tầng 3', 1);

GO

-- =============================================
-- 4. INSERT SERVICES
-- =============================================
-- Clear existing services (optional)
-- DELETE FROM Services;

INSERT INTO Services (ServiceName, Description, Price, Unit, Category, IsActive)
VALUES 
(N'Giặt ủi', N'Dịch vụ giặt ủi quần áo', 50000, N'kg', N'Laundry', 1),
(N'Ăn sáng buffet', N'Buffet sáng tại nhà hàng', 150000, N'người', N'Food', 1),
(N'Massage', N'Dịch vụ massage thư giãn', 300000, N'giờ', N'Spa', 1),
(N'Đưa đón sân bay', N'Dịch vụ đưa đón sân bay', 500000, N'chuyến', N'Transport', 1),
(N'Thuê xe máy', N'Thuê xe máy theo ngày', 150000, N'ngày', N'Transport', 1),
(N'Minibar', N'Đồ uống và snack trong phòng', 100000, N'lần', N'Food', 1);

GO

-- =============================================
-- 5. INSERT SAMPLE CUSTOMERS
-- =============================================
-- Clear existing customers (optional)
-- DELETE FROM Customers;

INSERT INTO Customers (FullName, IDCard, Phone, Email, Address, DateOfBirth, Nationality, TotalBookings, Notes)
VALUES 
(N'Nguyễn Văn An', '001234567890', '0987654321', 'nguyenvanan@gmail.com', N'123 Lê Lợi, Q1, TP.HCM', '1990-05-15', N'Việt Nam', 0, N'Khách hàng thân thiết'),
(N'Trần Thị Bình', '001234567891', '0987654322', 'tranthibinh@gmail.com', N'456 Nguyễn Huệ, Q1, TP.HCM', '1985-08-20', N'Việt Nam', 0, NULL),
(N'Lê Văn Cường', '001234567892', '0987654323', 'levancuong@gmail.com', N'789 Hai Bà Trưng, Q3, TP.HCM', '1992-12-10', N'Việt Nam', 0, NULL),
(N'John Smith', 'PASS123456', '0987654324', 'john.smith@email.com', N'New York, USA', '1988-03-25', N'USA', 0, N'English speaker'),
(N'Phạm Thị Dung', '001234567893', '0987654325', 'phamthidung@gmail.com', N'321 Võ Văn Tần, Q3, TP.HCM', '1995-07-18', N'Việt Nam', 0, NULL);

GO

-- =============================================
-- 6. INSERT COUPONS
-- =============================================
-- Clear existing coupons (optional)
-- DELETE FROM Coupons;

DECLARE @AdminUserID INT = (SELECT UserID FROM Users WHERE Username = 'admin');

INSERT INTO Coupons (CouponCode, Description, DiscountType, DiscountValue, MinBookingAmount, MaxDiscountAmount, 
                     StartDate, EndDate, UsageLimit, UsedCount, IsActive, CreatedBy)
VALUES 
('WELCOME10', N'Giảm 10% cho khách hàng mới', 'Percentage', 10, 500000, 200000, GETDATE(), DATEADD(MONTH, 3, GETDATE()), 100, 0, 1, @AdminUserID),
('SUMMER2025', N'Khuyến mãi mùa hè 2025', 'Percentage', 15, 1000000, 500000, GETDATE(), DATEADD(MONTH, 2, GETDATE()), 50, 0, 1, @AdminUserID),
('FIXED100K', N'Giảm 100,000đ cho đơn từ 1 triệu', 'Fixed', 100000, 1000000, 100000, GETDATE(), DATEADD(MONTH, 1, GETDATE()), 200, 0, 1, @AdminUserID);

GO

-- =============================================
-- VERIFICATION QUERIES
-- =============================================
PRINT '=== Test Data Inserted Successfully ===';
PRINT '';
PRINT 'Users:';
SELECT UserID, Username, FullName, Role, IsActive FROM Users;
PRINT '';
PRINT 'Room Types:';
SELECT RoomTypeID, TypeName, BasePrice, MaxGuests FROM RoomTypes;
PRINT '';
PRINT 'Rooms:';
SELECT RoomID, RoomNumber, Floor, Status FROM Rooms;
PRINT '';
PRINT 'Services:';
SELECT ServiceID, ServiceName, Price, Unit FROM Services;
PRINT '';
PRINT 'Customers:';
SELECT CustomerID, FullName, Phone, Email FROM Customers;
PRINT '';
PRINT 'Coupons:';
SELECT CouponID, CouponCode, DiscountType, DiscountValue FROM Coupons;
PRINT '';
PRINT '=== Login Credentials ===';
PRINT 'Admin:   admin / admin123';
PRINT 'User:    user / user123';
PRINT 'Manager: manager / manager123';
PRINT 'Staff:   staff / staff123';
PRINT '';
PRINT '⚠️ WARNING: These passwords use MD5 hashing which is NOT secure!';
PRINT 'For production, migrate to BCrypt or Argon2id immediately!';

GO

