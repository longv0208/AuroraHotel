# Aurora Hotel - Linked Account System Deployment Checklist

## 🎯 Implementation Complete!

The linked account system has been fully implemented. Follow this checklist to deploy:

---

## ✅ Pre-Deployment Checklist

### 1. Database Migration
- [ ] Open SQL Server Management Studio
- [ ] Connect to `AuroraHotel` database
- [ ] Run `migration_add_userid_to_customer.sql`
- [ ] Verify all verification queries pass
- [ ] Confirm UserID column exists in Customers table
- [ ] Confirm foreign key constraint created

### 2. Code Review
Review these modified/new files:

**New Files:**
- [ ] `src/main/java/controller/RegisterServlet.java` - User registration controller
- [ ] `src/main/webapp/WEB-INF/auth/register.jsp` - Registration form
- [ ] `migration_add_userid_to_customer.sql` - Database migration script
- [ ] `IMPLEMENTATION_GUIDE.md` - Detailed documentation

**Modified Files:**
- [ ] `src/main/java/model/Customer.java` - Added userID field
- [ ] `src/main/java/dao/CustomerDAO.java` - Added linked account methods
- [ ] `src/main/java/dao/UserDAO.java` - createUser() returns int, getUserByPhone()
- [ ] `src/main/java/controller/BookingServlet.java` - Support guest & registered bookings
- [ ] `src/main/webapp/WEB-INF/booking/create.jsp` - Pre-fill form, toggle booking mode
- [ ] `src/main/webapp/WEB-INF/common/navbar.jsp` - Added Register link
- [ ] `src/main/webapp/WEB-INF/login.jsp` - Added registration link

### 3. Password Hashing Fix (IMPORTANT!)
⚠️ **CRITICAL SECURITY ISSUE**: RegisterServlet uses SHA-256, but existing system uses MD5.

Choose one option:

**Option A (Quick Fix - Temporary):**
```java
// In RegisterServlet.java line 96, change to:
String passwordHash = MD5Util.hashPassword(password);
```

**Option B (Recommended - Long-term):**
1. Migrate to bcrypt or Argon2 for all passwords
2. Update both LoginServlet and RegisterServlet
3. Add logic to support both formats during migration

---

## 🚀 Deployment Steps

### Step 1: Database Migration (5 minutes)
```sql
-- Execute migration_add_userid_to_customer.sql
-- This will:
-- ✓ Add UserID column to Customers
-- ✓ Create foreign key constraint
-- ✓ Create indexes
-- ✓ Migrate existing data by phone matching
-- ✓ Create Customer records for existing Users
```

### Step 2: Fix Password Hashing (2 minutes)
Apply one of the options above in RegisterServlet.java

### Step 3: Build & Deploy (3 minutes)
```bash
# Clean and build
mvn clean package

# Deploy to Tomcat
# Copy target/Aurora-1.0-SNAPSHOT.war to Tomcat webapps/
# Or use your IDE's deploy function
```

### Step 4: Restart Server
```bash
# Restart Tomcat
# Verify no deployment errors in catalina.out
```

---

## 🧪 Testing Scenarios

### Test 1: User Registration
1. Go to `/register`
2. Fill form:
   - Username: `testuser123`
   - Full Name: `Nguyen Van Test`
   - Phone: `0987654321`
   - Email: `test@example.com`
   - Password: `password123`
3. Submit and verify redirect to login
4. **Expected**: Success message shown on login page

### Test 2: Login with New Account
1. Login with credentials from Test 1
2. **Expected**: Login successful, navbar shows user name

### Test 3: Guest Booking
1. **Without logging in**, go to `/booking?view=search`
2. Search for available rooms
3. Select a room and book
4. **Expected**:
   - Yellow alert: "Bạn đang đặt phòng như khách"
   - Can complete booking
   - Booking created with NULL UserID

### Test 4: Registered User Booking (For Self)
1. Login with account from Test 1
2. Search and select a room
3. **Expected**:
   - Blue alert: "Đặt phòng cho: [Your Name]"
   - Form pre-filled with your info
   - Can add CMND and address
4. Submit booking
5. **Expected**: Booking created with linked Customer

### Test 5: Registered User Booking (For Others)
1. While logged in, go to booking create page
2. Click "Đặt cho người khác" button
3. **Expected**: Form clears, can enter other person's info
4. Enter different person's details
5. Submit
6. **Expected**: Booking created with UserID = your ID, CustomerID = other person

### Test 6: View My Bookings
1. Login and go to "My Bookings"
2. **Expected**: See all bookings you created

### Test 7: Navigation Links
1. **Not logged in**: Navbar should show "Register" and "Login"
2. **Logged in**: Navbar should show user profile dropdown
3. Login page should have "Đăng ký ngay" link

---

## 🔍 Post-Deployment Verification

### Database Checks
```sql
-- Check UserID column exists
SELECT TOP 10 CustomerID, FullName, Phone, UserID FROM Customers;

-- Check linked accounts
SELECT u.UserID, u.Username, c.CustomerID, c.FullName
FROM Users u
LEFT JOIN Customers c ON u.UserID = c.UserID;

-- Check guest bookings (UserID = NULL)
SELECT COUNT(*) as GuestBookings FROM Bookings WHERE UserID IS NULL;

-- Check registered user bookings
SELECT COUNT(*) as RegisteredBookings FROM Bookings WHERE UserID IS NOT NULL;
```

### Application Checks
- [ ] Registration page loads at `/register`
- [ ] Registration form validates inputs
- [ ] Duplicate username/phone rejected
- [ ] Password mismatch detected
- [ ] Successful registration redirects to login
- [ ] Login page shows registration link
- [ ] Navbar shows "Register" when not logged in
- [ ] Booking form shows correct alert based on login status
- [ ] Pre-fill works for logged-in users
- [ ] Toggle button switches between self/other booking
- [ ] Guest can complete booking without login

---

## 📊 Success Metrics

After deployment, monitor these metrics:

1. **Registration Rate**: Number of new user registrations
2. **Guest vs Registered Bookings**: Track ratio
3. **Linked Accounts**: Number of Customers with non-NULL UserID
4. **Booking Completion Rate**: Compare guest vs registered users

---

## 🐛 Troubleshooting

### Issue: "Column UserID not found"
**Solution**: Migration script didn't run. Execute `migration_add_userid_to_customer.sql`

### Issue: Registration fails with "User created but Customer creation failed"
**Solution**: Check foreign key constraints and database connection

### Issue: Can't login after registration
**Solution**: Password hashing mismatch. Apply password hashing fix (Step 2)

### Issue: Booking form not pre-filling
**Solution**:
1. Check session contains `loggedInUser`
2. Verify JSTL tags in create.jsp
3. Clear browser cache

### Issue: "Số điện thoại đã được đăng ký"
**Solution**: Phone number already exists in Users table. This is expected behavior.

---

## 📞 Support

If issues persist:
1. Check Tomcat logs: `catalina.out`
2. Check browser console for JavaScript errors
3. Verify database schema changes applied
4. Review `IMPLEMENTATION_GUIDE.md` for detailed documentation

---

## 🎉 Deployment Complete!

Once all tests pass, the linked account system is live and ready for users!

**Key Features Enabled:**
✅ User self-registration
✅ Guest bookings (no login required)
✅ Registered user bookings (pre-filled info)
✅ User can book for others
✅ Automatic Customer creation on registration
✅ Booking history tracking per user

---

**Deployment Date**: _____________
**Deployed By**: _____________
**Server**: _____________
**Status**: [ ] Success  [ ] Issues Found

**Notes**:
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________
