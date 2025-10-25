-- =============================================
-- DATABASE: HOTEL MANAGEMENT SYSTEM
-- =============================================

-- 1. BẢNG NGƯỜI DÙNG (Users)
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Admin', 'User', 'System')),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    LastLogin DATETIME
);

-- 2. BẢNG LOẠI PHÒNG (Room Types)
CREATE TABLE RoomTypes (
    RoomTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(500),
    BasePrice DECIMAL(18,2) NOT NULL,
    MaxGuests INT NOT NULL,
    Amenities NVARCHAR(1000), -- Tiện nghi: TV, Điều hòa, Tủ lạnh...
    IsActive BIT DEFAULT 1
);

-- 3. BẢNG PHÒNG (Rooms)
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber NVARCHAR(20) UNIQUE NOT NULL,
    RoomTypeID INT FOREIGN KEY REFERENCES RoomTypes(RoomTypeID),
    Floor INT,
    Status NVARCHAR(20) DEFAULT N'Trống' CHECK (Status IN (N'Trống', N'Đã đặt', N'Đang sử dụng', N'Bảo trì')),
    Description NVARCHAR(500),
    IsActive BIT DEFAULT 1
);

-- 4. BẢNG KHÁCH HÀNG (Customers)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    IDCard NVARCHAR(20), -- CMND/CCCD
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(200),
    DateOfBirth DATE,
    Nationality NVARCHAR(50),
    CreatedDate DATETIME DEFAULT GETDATE(),
    TotalBookings INT DEFAULT 0, -- Số lần đặt phòng
    Notes NVARCHAR(500)
);

-- 5. BẢNG ĐẶT PHÒNG (Bookings)
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    RoomID INT FOREIGN KEY REFERENCES Rooms(RoomID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID), -- Người tạo booking
    BookingDate DATETIME DEFAULT GETDATE(),
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    NumberOfGuests INT NOT NULL,
    Status NVARCHAR(20) DEFAULT N'Chờ xác nhận' CHECK (Status IN (N'Chờ xác nhận', N'Đã xác nhận', N'Đã checkin', N'Đã checkout', N'Đã hủy')),
    TotalAmount DECIMAL(18,2),
    DepositAmount DECIMAL(18,2) DEFAULT 0,
    Notes NVARCHAR(500),
    CreatedDate DATETIME DEFAULT GETDATE(),
    UpdatedDate DATETIME
);

-- 6. BẢNG CHI TIẾT PHÒNG ĐÃ ĐẶT (Booking Details)
CREATE TABLE BookingDetails (
    BookingDetailID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
    ServiceDate DATE,
    RoomPrice DECIMAL(18,2),
    SpecialRequests NVARCHAR(500)
);

-- 7. BẢNG DỊCH VỤ (Services)
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(18,2) NOT NULL,
    Unit NVARCHAR(20), -- Đơn vị tính
    Category NVARCHAR(50), -- Loại dịch vụ: Ăn uống, Giặt ủi, Spa...
    IsActive BIT DEFAULT 1
);

-- 8. BẢNG DỊCH VỤ SỬ DỤNG (Booking Services)
CREATE TABLE BookingServices (
    BookingServiceID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
    ServiceID INT FOREIGN KEY REFERENCES Services(ServiceID),
    Quantity INT NOT NULL DEFAULT 1,
    UnitPrice DECIMAL(18,2) NOT NULL,
    TotalPrice DECIMAL(18,2) NOT NULL,
    ServiceDate DATETIME DEFAULT GETDATE(),
    Notes NVARCHAR(500)
);

-- 9. BẢNG THANH TOÁN (Payments)
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
    PaymentDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(18,2) NOT NULL,
    PaymentMethod NVARCHAR(50), -- Tiền mặt, Chuyển khoản, Thẻ
    PaymentType NVARCHAR(20) CHECK (PaymentType IN (N'Đặt cọc', N'Thanh toán', N'Hoàn tiền')),
    TransactionID NVARCHAR(100), -- Mã giao dịch
    UserID INT FOREIGN KEY REFERENCES Users(UserID), -- Người thu
    Notes NVARCHAR(500),
    Status NVARCHAR(20) DEFAULT N'Thành công'
);

-- 10. BẢNG ĐÁNH GIÁ (Reviews)
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(1000),
    ReviewDate DATETIME DEFAULT GETDATE(),
    IsApproved BIT DEFAULT 0,
    AdminReply NVARCHAR(1000),
    ReplyDate DATETIME
);

-- 11. BẢNG MÃ GIẢM GIÁ (Coupons)
CREATE TABLE Coupons (
    CouponID INT PRIMARY KEY IDENTITY(1,1),
    CouponCode NVARCHAR(50) UNIQUE NOT NULL,
    Description NVARCHAR(200),
    DiscountType NVARCHAR(20) CHECK (DiscountType IN ('Percent', 'FixedAmount')),
    DiscountValue DECIMAL(18,2) NOT NULL,
    MinBookingAmount DECIMAL(18,2),
    MaxDiscountAmount DECIMAL(18,2),
    RoomTypeID INT FOREIGN KEY REFERENCES RoomTypes(RoomTypeID), -- NULL nếu áp dụng cho tất cả
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    UsageLimit INT, -- Giới hạn số lần sử dụng
    UsedCount INT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedBy INT FOREIGN KEY REFERENCES Users(UserID),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 12. BẢNG SỬ DỤNG COUPON (Coupon Usage)
CREATE TABLE CouponUsage (
    UsageID INT PRIMARY KEY IDENTITY(1,1),
    CouponID INT FOREIGN KEY REFERENCES Coupons(CouponID),
    BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    DiscountAmount DECIMAL(18,2) NOT NULL,
    UsedDate DATETIME DEFAULT GETDATE()
);

-- 13. BẢNG PHÂN TRANG (Page Management)
CREATE TABLE Pages (
    PageID INT PRIMARY KEY IDENTITY(1,1),
    PageName NVARCHAR(100) NOT NULL,
    PageURL NVARCHAR(200) UNIQUE NOT NULL,
    Title NVARCHAR(200),
    Content NVARCHAR(MAX),
    MetaDescription NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    DisplayOrder INT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    UpdatedDate DATETIME
);

-- 14. BẢNG LOGS (System Logs)
CREATE TABLE SystemLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    Action NVARCHAR(100) NOT NULL,
    TableName NVARCHAR(50),
    RecordID INT,
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    IPAddress NVARCHAR(50),
    LogDate DATETIME DEFAULT GETDATE()
);

-- 15. BẢNG HÌNH ẢNH PHÒNG (Room Images)
CREATE TABLE RoomImages (
    ImageID INT PRIMARY KEY IDENTITY(1,1),
    RoomID INT FOREIGN KEY REFERENCES Rooms(RoomID),
    RoomTypeID INT FOREIGN KEY REFERENCES RoomTypes(RoomTypeID), -- NULL nếu ảnh cho phòng cụ thể
    ImageURL NVARCHAR(500) NOT NULL,
    ImageTitle NVARCHAR(200),
    Description NVARCHAR(500),
    IsPrimary BIT DEFAULT 0, -- Ảnh chính
    DisplayOrder INT DEFAULT 0,
    UploadedBy INT FOREIGN KEY REFERENCES Users(UserID),
    UploadedDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

-- 16. BẢNG LỊCH SỬ ĐẶT PHÒNG (Booking History)
CREATE TABLE BookingHistory (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
    FieldChanged NVARCHAR(100) NOT NULL, -- Trường thay đổi: Status, CheckInDate, etc.
    OldValue NVARCHAR(500),
    NewValue NVARCHAR(500),
    ChangedBy INT FOREIGN KEY REFERENCES Users(UserID),
    ChangedDate DATETIME DEFAULT GETDATE(),
    Action NVARCHAR(50), -- CREATE, UPDATE, CANCEL, CHECKIN, CHECKOUT
    Notes NVARCHAR(500),
    IPAddress NVARCHAR(50)
);

-- =============================================
-- INDEXES ĐỂ TỐI ƯU HIỆU SUẤT
-- =============================================

CREATE INDEX IX_Bookings_Status ON Bookings(Status);
CREATE INDEX IX_Bookings_Dates ON Bookings(CheckInDate, CheckOutDate);
CREATE INDEX IX_Rooms_Status ON Rooms(Status);
CREATE INDEX IX_Customers_Phone ON Customers(Phone);
CREATE INDEX IX_Payments_BookingID ON Payments(BookingID);
CREATE INDEX IX_Reviews_CustomerID ON Reviews(CustomerID);
CREATE INDEX IX_RoomImages_RoomID ON RoomImages(RoomID);
CREATE INDEX IX_RoomImages_RoomTypeID ON RoomImages(RoomTypeID);
CREATE INDEX IX_BookingHistory_BookingID ON BookingHistory(BookingID);
CREATE INDEX IX_BookingHistory_ChangedDate ON BookingHistory(ChangedDate);

-- =============================================
-- VIEWS HỖ TRỢ BÁO CÁO
-- =============================================

-- View: Danh sách phòng trống theo ngày
CREATE VIEW vw_AvailableRooms AS
SELECT 
    r.RoomID,
    r.RoomNumber,
    rt.TypeName,
    rt.BasePrice,
    r.Floor,
    r.Status
FROM Rooms r
INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
WHERE r.Status = N'Trống' AND r.IsActive = 1;
GO

-- View: Doanh thu theo tháng
CREATE VIEW vw_MonthlyRevenue AS
SELECT 
    YEAR(p.PaymentDate) AS Year,
    MONTH(p.PaymentDate) AS Month,
    SUM(p.Amount) AS TotalRevenue,
    COUNT(DISTINCT p.BookingID) AS TotalBookings
FROM Payments p
WHERE p.Status = N'Thành công' AND p.PaymentType = N'Thanh toán'
GROUP BY YEAR(p.PaymentDate), MONTH(p.PaymentDate);
GO

-- View: Thống kê công suất phòng
CREATE VIEW vw_RoomOccupancy AS
SELECT 
    rt.TypeName,
    COUNT(r.RoomID) AS TotalRooms,
    SUM(CASE WHEN r.Status = N'Đang sử dụng' THEN 1 ELSE 0 END) AS OccupiedRooms,
    SUM(CASE WHEN r.Status = N'Trống' THEN 1 ELSE 0 END) AS AvailableRooms,
    CAST(SUM(CASE WHEN r.Status = N'Đang sử dụng' THEN 1 ELSE 0 END) * 100.0 / COUNT(r.RoomID) AS DECIMAL(5,2)) AS OccupancyRate
FROM Rooms r
INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
WHERE r.IsActive = 1
GROUP BY rt.TypeName;
GO

-- View: Lịch sử chi tiết của từng booking
CREATE VIEW vw_BookingHistoryDetail AS
SELECT 
    bh.HistoryID,
    bh.BookingID,
    b.BookingDate,
    c.FullName AS CustomerName,
    r.RoomNumber,
    bh.FieldChanged,
    bh.OldValue,
    bh.NewValue,
    bh.Action,
    u.FullName AS ChangedByUser,
    bh.ChangedDate,
    bh.Notes
FROM BookingHistory bh
INNER JOIN Bookings b ON bh.BookingID = b.BookingID
INNER JOIN Customers c ON b.CustomerID = c.CustomerID
INNER JOIN Rooms r ON b.RoomID = r.RoomID
LEFT JOIN Users u ON bh.ChangedBy = u.UserID;
GO

-- View: Danh sách hình ảnh phòng với thông tin chi tiết
CREATE VIEW vw_RoomImagesDetail AS
SELECT 
    ri.ImageID,
    ri.ImageURL,
    ri.ImageTitle,
    ri.IsPrimary,
    ri.DisplayOrder,
    CASE 
        WHEN ri.RoomID IS NOT NULL THEN r.RoomNumber
        ELSE N'Ảnh chung cho loại phòng'
    END AS RoomNumber,
    rt.TypeName AS RoomTypeName,
    u.FullName AS UploadedByUser,
    ri.UploadedDate
FROM RoomImages ri
LEFT JOIN Rooms r ON ri.RoomID = r.RoomID
LEFT JOIN RoomTypes rt ON ri.RoomTypeID = rt.RoomTypeID
LEFT JOIN Users u ON ri.UploadedBy = u.UserID
WHERE ri.IsActive = 1;
GO

-- =============================================
-- STORED PROCEDURES
-- =============================================

-- SP: Tìm phòng trống theo ngày và loại phòng
CREATE PROCEDURE sp_SearchAvailableRooms
    @CheckInDate DATE,
    @CheckOutDate DATE,
    @RoomTypeID INT = NULL
AS
BEGIN
    SELECT 
        r.RoomID,
        r.RoomNumber,
        rt.TypeName,
        rt.BasePrice,
        rt.MaxGuests,
        r.Floor
    FROM Rooms r
    INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
    WHERE r.IsActive = 1
        AND (@RoomTypeID IS NULL OR r.RoomTypeID = @RoomTypeID)
        AND r.RoomID NOT IN (
            SELECT RoomID 
            FROM Bookings 
            WHERE Status NOT IN (N'Đã hủy', N'Đã checkout')
                AND (
                    (@CheckInDate BETWEEN CheckInDate AND CheckOutDate)
                    OR (@CheckOutDate BETWEEN CheckInDate AND CheckOutDate)
                    OR (CheckInDate BETWEEN @CheckInDate AND @CheckOutDate)
                )
        )
    ORDER BY r.RoomNumber;
END;
GO

-- SP: Tính tổng tiền booking
CREATE PROCEDURE sp_CalculateBookingTotal
    @BookingID INT,
    @TotalAmount DECIMAL(18,2) OUTPUT
AS
BEGIN
    DECLARE @RoomCharge DECIMAL(18,2);
    DECLARE @ServiceCharge DECIMAL(18,2);
    
    -- Tính tiền phòng
    SELECT @RoomCharge = 
        DATEDIFF(DAY, b.CheckInDate, b.CheckOutDate) * rt.BasePrice
    FROM Bookings b
    INNER JOIN Rooms r ON b.RoomID = r.RoomID
    INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
    WHERE b.BookingID = @BookingID;
    
    -- Tính tiền dịch vụ
    SELECT @ServiceCharge = ISNULL(SUM(TotalPrice), 0)
    FROM BookingServices
    WHERE BookingID = @BookingID;
    
    SET @TotalAmount = @RoomCharge + @ServiceCharge;
    
    -- Áp dụng coupon nếu có
    DECLARE @DiscountAmount DECIMAL(18,2);
    SELECT @DiscountAmount = ISNULL(SUM(DiscountAmount), 0)
    FROM CouponUsage
    WHERE BookingID = @BookingID;
    
    SET @TotalAmount = @TotalAmount - @DiscountAmount;
END;
GO

-- SP: Lấy lịch sử booking theo BookingID
CREATE PROCEDURE sp_GetBookingHistory
    @BookingID INT
AS
BEGIN
    SELECT 
        HistoryID,
        FieldChanged,
        OldValue,
        NewValue,
        Action,
        ChangedDate,
        Notes
    FROM vw_BookingHistoryDetail
    WHERE BookingID = @BookingID
    ORDER BY ChangedDate DESC;
END;
GO

-- SP: Lấy hình ảnh phòng theo loại phòng hoặc phòng cụ thể
CREATE PROCEDURE sp_GetRoomImages
    @RoomID INT = NULL,
    @RoomTypeID INT = NULL
AS
BEGIN
    SELECT 
        ImageID,
        ImageURL,
        ImageTitle,
        Description,
        IsPrimary,
        DisplayOrder
    FROM RoomImages
    WHERE IsActive = 1
        AND (
            (@RoomID IS NOT NULL AND RoomID = @RoomID)
            OR (@RoomTypeID IS NOT NULL AND RoomTypeID = @RoomTypeID)
            OR (@RoomID IS NULL AND @RoomTypeID IS NULL)
        )
    ORDER BY IsPrimary DESC, DisplayOrder ASC;
END;
GO

-- =============================================
-- TRIGGERS TỰ ĐỘNG GHI LOG
-- =============================================

-- Trigger: Tự động ghi log khi booking thay đổi
CREATE TRIGGER trg_BookingHistory_AfterUpdate
ON Bookings
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Ghi log thay đổi Status
    INSERT INTO BookingHistory (BookingID, FieldChanged, OldValue, NewValue, ChangedBy, Action)
    SELECT 
        i.BookingID,
        'Status',
        d.Status,
        i.Status,
        i.UserID,
        CASE 
            WHEN i.Status = N'Đã checkin' THEN 'CHECKIN'
            WHEN i.Status = N'Đã checkout' THEN 'CHECKOUT'
            WHEN i.Status = N'Đã hủy' THEN 'CANCEL'
            ELSE 'UPDATE'
        END
    FROM inserted i
    INNER JOIN deleted d ON i.BookingID = d.BookingID
    WHERE UPDATE(Status) AND i.Status <> d.Status;
    
    -- Ghi log thay đổi CheckInDate
    INSERT INTO BookingHistory (BookingID, FieldChanged, OldValue, NewValue, ChangedBy, Action)
    SELECT 
        i.BookingID,
        'CheckInDate',
        CONVERT(NVARCHAR(50), d.CheckInDate, 103),
        CONVERT(NVARCHAR(50), i.CheckInDate, 103),
        i.UserID,
        'UPDATE'
    FROM inserted i
    INNER JOIN deleted d ON i.BookingID = d.BookingID
    WHERE UPDATE(CheckInDate) AND i.CheckInDate <> d.CheckInDate;
    
    -- Ghi log thay đổi CheckOutDate
    INSERT INTO BookingHistory (BookingID, FieldChanged, OldValue, NewValue, ChangedBy, Action)
    SELECT 
        i.BookingID,
        'CheckOutDate',
        CONVERT(NVARCHAR(50), d.CheckOutDate, 103),
        CONVERT(NVARCHAR(50), i.CheckOutDate, 103),
        i.UserID,
        'UPDATE'
    FROM inserted i
    INNER JOIN deleted d ON i.BookingID = d.BookingID
    WHERE UPDATE(CheckOutDate) AND i.CheckOutDate <> d.CheckOutDate;
    
    -- Ghi log thay đổi TotalAmount
    INSERT INTO BookingHistory (BookingID, FieldChanged, OldValue, NewValue, ChangedBy, Action)
    SELECT 
        i.BookingID,
        'TotalAmount',
        CONVERT(NVARCHAR(50), d.TotalAmount),
        CONVERT(NVARCHAR(50), i.TotalAmount),
        i.UserID,
        'UPDATE'
    FROM inserted i
    INNER JOIN deleted d ON i.BookingID = d.BookingID
    WHERE UPDATE(TotalAmount) AND i.TotalAmount <> d.TotalAmount;
END;
GO

-- Trigger: Ghi log khi tạo booking mới
CREATE TRIGGER trg_BookingHistory_AfterInsert
ON Bookings
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO BookingHistory (BookingID, FieldChanged, OldValue, NewValue, ChangedBy, Action, Notes)
    SELECT 
        BookingID,
        'Status',
        NULL,
        Status,
        UserID,
        'CREATE',
        N'Tạo booking mới'
    FROM inserted;
END;
GO