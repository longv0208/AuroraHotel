# 🌐 AURORA HOTEL - URL ROUTES

## 🆕 NEW ROUTES

### Registration
```
GET  /register          → Display registration form
POST /register          → Process registration (create User + Customer)
```

---

## ✏️ MODIFIED ROUTES

### Booking (Updated to support guest bookings)
```
GET  /booking?view=search               → Search rooms (no login required)
GET  /booking?view=create&roomID=X      → Create booking form (supports guest + registered)
POST /booking?action=create             → Process booking (supports 3 scenarios)
GET  /booking?view=my-bookings          → View user's bookings (login required)
```

---

## 📋 ALL ROUTES OVERVIEW

### Public Routes (No Login Required)
```
✅ GET  /home                           → Homepage
✅ GET  /about                          → About page
✅ GET  /room                           → Room listing
✅ GET  /service                        → Services listing
✅ GET  /feedback                       → View public feedback
✅ GET  /login                          → Login form
✅ GET  /register                       → Registration form [NEW]
✅ POST /login                          → Process login
✅ POST /register                       → Process registration [NEW]

✅ GET  /booking?view=search            → Search available rooms [UPDATED]
✅ GET  /booking?view=create            → Booking form [UPDATED - Supports guests]
✅ POST /booking?action=create          → Create booking [UPDATED - Supports guests]
```

### Authenticated Routes (Login Required)
```
🔒 GET  /profile                        → User profile
🔒 GET  /booking?view=my-bookings       → My bookings
🔒 GET  /booking?view=details&id=X      → Booking details
🔒 POST /booking?action=cancel          → Cancel booking
🔒 POST /feedback                       → Submit feedback
🔒 GET  /logout                         → Logout
```

### Admin Routes (Admin Role Required)
```
👑 GET  /admin                          → Admin dashboard
👑 GET  /roomManagement?view=list       → Room management
👑 GET  /service?view=list              → Service management
👑 GET  /customer?view=list             → Customer management
👑 GET  /booking?view=list              → Booking management
👑 POST /booking?action=confirm         → Confirm booking
👑 POST /booking?action=checkin         → Check-in
👑 POST /booking?action=checkout        → Check-out
👑 GET  /feedback?action=admin          → Feedback moderation
👑 GET  /coupon?view=list               → Coupon management
👑 GET  /report?view=dashboard          → Dashboard report
👑 GET  /report?view=occupancy          → Occupancy report
```

---

## 🔄 ROUTE BEHAVIOR CHANGES

### Before (Old System)
```
❌ /booking?view=create  → Required login, redirected to /login if not logged in
❌ Only logged-in Users could make bookings
❌ Customer table was disconnected from booking flow
```

### After (New System)
```
✅ /booking?view=create  → Works for both guests and logged-in users
✅ Guests can book without login (shows yellow alert)
✅ Logged-in users see pre-filled form (shows blue alert)
✅ Customer table properly integrated via UserID link
```

---

## 📊 BOOKING FLOW ROUTES

### Scenario 1: Guest Booking
```
1. GET  /booking?view=search
   → Search form (no login)

2. GET  /booking?view=create&roomID=5&checkIn=2025-11-01&checkOut=2025-11-03
   → Booking form
   → Shows: Yellow alert "Bạn đang đặt phòng như khách"
   → Shows: Link to /register

3. POST /booking?action=create
   → Parameters:
     - roomID, checkInDate, checkOutDate
     - fullName, phone, email, address, idCard
     - bookingForSelf=false
   → Creates Booking (UserID=NULL)
   → Creates/Updates Customer (UserID=NULL)
   → Redirects to confirmation page
```

### Scenario 2: Registered User Booking (For Self)
```
1. POST /login
   → User logs in
   → Session stores loggedInUser

2. GET  /booking?view=search
   → Search form

3. GET  /booking?view=create&roomID=5&checkIn=2025-11-01&checkOut=2025-11-03
   → Booking form
   → Shows: Blue alert "Đặt phòng cho: [User Name]"
   → Form pre-filled with user info
   → Hidden field: bookingForSelf=true

4. POST /booking?action=create
   → Parameters include:
     - bookingForSelf=true
   → Uses existing linked Customer or creates one
   → Updates Customer with CMND/address
   → Creates Booking (UserID=loggedInUser.UserID)
   → Redirects to /booking?view=my-bookings
```

### Scenario 3: Registered User Booking (For Others)
```
1. (User already logged in)

2. GET  /booking?view=create&roomID=5&...
   → Booking form pre-filled

3. User clicks "Đặt cho người khác"
   → JavaScript toggles bookingForSelf to false
   → Form clears

4. User enters different person's info

5. POST /booking?action=create
   → Parameters:
     - bookingForSelf=false
     - Different fullName, phone, etc.
   → Creates/Updates different Customer
   → Creates Booking with:
       - CustomerID = other person's customer
       - UserID = loggedInUser.UserID (tracking who made booking)
   → Redirects to /booking?view=my-bookings
```

---

## 🔐 ROUTE SECURITY

### Public Routes (No Auth Check)
```
/home
/about
/room
/service
/feedback (GET only)
/login
/register          [NEW]
/booking?view=search
/booking?view=create   [UPDATED - Now allows guests]
```

### Protected Routes (Session Check)
```
if (session == null || session.getAttribute("loggedInUser") == null) {
    → Redirect to /login?redirect=[current_url]
}

Routes:
- /profile
- /booking?view=my-bookings
- /booking?view=details
- /booking?action=cancel
- /feedback (POST)
- /logout
```

### Admin Routes (Role Check)
```
User user = (User) session.getAttribute("loggedInUser");
if (user == null || !"Admin".equals(user.getRole())) {
    → Show 403 Forbidden or redirect to /home
}

Routes:
- /admin
- /roomManagement
- /service?view=list
- /customer
- /booking?view=list
- /booking?action=confirm|checkin|checkout
- /feedback?action=admin
- /coupon
- /report
```

---

## 🎯 TESTING URLS

### Registration Flow
```bash
# View registration form
http://localhost:8080/Aurora/register

# Submit registration (use Postman or form)
POST http://localhost:8080/Aurora/register
Body:
  username=testuser2025
  fullName=Nguyen Van Test
  phone=0912345678
  email=test@aurora.com
  password=test123
  confirmPassword=test123
```

### Guest Booking Flow
```bash
# Search rooms (no login)
http://localhost:8080/Aurora/booking?view=search

# Select room (example)
http://localhost:8080/Aurora/booking?view=create&roomID=1&checkIn=2025-11-01&checkOut=2025-11-03&guests=2

# Submit booking
POST http://localhost:8080/Aurora/booking
Body:
  action=create
  roomID=1
  checkInDate=2025-11-01
  checkOutDate=2025-11-03
  numberOfGuests=2
  fullName=Guest Name
  phone=0901234567
  email=guest@example.com
  bookingForSelf=false
```

### Registered User Booking Flow
```bash
# Login first
POST http://localhost:8080/Aurora/login
Body:
  username=testuser2025
  password=test123

# Then create booking (form will be pre-filled)
http://localhost:8080/Aurora/booking?view=create&roomID=1&checkIn=2025-11-01&checkOut=2025-11-03

# View my bookings
http://localhost:8080/Aurora/booking?view=my-bookings
```

---

## 📱 MOBILE-FRIENDLY ROUTES

All routes are responsive and work on mobile devices:
- ✅ Bootstrap 5 responsive design
- ✅ Mobile-first approach
- ✅ Touch-friendly buttons
- ✅ Optimized forms for mobile input

---

## 🔗 NAVIGATION LINKS

### Navbar (Not Logged In)
```html
Home → /home
About → /about
Rooms → /room
Booking → /booking?view=search
Services → /service
Feedback → /feedback
Register → /register  [NEW]
Login → /login
```

### Navbar (Logged In)
```html
Home → /home
About → /about
Rooms → /room
Booking → /booking?view=my-bookings
Services → /service
Feedback → /feedback
[Profile Dropdown]
  ├── Profile → /profile
  ├── My Bookings → /booking?view=my-bookings
  └── Logout → /logout
```

### Navbar (Admin)
```html
(All user links above, plus:)
[Management Dropdown]
  ├── Dashboard → /admin
  ├── Room Management → /roomManagement?view=list
  ├── Service Management → /service?view=list
  ├── Customer Management → /customer?view=list
  ├── Booking Management → /booking?view=list
  ├── Feedback Moderation → /feedback?action=admin
  ├── Coupon Management → /coupon?view=list
  ├── Dashboard Report → /report?view=dashboard
  └── Occupancy Report → /report?view=occupancy
```

---

## 🎉 Quick Reference

**New User Registration**: `/register`
**Guest Booking**: `/booking?view=search` → Select room → Fill form
**User Booking**: Login → `/booking?view=search` → Select room → Auto-filled form
**View My Bookings**: Login → `/booking?view=my-bookings`

---

**Last Updated**: 2025-10-26
**Version**: 1.0
