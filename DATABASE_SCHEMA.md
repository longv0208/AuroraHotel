# 🗄️ DATABASE SCHEMA - Linked Account System

## 📊 ENTITY RELATIONSHIP DIAGRAM

```
┌─────────────────────────┐
│        Users            │
├─────────────────────────┤
│ UserID (PK)            │◄────┐
│ Username (UNIQUE)      │     │
│ PasswordHash           │     │
│ FullName               │     │ 1
│ Email                  │     │
│ Phone (UNIQUE)         │     │
│ Role                   │     │
│ IsActive               │     │
│ CreatedDate            │     │
│ LastLogin              │     │
└─────────────────────────┘     │
                                │
                                │ FK_Customer_User
                                │
┌─────────────────────────┐     │
│      Customers          │     │
├─────────────────────────┤     │
│ CustomerID (PK)        │     │
│ FullName               │     │
│ IDCard                 │     │
│ Phone                  │     │
│ Email                  │     │
│ Address                │     │
│ DateOfBirth            │     │
│ Nationality            │     │
│ UserID (FK) ◄──────────┘ 0..1│  [NEW COLUMN]
│ Notes                  │
│ CreatedDate            │
└─────────────────────────┘
        │
        │ 1
        │
        │ FK_Booking_Customer
        │
        ▼ N
┌─────────────────────────┐         ┌─────────────────────────┐
│       Bookings          │    N    │        Rooms            │
├─────────────────────────┤◄────────┤                         │
│ BookingID (PK)         │  FK     │ RoomID (PK)            │
│ CustomerID (FK)        │         │ RoomNumber             │
│ RoomID (FK)            │         │ RoomTypeID (FK)        │
│ UserID (FK) [NULLABLE] │◄─┐      │ Status                 │
│ CheckInDate            │  │      │ Floor                  │
│ CheckOutDate           │  │      │ ...                    │
│ TotalAmount            │  │      └─────────────────────────┘
│ Status                 │  │
│ BookingDate            │  │
│ ...                    │  │
└─────────────────────────┘  │
                             │
                             │ FK_Booking_User
                             │ (Tracks who made the booking)
                             │
                             └───────── Users (UserID)
```

---

## 🔑 KEY RELATIONSHIPS

### 1. Users ↔ Customers (1:1, Optional)
```sql
-- Foreign Key
ALTER TABLE Customers
ADD CONSTRAINT FK_Customer_User
FOREIGN KEY (UserID) REFERENCES Users(UserID);

-- Meaning:
- 1 User can have 0 or 1 linked Customer
- 1 Customer can belong to 0 or 1 User
- Guest customers have UserID = NULL
```

### 2. Customers → Bookings (1:N)
```sql
-- Existing relationship
-- 1 Customer can have many Bookings
-- Each Booking must have 1 Customer
```

### 3. Users → Bookings (1:N, Optional) [ENHANCED]
```sql
-- Tracks who created the booking
-- UserID in Bookings can be NULL (guest booking)
-- UserID can differ from Customer's UserID (booking for others)
```

---

## 📋 TABLE DETAILS

### Users Table (Existing)
```sql
UserID          INT PRIMARY KEY IDENTITY(1,1)
Username        NVARCHAR(50) UNIQUE NOT NULL
PasswordHash    NVARCHAR(255) NOT NULL
FullName        NVARCHAR(100) NOT NULL
Email           NVARCHAR(100)
Phone           NVARCHAR(20) UNIQUE
Role            NVARCHAR(20) DEFAULT 'User'     -- 'User', 'Admin', 'Staff'
IsActive        BIT DEFAULT 1
CreatedDate     DATETIME DEFAULT GETDATE()
LastLogin       DATETIME
```

**Indexes:**
- `PK_Users` on `UserID`
- `UQ_Username` on `Username`
- `UQ_Phone` on `Phone`

---

### Customers Table (MODIFIED)
```sql
CustomerID      INT PRIMARY KEY IDENTITY(1,1)
FullName        NVARCHAR(100) NOT NULL
IDCard          NVARCHAR(20)
Phone           NVARCHAR(20)
Email           NVARCHAR(100)
Address         NVARCHAR(255)
DateOfBirth     DATE
Nationality     NVARCHAR(50)
UserID          INT NULL                        -- ⭐ NEW COLUMN
Notes           NVARCHAR(MAX)
CreatedDate     DATETIME DEFAULT GETDATE()

-- Constraints
CONSTRAINT FK_Customer_User
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
```

**Indexes:**
- `PK_Customers` on `CustomerID`
- `IX_Customer_UserID` on `UserID` ⭐ NEW
- `IX_Customer_Phone` on `Phone` ⭐ NEW

**Nullability:**
- `UserID = NULL` → Guest customer (no account)
- `UserID = <value>` → Linked to user account

---

### Bookings Table (Existing, Enhanced Usage)
```sql
BookingID           INT PRIMARY KEY IDENTITY(1,1)
CustomerID          INT NOT NULL
RoomID              INT NOT NULL
UserID              INT NULL                    -- Can be NULL for guest bookings
CheckInDate         DATE NOT NULL
CheckOutDate        DATE NOT NULL
TotalAmount         DECIMAL(10,2) NOT NULL
Status              NVARCHAR(20) DEFAULT 'Pending'
BookingDate         DATETIME DEFAULT GETDATE()
NumberOfGuests      INT DEFAULT 1
Notes               NVARCHAR(MAX)
CouponCode          NVARCHAR(50)
DiscountAmount      DECIMAL(10,2)

-- Constraints
CONSTRAINT FK_Booking_Customer
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
CONSTRAINT FK_Booking_Room
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
CONSTRAINT FK_Booking_User
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
```

**UserID in Bookings tracks:**
- Who created the booking (even if booking for someone else)
- `NULL` = Guest booking (no one logged in)
- `NOT NULL` = Booking created by logged-in user

---

## 🔄 DATA FLOW SCENARIOS

### Scenario 1: User Registration
```sql
-- Step 1: Create User
INSERT INTO Users (Username, PasswordHash, FullName, Email, Phone, Role, IsActive)
VALUES ('john_doe', 'hashed_password', 'John Doe', 'john@example.com', '0901234567', 'User', 1);
-- Returns: UserID = 100

-- Step 2: Auto-create linked Customer
INSERT INTO Customers (FullName, Phone, Email, UserID)
VALUES ('John Doe', '0901234567', 'john@example.com', 100);
-- Returns: CustomerID = 500

-- Result:
-- User (UserID=100) ↔ Customer (CustomerID=500, UserID=100)
```

---

### Scenario 2: Guest Booking
```sql
-- Step 1: Create/Find Guest Customer
INSERT INTO Customers (FullName, Phone, Email, UserID)
VALUES ('Guest Name', '0987654321', 'guest@example.com', NULL);
-- Returns: CustomerID = 501

-- Step 2: Create Booking
INSERT INTO Bookings (CustomerID, RoomID, UserID, CheckInDate, CheckOutDate, TotalAmount, Status)
VALUES (501, 10, NULL, '2025-11-01', '2025-11-03', 2000000, 'Pending');
-- Returns: BookingID = 1001

-- Result:
-- Booking (BookingID=1001)
--   └─ CustomerID = 501 (Guest with UserID=NULL)
--   └─ UserID = NULL (No one logged in)
```

---

### Scenario 3: Registered User Booking for Self
```sql
-- User already exists: UserID=100, has linked Customer: CustomerID=500

-- Step 1: Get linked Customer
SELECT CustomerID FROM Customers WHERE UserID = 100;
-- Returns: CustomerID = 500

-- Step 2: Update Customer info if needed (CMND, address)
UPDATE Customers
SET IDCard = '123456789', Address = '123 Main St'
WHERE CustomerID = 500;

-- Step 3: Create Booking
INSERT INTO Bookings (CustomerID, RoomID, UserID, CheckInDate, CheckOutDate, TotalAmount, Status)
VALUES (500, 10, 100, '2025-11-01', '2025-11-03', 2000000, 'Pending');
-- Returns: BookingID = 1002

-- Result:
-- Booking (BookingID=1002)
--   └─ CustomerID = 500 (User's own Customer)
--   └─ UserID = 100 (Same user who owns the Customer)
```

---

### Scenario 4: Registered User Booking for Others
```sql
-- User logged in: UserID=100
-- Booking for someone else: Phone='0912222222'

-- Step 1: Find or Create other Customer
SELECT CustomerID FROM Customers WHERE Phone = '0912222222';
-- Not found, so create:
INSERT INTO Customers (FullName, Phone, Email, UserID)
VALUES ('Other Person', '0912222222', 'other@example.com', NULL);
-- Returns: CustomerID = 502

-- Step 2: Create Booking
INSERT INTO Bookings (CustomerID, RoomID, UserID, CheckInDate, CheckOutDate, TotalAmount, Status)
VALUES (502, 10, 100, '2025-11-01', '2025-11-03', 2000000, 'Pending');
-- Returns: BookingID = 1003

-- Result:
-- Booking (BookingID=1003)
--   └─ CustomerID = 502 (Different person, UserID=NULL)
--   └─ UserID = 100 (Tracks who made the booking)
```

---

## 🔍 USEFUL QUERIES

### Find linked Customer for a User
```sql
SELECT c.*
FROM Customers c
WHERE c.UserID = @UserID;
```

### Find all Bookings created by a User
```sql
SELECT b.*, c.FullName as CustomerName, r.RoomNumber
FROM Bookings b
INNER JOIN Customers c ON b.CustomerID = c.CustomerID
INNER JOIN Rooms r ON b.RoomID = r.RoomID
WHERE b.UserID = @UserID
ORDER BY b.BookingDate DESC;
```

### Find Guest Customers (no account)
```sql
SELECT *
FROM Customers
WHERE UserID IS NULL;
```

### Find Registered Customers (have account)
```sql
SELECT c.*, u.Username, u.Email as UserEmail
FROM Customers c
INNER JOIN Users u ON c.UserID = u.UserID;
```

### Find Guest Bookings
```sql
SELECT b.*, c.FullName, c.Phone
FROM Bookings b
INNER JOIN Customers c ON b.CustomerID = c.CustomerID
WHERE b.UserID IS NULL;
```

### Find User who booked for someone else
```sql
-- Bookings where UserID ≠ Customer's UserID
SELECT
    b.BookingID,
    u.FullName as BookedBy,
    c.FullName as BookedFor
FROM Bookings b
INNER JOIN Users u ON b.UserID = u.UserID
INNER JOIN Customers c ON b.CustomerID = c.CustomerID
WHERE c.UserID IS NULL OR c.UserID <> b.UserID;
```

---

## 📊 DATA INTEGRITY RULES

### Rule 1: Unique UserID in Customers
```sql
-- Each User can have at most 1 Customer
-- Enforced by: UNIQUE constraint on UserID (if needed)
-- Current: Multiple Customers CAN have same UserID (FK allows it)
-- Application logic prevents this

-- To enforce at DB level (optional):
CREATE UNIQUE INDEX IX_Customer_UserID_Unique
ON Customers(UserID)
WHERE UserID IS NOT NULL;
```

### Rule 2: Cascading Deletes (NOT IMPLEMENTED - Intentional)
```sql
-- If User is deleted, Customer remains (set UserID to NULL)
-- If Customer is deleted, Bookings remain (orphaned)
-- Current: NO CASCADE DELETE
-- Reason: Preserve historical data
```

### Rule 3: Phone Number Matching
```sql
-- During migration, match by phone:
UPDATE c
SET c.UserID = u.UserID
FROM Customers c
INNER JOIN Users u ON c.Phone = u.Phone
WHERE c.UserID IS NULL;
```

---

## 🛡️ CONSTRAINTS SUMMARY

```sql
-- Primary Keys
PK_Users        ON Users(UserID)
PK_Customers    ON Customers(CustomerID)
PK_Bookings     ON Bookings(BookingID)

-- Foreign Keys
FK_Customer_User     Customers(UserID) → Users(UserID)
FK_Booking_Customer  Bookings(CustomerID) → Customers(CustomerID)
FK_Booking_Room      Bookings(RoomID) → Rooms(RoomID)
FK_Booking_User      Bookings(UserID) → Users(UserID)

-- Unique Constraints
UQ_Username     ON Users(Username)
UQ_Phone        ON Users(Phone)

-- Indexes
IX_Customer_UserID   ON Customers(UserID)
IX_Customer_Phone    ON Customers(Phone)
```

---

## 📈 PERFORMANCE CONSIDERATIONS

### Indexed Columns
```sql
-- Fast lookup by UserID
SELECT * FROM Customers WHERE UserID = ?;
-- Uses: IX_Customer_UserID

-- Fast lookup by Phone
SELECT * FROM Customers WHERE Phone = ?;
-- Uses: IX_Customer_Phone

-- Fast join
SELECT c.*, u.Username
FROM Customers c
INNER JOIN Users u ON c.UserID = u.UserID;
-- Uses: FK indexes
```

### Query Optimization Tips
```sql
-- Good: Use indexed columns
SELECT * FROM Customers WHERE UserID = 100;

-- Bad: Full table scan
SELECT * FROM Customers WHERE LOWER(FullName) LIKE '%john%';

-- Better: Consider full-text search if needed
```

---

## 🎯 MIGRATION CHECKLIST

✅ Add UserID column to Customers
✅ Create FK constraint FK_Customer_User
✅ Create index IX_Customer_UserID
✅ Create index IX_Customer_Phone
✅ Migrate existing data (match by phone)
✅ Create Customers for existing Users
✅ Verify data integrity

---

**Database Version**: 2.0 (Linked Account System)
**Last Updated**: 2025-10-26
**Status**: ✅ READY FOR MIGRATION
