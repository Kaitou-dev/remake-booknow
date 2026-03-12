# User Roles and Permissions

## Role Summary

| Role | Description | Access Scope |
|------|-------------|-------------|
| **Customer** | End-user who searches, books, pays for, and stays in homestay rooms. Registered via email/password or Google OAuth2. | Customer-facing UI only |
| **Staff** | Operations personnel who manage day-to-day bookings, rooms, feedback, and reports. | Staff/Admin management dashboard |
| **Admin** | System administrator with full control over staff accounts, user accounts, and all staff capabilities. | Full system access |

---

## Detailed Role Definitions

### Customer

**Registration**: Self-registration via email + OTP verification, or Google OAuth2.

| Permission | Description |
|-----------|-------------|
| Login / Logout | Authenticate via email/password + reCAPTCHA, or Google OAuth2 |
| Reset Password | Request OTP, verify, set new password |
| View Profile | View own profile information |
| Update Profile | Edit full name, phone (email is immutable) |
| Change Password | Change own password (requires current password, 8+ chars with complexity) |
| Browse Rooms | View homepage room listings, filter rooms, view room details and timetable |
| Create Booking | Book a room (requires ID card front/back upload) |
| View Booking History | View own past and current bookings |
| Make Payment | Initiate and complete MoMo payment for a booking |
| Check-in | Submit check-in video for admin approval |
| Check-out | Confirm checkout from a checked-in room |
| Submit Feedback | Leave rating (1–5) and content for a completed booking |

### Staff

**Registration**: Created by Admin only.

| Permission | Description |
|-----------|-------------|
| Login / Logout | Authenticate via staff login (email/password) |
| View Room List | View all rooms with status, type, and pricing |
| Search Rooms | Filter rooms by status, room type |
| View Room Detail | See full room details including images and amenities |
| Add Room | Create new rooms (with duplicate room number check) |
| Update Room | Modify room number, type, status |
| Delete Room | Soft-delete rooms (blocked if active bookings exist) |
| View Booking List | See all customer bookings |
| View Booking Detail | See full booking information including ID card images |
| Update Booking Status | Approve bookings, confirm payments, approve check-ins |
| View Feedback List | View all customer feedback |
| View Feedback Detail | View individual feedback content |
| Hide/Show Feedback | Toggle feedback visibility |
| Reply to Feedback | Add staff reply to feedback |
| View Revenue Reports | View weekly, monthly, quarterly revenue reports |

### Admin

**Inherits all Staff permissions**, plus:

| Permission | Description |
|-----------|-------------|
| Create Staff Account | Register new staff/admin accounts |
| Update Staff Role | Change account role between ADMIN and STAFF |
| View User List | View all customers and staff with filters (role, status) |
| View User Detail | See complete user/staff account information |
| Activate/Deactivate Users | Toggle ACTIVE/INACTIVE status for any customer or staff account |
| Approve Check-in | Review check-in video and approve (via WebSocket notification) |

---

## Role-Based Access Control (RBAC) Matrix

| Feature | Customer | Staff | Admin |
|---------|----------|-------|-------|
| Customer Registration | ✅ | — | — |
| Customer Login (email/Google) | ✅ | — | — |
| Staff/Admin Login | — | ✅ | ✅ |
| View/Update Own Profile | ✅ | — | — |
| Change Own Password | ✅ | — | — |
| Browse/Filter/Detail Rooms | ✅ | — | — |
| Create Booking | ✅ | — | — |
| View Own Booking History | ✅ | — | — |
| Make Payment (MoMo) | ✅ | — | — |
| Submit Check-in Video | ✅ | — | — |
| Confirm Check-out | ✅ | — | — |
| Manage Rooms (CRUD) | — | ✅ | ✅ |
| Manage Bookings (view/update status) | — | ✅ | ✅ |
| Manage Feedback | — | ✅ | ✅ |
| View Revenue Reports | — | ✅ | ✅ |
| Manage Staff Accounts | — | — | ✅ |
| Manage All Users | — | — | ✅ |
| Approve Check-in (WebSocket) | — | — | ✅ |

---

## Authentication Mechanisms

| Mechanism | Applicable To | Details |
|-----------|--------------|---------|
| Email + Password + reCAPTCHA | Customer | BCrypt hashing, Google reCAPTCHA v2/v3 |
| Google OAuth2 | Customer | Google ID Token verification, auto-registration if new |
| Email + Password | Staff, Admin | BCrypt hashing, no reCAPTCHA |
| JWT Access Token | All | Short-lived, used for API authorization |
| Refresh Token | All | Long-lived, stored in DB, revocable. Constraint: exactly one owner (customer XOR staff). |
| OTP (Email) | Customer | Used for registration verification and password reset. 1-minute expiration. |
