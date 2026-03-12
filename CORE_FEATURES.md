# Core Features

## F-01: Customer Login

| Attribute | Detail |
|-----------|--------|
| **Description** | Authenticate customers via email/password with reCAPTCHA, or via Google OAuth2. |
| **Actors** | Customer |
| **Input** | Email, password, reCAPTCHA token — OR — Google ID token |
| **System Behavior** | Validate credentials against DB (BCrypt compare), verify reCAPTCHA with Google API, check account is ACTIVE and not deleted. For Google login: verify ID token, auto-create account if new. Generate JWT access token + refresh token. |
| **Output** | Authenticated session (access token + refresh token), redirect to homepage. Error message on failure. |

---

## F-02: Customer Registration

| Attribute | Detail |
|-----------|--------|
| **Description** | Register a new customer account with email verification via OTP. |
| **Actors** | Customer |
| **Input** | Email, OTP code, full name, password, phone number |
| **System Behavior** | Check email uniqueness. Send OTP to email. Verify OTP (1-minute expiry). Hash password with BCrypt. Create customer record with status ACTIVE. |
| **Output** | New customer account created. Redirect to login. |

---

## F-03: Password Reset

| Attribute | Detail |
|-----------|--------|
| **Description** | Allow customers to reset forgotten passwords via email OTP. |
| **Actors** | Customer |
| **Input** | Email, OTP code, new password, confirm password |
| **System Behavior** | Verify email exists and account is active. Send OTP, validate OTP within 1-minute window. Validate password complexity. Hash and update password. |
| **Output** | Password updated. Redirect to login. |

---

## F-04: Logout

| Attribute | Detail |
|-----------|--------|
| **Description** | Terminate user session by revoking refresh token. |
| **Actors** | Customer, Staff, Admin |
| **Input** | Current refresh token |
| **System Behavior** | Find refresh token in DB, delete it. Identify user role to determine redirect URL (customer → homepage, staff/admin → staff login). |
| **Output** | Session terminated. Redirect based on role. |

---

## F-05: Profile Management

| Attribute | Detail |
|-----------|--------|
| **Description** | View, update profile and change password. |
| **Actors** | Customer |
| **Input** | View: customer ID. Update: full name, phone. Change password: current password, new password, confirm password. |
| **System Behavior** | View: fetch profile from DB. Update: validate inputs, ensure email is NOT changeable, check phone uniqueness. Change password: verify current password, validate complexity (8+ chars, uppercase, lowercase, number), hash and persist. |
| **Output** | Updated profile data or success/error message. |

---

## F-06: Room Browsing (Homepage & Timetable)

| Attribute | Detail |
|-----------|--------|
| **Description** | Display paginated room listings with cover images and amenities on the homepage. |
| **Actors** | Customer |
| **Input** | Page number (pagination) |
| **System Behavior** | Query rooms with JOIN on RoomType, Amenity, Image (cover only). Return paginated DTO list. Also load all amenities for filter sidebar. |
| **Output** | Paginated room cards with type name, base price, max guests, cover image, amenities. |

---

## F-07: Room Filtering

| Attribute | Detail |
|-----------|--------|
| **Description** | Filter rooms by price range and amenities. |
| **Actors** | Customer |
| **Input** | Min price, max price, amenity IDs |
| **System Behavior** | Dynamic SQL query with optional WHERE clauses for price range and amenity filtering. Group results to aggregate amenity names. |
| **Output** | Filtered room list matching criteria. |

---

## F-08: Room Detail View

| Attribute | Detail |
|-----------|--------|
| **Description** | Display complete room information including all images, amenities, type details. |
| **Actors** | Customer |
| **Input** | Room ID |
| **System Behavior** | Query room with JOINs on RoomType, RoomAmenity, Amenity, Image. Return full detail DTO. |
| **Output** | Room detail page with all images, amenity list, description, pricing, max guests. |

---

## F-09: Room Booking

| Attribute | Detail |
|-----------|--------|
| **Description** | Create a new booking for a selected room. |
| **Actors** | Customer |
| **Input** | Customer ID, room ID, check-in date, check-out date, ID card front image URL, ID card back image URL, note (optional) |
| **System Behavior** | Validate room availability. Calculate total amount. Generate booking code. Set initial status (PENDING). Persist booking record. |
| **Output** | Booking created with booking code. Redirect to booking confirmation/payment. |

---

## F-10: MoMo Payment

| Attribute | Detail |
|-----------|--------|
| **Description** | Process booking payment via MoMo payment gateway. |
| **Actors** | Customer |
| **Input** | Booking ID, payment method ("MOMO") |
| **System Behavior** | Validate booking status is pending payment and within 15-minute window. Create PENDING payment record. Call MoMo Sandbox API to generate payment URL. Customer pays via MoMo. MoMo sends callback. Verify HMAC-SHA256 signature. Update payment to SUCCESS and booking to PAID. |
| **Output** | Payment URL for redirect → MoMo payment screen → callback updates status. |

---

## F-11: Booking History

| Attribute | Detail |
|-----------|--------|
| **Description** | View all bookings belonging to the authenticated customer. |
| **Actors** | Customer |
| **Input** | Customer ID (from session) |
| **System Behavior** | Query all bookings for the customer. Return read-only list with status, dates, amounts. |
| **Output** | Booking history list. |

---

## F-12: Check-in

| Attribute | Detail |
|-----------|--------|
| **Description** | Customer submits a check-in video; admin reviews and approves. |
| **Actors** | Customer (initiates), Admin (approves) |
| **Input** | Booking ID, video file (MultipartFile) |
| **System Behavior** | Upload video to Cloudinary. Create CheckInSession with status PENDING. Notify admin via WebSocket. Admin reviews and approves. Update booking status to CHECKED_IN. Notify customer via WebSocket. |
| **Output** | Booking status transitions to CHECKED_IN. Both parties notified in real-time. |

---

## F-13: Check-out

| Attribute | Detail |
|-----------|--------|
| **Description** | Customer confirms checkout from a checked-in room. |
| **Actors** | Customer |
| **Input** | Booking ID |
| **System Behavior** | Validate booking is in CHECKED_IN state and belongs to the customer. Update booking status to CHECKED_OUT. Set room status back to AVAILABLE. |
| **Output** | Booking completed. Room released. |

---

## F-14: Staff/Admin Login

| Attribute | Detail |
|-----------|--------|
| **Description** | Authenticate staff and admin users for the management dashboard. |
| **Actors** | Staff, Admin |
| **Input** | Email, password |
| **System Behavior** | Find staff account by email. Verify BCrypt password. Check account is ACTIVE and not deleted. Generate session token (refresh token). |
| **Output** | Authenticated management session. Redirect to dashboard. |

---

## F-15: Room Management (CRUD)

| Attribute | Detail |
|-----------|--------|
| **Description** | Full lifecycle management of rooms by staff/admin. |
| **Actors** | Staff, Admin |
| **Input** | Room number, room type ID, status, images, amenities |
| **System Behavior** | **View**: List all rooms with type info. **Search**: Filter by status, room type. **Detail**: Full room info with images and amenities. **Add**: Validate unique room number, set initial status, persist. **Update**: Validate unique room number (excluding self), update attributes. **Delete**: Soft-delete (set `is_deleted = 1`) only if no active bookings exist. |
| **Output** | Room list/detail views. Success/error messages for mutations. |

---

## F-16: Booking Management (Staff)

| Attribute | Detail |
|-----------|--------|
| **Description** | Staff views and manages customer bookings through status transitions. |
| **Actors** | Staff, Admin |
| **Input** | Booking ID, target status |
| **System Behavior** | **View List**: All bookings with pagination. **View Detail**: Full booking info including ID card images. **Update Status**: Approve booking (→ WAITING_PAYMENT), confirm payment (→ PAID), approve check-in (→ CHECKED_IN). Validates payment record exists before confirming. |
| **Output** | Updated booking status. |

---

## F-17: Feedback Management

| Attribute | Detail |
|-----------|--------|
| **Description** | Staff views, moderates, and responds to customer feedback. |
| **Actors** | Staff, Admin |
| **Input** | Feedback ID, visibility flag, reply content |
| **System Behavior** | **View List**: All feedback ordered by creation date. **View Detail**: Rating, content, reply. **Hide/Show**: Toggle `is_hidden` flag. **Reply**: Set `content_reply` on feedback record. |
| **Output** | Feedback list/detail. Updated visibility or reply. |

---

## F-18: Revenue Reports

| Attribute | Detail |
|-----------|--------|
| **Description** | Aggregated revenue analytics from completed bookings. |
| **Actors** | Staff, Admin |
| **Input** | Year |
| **System Behavior** | **Weekly**: Group by DATEPART(WEEK) — count bookings, sum revenue. **Monthly**: Group by MONTH — count bookings, sum revenue. **Quarterly**: Group by DATEPART(QUARTER) — count bookings, sum revenue. Only COMPLETED bookings from non-deleted rooms. |
| **Output** | Report DTOs with period, total bookings, total revenue. |

---

## F-19: Staff Account Management

| Attribute | Detail |
|-----------|--------|
| **Description** | Admin creates and manages staff/admin accounts. |
| **Actors** | Admin |
| **Input** | Email, phone, full name, password, role (ADMIN/STAFF) |
| **System Behavior** | **Create**: Validate email uniqueness, validate input format, hash password, persist with status ACTIVE. **Update Role**: Retrieve account, validate email uniqueness (excluding self), merge form data (empty fields retain old values), persist. Audit log entry created. |
| **Output** | New/updated staff account. Audit log recorded. |

---

## F-20: User Management

| Attribute | Detail |
|-----------|--------|
| **Description** | Admin views and manages all system users (customers + staff). |
| **Actors** | Admin |
| **Input** | Filters (role, status), user ID, target status |
| **System Behavior** | **View List**: Query customers and staff with optional role/status filters. **View Detail**: Full account info (read-only). **Activate/Deactivate**: Toggle status between ACTIVE and INACTIVE for any customer or staff account. |
| **Output** | User list/detail. Updated account status. |
