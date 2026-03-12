# System Workflows

## WF-01: Customer Registration

**Actors**: Customer  
**Trigger**: Customer clicks "Register" on the homepage.

1. System displays the email entry form.
2. Customer enters email address.
3. System checks if email already exists in DB (`findByEmail`).
4. If email exists → display error "Email already registered."
5. System generates a random OTP code and sends it to the email via Email Service.
6. System displays the OTP verification screen.
7. Customer enters the received OTP.
8. System validates OTP matches and is within 1-minute expiry window.
9. If OTP invalid/expired → display error, offer resend.
10. System displays the registration form (full name, password, phone).
11. Customer fills in details and submits.
12. System hashes the password with BCrypt.
13. System creates a new Customer record with status `ACTIVE`, `is_deleted = 0`.
14. System redirects to login page with success message.

---

## WF-02: Customer Login (Email/Password)

**Actors**: Customer  
**Trigger**: Customer navigates to the login page.

1. Customer enters email, password, and completes reCAPTCHA.
2. System sends reCAPTCHA token to Google reCAPTCHA API for verification.
3. If reCAPTCHA fails → display error.
4. System queries Customer by email (`is_deleted = 0`).
5. If customer not found → display error "Invalid credentials."
6. System compares password hash with BCrypt.
7. If password mismatch → display error.
8. System checks customer status is `ACTIVE`.
9. If inactive → display error "Account is deactivated."
10. System generates JWT Access Token.
11. System generates Refresh Token, stores it in `RefreshToken` table with `customer_id`.
12. System returns `AuthResponse` and redirects to homepage.

---

## WF-03: Google OAuth2 Login

**Actors**: Customer  
**Trigger**: Customer clicks "Login with Google."

1. Customer authenticates with Google and receives an ID Token.
2. System sends ID Token to Google API for verification.
3. Google returns user info (email, name, avatar).
4. System checks if email exists in Customer table.
5. If exists → generate session (access token + refresh token), redirect to homepage.
6. If not exists → create new Customer record (email, name, avatar, status `ACTIVE`) → generate session → redirect.

---

## WF-04: Password Reset

**Actors**: Customer  
**Trigger**: Customer clicks "Forgot Password" on login page.

1. Customer enters email address.
2. System verifies email exists and account is active/not deleted.
3. If not found → display error.
4. System generates OTP, sends to email, stores in session/cache.
5. Customer enters OTP code.
6. System validates OTP matches and is within 1-minute window.
7. If invalid → display error, offer resend.
8. System displays new password form.
9. Customer enters new password and confirmation.
10. System validates passwords match and meet complexity rules (8+ chars, uppercase, lowercase, number).
11. System hashes password with BCrypt.
12. System updates `password_hash` and `updated_at` in Customer table.
13. Redirect to login page.

---

## WF-05: Room Search and Filtering

**Actors**: Customer  
**Trigger**: Customer visits homepage or applies filters.

1. System loads paginated room list with cover images and amenities.
2. System loads all amenities for filter sidebar.
3. Customer optionally sets price range (min/max) and selects amenity filters.
4. System sends filter criteria to backend.
5. Backend builds dynamic query with optional WHERE clauses.
6. System returns filtered, paginated room list.
7. Customer clicks on a room card.
8. System queries full room detail (all images, all amenities, type info).
9. System displays room detail page.

---

## WF-06: Room Booking

**Actors**: Customer  
**Trigger**: Customer clicks "Book" on room detail page.

1. Customer selects slot on timetable at home page or room detail page.
2. Customer uploads ID card front and back images.
3. Customer optionally adds a note.
4. System validates room availability for the selected dates.
5. System calculates `total_amount` based on room type pricing and duration.
6. System generates unique `booking_code`.
7. System creates Booking record with status `PENDING`.
8. System creates corresponding Scheduler records linking booking to timetable slots.
9. System redirects to booking confirmation page.

---

## WF-07: MoMo Payment

**Actors**: Customer  
**Trigger**: Customer initiates payment for a pending booking.

1. Customer selects MoMo as payment method on the booking confirmation page.
2. System validates booking status is appropriate for payment.
3. System validates the 15-minute payment window from booking creation.
4. System creates a Payment record with status `PENDING` and method `MOMO`.
5. System calls MoMo Sandbox API (`createPaymentRequest`) with order ID, amount, and description.
6. MoMo returns a payment URL/QR code.
7. System redirects customer to MoMo payment page.
8. Customer completes payment in MoMo.
9. MoMo sends callback to system's callback endpoint with payment result and signature.
10. System recalculates HMAC-SHA256 signature and compares with MoMo's signature.
11. If signature valid and payment successful → update Payment status to `SUCCESS`, Booking status to `PAID`.
12. If signature invalid or payment failed → log the error, Payment status remains `PENDING`.

---

## WF-08: Check-in

**Actors**: Customer (initiates), Admin (approves)  
**Trigger**: Customer initiates check-in for a paid booking.

1. Customer selects a booking and uploads a check-in video.
2. System uploads video to Cloudinary, receives video URL.
3. System creates `CheckInSession` record with status `PENDING` and video URL.
4. System sends real-time notification to Admin via WebSocket (`notifyAdmin`).
5. Admin receives notification and reviews the check-in video.
6. Admin clicks "Approve" on the check-in session.
7. System updates Booking status to `CHECKED_IN` and sets `check_in_time`.
8. System sends real-time notification to Customer via WebSocket (`notifyUser`).
9. Customer sees confirmation that check-in was approved.

---

## WF-09: Check-out

**Actors**: Customer  
**Trigger**: Customer clicks "Check-out" on their active booking.

1. System retrieves booking and validates status is `CHECKED_IN`.
2. System validates booking belongs to the authenticated customer.
3. System displays checkout confirmation details.
4. Customer confirms checkout.
5. System updates Booking status to `CHECKED_OUT`.
6. System updates Room status to `AVAILABLE`.
7. System redirects to booking history.

---

## WF-10: Booking Status Management (Staff)

**Actors**: Staff, Admin  
**Trigger**: Staff selects a booking from the booking list.

1. Staff views booking list (all bookings with pagination).
2. Staff clicks on a booking to view details (including ID card images).
3. System displays current status and available status transitions.
4. **Approve**: Staff approves a PENDING booking → status becomes `WAITING_PAYMENT`.
5. **Confirm Payment**: Staff verifies payment record exists → status becomes `PAID`.
6. **Approve Check-in**: Staff approves check-in → status becomes `CHECKED_IN`.
7. System persists the status change with `updated_at` timestamp.

---

## WF-11: Room Management (Staff/Admin)

**Actors**: Staff, Admin  
**Trigger**: Staff navigates to Room Management dashboard.

1. System displays all rooms with status, type, and pricing.
2. Staff can search/filter by status or room type.
3. **Add Room**: Staff enters room number and selects room type → system checks for duplicate room number → persists new room.
4. **Update Room**: Staff modifies room attributes → system validates unique room number (excluding self) → persists changes.
5. **Delete Room**: Staff requests deletion → system checks for active bookings → if none, sets `is_deleted = 1` (soft delete).

---

## WF-12: Feedback Management

**Actors**: Staff, Admin  
**Trigger**: Staff navigates to Feedback section.

1. System displays feedback list ordered by `created_at DESC`.
2. Staff selects a feedback item to view details (rating, content, reply).
3. **Hide/Show**: Staff toggles `is_hidden` flag to control public visibility.
4. **Reply**: Staff enters reply content → system updates `content_reply` field.

---

## WF-13: Staff Account Creation (Admin)

**Actors**: Admin  
**Trigger**: Admin clicks "Create Staff Account."

1. Admin fills in email, phone, full name, password, and selects role (ADMIN/STAFF).
2. System validates input format and completeness.
3. System checks email uniqueness (`existsByEmail`).
4. If duplicate → display error.
5. System hashes password with BCrypt.
6. System creates StaffAccount with status `ACTIVE`, `is_deleted = 0`.
7. Admin sees success confirmation.

---

## WF-14: User Account Management (Admin)

**Actors**: Admin  
**Trigger**: Admin navigates to User Management.

1. System displays user list (customers + staff) with optional filters (role, status).
2. Admin selects a user to view full details (read-only).
3. **Activate/Deactivate**: Admin toggles user status between `ACTIVE` and `INACTIVE`.
4. System updates the status field in the corresponding table (Customer or StaffAccount).

