# System Context — BookNow Homestay Booking System

## System Overview

| Attribute | Detail |
|-----------|--------|
| **System Name** | BookNow — Booking Homestay System |
| **Project Code** | SWP392 — Group 02 (SE1910) |
| **Short Description** | A web-based homestay room booking platform that enables customers to search, book, pay for, and check in/out of homestay rooms, while providing staff and admins with tools to manage rooms, bookings, feedback, revenue reports, and user accounts. |
| **Problem Solved** | Eliminates manual, error-prone homestay reservation processes by providing a digital platform for the full booking lifecycle — from room discovery through payment and check-out. |
| **Target Users** | Customers (guests), Staff (operations), Admin (system management) |

---

## System Architecture

### Architecture Style

**Layered (Monolithic)** — Classic Spring Boot 3-tier architecture.

```
┌─────────────────────────────────────────────┐
│                  Frontend                    │
│         (Server-rendered views / UI)         │
├─────────────────────────────────────────────┤
│              Controller Layer                │
│   controllers.customer │ controllers.staffadmin│
├─────────────────────────────────────────────┤
│               Service Layer                  │
│    services.customer │ services.staffadmin    │
├─────────────────────────────────────────────┤
│             Repository Layer                 │
│           (JPA/Hibernate ORM)                │
├─────────────────────────────────────────────┤
│               Database                       │
│            (SQL Server)                      │
├─────────────────────────────────────────────┤
│           External Services                  │
│  MoMo · Google Auth · Cloudinary · Email     │
└─────────────────────────────────────────────┘
```

### High-Level Components

| Component | Responsibility |
|-----------|---------------|
| **Controllers** | Handle HTTP requests/responses, input validation, delegate to services. Split into `controllers.customer` (customer-facing) and `controllers.staffadmin` (management). |
| **Services** | Core business logic, use-case orchestration, data transformation. Split into `services.customer` and `services.staffadmin`. |
| **Repositories** | Database access via JPA/Hibernate. CRUD operations and custom queries against SQL Server. |
| **Security** | Spring Security configuration — authentication filters, JWT/refresh token handling, role-based access control. |
| **Model Layer** | `model.entities` (ORM-mapped domain entities), `model.dto` (data transfer objects), `model.map` (Spring Security adapters/wrappers). |
| **Utils** | Reusable validators, helpers, and utility classes. |

---

## Technology Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Server-side rendered views (Thymeleaf/JSP implied by controller return patterns) |
| **Backend** | Java, Spring Boot, Spring MVC, Spring Security |
| **ORM** | JPA / Hibernate |
| **Database** | Microsoft SQL Server |
| **Authentication** | JWT (Access Token + Refresh Token), Google OAuth2, reCAPTCHA |
| **Payment** | MoMo Sandbox API (HMAC-SHA256 signature verification) |
| **File Storage** | Cloudinary (video/image uploads) |
| **Real-time** | WebSocket (check-in notifications) |
| **Email** | Internal Email Service (OTP delivery) |
| **Password Hashing** | BCrypt |

---

## System Modules

### 1. Authentication & Authorization Module
- **Purpose**: Manage user identity, login, registration, logout, and session tokens.
- **Responsibilities**: Customer login (email/password + reCAPTCHA), Google OAuth2 login, Staff/Admin login, registration with OTP email verification, password reset with OTP, logout with token revocation, JWT access/refresh token lifecycle.
- **Interactions**: Security module, Customer & StaffAccount repositories, Google Auth service, Email service.

### 2. Profile Management Module
- **Purpose**: Allow users to view and update personal information.
- **Responsibilities**: View profile, update profile (name, phone — email immutable), change password with complexity validation.
- **Interactions**: Customer repository, Security module.

### 3. Room Discovery Module
- **Purpose**: Enable customers to find and explore available rooms.
- **Responsibilities**: Homepage with room listings and timetable, room filtering (price range, amenities), room detail view (images, amenities, type info).
- **Interactions**: Room, RoomType, Amenity, Image repositories.

### 4. Booking Module
- **Purpose**: Manage the full booking lifecycle.
- **Responsibilities**: Create bookings (with ID card upload), view booking history, staff-side booking list/detail/status management, booking status transitions (PENDING → WAITING_PAYMENT → PAID → CHECKED_IN → CHECKED_OUT).
- **Interactions**: Room module, Payment module, Customer repository, Scheduler/Timetable.

### 5. Payment Module
- **Purpose**: Process payments for bookings.
- **Responsibilities**: Initiate MoMo payment, handle MoMo callback, verify HMAC-SHA256 signature, update payment and booking status.
- **Interactions**: MoMo Gateway, Booking module.

### 6. Check-in / Check-out Module
- **Purpose**: Manage physical room occupancy transitions.
- **Responsibilities**: Customer submits check-in video → uploaded to Cloudinary → admin notified via WebSocket → admin approves → status becomes CHECKED_IN. Checkout validates checked-in state, updates booking to CHECKED_OUT, releases room to AVAILABLE.
- **Interactions**: Cloudinary, WebSocket, Booking repository, Room repository.

### 7. Room Management Module (Staff/Admin)
- **Purpose**: CRUD operations for rooms.
- **Responsibilities**: View room list, search/filter rooms, view room detail, add room (with duplicate check), update room, soft-delete room (blocked if active bookings exist).
- **Interactions**: Room, RoomType, Image, Amenity repositories.

### 8. Feedback Module
- **Purpose**: Manage customer feedback/reviews.
- **Responsibilities**: View feedback list/detail, hide/show feedback visibility, reply to feedback.
- **Interactions**: Feedback repository, Booking module.

### 9. Revenue Reporting Module
- **Purpose**: Provide business intelligence on booking revenue.
- **Responsibilities**: Weekly, monthly, and quarterly revenue reports aggregated from completed bookings.
- **Interactions**: Booking repository (read-only aggregation queries).

### 10. User & Staff Account Management Module (Admin)
- **Purpose**: Manage system users and staff accounts.
- **Responsibilities**: View user/staff lists with filters, view user detail, activate/deactivate accounts, create staff accounts, update staff roles (ADMIN/STAFF).
- **Interactions**: Customer repository, StaffAccount repository, AuditLog.
