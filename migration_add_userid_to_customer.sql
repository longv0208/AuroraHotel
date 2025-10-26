-- Migration Script: Add UserID to Customers table
-- Date: 2025-10-26
-- Purpose: Link Customer records to User accounts

-- Step 1: Add UserID column to Customers table
ALTER TABLE Customers
ADD UserID INT NULL;
GO

-- Step 2: Add foreign key constraint
ALTER TABLE Customers
ADD CONSTRAINT FK_Customer_User
FOREIGN KEY (UserID) REFERENCES Users(UserID);
GO

-- Step 3: Create index for performance
CREATE INDEX IX_Customer_UserID ON Customers(UserID);
GO

-- Step 4: Create index on Phone for lookup optimization
CREATE INDEX IX_Customer_Phone ON Customers(Phone);
GO

-- Step 5: Migrate existing data - Link Users to Customers by matching Phone
UPDATE c
SET c.UserID = u.UserID
FROM Customers c
INNER JOIN Users u ON c.Phone = u.Phone
WHERE c.UserID IS NULL AND c.Phone IS NOT NULL AND u.Phone IS NOT NULL;
GO

-- Step 6: Create Customer records for Users that don't have one yet
INSERT INTO Customers (FullName, Phone, Email, UserID, CreatedDate, TotalBookings)
SELECT
    u.FullName,
    u.Phone,
    u.Email,
    u.UserID,
    GETDATE(),
    0
FROM Users u
WHERE NOT EXISTS (
    SELECT 1 FROM Customers c WHERE c.UserID = u.UserID
)
AND u.IsActive = 1;
GO

-- Verification queries
PRINT 'Migration completed. Verification:';
PRINT 'Total Customers: ' + CAST((SELECT COUNT(*) FROM Customers) AS VARCHAR);
PRINT 'Customers with UserID: ' + CAST((SELECT COUNT(*) FROM Customers WHERE UserID IS NOT NULL) AS VARCHAR);
PRINT 'Customers without UserID (Guests): ' + CAST((SELECT COUNT(*) FROM Customers WHERE UserID IS NULL) AS VARCHAR);
GO
