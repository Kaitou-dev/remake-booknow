# AI Developer Context

> This file serves as a **knowledge base for AI coding assistants** working on the BookNow Homestay Booking System. It provides essential domain context, assumptions, and conventions that must be understood before generating or modifying code.

---

## Domain Concepts

### Core Domain
This is a **homestay room booking platform** — not a hotel chain system. Key distinctions:
- Rooms belong to a single homestay property (not multiple properties/branches).
- Room types define pricing; rooms are individual instances of a type.
- Bookings require ID card verification (front + back image upload).
- Check-in involves video submission reviewed by admin in real-time.

### Key Domain Terms

| Term | Meaning |
|------|---------|
| **Customer** | External guest user who books rooms |
| **Staff** | Internal operator managing bookings, rooms, feedback |
| **Admin** | Staff with elevated privileges (user management, check-in approval) |
| **Booking** | A reservation tying a customer to a room for a date range |
| **Room** | An individual bookable unit (e.g., room 101) |
| **RoomType** | Category with pricing (e.g., "Deluxe", "Standard") — includes `base_price` and `over_price` |
| **Amenity** | Feature available in rooms (e.g., WiFi, AC) — many-to-many with Room |
| **Timetable** | Named time slots with start/end times |
| **Scheduler** | Links a booking to specific timetable slots on specific dates |
| **CheckInSession** | Tracks the video upload + admin approval for check-in |
| **Feedback** | Customer review (rating 1-5 + text content) linked to a booking |

---

## Architecture Conventions

### Package Structure (Java / Spring Boot)
```
com.booknow
├── controllers
│   ├── customer          # Customer-facing endpoints
│   └── staffadmin        # Staff/Admin management endpoints
├── services
│   ├── customer          # Customer business logic
│   └── staffadmin        # Staff/Admin business logic
├── repositories          # JPA repositories (data access)
├── model
│   ├── entities          # JPA entities (mapped to SQL Server tables)
│   ├── dto               # Request/Response DTOs
│   └── map               # Spring Security UserDetails adapters
├── security              # Spring Security config, JWT filters, role handling
└── utils                 # Validators, helpers
```

### Layered Architecture Pattern
```
HTTP Request → Controller → Service → Repository → SQL Server
HTTP Response ← Controller ← Service ← Repository ← SQL Server
```
- **Controllers**: Input validation, HTTP handling, view name returns. Never contain business logic.
- **Services**: All business rules, orchestration, password hashing, status validation.
- **Repositories**: Only database CRUD. No business logic.

### Naming Conventions
- Entity classes match table names: `Customer`, `StaffAccount`, `Room`, `Booking`, etc.
- Repository classes: `CustomerRepository`, `BookingRepository`, etc.
- Service classes: named by use case (e.g., `AuthService`, `CheckoutService`, `PaymentService`)
- Controller classes: named by feature (e.g., `AuthController`, `ManageRoomController`)
- DTOs: `RoomDTO`, `WeeklyRevenueReportDTO`, `MonthlyRevenueReportDTO`, etc.

---

## Key System Assumptions

1. **Single property**: The system manages ONE homestay, not a multi-property chain.
2. **Soft delete everywhere**: Records are never physically deleted. All queries must include `WHERE is_deleted = 0`.
3. **Email is immutable**: Once a customer registers, their email cannot be changed (enforced in update profile logic).
4. **Session-based auth with JWT**: Access tokens are short-lived JWT; refresh tokens are long-lived and stored in DB. Logout = delete refresh token from DB.
5. **Customer and Staff are separate tables**: They are NOT in a unified `User` table. They have separate auth flows, separate repositories, separate login endpoints.
6. **MoMo is the only payment method**: Currently only MoMo sandbox is integrated. Payment method is stored as `MOMO` in the Payment table.
7. **Check-in requires video**: No alternative check-in methods. Video is uploaded to Cloudinary.
8. **Admin approves check-ins via WebSocket**: Real-time push notifications, not polling or email.
9. **Booking requires ID card images**: Both front and back URLs are NOT NULL.
10. **Revenue reports only count COMPLETED bookings**: All report queries filter by `booking_status = 'COMPLETED'`.

---

## Expected Behaviors

### Authentication
- Customer login: email + password + reCAPTCHA → BCrypt verify → JWT + refresh token
- Google login: ID token → verify with Google → find or create customer → JWT + refresh token
- Staff/Admin login: email + password → BCrypt verify → session token (no reCAPTCHA)
- Logout: find refresh token → delete from DB → redirect based on role

### Booking Lifecycle
```
Customer creates booking (PENDING)
  → Staff approves (WAITING_PAYMENT)
    → Customer pays via MoMo (PAID)
      → Customer uploads check-in video → Admin approves (CHECKED_IN)
        → Customer confirms checkout (CHECKED_OUT) → Room → AVAILABLE
```

### Payment Safety
- 15-minute window from booking creation
- HMAC-SHA256 signature verification on every callback
- PENDING payment record created BEFORE redirect to MoMo
- Payment SUCCESS and Booking PAID updated together on valid callback

### Room Management Safety
- Room cannot be deleted if it has active bookings
- Room number must be unique (checked both on create and update, excluding self on update)
- All deletions are soft deletes (`is_deleted = 1`)

---

## Development Notes

### Database
- **Engine**: Microsoft SQL Server
- **Timestamps**: Use `DATETIME2` for nullable datetime, `DATE` for date-only fields
- **Defaults**: `GETDATE()` for `created_at`, `0` for `is_deleted`
- **Identity**: `BIGINT IDENTITY` for most PKs, `INT` for Customer PK

### Security Implementation
- Spring Security with custom filters for JWT validation
- `model.map` package contains `UserDetails` wrappers that bridge domain entities to Spring Security's principal model
- Role values: `CUSTOMER` (implied from Customer table), `STAFF`, `ADMIN` (from StaffAccount.role)
- RefreshToken has CHECK constraint ensuring exactly one owner type

### ORM Considerations
- JPA/Hibernate entity mapping — use `@Entity`, `@Table`, `@Column` annotations
- Many-to-many: Room ↔ Amenity via `RoomAmenity` junction table (explicit entity, not `@ManyToMany`)
- Cascade behavior should be conservative — avoid cascade deletes due to soft-delete pattern

### Query Patterns
- All list queries filter `is_deleted = 0`
- Room queries JOIN multiple tables in one query (Room + RoomType + Image + Amenity) to avoid N+1
- Revenue queries use `DATEPART` for week/quarter grouping
- Filter queries use optional `@param IS NULL OR column = @param` pattern for dynamic filtering

### External Services Configuration
- Google OAuth2: needs client ID/secret
- Google reCAPTCHA: needs site key + secret key
- MoMo: needs partner code, access key, secret key, sandbox endpoint
- Cloudinary: needs cloud name, API key, API secret
- Email/SMTP: needs host, port, username, password

---

## Common Pitfalls to Avoid

1. **Forgetting `is_deleted = 0`** in queries — this will return logically deleted records.
2. **Skipping booking status validation** before transitions — always verify current status before updating.
3. **Not verifying MoMo signature** — security-critical; never trust callback data without HMAC verification.
4. **Allowing email changes** on profile update — email is immutable after registration.
5. **Using physical DELETE** — always use soft delete (`UPDATE SET is_deleted = 1`).
6. **Mixing Customer and StaffAccount auth** — they are separate tables with separate login flows.
7. **Not checking phone uniqueness** before customer profile update.
8. **Not checking active bookings** before room deletion.
9. **Generating refresh tokens for both customer_id AND staff_account_id** — exactly one must be NULL.
10. **Skipping reCAPTCHA** on customer login — it's required; staff login does NOT use reCAPTCHA.

---

## Quick Reference: Use Case → Controller Mapping

| Use Case | Controller | Package |
|----------|-----------|---------|
| UC-01 Login | `AuthController` | controllers.customer |
| UC-02 Register | `AuthController` | controllers.customer |
| UC-03 Logout | `LogoutController` | controllers.customer |
| UC-04 Profile | `ViewProfileController`, `UpdateProfileController`, `ChangePasswordController` | controllers.customer |
| UC-05 Room Browse | `HomeController`, `FilterController` | controllers.customer |
| UC-06 Booking | `RoomController` | controllers.customer |
| UC-07 Payment | `PaymentController` | controllers.customer |
| UC-08 Booking History | `BookingHistoryController` | controllers.customer |
| UC-09 Check-in | `CheckInController` | controllers.customer |
| UC-10 Check-out | `CheckoutController` | controllers.customer |
| UC-11 Staff Login | `StaffAccountAuthController` | controllers.staffadmin |
| UC-12 Manage Room | `ManageRoomController` | controllers.staffadmin |
| UC-13 Manage Booking | `ViewBookingListController`, `ViewBookingDetailController`, `UpdateBookingStatusController` | controllers.staffadmin |
| UC-14 Manage Feedback | `ViewFeedbackController`, `FeedbackDetailController`, `FeedbackVisibilityController`, `ReplyFeedbackController` | controllers.staffadmin |
| UC-15 Revenue Reports | `ManageRoomController` (overloaded) | controllers.staffadmin |
| UC-16 Manage Staff | `StaffAccountController` | controllers.staffadmin |
| UC-17 Manage Users | `ViewUserListController`, `ViewUserDetailController`, `ManageUserStatusController` | controllers.staffadmin |
