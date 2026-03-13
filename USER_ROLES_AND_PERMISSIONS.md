# User Roles and Permissions

## Role Summary

| Role | Description | Access Scope |
|------|-------------|-------------|
| **Customer** | End-user who searches, books, pays for, and stays in homestay rooms. Registered via email/password or Google OAuth2. | Customer-facing UI only |
| **Staff** | Operations personnel who manage day-to-day bookings, rooms, feedback, and reports. | Staff/Admin management dashboard |
| **Housekeeping** | Cleaning and maintenance personnel responsible for room turnover and upkeep. | Housekeeping dashboard only |
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
| View Housekeeping Dashboard | Monitor room cleaning status and task progress |
| Assign Housekeeping Tasks | Assign cleaning/maintenance tasks to housekeeping staff |
| Force Checkout | Force checkout for overdue guests |

### Housekeeping

**Registration**: Created by Admin only.

| Permission | Description |
|-----------|-------------|
| Login / Logout | Authenticate via staff login (email/password) |
| View Housekeeping Dashboard | See rooms needing cleaning, in progress, maintenance required |
| View Task List | See all assigned and unassigned housekeeping tasks |
| View Task Detail | See room info, checklist items, notes, priority |
| Claim Task | Self-assign an unassigned task |
| Start Cleaning | Mark a DIRTY room as CLEANING, begin task |
| Update Checklist | Mark individual cleaning checklist items as complete |
| Complete Task | Finish cleaning task, mark room as AVAILABLE |
| Report Maintenance | Flag room for maintenance issues during cleaning |
| Create Maintenance Task | Create new maintenance task with notes and priority |
| Add Task Notes | Record observations during inspection or cleaning |
| View Room Status History | View `RoomStatusLog` for a specific room |

**Housekeeping staff CANNOT**:

| Restricted Action | Reason |
|-------------------|--------|
| Manage bookings | Bookings handled by Staff/Admin |
| Access customer data | Privacy restriction |
| Process payments | Financial operations restricted |
| Create/delete rooms | Room management handled by Staff/Admin |
| Access revenue reports | Business intelligence restricted |
| Manage user accounts | Admin-only function |
| Approve check-ins | Admin-only function |

### Admin

**Inherits all Staff permissions**, plus:

| Permission | Description |
|-----------|-------------|
| Create Staff Account | Register new staff/admin/housekeeping accounts |
| Update Staff Role | Change account role between ADMIN, STAFF, and HOUSEKEEPING |
| View User List | View all customers and staff with filters (role, status) |
| View User Detail | See complete user/staff account information |
| Activate/Deactivate Users | Toggle ACTIVE/INACTIVE status for any customer or staff account |
| Approve Check-in | Review check-in video and approve (via WebSocket notification) |
| Set Room Out of Service | Take a room offline from inventory |
| Restore Room | Bring a room back online |
| Manage Housekeeping Staff | Create, update, deactivate housekeeping accounts |
| View All Task History | Access complete housekeeping task history |
| Escalate Task Priority | Change task priority to URGENT |

---

## Role-Based Access Control (RBAC) Matrix

| Feature | Customer | Staff | Housekeeping | Admin |
|---------|----------|-------|--------------|-------|
| Customer Registration | ✅ | — | — | — |
| Customer Login (email/Google) | ✅ | — | — | — |
| Staff/Admin/Housekeeping Login | — | ✅ | ✅ | ✅ |
| View/Update Own Profile | ✅ | — | — | — |
| Change Own Password | ✅ | — | — | — |
| Browse/Filter/Detail Rooms | ✅ | — | — | — |
| Create Booking | ✅ | — | — | — |
| View Own Booking History | ✅ | — | — | — |
| Make Payment (MoMo) | ✅ | — | — | — |
| Submit Check-in Video | ✅ | — | — | — |
| Confirm Check-out | ✅ | — | — | — |
| Submit Feedback | ✅ | — | — | — |
| Manage Rooms (CRUD) | — | ✅ | — | ✅ |
| Manage Bookings (view/update status) | — | ✅ | — | ✅ |
| Manage Feedback | — | ✅ | — | ✅ |
| View Revenue Reports | — | ✅ | — | ✅ |
| View Housekeeping Dashboard | — | ✅ | ✅ | ✅ |
| Claim/Start/Complete Tasks | — | — | ✅ | — |
| Report Maintenance | — | — | ✅ | — |
| Assign Tasks to Housekeeping | — | ✅ | — | ✅ |
| Force Checkout | — | ✅ | — | ✅ |
| Manage Staff Accounts | — | — | — | ✅ |
| Manage All Users | — | — | — | ✅ |
| Approve Check-in (WebSocket) | — | — | — | ✅ |
| Set Room Out of Service | — | — | — | ✅ |

---

## Authentication Mechanisms

| Mechanism | Applicable To | Details |
|-----------|--------------|---------|
| Email + Password + reCAPTCHA | Customer | BCrypt hashing, Google reCAPTCHA v2/v3 |
| Google OAuth2 | Customer | Google ID Token verification, auto-registration if new |
| Email + Password | Staff, Admin, Housekeeping | BCrypt hashing, no reCAPTCHA |
| JWT Access Token | All | Short-lived, used for API authorization |
| Refresh Token | All | Long-lived, stored in DB, revocable. Constraint: exactly one owner (customer XOR staff). |
| OTP (Email) | Customer | Used for registration verification and password reset. 1-minute expiration. |

---

## Housekeeping Workflow Permissions

### Task Assignment Rules

| Action | Who Can Perform | Conditions |
|--------|-----------------|------------|
| Auto-create cleaning task | System | After checkout completes |
| Assign task to housekeeping | Staff, Admin | Task must be in PENDING status |
| Self-assign (claim) task | Housekeeping | Task must be unassigned and PENDING |
| Reassign task | Staff, Admin | Any open task |
| Cancel task | Staff, Admin | Task not yet COMPLETED |
| Escalate priority | Staff, Admin | Any open task |

### Room Status Change Permissions

| Status Change | Who Can Perform |
|---------------|-----------------|
| AVAILABLE → BOOKED | System (on payment success) |
| BOOKED → OCCUPIED | Admin (on check-in approval) |
| OCCUPIED → DIRTY | System (on checkout) |
| OCCUPIED → CHECKOUT_PENDING | System (scheduled job) |
| CHECKOUT_PENDING → DIRTY | Staff (force checkout) |
| DIRTY → CLEANING | Housekeeping (start task) |
| CLEANING → AVAILABLE | Housekeeping (complete task) |
| CLEANING → MAINTENANCE | Housekeeping (report issue) |
| MAINTENANCE → AVAILABLE | Staff, Housekeeping (resolve issue) |
| Any → OUT_OF_SERVICE | Admin only |
| OUT_OF_SERVICE → AVAILABLE | Admin only |

---

## Staff Account Role Values

```sql
CHECK (role IN ('ADMIN', 'STAFF', 'HOUSEKEEPING'))
```

| Role | Dashboard Access | API Endpoints |
|------|------------------|---------------|
| `ADMIN` | Full admin dashboard | `/api/admin/*`, `/api/staff/*`, `/api/housekeeping/*` |
| `STAFF` | Staff dashboard | `/api/staff/*`, `/api/housekeeping/view/*` |
| `HOUSEKEEPING` | Housekeeping dashboard only | `/api/housekeeping/*` |
