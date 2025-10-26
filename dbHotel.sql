USE [master]
GO
/****** Object:  Database [HotelManagementDB]    Script Date: 10/26/2025 1:14:37 AM ******/
--CREATE DATABASE [HotelManagementDB]
 
USE [HotelManagementDB]
GO
/****** Object:  Table [dbo].[RoomTypes]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomTypes](
	[RoomTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[BasePrice] [decimal](18, 2) NOT NULL,
	[MaxGuests] [int] NOT NULL,
	[Amenities] [nvarchar](1000) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RoomTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rooms]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rooms](
	[RoomID] [int] IDENTITY(1,1) NOT NULL,
	[RoomNumber] [nvarchar](20) NOT NULL,
	[RoomTypeID] [int] NULL,
	[Floor] [int] NULL,
	[Status] [nvarchar](20) NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_AvailableRooms]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_AvailableRooms] AS
SELECT r.RoomID, r.RoomNumber, rt.TypeName, rt.BasePrice, r.Floor, r.Status
FROM Rooms r
INNER JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
WHERE r.Status = N'Trống' AND r.IsActive = 1;
GO
/****** Object:  Table [dbo].[Payments]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NULL,
	[PaymentDate] [datetime] NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[PaymentMethod] [nvarchar](50) NULL,
	[PaymentType] [nvarchar](20) NULL,
	[TransactionID] [nvarchar](100) NULL,
	[UserID] [int] NULL,
	[Notes] [nvarchar](500) NULL,
	[Status] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_MonthlyRevenue]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_MonthlyRevenue] AS
SELECT 
    YEAR(p.PaymentDate) AS Year,
    MONTH(p.PaymentDate) AS Month,
    SUM(p.Amount) AS TotalRevenue,
    COUNT(DISTINCT p.BookingID) AS TotalBookings
FROM Payments p
WHERE p.Status = N'Thành công' AND p.PaymentType = N'Thanh toán'
GROUP BY YEAR(p.PaymentDate), MONTH(p.PaymentDate);
GO
/****** Object:  View [dbo].[vw_RoomOccupancy]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_RoomOccupancy] AS
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
/****** Object:  Table [dbo].[Users]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[PasswordHash] [nvarchar](255) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Phone] [nvarchar](20) NULL,
	[Role] [nvarchar](20) NOT NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[LastLogin] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[IDCard] [nvarchar](20) NULL,
	[Phone] [nvarchar](20) NULL,
	[Email] [nvarchar](100) NULL,
	[Address] [nvarchar](200) NULL,
	[DateOfBirth] [date] NULL,
	[Nationality] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[TotalBookings] [int] NULL,
	[Notes] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bookings]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bookings](
	[BookingID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[RoomID] [int] NULL,
	[UserID] [int] NULL,
	[BookingDate] [datetime] NULL,
	[CheckInDate] [date] NOT NULL,
	[CheckOutDate] [date] NOT NULL,
	[NumberOfGuests] [int] NOT NULL,
	[Status] [nvarchar](20) NULL,
	[TotalAmount] [decimal](18, 2) NULL,
	[DepositAmount] [decimal](18, 2) NULL,
	[Notes] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[BookingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookingHistory]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingHistory](
	[HistoryID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NULL,
	[FieldChanged] [nvarchar](100) NOT NULL,
	[OldValue] [nvarchar](500) NULL,
	[NewValue] [nvarchar](500) NULL,
	[ChangedBy] [int] NULL,
	[ChangedDate] [datetime] NULL,
	[Action] [nvarchar](50) NULL,
	[Notes] [nvarchar](500) NULL,
	[IPAddress] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_BookingHistoryDetail]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_BookingHistoryDetail] AS
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
/****** Object:  Table [dbo].[RoomImages]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomImages](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[RoomID] [int] NULL,
	[RoomTypeID] [int] NULL,
	[ImageURL] [nvarchar](500) NOT NULL,
	[ImageTitle] [nvarchar](200) NULL,
	[Description] [nvarchar](500) NULL,
	[IsPrimary] [bit] NULL,
	[DisplayOrder] [int] NULL,
	[UploadedBy] [int] NULL,
	[UploadedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_RoomImagesDetail]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_RoomImagesDetail] AS
SELECT 
    ri.ImageID,
    ri.ImageURL,
    ri.ImageTitle,
    ri.IsPrimary,
    ri.DisplayOrder,
    CASE WHEN ri.RoomID IS NOT NULL THEN r.RoomNumber ELSE N'Ảnh chung cho loại phòng' END AS RoomNumber,
    rt.TypeName AS RoomTypeName,
    u.FullName AS UploadedByUser,
    ri.UploadedDate
FROM RoomImages ri
LEFT JOIN Rooms r ON ri.RoomID = r.RoomID
LEFT JOIN RoomTypes rt ON ri.RoomTypeID = rt.RoomTypeID
LEFT JOIN Users u ON ri.UploadedBy = u.UserID
WHERE ri.IsActive = 1;
GO
/****** Object:  Table [dbo].[BookingDetails]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingDetails](
	[BookingDetailID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NULL,
	[ServiceDate] [date] NULL,
	[RoomPrice] [decimal](18, 2) NULL,
	[SpecialRequests] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[BookingDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookingServices]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingServices](
	[BookingServiceID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NULL,
	[ServiceID] [int] NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[TotalPrice] [decimal](18, 2) NOT NULL,
	[ServiceDate] [datetime] NULL,
	[Notes] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[BookingServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Coupons]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Coupons](
	[CouponID] [int] IDENTITY(1,1) NOT NULL,
	[CouponCode] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[DiscountType] [nvarchar](20) NULL,
	[DiscountValue] [decimal](18, 2) NOT NULL,
	[MinBookingAmount] [decimal](18, 2) NULL,
	[MaxDiscountAmount] [decimal](18, 2) NULL,
	[RoomTypeID] [int] NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[UsageLimit] [int] NULL,
	[UsedCount] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CouponID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CouponUsage]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CouponUsage](
	[UsageID] [int] IDENTITY(1,1) NOT NULL,
	[CouponID] [int] NULL,
	[BookingID] [int] NULL,
	[CustomerID] [int] NULL,
	[DiscountAmount] [decimal](18, 2) NOT NULL,
	[UsedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UsageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[ReviewID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NULL,
	[CustomerID] [int] NULL,
	[Rating] [int] NULL,
	[Comment] [nvarchar](1000) NULL,
	[ReviewDate] [datetime] NULL,
	[IsApproved] [bit] NULL,
	[AdminReply] [nvarchar](1000) NULL,
	[ReplyDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Services]    Script Date: 10/26/2025 1:14:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services](
	[ServiceID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[Unit] [nvarchar](20) NULL,
	[Category] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[BookingDetails] ON 

INSERT [dbo].[BookingDetails] ([BookingDetailID], [BookingID], [ServiceDate], [RoomPrice], [SpecialRequests]) VALUES (1, 1, CAST(N'2025-10-20' AS Date), CAST(800000.00 AS Decimal(18, 2)), N'Thêm gối')
INSERT [dbo].[BookingDetails] ([BookingDetailID], [BookingID], [ServiceDate], [RoomPrice], [SpecialRequests]) VALUES (2, 2, CAST(N'2025-10-25' AS Date), CAST(800000.00 AS Decimal(18, 2)), N'Không hút thuốc')
INSERT [dbo].[BookingDetails] ([BookingDetailID], [BookingID], [ServiceDate], [RoomPrice], [SpecialRequests]) VALUES (3, 3, CAST(N'2025-10-15' AS Date), CAST(1500000.00 AS Decimal(18, 2)), N'Tầng cao')
SET IDENTITY_INSERT [dbo].[BookingDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[BookingHistory] ON 

INSERT [dbo].[BookingHistory] ([HistoryID], [BookingID], [FieldChanged], [OldValue], [NewValue], [ChangedBy], [ChangedDate], [Action], [Notes], [IPAddress]) VALUES (1, 3, N'Status', NULL, N'Đã checkout', 2, CAST(N'2025-10-25T23:44:12.730' AS DateTime), N'CREATE', N'Tạo booking mới', NULL)
INSERT [dbo].[BookingHistory] ([HistoryID], [BookingID], [FieldChanged], [OldValue], [NewValue], [ChangedBy], [ChangedDate], [Action], [Notes], [IPAddress]) VALUES (2, 2, N'Status', NULL, N'Chờ xác nhận', 2, CAST(N'2025-10-25T23:44:12.730' AS DateTime), N'CREATE', N'Tạo booking mới', NULL)
INSERT [dbo].[BookingHistory] ([HistoryID], [BookingID], [FieldChanged], [OldValue], [NewValue], [ChangedBy], [ChangedDate], [Action], [Notes], [IPAddress]) VALUES (3, 1, N'Status', NULL, N'Đã checkin', 2, CAST(N'2025-10-25T23:44:12.730' AS DateTime), N'CREATE', N'Tạo booking mới', NULL)
INSERT [dbo].[BookingHistory] ([HistoryID], [BookingID], [FieldChanged], [OldValue], [NewValue], [ChangedBy], [ChangedDate], [Action], [Notes], [IPAddress]) VALUES (4, 1, N'Status', N'Chờ xác nhận', N'Đã checkin', 2, CAST(N'2025-10-25T23:44:12.757' AS DateTime), N'CHECKIN', N'Khách đã nhận phòng', NULL)
INSERT [dbo].[BookingHistory] ([HistoryID], [BookingID], [FieldChanged], [OldValue], [NewValue], [ChangedBy], [ChangedDate], [Action], [Notes], [IPAddress]) VALUES (5, 3, N'Status', N'Đã checkin', N'Đã checkout', 2, CAST(N'2025-10-25T23:44:12.757' AS DateTime), N'CHECKOUT', N'Khách trả phòng', NULL)
INSERT [dbo].[BookingHistory] ([HistoryID], [BookingID], [FieldChanged], [OldValue], [NewValue], [ChangedBy], [ChangedDate], [Action], [Notes], [IPAddress]) VALUES (6, 2, N'Status', NULL, N'Chờ xác nhận', 2, CAST(N'2025-10-25T23:44:12.757' AS DateTime), N'CREATE', N'Khách đặt phòng mới', NULL)
SET IDENTITY_INSERT [dbo].[BookingHistory] OFF
GO
SET IDENTITY_INSERT [dbo].[Bookings] ON 

INSERT [dbo].[Bookings] ([BookingID], [CustomerID], [RoomID], [UserID], [BookingDate], [CheckInDate], [CheckOutDate], [NumberOfGuests], [Status], [TotalAmount], [DepositAmount], [Notes], [CreatedDate], [UpdatedDate]) VALUES (1, 1, 2, 2, CAST(N'2025-10-25T23:44:12.720' AS DateTime), CAST(N'2025-10-20' AS Date), CAST(N'2025-10-23' AS Date), 1, N'Đã checkin', CAST(2400000.00 AS Decimal(18, 2)), CAST(500000.00 AS Decimal(18, 2)), N'Khách ở 3 đêm', CAST(N'2025-10-25T23:44:12.720' AS DateTime), NULL)
INSERT [dbo].[Bookings] ([BookingID], [CustomerID], [RoomID], [UserID], [BookingDate], [CheckInDate], [CheckOutDate], [NumberOfGuests], [Status], [TotalAmount], [DepositAmount], [Notes], [CreatedDate], [UpdatedDate]) VALUES (2, 2, 3, 2, CAST(N'2025-10-25T23:44:12.720' AS DateTime), CAST(N'2025-10-25' AS Date), CAST(N'2025-10-27' AS Date), 2, N'Chờ xác nhận', CAST(1600000.00 AS Decimal(18, 2)), CAST(400000.00 AS Decimal(18, 2)), N'Khách yêu cầu tầng 2', CAST(N'2025-10-25T23:44:12.720' AS DateTime), NULL)
INSERT [dbo].[Bookings] ([BookingID], [CustomerID], [RoomID], [UserID], [BookingDate], [CheckInDate], [CheckOutDate], [NumberOfGuests], [Status], [TotalAmount], [DepositAmount], [Notes], [CreatedDate], [UpdatedDate]) VALUES (3, 3, 4, 2, CAST(N'2025-10-25T23:44:12.720' AS DateTime), CAST(N'2025-10-15' AS Date), CAST(N'2025-10-18' AS Date), 2, N'Đã checkout', CAST(4500000.00 AS Decimal(18, 2)), CAST(1000000.00 AS Decimal(18, 2)), N'Đã thanh toán đủ', CAST(N'2025-10-25T23:44:12.720' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Bookings] OFF
GO
SET IDENTITY_INSERT [dbo].[BookingServices] ON 

INSERT [dbo].[BookingServices] ([BookingServiceID], [BookingID], [ServiceID], [Quantity], [UnitPrice], [TotalPrice], [ServiceDate], [Notes]) VALUES (1, 1, 1, 3, CAST(100000.00 AS Decimal(18, 2)), CAST(300000.00 AS Decimal(18, 2)), CAST(N'2025-10-25T23:44:12.740' AS DateTime), NULL)
INSERT [dbo].[BookingServices] ([BookingServiceID], [BookingID], [ServiceID], [Quantity], [UnitPrice], [TotalPrice], [ServiceDate], [Notes]) VALUES (2, 1, 2, 2, CAST(50000.00 AS Decimal(18, 2)), CAST(100000.00 AS Decimal(18, 2)), CAST(N'2025-10-25T23:44:12.740' AS DateTime), NULL)
INSERT [dbo].[BookingServices] ([BookingServiceID], [BookingID], [ServiceID], [Quantity], [UnitPrice], [TotalPrice], [ServiceDate], [Notes]) VALUES (3, 3, 3, 1, CAST(300000.00 AS Decimal(18, 2)), CAST(300000.00 AS Decimal(18, 2)), CAST(N'2025-10-25T23:44:12.740' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[BookingServices] OFF
GO
SET IDENTITY_INSERT [dbo].[Coupons] ON 

INSERT [dbo].[Coupons] ([CouponID], [CouponCode], [Description], [DiscountType], [DiscountValue], [MinBookingAmount], [MaxDiscountAmount], [RoomTypeID], [StartDate], [EndDate], [UsageLimit], [UsedCount], [IsActive], [CreatedBy], [CreatedDate]) VALUES (1, N'TEST', N'12', N'Percent', CAST(12.00 AS Decimal(18, 2)), NULL, NULL, NULL, CAST(N'2025-10-27' AS Date), CAST(N'2025-10-28' AS Date), NULL, 0, 1, 1, CAST(N'2025-10-26T00:29:04.353' AS DateTime))
INSERT [dbo].[Coupons] ([CouponID], [CouponCode], [Description], [DiscountType], [DiscountValue], [MinBookingAmount], [MaxDiscountAmount], [RoomTypeID], [StartDate], [EndDate], [UsageLimit], [UsedCount], [IsActive], [CreatedBy], [CreatedDate]) VALUES (5, N'QQQ', N'qqq', N'FixedAmount', CAST(1000000.00 AS Decimal(18, 2)), NULL, NULL, NULL, CAST(N'2025-10-26' AS Date), CAST(N'2025-11-01' AS Date), 10, 0, 0, 1, CAST(N'2025-10-26T00:42:57.803' AS DateTime))
SET IDENTITY_INSERT [dbo].[Coupons] OFF
GO
SET IDENTITY_INSERT [dbo].[Customers] ON 

INSERT [dbo].[Customers] ([CustomerID], [FullName], [IDCard], [Phone], [Email], [Address], [DateOfBirth], [Nationality], [CreatedDate], [TotalBookings], [Notes]) VALUES (1, N'Phạm Minh Khôi', N'012345678', N'0909123123', N'khoi.p@gmail.com', N'Hà Nội', NULL, N'Việt Nam', CAST(N'2025-10-25T23:44:12.710' AS DateTime), 0, NULL)
INSERT [dbo].[Customers] ([CustomerID], [FullName], [IDCard], [Phone], [Email], [Address], [DateOfBirth], [Nationality], [CreatedDate], [TotalBookings], [Notes]) VALUES (2, N'Trần Thu Hà', N'098765432', N'0911222333', N'ha.tran@gmail.com', N'Hồ Chí Minh', NULL, N'Việt Nam', CAST(N'2025-10-25T23:44:12.710' AS DateTime), 0, NULL)
INSERT [dbo].[Customers] ([CustomerID], [FullName], [IDCard], [Phone], [Email], [Address], [DateOfBirth], [Nationality], [CreatedDate], [TotalBookings], [Notes]) VALUES (3, N'Lê Quốc Bảo', N'077889900', N'0988777666', N'bao.le@gmail.com', N'Đà Nẵng', NULL, N'Việt Nam', CAST(N'2025-10-25T23:44:12.710' AS DateTime), 0, NULL)
SET IDENTITY_INSERT [dbo].[Customers] OFF
GO
SET IDENTITY_INSERT [dbo].[Payments] ON 

INSERT [dbo].[Payments] ([PaymentID], [BookingID], [PaymentDate], [Amount], [PaymentMethod], [PaymentType], [TransactionID], [UserID], [Notes], [Status]) VALUES (1, 1, CAST(N'2025-10-20T00:00:00.000' AS DateTime), CAST(2400000.00 AS Decimal(18, 2)), N'Tiền mặt', N'Thanh toán', N'TX001', 2, N'Thanh toán toàn bộ khi checkin', N'Thành công')
INSERT [dbo].[Payments] ([PaymentID], [BookingID], [PaymentDate], [Amount], [PaymentMethod], [PaymentType], [TransactionID], [UserID], [Notes], [Status]) VALUES (2, 2, CAST(N'2025-10-24T00:00:00.000' AS DateTime), CAST(400000.00 AS Decimal(18, 2)), N'Tiền mặt', N'Đặt cọc', N'TX002', 2, N'Khách đặt cọc', N'Thành công')
INSERT [dbo].[Payments] ([PaymentID], [BookingID], [PaymentDate], [Amount], [PaymentMethod], [PaymentType], [TransactionID], [UserID], [Notes], [Status]) VALUES (3, 3, CAST(N'2025-10-18T00:00:00.000' AS DateTime), CAST(4500000.00 AS Decimal(18, 2)), N'Chuyển khoản', N'Thanh toán', N'TX003', 1, N'Thanh toán khi checkout', N'Thành công')
SET IDENTITY_INSERT [dbo].[Payments] OFF
GO
SET IDENTITY_INSERT [dbo].[RoomImages] ON 

INSERT [dbo].[RoomImages] ([ImageID], [RoomID], [RoomTypeID], [ImageURL], [ImageTitle], [Description], [IsPrimary], [DisplayOrder], [UploadedBy], [UploadedDate], [IsActive]) VALUES (1, 1, 1, N'room101.jpg', N'Phòng đơn 101', N'Hình ảnh thực tế phòng 101', 1, 1, 1, CAST(N'2025-10-25T23:44:12.750' AS DateTime), 1)
INSERT [dbo].[RoomImages] ([ImageID], [RoomID], [RoomTypeID], [ImageURL], [ImageTitle], [Description], [IsPrimary], [DisplayOrder], [UploadedBy], [UploadedDate], [IsActive]) VALUES (2, 2, 2, N'room102.jpg', N'Phòng đôi 102', N'Hình ảnh phòng hướng vườn', 1, 1, 2, CAST(N'2025-10-25T23:44:12.750' AS DateTime), 1)
INSERT [dbo].[RoomImages] ([ImageID], [RoomID], [RoomTypeID], [ImageURL], [ImageTitle], [Description], [IsPrimary], [DisplayOrder], [UploadedBy], [UploadedDate], [IsActive]) VALUES (3, NULL, 3, N'suite_room.jpg', N'Suite Room', N'Ảnh đại diện loại phòng Suite', 1, 1, 1, CAST(N'2025-10-25T23:44:12.750' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[RoomImages] OFF
GO
SET IDENTITY_INSERT [dbo].[Rooms] ON 

INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [RoomTypeID], [Floor], [Status], [Description], [IsActive]) VALUES (1, N'101', 1, 1, N'Trống', N'Phòng yên tĩnh gần lễ tân', 1)
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [RoomTypeID], [Floor], [Status], [Description], [IsActive]) VALUES (2, N'102', 2, 1, N'Đang sử dụng', N'Phòng hướng vườn', 1)
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [RoomTypeID], [Floor], [Status], [Description], [IsActive]) VALUES (3, N'201', 2, 2, N'Đã đặt', N'Phòng gần thang máy', 1)
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [RoomTypeID], [Floor], [Status], [Description], [IsActive]) VALUES (4, N'301', 3, 3, N'Trống', N'Phòng VIP có view đẹp', 1)
SET IDENTITY_INSERT [dbo].[Rooms] OFF
GO
SET IDENTITY_INSERT [dbo].[RoomTypes] ON 

INSERT [dbo].[RoomTypes] ([RoomTypeID], [TypeName], [Description], [BasePrice], [MaxGuests], [Amenities], [IsActive]) VALUES (1, N'Single Room', N'Phòng đơn có giường 1m2, phù hợp cho 1 người.', CAST(500000.00 AS Decimal(18, 2)), 1, N'TV, Điều hòa, Wifi, Mini bar', 1)
INSERT [dbo].[RoomTypes] ([RoomTypeID], [TypeName], [Description], [BasePrice], [MaxGuests], [Amenities], [IsActive]) VALUES (2, N'Double Room', N'Phòng đôi có giường 1m6, phù hợp cho 2 người.', CAST(800000.00 AS Decimal(18, 2)), 2, N'TV, Điều hòa, Wifi, Tủ lạnh, Bàn làm việc', 1)
INSERT [dbo].[RoomTypes] ([RoomTypeID], [TypeName], [Description], [BasePrice], [MaxGuests], [Amenities], [IsActive]) VALUES (3, N'Suite Room', N'Phòng hạng sang với ban công hướng biển.', CAST(1500000.00 AS Decimal(18, 2)), 3, N'TV, Điều hòa, Wifi, Jacuzzi, Sofa, View đẹp', 1)
SET IDENTITY_INSERT [dbo].[RoomTypes] OFF
GO
SET IDENTITY_INSERT [dbo].[Services] ON 

INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [Unit], [Category], [IsActive]) VALUES (1, N'Bữa sáng buffet', N'Ăn sáng tại nhà hàng tầng 1', CAST(100000.00 AS Decimal(18, 2)), N'Suất', N'Ăn uống', 1)
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [Unit], [Category], [IsActive]) VALUES (2, N'Giặt ủi', N'Dịch vụ giặt quần áo theo kg', CAST(50000.00 AS Decimal(18, 2)), N'Kg', N'Giặt ủi', 1)
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [Unit], [Category], [IsActive]) VALUES (3, N'Spa', N'Dịch vụ massage thư giãn toàn thân', CAST(300000.00 AS Decimal(18, 2)), N'Lần', N'Spa', 1)
SET IDENTITY_INSERT [dbo].[Services] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserID], [Username], [PasswordHash], [FullName], [Email], [Phone], [Role], [IsActive], [CreatedDate], [LastLogin]) VALUES (1, N'admin01', N'c4ca4238a0b923820dcc509a6f75849b', N'Nguyễn Văn A', N'admin@hotel.com', N'0909123456', N'Admin', 1, CAST(N'2025-10-25T23:44:12.683' AS DateTime), CAST(N'2025-10-26T00:59:14.580' AS DateTime))
INSERT [dbo].[Users] ([UserID], [Username], [PasswordHash], [FullName], [Email], [Phone], [Role], [IsActive], [CreatedDate], [LastLogin]) VALUES (2, N'reception01', N'c4ca4238a0b923820dcc509a6f75849b', N'Lê Thị B', N'le.b@hotel.com', N'0912345678', N'User', 1, CAST(N'2025-10-25T23:44:12.683' AS DateTime), NULL)
INSERT [dbo].[Users] ([UserID], [Username], [PasswordHash], [FullName], [Email], [Phone], [Role], [IsActive], [CreatedDate], [LastLogin]) VALUES (3, N'system01', N'c4ca4238a0b923820dcc509a6f75849b', N'Hệ thống', NULL, NULL, N'System', 1, CAST(N'2025-10-25T23:44:12.683' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Coupons__D34908005FBEE0E4]    Script Date: 10/26/2025 1:14:37 AM ******/
ALTER TABLE [dbo].[Coupons] ADD UNIQUE NONCLUSTERED 
(
	[CouponCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Rooms__AE10E07A32A068FB]    Script Date: 10/26/2025 1:14:37 AM ******/
ALTER TABLE [dbo].[Rooms] ADD UNIQUE NONCLUSTERED 
(
	[RoomNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__536C85E467922391]    Script Date: 10/26/2025 1:14:37 AM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BookingHistory] ADD  DEFAULT (getdate()) FOR [ChangedDate]
GO
ALTER TABLE [dbo].[Bookings] ADD  DEFAULT (getdate()) FOR [BookingDate]
GO
ALTER TABLE [dbo].[Bookings] ADD  DEFAULT (N'Chờ xác nhận') FOR [Status]
GO
ALTER TABLE [dbo].[Bookings] ADD  DEFAULT ((0)) FOR [DepositAmount]
GO
ALTER TABLE [dbo].[Bookings] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[BookingServices] ADD  DEFAULT ((1)) FOR [Quantity]
GO
ALTER TABLE [dbo].[BookingServices] ADD  DEFAULT (getdate()) FOR [ServiceDate]
GO
ALTER TABLE [dbo].[Coupons] ADD  DEFAULT ((0)) FOR [UsedCount]
GO
ALTER TABLE [dbo].[Coupons] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Coupons] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[CouponUsage] ADD  DEFAULT (getdate()) FOR [UsedDate]
GO
ALTER TABLE [dbo].[Customers] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Customers] ADD  DEFAULT ((0)) FOR [TotalBookings]
GO
ALTER TABLE [dbo].[Payments] ADD  DEFAULT (getdate()) FOR [PaymentDate]
GO
ALTER TABLE [dbo].[Payments] ADD  DEFAULT (N'Thành công') FOR [Status]
GO
ALTER TABLE [dbo].[Reviews] ADD  DEFAULT (getdate()) FOR [ReviewDate]
GO
ALTER TABLE [dbo].[Reviews] ADD  DEFAULT ((0)) FOR [IsApproved]
GO
ALTER TABLE [dbo].[RoomImages] ADD  DEFAULT ((0)) FOR [IsPrimary]
GO
ALTER TABLE [dbo].[RoomImages] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[RoomImages] ADD  DEFAULT (getdate()) FOR [UploadedDate]
GO
ALTER TABLE [dbo].[RoomImages] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Rooms] ADD  DEFAULT (N'Trống') FOR [Status]
GO
ALTER TABLE [dbo].[Rooms] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[RoomTypes] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Services] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[BookingDetails]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
GO
ALTER TABLE [dbo].[BookingHistory]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
GO
ALTER TABLE [dbo].[BookingHistory]  WITH CHECK ADD FOREIGN KEY([ChangedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD FOREIGN KEY([RoomID])
REFERENCES [dbo].[Rooms] ([RoomID])
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[BookingServices]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
GO
ALTER TABLE [dbo].[BookingServices]  WITH CHECK ADD FOREIGN KEY([ServiceID])
REFERENCES [dbo].[Services] ([ServiceID])
GO
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD FOREIGN KEY([RoomTypeID])
REFERENCES [dbo].[RoomTypes] ([RoomTypeID])
GO
ALTER TABLE [dbo].[CouponUsage]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
GO
ALTER TABLE [dbo].[CouponUsage]  WITH CHECK ADD FOREIGN KEY([CouponID])
REFERENCES [dbo].[Coupons] ([CouponID])
GO
ALTER TABLE [dbo].[CouponUsage]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[RoomImages]  WITH CHECK ADD FOREIGN KEY([RoomID])
REFERENCES [dbo].[Rooms] ([RoomID])
GO
ALTER TABLE [dbo].[RoomImages]  WITH CHECK ADD FOREIGN KEY([RoomTypeID])
REFERENCES [dbo].[RoomTypes] ([RoomTypeID])
GO
ALTER TABLE [dbo].[RoomImages]  WITH CHECK ADD FOREIGN KEY([UploadedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Rooms]  WITH CHECK ADD FOREIGN KEY([RoomTypeID])
REFERENCES [dbo].[RoomTypes] ([RoomTypeID])
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD CHECK  (([Status]=N'Đã hủy' OR [Status]=N'Đã checkout' OR [Status]=N'Đã checkin' OR [Status]=N'Đã xác nhận' OR [Status]=N'Chờ xác nhận'))
GO
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD CHECK  (([DiscountType]='FixedAmount' OR [DiscountType]='Percent'))
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD CHECK  (([PaymentType]=N'Hoàn tiền' OR [PaymentType]=N'Thanh toán' OR [PaymentType]=N'Đặt cọc'))
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD CHECK  (([Rating]>=(1) AND [Rating]<=(5)))
GO
ALTER TABLE [dbo].[Rooms]  WITH CHECK ADD CHECK  (([Status]=N'Bảo trì' OR [Status]=N'Đang sử dụng' OR [Status]=N'Đã đặt' OR [Status]=N'Trống'))
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([Role]='System' OR [Role]='User' OR [Role]='Admin'))
GO
USE [master]
GO
ALTER DATABASE [HotelManagementDB] SET  READ_WRITE 
GO
