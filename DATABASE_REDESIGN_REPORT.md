# BookNow — Database Redesign & Housekeeping Module Report

> **Prepared by**: Senior Software Architect / Senior Database Architect  
> **Date**: 2026-03-12  
> **System**: BookNow — Homestay Booking System (SWP392)  
> **Database**: Microsoft SQL Server  
> **Backend**: Java Spring Boot (JPA/Hibernate)

---

## Table of Contents

1. [System Analysis](#1-system-analysis)
2. [Database Anti-Pattern Detection](#2-database-anti-pattern-detection)
3. [Room Status Lifecycle Redesign](#3-room-status-lifecycle-redesign)
4. [Housekeeping System Design](#4-housekeeping-system-design)
5. [Database Refactor Strategy](#5-database-refactor-strategy)
6. [New Tables SQL Design](#6-new-tables-sql-design)
7. [Index Optimization Plan](#7-index-optimization-plan)
8. [Migration Strategy](#8-migration-strategy)
9. [Final Database Schema](#9-final-database-schema)

---

## 1. System Analysis

### 1.1 Current System Architecture

BookNow is a **monolithic Spring Boot 3-tier web application** for managing homestay room bookings. It uses:

| Layer | Technology |
|-------|------------|
| Frontend | Server-rendered views (Thymeleaf) |
| Backend | Java, Spring Boot, Spring MVC, Spring Security |
| ORM | JPA / Hibernate |
| Database | Microsoft SQL Server |
| Auth | JWT + Refresh Token, Google OAuth2, reCAPTCHA |
| Payment | MoMo Sandbox (HMAC-SHA256) |
| Media | Cloudinary (video/image CDN) |
| Real-time | WebSocket (check-in notifications) |

Architecture flow: `Browser → Controller → Service → Repository → SQL Server`

Three user roles exist: **Customer**, **Staff**, **Admin**. There is **no Housekeeping role** in the current system.

### 1.2 Current Room Lifecycle

The current Room entity tracks only **3 statuses**:

```
AVAILABLE ──► BOOKED ──► AVAILABLE (after checkout)
    │                        ▲
    ▼                        │
MAINTENANCE ─────────────────┘
```

**Critical gap**: There is no intermediate state between checkout and the room becoming available again. The system sets the room directly to `AVAILABLE` after checkout, which means:
- No tracking of whether the room was cleaned
- No tracking of whether the room is physically ready for the next guest
- No signal to housekeeping staff

### 1.3 Booking → Check-in → Check-out Flow

```
Customer creates booking
    → Status: PENDING
    → Staff approves
    → Status: WAITING_PAYMENT
    → Customer pays via MoMo
    → Status: PAID
    → Customer uploads check-in video
    → Admin reviews and approves
    → Status: CHECKED_IN
    → Customer confirms checkout
    → Status: CHECKED_OUT
    → Room.status → AVAILABLE (immediately!)
    → Status: COMPLETED
```

**Problem**: Checkout triggers `Room.status = 'AVAILABLE'` directly. In a real hotel, checkout should trigger `Room.status = 'DIRTY'` or `'CLEANING'`, and only after housekeeping confirms should it become `AVAILABLE`.

### 1.4 Current Room Status Management

Room status is managed by a `VARCHAR(50)` column with a CHECK constraint:

```sql
CHECK (status IN ('AVAILABLE', 'BOOKED', 'MAINTENANCE'))
```

Status transitions happen in service-layer code:
- **Booking created** → Room stays as-is (scheduler handles availability)
- **Checkout** → Room set to `AVAILABLE`
- **Staff manual action** → Room set to `MAINTENANCE` or back to `AVAILABLE`

There is **no event log, no audit trail, no status history** for room state changes.

### 1.5 Weak Points in the Current Design

| # | Issue | Impact |
|---|-------|--------|
| W1 | Room goes directly to AVAILABLE after checkout | Dirty rooms may be assigned to new guests |
| W2 | No CLEANING / DIRTY status exists | Housekeeping staff cannot see which rooms need attention |
| W3 | No housekeeping task tracking | No record of who cleaned what, when |
| W4 | No overdue checkout detection mechanism | Staff cannot see guests who overstay |
| W5 | No room inspection after cleaning | No quality control for room readiness |
| W6 | No maintenance request workflow | Maintenance is just a binary status toggle |
| W7 | Pricing is on Room instead of RoomType | Data inconsistency across rooms of the same type |
| W8 | CheckInSession table is documented but missing from SQL | Incomplete schema deployment |
| W9 | Feedback.admin_id is NOT NULL | Cannot create feedback without assigning an admin first |
| W10 | No room status change history | Cannot audit or debug status issues |
| W11 | No actual checkout timestamp | Only planned checkout time exists |
| W12 | Customer who leaves without checkout → room stuck in BOOKED | No automated overdue handling |

### 1.6 Problems Caused by Current Database Structure

1. **Operational blind spot**: After checkout, the room is immediately `AVAILABLE` — housekeeping doesn't know which rooms need cleaning.
2. **Guest walks out without checkout**: Room stays `BOOKED` indefinitely. No one is alerted.
3. **No maintenance workflow**: Setting a room to `MAINTENANCE` has no description, no tracking, no resolution path.
4. **Price drift**: If `base_price` differs across rooms of the same type, the system shows inconsistent pricing.
5. **Dead invoice table**: Invoice has no meaningful data (no amount, no tax, no line items).
6. **Payment timing error**: `paid_at` defaults to `sysdatetime()` at record creation, not when payment actually succeeds.

---

## 2. Database Anti-Pattern Detection

### AP-01: Price Stored in Room Instead of RoomType ⚠️ CRITICAL

**Current state**: `Room` table contains `base_price`, `over_price`, `description`.  
**Documentation says**: `RoomType` should have `base_price`, `over_price`, `description`.  
**Actual RoomType schema**: Only has `room_type_id`, `name`, `image_url`, `max_guests`, `is_deleted`.

**Impact**:
- If you want to change the price for all "Deluxe" rooms, you must update every individual Room row.
- Two rooms of the same type can show different prices (data inconsistency).
- Room filtering by price is correct per-room, but marketing/display "starting from" prices require aggregation.

**Verdict**: The design docs are correct — `base_price`, `over_price`, and `description` belong on `RoomType`. The implementation deviated.

---

### AP-02: Room Status Enum Too Simplistic

**Current**: `CHECK (status IN ('AVAILABLE', 'BOOKED', 'MAINTENANCE'))`

**Missing states**: `OCCUPIED`, `DIRTY`, `CLEANING`, `INSPECTING`, `OUT_OF_SERVICE`

**Impact**: Cannot model the real room lifecycle. Checkout → AVAILABLE skips the cleaning phase entirely.

---

### AP-03: Feedback.admin_id is NOT NULL

```sql
[admin_id] [bigint] NOT NULL
```

Feedback is created by *customers*. At creation time, no admin has been assigned yet. The `admin_id` should be **nullable** — it gets populated only when a staff member replies.

**Impact**: Application code must either:
- Assign a "dummy" admin_id (bad)
- Force an admin assignment at feedback creation time (wrong business logic)

---

### AP-04: No CheckInSession Table in Schema

The `DATA_MODEL_OVERVIEW.md` documents a `CheckInSession` table, but it does not exist in `database_schema.txt`.

**Impact**: Check-in video workflow is either:
- Not yet deployed to the production schema
- Handled via a column on Booking (fragile)
- Managed outside the DB (data loss risk)

---

### AP-05: Payment.paid_at Defaults to sysdatetime() at Creation

```sql
ALTER TABLE [dbo].[Payment] ADD CONSTRAINT [DF_Payment_PaidAt] DEFAULT (sysdatetime()) FOR [paid_at]
```

The payment record is created with status `PENDING` before the customer pays. `paid_at` should only be set when `payment_status` becomes `SUCCESS`. Setting it at creation means the timestamp is wrong.

**Impact**: Reporting shows incorrect payment timestamps. Financial reconciliation is unreliable.

---

### AP-06: No Booking Status CHECK Constraint

```sql
[booking_status] [nvarchar](20) NOT NULL
-- No CHECK constraint!
```

Status transitions are enforced only in application code. Any direct DB operation or bug can insert invalid statuses.

**Impact**: Data integrity relies entirely on application layer — risky for production.

---

### AP-07: Missing updated_at on Booking Table

The column is named `update_at` (typo, missing 'd') and exists, but many other tables lack `updated_at` entirely (Room, RoomType, Payment, etc.).

**Impact**: Cannot track when records were last modified. Audit trail is incomplete.

---

### AP-08: No Room Status History / Audit Log

There is no table recording room status changes. When debugging "why is this room BOOKED?", staff have no history to examine.

**Impact**: Operational blind spot. Cannot trace issues.

---

### AP-09: Invoice Table is Nearly Empty

```sql
CREATE TABLE [dbo].[Invoice](
    [invoice_id] [bigint] IDENTITY(1,1) NOT NULL,
    [booking_id] [bigint] NOT NULL,
    [invoice_number] [nvarchar](50) NULL,
    [issued_at] [datetime2](7) NOT NULL
)
```

An invoice with no `amount`, no `tax`, no `customer_name`, no `line_items` is not a real invoice. It's a placeholder.

**Impact**: Cannot generate actual invoices. Low priority to fix now since it's not related to housekeeping.

---

### AP-10: RoomAmenity Missing Unique Constraint

```sql
CREATE TABLE [dbo].[RoomAmenity](
    [room_amenity_id] [bigint] IDENTITY(1,1) NOT NULL,
    [room_id] [bigint] NOT NULL,
    [amenity_id] [bigint] NOT NULL
)
```

No `UNIQUE(room_id, amenity_id)` constraint. The same amenity can be linked to the same room multiple times.

**Impact**: Duplicate data, incorrect counts in UI display.

---

### AP-11: No Soft Delete Consistency

`Customer` and `StaffAccounts` have `is_deleted`, but `Booking`, `Payment`, `Invoice`, `Scheduler`, `Timetable` do not. Inconsistent deletion strategy.

---

### AP-12: Booking Lacks Actual Check-in/Check-out Timestamps

`check_in_time` and `check_out_time` are **planned** times set at booking creation. There is no `actual_check_in_time` or `actual_check_out_time`. (Note: The docs mention that `check_in_time` is set during check-in approval, but `check_out_time` is always the planned time.)

**Impact**: Cannot calculate actual stay duration. Cannot detect overdue checkouts by comparing `check_out_time` with `NOW()`.

---

## 3. Room Status Lifecycle Redesign

### 3.1 New Room Statuses

| Status | Description | Who Sets It | Trigger |
|--------|-------------|-------------|---------|
| `AVAILABLE` | Room is clean, inspected, and ready for booking | Housekeeping / System | After cleaning completed or maintenance resolved |
| `BOOKED` | Room has an active reservation (future) | System | Booking confirmed/paid |
| `OCCUPIED` | Guest has physically checked in | System | Admin approves check-in |
| `CHECKOUT_PENDING` | Check-out time has passed but guest has not checked out | System (scheduler) | `NOW() > check_out_time` while status is `OCCUPIED` |
| `DIRTY` | Guest checked out; room needs cleaning | System | Checkout completed |
| `CLEANING` | Housekeeping staff has started cleaning | Housekeeping staff | Staff starts cleaning task |
| `MAINTENANCE` | Room requires repair / maintenance work | Housekeeping staff / Staff | Reported during cleaning or by staff |
| `OUT_OF_SERVICE` | Room is temporarily removed from inventory | Admin | Administrative decision |

### 3.2 Status Transition Diagram

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                                                         │
                    ▼                                                         │
              ┌───────────┐  Booking paid   ┌────────┐  Check-in    ┌──────────┐
              │ AVAILABLE  │ ──────────────► │ BOOKED │ ──────────► │ OCCUPIED  │
              └───────────┘                  └────────┘  approved    └──────────┘
                    ▲                                                    │
                    │                                          ┌────────┤
                    │                                          │        │
                    │                              Checkout    │  Time   │
                    │                              confirmed   │  passes │
                    │                                          ▼        ▼
                    │                                    ┌───────┐  ┌──────────────────┐
                    │                                    │ DIRTY  │  │ CHECKOUT_PENDING  │
                    │                                    └───────┘  └──────────────────┘
                    │                                        │              │
                    │                           Staff starts │    Customer  │
                    │                            cleaning    │  checks out  │
                    │                                        ▼              │
                    │                                   ┌──────────┐       │
                    │                                   │ CLEANING  │◄──────┘
                    │                                   └──────────┘
                    │                                        │
                    │                            ┌───────────┤
                    │               Cleaning     │           │  Issue found
                    │               completed    │           │
                    │                            ▼           ▼
                    │                      ┌───────────┐  ┌─────────────┐
                    └──────────────────────│ AVAILABLE  │  │ MAINTENANCE  │
                                           └───────────┘  └─────────────┘
                                                 ▲              │
                                                 │  Resolved    │
                                                 └──────────────┘

              ┌────────────────┐
              │ OUT_OF_SERVICE  │  ← Admin can set from any status
              └────────────────┘    → Admin restores to AVAILABLE
```

### 3.3 Transition Rules

| # | From | To | Trigger | Actor |
|---|------|----|---------|-------|
| T1 | `AVAILABLE` | `BOOKED` | Booking reaches PAID status | System |
| T2 | `BOOKED` | `OCCUPIED` | Admin approves check-in | Admin |
| T3 | `OCCUPIED` | `DIRTY` | Customer confirms checkout | Customer / System |
| T4 | `OCCUPIED` | `CHECKOUT_PENDING` | `NOW() > booking.check_out_time` (scheduled job) | System (cron) |
| T5 | `CHECKOUT_PENDING` | `DIRTY` | Staff forces checkout / Customer late-checks-out | Staff / Customer |
| T6 | `DIRTY` | `CLEANING` | Housekeeping starts cleaning task | Housekeeping |
| T7 | `CLEANING` | `AVAILABLE` | Housekeeping completes all checklist items | Housekeeping |
| T8 | `CLEANING` | `MAINTENANCE` | Housekeeping reports issue during cleaning | Housekeeping |
| T9 | `MAINTENANCE` | `AVAILABLE` | Maintenance resolved by staff/housekeeping | Staff / Housekeeping |
| T10 | Any | `OUT_OF_SERVICE` | Admin takes room offline | Admin |
| T11 | `OUT_OF_SERVICE` | `AVAILABLE` | Admin restores room | Admin |

### 3.4 Overdue Checkout Detection

A **scheduled job** (e.g., Spring `@Scheduled` cron every 5–15 minutes) should:

```
SELECT b.booking_id, b.room_id, r.room_number
FROM Booking b
JOIN Room r ON b.room_id = r.room_id
WHERE b.booking_status = 'CHECKED_IN'
  AND r.status = 'OCCUPIED'
  AND b.check_out_time < GETDATE()
```

For each result:
1. Update `Room.status = 'CHECKOUT_PENDING'`
2. Create a `HousekeepingTask` with `task_type = 'OVERDUE_CHECKOUT'`
3. Optionally notify staff via WebSocket

---

## 4. Housekeeping System Design

### 4.1 Overview

The Housekeeping module introduces:
- A new role: **HOUSEKEEPING** (added to `StaffAccounts.role`)
- New tables for task management and room cleaning tracking
- Dashboard views for housekeeping staff

### 4.2 New Role: HOUSEKEEPING

Added to `StaffAccounts.role` CHECK constraint:

```sql
CHECK (role IN ('ADMIN', 'STAFF', 'HOUSEKEEPING'))
```

Housekeeping staff can:
| Permission | Description |
|-----------|-------------|
| View task list | See all rooms needing cleaning/maintenance |
| View task detail | See room info, checklist, notes |
| Start cleaning | Mark a DIRTY room as CLEANING |
| Complete cleaning | Mark a CLEANING room as AVAILABLE |
| Report maintenance | Flag room for maintenance |
| Add notes | Record observations during inspection |

Housekeeping staff **cannot**:
- Manage bookings, customers, or payments
- Create/delete rooms
- Access revenue reports
- Manage user accounts

### 4.3 Required Tables

| Table | Purpose |
|-------|---------|
| `HousekeepingTask` | Central task tracking — one task per room cleaning/maintenance event |
| `TaskChecklist` | Individual checklist items within a task (bed, bathroom, floor, etc.) |
| `RoomStatusLog` | Audit trail: every room status change, by whom, when |

### 4.4 HousekeepingTask Design

Each time a room needs housekeeping attention, a task is created:

```
Fields:
  task_id (PK)
  room_id (FK → Room)
  booking_id (FK → Booking, nullable — maintenance may not be booking-related)
  assigned_to (FK → StaffAccounts, nullable — unassigned tasks exist)
  task_type: CLEANING | MAINTENANCE | INSPECTION | OVERDUE_CHECKOUT
  task_status: PENDING | IN_PROGRESS | COMPLETED | CANCELLED
  priority: LOW | NORMAL | HIGH | URGENT
  notes (staff notes)
  created_at
  started_at
  completed_at
  created_by (FK → StaffAccounts, nullable — system-generated tasks)
```

### 4.5 TaskChecklist Design

Pre-defined checklist items for cleaning tasks:

```
Fields:
  checklist_id (PK)
  task_id (FK → HousekeepingTask)
  item_name (e.g., "Change bedsheets", "Clean bathroom")
  is_completed (BIT)
  completed_at
```

### 4.6 RoomStatusLog Design

Every room status transition is logged:

```
Fields:
  log_id (PK)
  room_id (FK → Room)
  previous_status
  new_status
  changed_by (FK → StaffAccounts, nullable — system changes have NULL)
  change_reason (description)
  booking_id (FK → Booking, nullable)
  created_at
```

### 4.7 Housekeeping Dashboard Queries

**1. Rooms needing cleaning** (DIRTY status):
```sql
SELECT r.room_id, r.room_number, rt.name AS room_type
FROM Room r
JOIN RoomType rt ON r.room_type_id = rt.room_type_id
WHERE r.status = 'DIRTY' AND r.is_deleted = 0
```

**2. Rooms needing maintenance**:
```sql
SELECT r.room_id, r.room_number, ht.notes, ht.priority
FROM Room r
JOIN HousekeepingTask ht ON r.room_id = ht.room_id
WHERE r.status = 'MAINTENANCE'
  AND ht.task_status IN ('PENDING', 'IN_PROGRESS')
  AND r.is_deleted = 0
```

**3. Rooms currently being cleaned**:
```sql
SELECT r.room_id, r.room_number, ht.assigned_to, sa.full_name, ht.started_at
FROM Room r
JOIN HousekeepingTask ht ON r.room_id = ht.room_id
JOIN StaffAccounts sa ON ht.assigned_to = sa.staff_account_id
WHERE r.status = 'CLEANING'
  AND ht.task_status = 'IN_PROGRESS'
```

**4. Overdue checkout rooms**:
```sql
SELECT r.room_id, r.room_number, b.booking_id, b.check_out_time,
       c.full_name AS guest_name,
       DATEDIFF(MINUTE, b.check_out_time, GETDATE()) AS minutes_overdue
FROM Room r
JOIN Booking b ON r.room_id = b.room_id
JOIN Customer c ON b.customer_id = c.customer_id
WHERE r.status IN ('OCCUPIED', 'CHECKOUT_PENDING')
  AND b.booking_status = 'CHECKED_IN'
  AND b.check_out_time < GETDATE()
ORDER BY b.check_out_time ASC
```

**5. Rooms reported for problems**:
```sql
SELECT r.room_id, r.room_number, ht.task_id, ht.notes, ht.priority, ht.created_at
FROM Room r
JOIN HousekeepingTask ht ON r.room_id = ht.room_id
WHERE ht.task_type = 'MAINTENANCE'
  AND ht.task_status IN ('PENDING', 'IN_PROGRESS')
ORDER BY
  CASE ht.priority WHEN 'URGENT' THEN 1 WHEN 'HIGH' THEN 2 WHEN 'NORMAL' THEN 3 ELSE 4 END,
  ht.created_at ASC
```

---

## 5. Database Refactor Strategy

### 5.1 Table-by-Table Decision

| # | Table | Decision | Action | Reason |
|---|-------|----------|--------|--------|
| 01 | `Customer` | **KEEP** | No changes | Working correctly |
| 02 | `StaffAccounts` | **MODIFY** | Update role CHECK constraint | Add `'HOUSEKEEPING'` role |
| 03 | `RefreshTokens` | **KEEP** | No changes | Working correctly |
| 04 | `RoomType` | **EXTEND** | Add `base_price`, `over_price`, `description` columns | Fix AP-01: pricing belongs on type |
| 05 | `Room` | **MODIFY** | Update status CHECK constraint; keep `base_price`/`over_price` temporarily for backward compat | Add new statuses; mark price columns for deprecation |
| 06 | `Amenity` | **KEEP** | No changes | Working correctly |
| 07 | `RoomAmenity` | **EXTEND** | Add UNIQUE constraint `(room_id, amenity_id)` | Fix AP-10: prevent duplicates |
| 08 | `Image` | **KEEP** | No changes | Working correctly |
| 09 | `Booking` | **EXTEND** | Add `actual_check_in_time`, `actual_check_out_time`; add status CHECK | Fix AP-06, AP-12 |
| 10 | `Payment` | **MODIFY** | Make `paid_at` nullable, remove default | Fix AP-05: timestamp only on success |
| 11 | `Invoice` | **KEEP** | No changes now | Low priority; not related to housekeeping |
| 12 | `Feedback` | **MODIFY** | Make `admin_id` nullable | Fix AP-03: feedback exists before reply |
| 13 | `Timetable` | **KEEP** | No changes | Working correctly |
| 14 | `Scheduler` | **KEEP** | No changes | Working correctly |
| 15 | `CheckInSession` | **ADD** | Create table (missing from schema) | Fix AP-04 |
| 16 | `HousekeepingTask` | **ADD** | New table | Housekeeping module |
| 17 | `TaskChecklist` | **ADD** | New table | Housekeeping module |
| 18 | `RoomStatusLog` | **ADD** | New table | Room audit trail |

### 5.2 Columns to Deprecate (Not Remove)

To maintain backward compatibility, these columns will remain but should be deprecated in code:

| Table | Column | Reason |
|-------|--------|--------|
| `Room` | `base_price` | Will be migrated to `RoomType.base_price`; keep for existing code |
| `Room` | `over_price` | Will be migrated to `RoomType.over_price`; keep for existing code |
| `Room` | `description` | Will be migrated to `RoomType.description`; keep for existing code |

**Code migration path**: Update service layer to read price from `RoomType` first, fall back to `Room` if null. Eventually remove Room-level price columns after all code is updated.

---

## 6. New Tables SQL Design

### 6.1 CheckInSession (Missing — Must Create)

```sql
CREATE TABLE [dbo].[CheckInSession](
    [check_in_session_id] [bigint] IDENTITY(1,1) NOT NULL,
    [booking_id]          [bigint] NOT NULL,
    [video_url]           [nvarchar](500) NOT NULL,
    [video_public_id]     [nvarchar](255) NULL,
    [status]              [varchar](20) NOT NULL DEFAULT 'PENDING',
    [reviewed_by]         [bigint] NULL,
    [created_at]          [datetime2](7) NOT NULL DEFAULT (sysdatetime()),
    [reviewed_at]         [datetime2](7) NULL,

    CONSTRAINT [PK_CheckInSession] PRIMARY KEY CLUSTERED ([check_in_session_id]),

    CONSTRAINT [FK_CheckInSession_Booking] FOREIGN KEY ([booking_id])
        REFERENCES [dbo].[Booking]([booking_id]),

    CONSTRAINT [FK_CheckInSession_Reviewer] FOREIGN KEY ([reviewed_by])
        REFERENCES [dbo].[StaffAccounts]([staff_account_id]),

    CONSTRAINT [CK_CheckInSession_Status] CHECK ([status] IN ('PENDING', 'APPROVED', 'REJECTED'))
);
```

### 6.2 HousekeepingTask

```sql
CREATE TABLE [dbo].[HousekeepingTask](
    [task_id]       [bigint] IDENTITY(1,1) NOT NULL,
    [room_id]       [bigint] NOT NULL,
    [booking_id]    [bigint] NULL,
    [assigned_to]   [bigint] NULL,
    [created_by]    [bigint] NULL,
    [task_type]     [varchar](30) NOT NULL,
    [task_status]   [varchar](20) NOT NULL DEFAULT 'PENDING',
    [priority]      [varchar](10) NOT NULL DEFAULT 'NORMAL',
    [notes]         [nvarchar](1000) NULL,
    [created_at]    [datetime2](7) NOT NULL DEFAULT (sysdatetime()),
    [started_at]    [datetime2](7) NULL,
    [completed_at]  [datetime2](7) NULL,

    CONSTRAINT [PK_HousekeepingTask] PRIMARY KEY CLUSTERED ([task_id]),

    CONSTRAINT [FK_HousekeepingTask_Room] FOREIGN KEY ([room_id])
        REFERENCES [dbo].[Room]([room_id]),

    CONSTRAINT [FK_HousekeepingTask_Booking] FOREIGN KEY ([booking_id])
        REFERENCES [dbo].[Booking]([booking_id]),

    CONSTRAINT [FK_HousekeepingTask_AssignedTo] FOREIGN KEY ([assigned_to])
        REFERENCES [dbo].[StaffAccounts]([staff_account_id]),

    CONSTRAINT [FK_HousekeepingTask_CreatedBy] FOREIGN KEY ([created_by])
        REFERENCES [dbo].[StaffAccounts]([staff_account_id]),

    CONSTRAINT [CK_HousekeepingTask_Type] CHECK ([task_type] IN (
        'CLEANING', 'MAINTENANCE', 'INSPECTION', 'OVERDUE_CHECKOUT'
    )),

    CONSTRAINT [CK_HousekeepingTask_Status] CHECK ([task_status] IN (
        'PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'
    )),

    CONSTRAINT [CK_HousekeepingTask_Priority] CHECK ([priority] IN (
        'LOW', 'NORMAL', 'HIGH', 'URGENT'
    ))
);
```

### 6.3 TaskChecklist

```sql
CREATE TABLE [dbo].[TaskChecklist](
    [checklist_id]   [bigint] IDENTITY(1,1) NOT NULL,
    [task_id]        [bigint] NOT NULL,
    [item_name]      [nvarchar](200) NOT NULL,
    [is_completed]   [bit] NOT NULL DEFAULT (0),
    [completed_at]   [datetime2](7) NULL,

    CONSTRAINT [PK_TaskChecklist] PRIMARY KEY CLUSTERED ([checklist_id]),

    CONSTRAINT [FK_TaskChecklist_Task] FOREIGN KEY ([task_id])
        REFERENCES [dbo].[HousekeepingTask]([task_id])
        ON DELETE CASCADE
);
```

### 6.4 RoomStatusLog

```sql
CREATE TABLE [dbo].[RoomStatusLog](
    [log_id]           [bigint] IDENTITY(1,1) NOT NULL,
    [room_id]          [bigint] NOT NULL,
    [previous_status]  [varchar](30) NULL,
    [new_status]       [varchar](30) NOT NULL,
    [changed_by]       [bigint] NULL,
    [change_reason]    [nvarchar](500) NULL,
    [booking_id]       [bigint] NULL,
    [created_at]       [datetime2](7) NOT NULL DEFAULT (sysdatetime()),

    CONSTRAINT [PK_RoomStatusLog] PRIMARY KEY CLUSTERED ([log_id]),

    CONSTRAINT [FK_RoomStatusLog_Room] FOREIGN KEY ([room_id])
        REFERENCES [dbo].[Room]([room_id]),

    CONSTRAINT [FK_RoomStatusLog_ChangedBy] FOREIGN KEY ([changed_by])
        REFERENCES [dbo].[StaffAccounts]([staff_account_id]),

    CONSTRAINT [FK_RoomStatusLog_Booking] FOREIGN KEY ([booking_id])
        REFERENCES [dbo].[Booking]([booking_id])
);
```

---

## 7. Index Optimization Plan

### 7.1 Room Status Lookup

```sql
-- Housekeeping dashboard: filter rooms by status
CREATE NONCLUSTERED INDEX [IX_Room_Status]
ON [dbo].[Room] ([status])
INCLUDE ([room_number], [room_type_id])
WHERE [is_deleted] = 0;
```

**Reason**: The housekeeping dashboard will frequently query rooms by `status IN ('DIRTY', 'CLEANING', 'MAINTENANCE', 'CHECKOUT_PENDING')`. This filtered index makes those lookups fast while excluding deleted rooms.

### 7.2 Housekeeping Task Lists

```sql
-- Active tasks for dashboard
CREATE NONCLUSTERED INDEX [IX_HousekeepingTask_Status_Type]
ON [dbo].[HousekeepingTask] ([task_status], [task_type])
INCLUDE ([room_id], [assigned_to], [priority], [created_at]);
```

**Reason**: Housekeeping staff filter tasks by status (PENDING, IN_PROGRESS) and type (CLEANING, MAINTENANCE). This composite index covers the primary query pattern.

```sql
-- Tasks assigned to a specific staff member
CREATE NONCLUSTERED INDEX [IX_HousekeepingTask_AssignedTo]
ON [dbo].[HousekeepingTask] ([assigned_to], [task_status])
INCLUDE ([room_id], [task_type], [priority]);
```

**Reason**: "My tasks" view for each housekeeping staff member.

### 7.3 Booking → Room Queries

```sql
-- Active bookings per room (availability check + overdue detection)
CREATE NONCLUSTERED INDEX [IX_Booking_Room_Status]
ON [dbo].[Booking] ([room_id], [booking_status])
INCLUDE ([customer_id], [check_in_time], [check_out_time]);
```

**Reason**: Room availability checks and overdue detection both query Booking by `room_id` + `booking_status`.

```sql
-- Customer booking history
CREATE NONCLUSTERED INDEX [IX_Booking_Customer_CreatedAt]
ON [dbo].[Booking] ([customer_id], [created_at] DESC)
INCLUDE ([room_id], [booking_status], [total_amount]);
```

**Reason**: Booking history page lists bookings by customer, sorted by newest first.

### 7.4 Overdue Checkout Detection

```sql
-- Scheduled job: find rooms past checkout time
CREATE NONCLUSTERED INDEX [IX_Booking_CheckedIn_CheckoutTime]
ON [dbo].[Booking] ([booking_status], [check_out_time])
INCLUDE ([room_id], [customer_id])
WHERE [booking_status] = 'CHECKED_IN';
```

**Reason**: The overdue detection cron job queries `WHERE booking_status = 'CHECKED_IN' AND check_out_time < GETDATE()`. This filtered index is optimal for that specific query pattern.

### 7.5 Room Status Log

```sql
-- Room history lookup
CREATE NONCLUSTERED INDEX [IX_RoomStatusLog_Room_CreatedAt]
ON [dbo].[RoomStatusLog] ([room_id], [created_at] DESC)
INCLUDE ([previous_status], [new_status], [changed_by]);
```

**Reason**: Viewing the status change history for a specific room.

### 7.6 Task Checklist

```sql
-- Checklist items per task
CREATE NONCLUSTERED INDEX [IX_TaskChecklist_TaskId]
ON [dbo].[TaskChecklist] ([task_id])
INCLUDE ([item_name], [is_completed]);
```

**Reason**: Loading checklist items for a task detail view.

---

## 8. Migration Strategy

### 8.1 Migration Order

The migration must be executed in a specific order to avoid FK constraint violations and minimize downtime.

#### Phase 1: Non-Breaking Additions (Safe — Zero Downtime)

These changes add new columns/tables without affecting existing code:

```
Step 1.1: Add columns to RoomType (base_price, over_price, description)
Step 1.2: Add columns to Booking (actual_check_in_time, actual_check_out_time)
Step 1.3: Create CheckInSession table
Step 1.4: Create HousekeepingTask table
Step 1.5: Create TaskChecklist table
Step 1.6: Create RoomStatusLog table
Step 1.7: Create all new indexes
```

#### Phase 2: Data Migration (Safe — Idempotent)

```
Step 2.1: Copy pricing from Room to RoomType (group by room_type_id)
Step 2.2: Seed initial RoomStatusLog entries for current room states
```

#### Phase 3: Constraint Modifications (Requires Brief Testing Window)

```
Step 3.1: Update Room.status CHECK constraint (add new statuses)
Step 3.2: Update StaffAccounts.role CHECK constraint (add HOUSEKEEPING)
Step 3.3: Add Booking.booking_status CHECK constraint
Step 3.4: Make Feedback.admin_id nullable
Step 3.5: Make Payment.paid_at nullable, remove default
Step 3.6: Add RoomAmenity UNIQUE constraint
```

### 8.2 Detailed Migration Scripts

#### Phase 1: Non-Breaking Additions

```sql
-- ============================================================
-- PHASE 1: NON-BREAKING ADDITIONS
-- ============================================================

-- 1.1: Extend RoomType with pricing columns
ALTER TABLE [dbo].[RoomType] ADD [base_price] [decimal](12, 2) NULL;
ALTER TABLE [dbo].[RoomType] ADD [over_price] [decimal](12, 2) NULL;
ALTER TABLE [dbo].[RoomType] ADD [description] [nvarchar](500) NULL;
GO

-- 1.2: Add actual timestamps to Booking
ALTER TABLE [dbo].[Booking] ADD [actual_check_in_time]  [datetime2](7) NULL;
ALTER TABLE [dbo].[Booking] ADD [actual_check_out_time] [datetime2](7) NULL;
GO

-- 1.3: Create CheckInSession
-- (See Section 6.1 for full CREATE TABLE script)

-- 1.4: Create HousekeepingTask
-- (See Section 6.2 for full CREATE TABLE script)

-- 1.5: Create TaskChecklist
-- (See Section 6.3 for full CREATE TABLE script)

-- 1.6: Create RoomStatusLog
-- (See Section 6.4 for full CREATE TABLE script)

-- 1.7: Create indexes
-- (See Section 7 for all CREATE INDEX scripts)
```

#### Phase 2: Data Migration

```sql
-- ============================================================
-- PHASE 2: DATA MIGRATION
-- ============================================================

-- 2.1: Copy pricing from Room to RoomType
-- Strategy: For each RoomType, take the price from the first non-deleted Room of that type
UPDATE rt
SET rt.base_price = sub.base_price,
    rt.over_price = sub.over_price,
    rt.description = sub.description
FROM [dbo].[RoomType] rt
INNER JOIN (
    SELECT room_type_id,
           base_price,
           over_price,
           description,
           ROW_NUMBER() OVER (PARTITION BY room_type_id ORDER BY room_id) AS rn
    FROM [dbo].[Room]
    WHERE is_deleted = 0 AND base_price IS NOT NULL
) sub ON rt.room_type_id = sub.room_type_id AND sub.rn = 1;
GO

-- 2.2: Seed RoomStatusLog with current state
INSERT INTO [dbo].[RoomStatusLog] (room_id, previous_status, new_status, change_reason, created_at)
SELECT room_id, NULL, status, 'Initial state captured during migration', sysdatetime()
FROM [dbo].[Room]
WHERE is_deleted = 0;
GO

-- 2.3: Backfill actual_check_in_time from existing CHECKED_IN bookings
-- For bookings already in CHECKED_IN or later state, set actual_check_in_time = check_in_time
UPDATE [dbo].[Booking]
SET actual_check_in_time = check_in_time
WHERE booking_status IN ('CHECKED_IN', 'CHECKED_OUT', 'COMPLETED')
  AND actual_check_in_time IS NULL;
GO

-- 2.4: Backfill actual_check_out_time from existing CHECKED_OUT bookings
UPDATE [dbo].[Booking]
SET actual_check_out_time = COALESCE(update_at, check_out_time)
WHERE booking_status IN ('CHECKED_OUT', 'COMPLETED')
  AND actual_check_out_time IS NULL;
GO
```

#### Phase 3: Constraint Modifications

```sql
-- ============================================================
-- PHASE 3: CONSTRAINT MODIFICATIONS
-- ============================================================

-- 3.1: Update Room.status CHECK constraint
ALTER TABLE [dbo].[Room] DROP CONSTRAINT [CK_Room_Status];
GO
ALTER TABLE [dbo].[Room] ADD CONSTRAINT [CK_Room_Status]
CHECK ([status] IN (
    'AVAILABLE', 'BOOKED', 'OCCUPIED', 'CHECKOUT_PENDING',
    'DIRTY', 'CLEANING', 'MAINTENANCE', 'OUT_OF_SERVICE'
));
GO

-- 3.2: Update StaffAccounts.role CHECK constraint
ALTER TABLE [dbo].[StaffAccounts] DROP CONSTRAINT [CK_Admin_Role];
GO
ALTER TABLE [dbo].[StaffAccounts] ADD CONSTRAINT [CK_Admin_Role]
CHECK ([role] IN ('ADMIN', 'STAFF', 'HOUSEKEEPING'));
GO

-- 3.3: Add Booking.booking_status CHECK constraint
ALTER TABLE [dbo].[Booking] ADD CONSTRAINT [CK_Booking_Status]
CHECK ([booking_status] IN (
    'PENDING', 'WAITING_PAYMENT', 'PAID',
    'CHECKED_IN', 'CHECKED_OUT', 'COMPLETED', 'CANCELLED'
));
GO

-- 3.4: Make Feedback.admin_id nullable
-- Step A: Drop the existing FK constraint
ALTER TABLE [dbo].[Feedback] DROP CONSTRAINT [FK_Feedback_StaffAccounts];
GO
-- Step B: Alter the column to allow NULL
ALTER TABLE [dbo].[Feedback] ALTER COLUMN [admin_id] [bigint] NULL;
GO
-- Step C: Re-add the FK constraint
ALTER TABLE [dbo].[Feedback] ADD CONSTRAINT [FK_Feedback_StaffAccounts]
FOREIGN KEY ([admin_id]) REFERENCES [dbo].[StaffAccounts]([staff_account_id]);
GO

-- 3.5: Make Payment.paid_at nullable, remove default
ALTER TABLE [dbo].[Payment] DROP CONSTRAINT [DF_Payment_PaidAt];
GO
ALTER TABLE [dbo].[Payment] ALTER COLUMN [paid_at] [datetime2](7) NULL;
GO

-- 3.6: Add unique constraint on RoomAmenity
ALTER TABLE [dbo].[RoomAmenity] ADD CONSTRAINT [UQ_RoomAmenity_Room_Amenity]
UNIQUE ([room_id], [amenity_id]);
GO

-- Clean up duplicate RoomAmenity records first (if any exist)
-- Run this BEFORE the UNIQUE constraint above if duplicates exist:
/*
WITH cte AS (
    SELECT room_amenity_id,
           ROW_NUMBER() OVER (PARTITION BY room_id, amenity_id ORDER BY room_amenity_id) AS rn
    FROM [dbo].[RoomAmenity]
)
DELETE FROM cte WHERE rn > 1;
*/
```

### 8.3 How to Avoid Breaking Current Code

| Change | Backward Compatibility Strategy |
|--------|-------------------------------|
| New Room statuses | Existing code checks for `'AVAILABLE'`, `'BOOKED'`, `'MAINTENANCE'` — all still valid. New statuses are additive. Update service layer to handle new values gradually. |
| Price on RoomType | Keep `Room.base_price` / `over_price` intact. Update read logic to prefer `RoomType` price, fall back to `Room` price. |
| `Feedback.admin_id` nullable | Existing records already have admin_id populated. New feedback can be created without it. Existing read code still works. |
| `Payment.paid_at` nullable | Existing records retain their timestamps. Update the payment success handler to `SET paid_at = sysdatetime()` explicitly. |
| New tables | Completely additive — no existing code interacts with them until new features are built. |
| New Booking columns | Nullable, so existing INSERT statements work without modification. |
| HOUSEKEEPING role | Additive — existing ADMIN/STAFF auth checks unaffected. New role requires new controller endpoints. |

### 8.4 Rollback Plan

Every migration step is independently reversible:

```sql
-- Rollback Phase 3.1:
ALTER TABLE [dbo].[Room] DROP CONSTRAINT [CK_Room_Status];
ALTER TABLE [dbo].[Room] ADD CONSTRAINT [CK_Room_Status]
CHECK ([status] IN ('AVAILABLE', 'BOOKED', 'MAINTENANCE'));

-- Rollback Phase 1.1:
ALTER TABLE [dbo].[RoomType] DROP COLUMN [base_price];
ALTER TABLE [dbo].[RoomType] DROP COLUMN [over_price];
ALTER TABLE [dbo].[RoomType] DROP COLUMN [description];

-- Rollback new tables:
DROP TABLE [dbo].[TaskChecklist];
DROP TABLE [dbo].[HousekeepingTask];
DROP TABLE [dbo].[RoomStatusLog];
DROP TABLE [dbo].[CheckInSession];
```

---

## 9. Final Database Schema

### 9.1 Complete Table List

| # | Table | Status | Description |
|---|-------|--------|-------------|
| 01 | `Customer` | Unchanged | Guest user accounts |
| 02 | `StaffAccounts` | Modified constraint | Staff/Admin/Housekeeping accounts |
| 03 | `RefreshTokens` | Unchanged | Session tokens |
| 04 | `RoomType` | Extended | Room categories + pricing (NEW: base_price, over_price, description) |
| 05 | `Room` | Modified constraint | Individual rooms (NEW status values) |
| 06 | `Amenity` | Unchanged | Room features |
| 07 | `RoomAmenity` | New constraint | Room-Amenity junction (NEW: unique constraint) |
| 08 | `Image` | Unchanged | Room photos |
| 09 | `Booking` | Extended | Reservations (NEW: actual timestamps, CHECK constraint) |
| 10 | `Payment` | Modified | Payments (FIX: paid_at nullable) |
| 11 | `Invoice` | Unchanged | Invoices (to be improved later) |
| 12 | `Feedback` | Modified | Reviews (FIX: admin_id nullable) |
| 13 | `Timetable` | Unchanged | Time slots |
| 14 | `Scheduler` | Unchanged | Booking-timetable links |
| 15 | `CheckInSession` | **NEW** | Check-in video tracking |
| 16 | `HousekeepingTask` | **NEW** | Cleaning/maintenance tasks |
| 17 | `TaskChecklist` | **NEW** | Cleaning checklist items |
| 18 | `RoomStatusLog` | **NEW** | Room status audit trail |

### 9.2 Entity Relationship Diagram

```
Customer ──────────< Booking >──────────── Room ──────── RoomType
    │                   │                    │
    │                   ├──< Payment         ├──<< RoomAmenity >>── Amenity
    │                   │                    │
    │                   ├──< Invoice         ├──< Image
    │                   │                    │
    │                   ├──< Feedback ──┐    ├──< RoomStatusLog
    │                   │               │    │
    │                   ├──< Scheduler  │    └──< HousekeepingTask ──< TaskChecklist
    │                   │    │          │              │
    │                   ├──< CheckIn    │              │
    │                   │    Session    │              │
    │                   │               │              │
    └──< RefreshToken >── StaffAccounts ◄──────────────┘
                              │
                              ├── assigned_to (HousekeepingTask)
                              ├── created_by (HousekeepingTask)
                              ├── changed_by (RoomStatusLog)
                              └── reviewed_by (CheckInSession)
```

### 9.3 Final SQL Schema Script

Below is the **complete** final schema, including all existing tables (with modifications applied) and all new tables.

```sql
-- ============================================================
-- BookNow — Final Optimized Database Schema
-- Version: 2.0 (with Housekeeping Module)
-- Database: Microsoft SQL Server
-- Generated from: DATABASE_REDESIGN_REPORT.md
-- ============================================================

USE [BookNow]
GO

-- ============================================================
-- TABLE: Customer
-- ============================================================
CREATE TABLE [dbo].[Customer](
    [customer_id]      [bigint] IDENTITY(1,1) NOT NULL,
    [email]            [nvarchar](255) NOT NULL,
    [password_hash]    [nvarchar](255) NULL,
    [full_name]        [nvarchar](50) NULL,
    [avatar_url]       [nvarchar](255) NULL,
    [phone]            [nvarchar](20) NULL,
    [status]           [varchar](50) NOT NULL DEFAULT ('ACTIVE'),
    [created_at]       [datetime2](7) NOT NULL DEFAULT (sysdatetime()),
    [updated_at]       [datetime2](7) NULL,
    [is_deleted]       [bit] NOT NULL DEFAULT (0),
    [avatar_public_id] [nvarchar](255) NULL,

    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([customer_id]),
    CONSTRAINT [UQ_Customer_Email] UNIQUE ([email]),
    CONSTRAINT [CK_Customer_Status] CHECK ([status] IN ('ACTIVE', 'INACTIVE'))
);
GO

-- ============================================================
-- TABLE: StaffAccounts
-- ============================================================
CREATE TABLE [dbo].[StaffAccounts](
    [staff_account_id] [bigint] IDENTITY(1,1) NOT NULL,
    [email]            [nvarchar](255) NOT NULL,
    [phone]            [nvarchar](20) NULL,
    [password_hash]    [nvarchar](255) NOT NULL,
    [full_name]        [nvarchar](50) NULL,
    [avatar_url]       [nvarchar](255) NULL,
    [role]             [nvarchar](20) NOT NULL,
    [status]           [varchar](50) NOT NULL DEFAULT ('ACTIVE'),
    [created_at]       [datetime2](7) NOT NULL DEFAULT (sysdatetime()),
    [is_deleted]       [bit] NOT NULL DEFAULT (0),
    [avatar_public_id] [nvarchar](255) NULL,

    CONSTRAINT [PK_Admin] PRIMARY KEY CLUSTERED ([staff_account_id]),
    CONSTRAINT [UQ_Admin_Email] UNIQUE ([email]),
    CONSTRAINT [CK_Admin_Role] CHECK ([role] IN ('ADMIN', 'STAFF', 'HOUSEKEEPING')),
    CONSTRAINT [CK_Admin_Status] CHECK ([status] IN ('ACTIVE', 'INACTIVE'))
);
GO

-- ============================================================
-- TABLE: RoomType
-- ============================================================
CREATE TABLE [dbo].[RoomType](
    [room_type_id] [bigint] IDENTITY(1,1) NOT NULL,
    [name]         [nvarchar](100) NOT NULL,
    [description]  [nvarchar](500) NULL,
    [base_price]   [decimal](12, 2) NULL,
    [over_price]   [decimal](12, 2) NULL,
    [image_url]    [nvarchar](500) NULL,
    [max_guests]   [int] NOT NULL,
    [area_m2]      [decimal](10, 2) NULL,
    [is_deleted]   [bit] NOT NULL DEFAULT (0),

    CONSTRAINT [PK_RoomType] PRIMARY KEY CLUSTERED ([room_type_id]),
    CONSTRAINT [UQ_RoomType_Name] UNIQUE ([name])
);
GO

-- ============================================================
-- TABLE: Room
-- ============================================================
CREATE TABLE [dbo].[Room](
    [room_id]      [bigint] IDENTITY(1,1) NOT NULL,
    [room_type_id] [bigint] NOT NULL,
    [room_number]  [nvarchar](50) NOT NULL,
    [status]       [varchar](50) NOT NULL DEFAULT ('AVAILABLE'),
    [is_deleted]   [bit] NOT NULL DEFAULT (0),
    CONSTRAINT [PK_Room] PRIMARY KEY CLUSTERED ([room_id]),
    CONSTRAINT [UQ_Room_RoomNumber] UNIQUE ([room_number]),
    CONSTRAINT [FK_Room_RoomType] FOREIGN KEY ([room_type_id])
        REFERENCES [dbo].[RoomType]([room_type_id]),
    CONSTRAINT [CK_Room_Status] CHECK ([status] IN (
        'AVAILABLE', 'BOOKED', 'OCCUPIED', 'CHECKOUT_PENDING',
        'DIRTY', 'CLEANING', 'MAINTENANCE', 'OUT_OF_SERVICE'
    ))
);
GO

-- ============================================================
-- TABLE: Amenity
-- ============================================================
CREATE TABLE [dbo].[Amenity](
    [amenity_id] [bigint] IDENTITY(1,1) NOT NULL,
    [name]       [nvarchar](100) NOT NULL,
    [icon_url]   [nvarchar](255) NULL,
    [is_deleted] [bit] NOT NULL DEFAULT (0),

    CONSTRAINT [PK_Amenity] PRIMARY KEY CLUSTERED ([amenity_id]),
    CONSTRAINT [UQ_Amenity_Name] UNIQUE ([name])
);
GO

-- ============================================================
-- TABLE: RoomAmenity
-- ============================================================
CREATE TABLE [dbo].[RoomAmenity](
    [room_amenity_id] [bigint] IDENTITY(1,1) NOT NULL,
    [room_id]         [bigint] NOT NULL,
    [amenity_id]      [bigint] NOT NULL,

    CONSTRAINT [PK_RoomAmenity] PRIMARY KEY CLUSTERED ([room_amenity_id]),
    CONSTRAINT [FK_RoomAmenity_Room] FOREIGN KEY ([room_id])
        REFERENCES [dbo].[Room]([room_id]),
    CONSTRAINT [FK_RoomAmenity_Amenity] FOREIGN KEY ([amenity_id])
        REFERENCES [dbo].[Amenity]([amenity_id]),
    CONSTRAINT [UQ_RoomAmenity_Room_Amenity] UNIQUE ([room_id], [amenity_id])
);
GO

-- ============================================================
-- TABLE: Image
-- ============================================================
CREATE TABLE [dbo].[Image](
    [image_id]  [bigint] IDENTITY(1,1) NOT NULL,
    [room_id]   [bigint] NOT NULL,
    [image_url] [nvarchar](500) NOT NULL,
    [is_cover]  [bit] NOT NULL DEFAULT (0),
    [public_id] [nvarchar](255) NULL,

    CONSTRAINT [PK_Image] PRIMARY KEY CLUSTERED ([image_id]),
    CONSTRAINT [FK_Image_Room] FOREIGN KEY ([room_id])
        REFERENCES [dbo].[Room]([room_id])
);
GO

-- ============================================================
-- TABLE: Booking
-- ============================================================
CREATE TABLE [dbo].[Booking](
    [booking_id]            [bigint] IDENTITY(1,1) NOT NULL,
    [customer_id]           [bigint] NOT NULL,
    [room_id]               [bigint] NOT NULL,
    [check_in_time]         [datetime2](7) NOT NULL,
    [check_out_time]        [datetime2](7) NOT NULL,
    [actual_check_in_time]  [datetime2](7) NULL,
    [actual_check_out_time] [datetime2](7) NULL,
    [id_card_front_url]     [nvarchar](500) NOT NULL,
    [id_card_back_url]      [nvarchar](500) NOT NULL,
    [booking_status]        [nvarchar](20) NOT NULL,
    [total_amount]          [decimal](12, 2) NOT NULL,
    [booking_code]          [nvarchar](500) NULL,
    [created_at]            [datetime2](7) NOT NULL DEFAULT (sysdatetime()),
    [note]                  [nvarchar](255) NULL,
    [update_at]             [datetime2](7) NULL,

    CONSTRAINT [PK_Booking] PRIMARY KEY CLUSTERED ([booking_id]),
    CONSTRAINT [FK_Booking_Customer] FOREIGN KEY ([customer_id])
        REFERENCES [dbo].[Customer]([customer_id]),
    CONSTRAINT [FK_Booking_Room] FOREIGN KEY ([room_id])
        REFERENCES [dbo].[Room]([room_id]),
    CONSTRAINT [CK_Booking_Status] CHECK ([booking_status] IN (
        'PENDING', 'PENDING_PAYMENT', 'PAID',
        'CHECKED_IN', 'CHECKED_OUT', 'COMPLETED', 'FAILED', 'REJECTED'
    ))
);
GO

-- ============================================================
-- TABLE: Payment
-- ============================================================
CREATE TABLE [dbo].[Payment](
    [payment_id]     [bigint] IDENTITY(1,1) NOT NULL,
    [booking_id]     [bigint] NOT NULL,
    [amount]         [decimal](12, 2) NOT NULL,
    [method]         [nvarchar](50) NOT NULL,
    [payment_status] [varchar](20) NOT NULL,
    [paid_at]        [datetime2](7) NULL,

    CONSTRAINT [PK_Payment] PRIMARY KEY CLUSTERED ([payment_id]),
    CONSTRAINT [FK_Payment_Booking] FOREIGN KEY ([booking_id])
        REFERENCES [dbo].[Booking]([booking_id])
);
GO

-- ============================================================
-- TABLE: Invoice
-- ============================================================
CREATE TABLE [dbo].[Invoice](
    [invoice_id]     [bigint] IDENTITY(1,1) NOT NULL,
    [booking_id]     [bigint] NOT NULL,
    [invoice_number] [nvarchar](50) NULL,
    [issued_at]      [datetime2](7) NOT NULL DEFAULT (sysdatetime()),

    CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED ([invoice_id]),
    CONSTRAINT [UQ_Invoice_Number] UNIQUE ([invoice_number]),
    CONSTRAINT [FK_Invoice_Booking] FOREIGN KEY ([booking_id])
        REFERENCES [dbo].[Booking]([booking_id])
);
GO

-- ============================================================
-- TABLE: Feedback
-- ============================================================
CREATE TABLE [dbo].[Feedback](
    [feedback_id]   [bigint] IDENTITY(1,1) NOT NULL,
    [booking_id]    [bigint] NOT NULL,
    [admin_id]      [bigint] NULL,
    [rating]        [int] NOT NULL,
    [content]       [nvarchar](1000) NOT NULL,
    [content_reply] [nvarchar](1000) NULL,
    [is_hidden]     [bit] NOT NULL DEFAULT (0),
    [created_at]    [datetime2](7) NOT NULL DEFAULT (sysdatetime()),
    [reply_at]      [datetime2](7) NULL,

    CONSTRAINT [PK_Feedback] PRIMARY KEY CLUSTERED ([feedback_id]),
    CONSTRAINT [FK_Feedback_Booking] FOREIGN KEY ([booking_id])
        REFERENCES [dbo].[Booking]([booking_id]),
    CONSTRAINT [FK_Feedback_StaffAccounts] FOREIGN KEY ([admin_id])
        REFERENCES [dbo].[StaffAccounts]([staff_account_id]),
    CONSTRAINT [CK_Feedback_Rating] CHECK ([rating] >= 1 AND [rating] <= 5)
);
GO

-- ============================================================
-- TABLE: Timetable
-- ============================================================
CREATE TABLE [dbo].[Timetable](
    [timetable_id] [bigint] IDENTITY(1,1) NOT NULL,
    [slot_name]    [nvarchar](50) NOT NULL,
    [start_time]   [time](7) NOT NULL,
    [end_time]     [time](7) NOT NULL,

    CONSTRAINT [PK_Timetable] PRIMARY KEY CLUSTERED ([timetable_id])
);
GO

-- ============================================================
-- TABLE: Scheduler
-- ============================================================
CREATE TABLE [dbo].[Scheduler](
    [scheduler_id] [bigint] IDENTITY(1,1) NOT NULL,
    [booking_id]   [bigint] NOT NULL,
    [timetable_id] [bigint] NOT NULL,
    [date]         [date] NOT NULL,

    CONSTRAINT [PK_Scheduler] PRIMARY KEY CLUSTERED ([scheduler_id]),
    CONSTRAINT [FK_Scheduler_Booking] FOREIGN KEY ([booking_id])
        REFERENCES [dbo].[Booking]([booking_id]),
    CONSTRAINT [FK_Scheduler_Timetable] FOREIGN KEY ([timetable_id])
        REFERENCES [dbo].[Timetable]([timetable_id])
);
GO

-- ============================================================
-- TABLE: RefreshTokens
-- ============================================================
CREATE TABLE [dbo].[RefreshTokens](
    [id]               [bigint] IDENTITY(1,1) NOT NULL,
    [token_hash]       [varchar](255) NOT NULL,
    [expires_at]       [datetime2](7) NOT NULL,
    [is_revoked]       [bit] NOT NULL DEFAULT (0),
    [revoked_at]       [datetime2](7) NULL,
    [created_at]       [datetime2](7) NOT NULL DEFAULT (sysdatetime()),
    [account_type]     [varchar](20) NOT NULL,
    [customer_id]      [bigint] NULL,
    [staff_account_id] [bigint] NULL,

    CONSTRAINT [PK_RefreshTokens] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [FK_RefreshTokens_Customers] FOREIGN KEY ([customer_id])
        REFERENCES [dbo].[Customer]([customer_id]) ON DELETE CASCADE,
    CONSTRAINT [FK_RefreshTokens_StaffAccounts] FOREIGN KEY ([staff_account_id])
        REFERENCES [dbo].[StaffAccounts]([staff_account_id]) ON DELETE CASCADE,
    CONSTRAINT [CK_RefreshTokens_AccountType] CHECK (
        ([account_type] = 'CUSTOMER' AND [customer_id] IS NOT NULL AND [staff_account_id] IS NULL)
        OR
        ([account_type] = 'STAFF' AND [staff_account_id] IS NOT NULL AND [customer_id] IS NULL)
    )
);
GO

-- ============================================================
-- TABLE: CheckInSession (NEW)
-- ============================================================
CREATE TABLE [dbo].[CheckInSession](
    [check_in_session_id] [bigint] IDENTITY(1,1) NOT NULL,
    [booking_id]          [bigint] NOT NULL,
    [video_url]           [nvarchar](500) NOT NULL,
    [video_public_id]     [nvarchar](255) NULL,
    [status]              [varchar](20) NOT NULL DEFAULT ('PENDING'),
    [reviewed_by]         [bigint] NULL,
    [created_at]          [datetime2](7) NOT NULL DEFAULT (sysdatetime()),
    [reviewed_at]         [datetime2](7) NULL,

    CONSTRAINT [PK_CheckInSession] PRIMARY KEY CLUSTERED ([check_in_session_id]),
    CONSTRAINT [FK_CheckInSession_Booking] FOREIGN KEY ([booking_id])
        REFERENCES [dbo].[Booking]([booking_id]),
    CONSTRAINT [FK_CheckInSession_Reviewer] FOREIGN KEY ([reviewed_by])
        REFERENCES [dbo].[StaffAccounts]([staff_account_id]),
    CONSTRAINT [CK_CheckInSession_Status] CHECK ([status] IN ('PENDING', 'APPROVED', 'REJECTED'))
);
GO

-- ============================================================
-- TABLE: HousekeepingTask (NEW)
-- ============================================================
CREATE TABLE [dbo].[HousekeepingTask](
    [task_id]      [bigint] IDENTITY(1,1) NOT NULL,
    [room_id]      [bigint] NOT NULL,
    [booking_id]   [bigint] NULL,
    [assigned_to]  [bigint] NULL,
    [created_by]   [bigint] NULL,
    [task_type]    [varchar](30) NOT NULL,
    [task_status]  [varchar](20) NOT NULL DEFAULT ('PENDING'),
    [priority]     [varchar](10) NOT NULL DEFAULT ('NORMAL'),
    [notes]        [nvarchar](1000) NULL,
    [created_at]   [datetime2](7) NOT NULL DEFAULT (sysdatetime()),
    [started_at]   [datetime2](7) NULL,
    [completed_at] [datetime2](7) NULL,

    CONSTRAINT [PK_HousekeepingTask] PRIMARY KEY CLUSTERED ([task_id]),
    CONSTRAINT [FK_HousekeepingTask_Room] FOREIGN KEY ([room_id])
        REFERENCES [dbo].[Room]([room_id]),
    CONSTRAINT [FK_HousekeepingTask_Booking] FOREIGN KEY ([booking_id])
        REFERENCES [dbo].[Booking]([booking_id]),
    CONSTRAINT [FK_HousekeepingTask_AssignedTo] FOREIGN KEY ([assigned_to])
        REFERENCES [dbo].[StaffAccounts]([staff_account_id]),
    CONSTRAINT [FK_HousekeepingTask_CreatedBy] FOREIGN KEY ([created_by])
        REFERENCES [dbo].[StaffAccounts]([staff_account_id]),
    CONSTRAINT [CK_HousekeepingTask_Type] CHECK ([task_type] IN (
        'CLEANING', 'MAINTENANCE', 'INSPECTION', 'OVERDUE_CHECKOUT'
    )),
    CONSTRAINT [CK_HousekeepingTask_Status] CHECK ([task_status] IN (
        'PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'
    )),
    CONSTRAINT [CK_HousekeepingTask_Priority] CHECK ([priority] IN (
        'LOW', 'NORMAL', 'HIGH', 'URGENT'
    ))
);
GO

-- ============================================================
-- TABLE: TaskChecklist (NEW)
-- ============================================================
CREATE TABLE [dbo].[TaskChecklist](
    [checklist_id] [bigint] IDENTITY(1,1) NOT NULL,
    [task_id]      [bigint] NOT NULL,
    [item_name]    [nvarchar](200) NOT NULL,
    [is_completed] [bit] NOT NULL DEFAULT (0),
    [completed_at] [datetime2](7) NULL,

    CONSTRAINT [PK_TaskChecklist] PRIMARY KEY CLUSTERED ([checklist_id]),
    CONSTRAINT [FK_TaskChecklist_Task] FOREIGN KEY ([task_id])
        REFERENCES [dbo].[HousekeepingTask]([task_id])
        ON DELETE CASCADE
);
GO

-- ============================================================
-- TABLE: RoomStatusLog (NEW)
-- ============================================================
CREATE TABLE [dbo].[RoomStatusLog](
    [log_id]          [bigint] IDENTITY(1,1) NOT NULL,
    [room_id]         [bigint] NOT NULL,
    [previous_status] [varchar](30) NULL,
    [new_status]      [varchar](30) NOT NULL,
    [changed_by]      [bigint] NULL,
    [change_reason]   [nvarchar](500) NULL,
    [booking_id]      [bigint] NULL,
    [created_at]      [datetime2](7) NOT NULL DEFAULT (sysdatetime()),

    CONSTRAINT [PK_RoomStatusLog] PRIMARY KEY CLUSTERED ([log_id]),
    CONSTRAINT [FK_RoomStatusLog_Room] FOREIGN KEY ([room_id])
        REFERENCES [dbo].[Room]([room_id]),
    CONSTRAINT [FK_RoomStatusLog_ChangedBy] FOREIGN KEY ([changed_by])
        REFERENCES [dbo].[StaffAccounts]([staff_account_id]),
    CONSTRAINT [FK_RoomStatusLog_Booking] FOREIGN KEY ([booking_id])
        REFERENCES [dbo].[Booking]([booking_id])
);
GO

-- ============================================================
-- INDEXES
-- ============================================================

-- Room status lookup (housekeeping dashboard)
CREATE NONCLUSTERED INDEX [IX_Room_Status]
ON [dbo].[Room] ([status])
INCLUDE ([room_number], [room_type_id])
WHERE [is_deleted] = 0;
GO

-- Active housekeeping tasks
CREATE NONCLUSTERED INDEX [IX_HousekeepingTask_Status_Type]
ON [dbo].[HousekeepingTask] ([task_status], [task_type])
INCLUDE ([room_id], [assigned_to], [priority], [created_at]);
GO

-- Tasks by assignee
CREATE NONCLUSTERED INDEX [IX_HousekeepingTask_AssignedTo]
ON [dbo].[HousekeepingTask] ([assigned_to], [task_status])
INCLUDE ([room_id], [task_type], [priority]);
GO

-- Booking by room and status
CREATE NONCLUSTERED INDEX [IX_Booking_Room_Status]
ON [dbo].[Booking] ([room_id], [booking_status])
INCLUDE ([customer_id], [check_in_time], [check_out_time]);
GO

-- Customer booking history
CREATE NONCLUSTERED INDEX [IX_Booking_Customer_CreatedAt]
ON [dbo].[Booking] ([customer_id], [created_at] DESC)
INCLUDE ([room_id], [booking_status], [total_amount]);
GO

-- Overdue checkout detection (filtered index)
CREATE NONCLUSTERED INDEX [IX_Booking_CheckedIn_CheckoutTime]
ON [dbo].[Booking] ([booking_status], [check_out_time])
INCLUDE ([room_id], [customer_id])
WHERE [booking_status] = 'CHECKED_IN';
GO

-- Room status history
CREATE NONCLUSTERED INDEX [IX_RoomStatusLog_Room_CreatedAt]
ON [dbo].[RoomStatusLog] ([room_id], [created_at] DESC)
INCLUDE ([previous_status], [new_status], [changed_by]);
GO

-- Task checklist items
CREATE NONCLUSTERED INDEX [IX_TaskChecklist_TaskId]
ON [dbo].[TaskChecklist] ([task_id])
INCLUDE ([item_name], [is_completed]);
GO

```

---

## Appendix A: Summary of Changes

### New Tables (4)

| Table | Rows Expected | Purpose |
|-------|--------------|---------|
| `CheckInSession` | 1 per check-in attempt | Video review workflow |
| `HousekeepingTask` | 1 per cleaning/maintenance event | Task management |
| `TaskChecklist` | ~5 per cleaning task | Cleaning quality control |
| `RoomStatusLog` | Grows with every status change | Audit trail |

### Modified Tables (5)

| Table | Change | Risk |
|-------|--------|------|
| `RoomType` | +3 nullable columns | Zero risk — additive |
| `Room` | Updated CHECK constraint | Low risk — existing values still valid |
| `StaffAccounts` | Updated role CHECK | Low risk — additive |
| `Booking` | +2 nullable columns, +CHECK | Low risk — nullable + additive |
| `Payment` | `paid_at` made nullable | Low risk — existing data preserved |

### Modified Constraints (2)

| Table | Old | New | Risk |
|-------|-----|-----|------|
| `Feedback` | `admin_id NOT NULL` | `admin_id NULL` | Low — relaxing constraint |
| `RoomAmenity` | No unique | `UNIQUE(room_id, amenity_id)` | Medium — must deduplicate first |

### New Indexes (8)

All non-clustered, non-unique indexes — zero risk, purely additive performance optimization.

---

## Appendix B: Service Layer Changes Required

The following code changes are needed after the database migration:

### 1. Checkout Service
```
OLD: Room.status = 'AVAILABLE'
NEW: Room.status = 'DIRTY'
     + Create HousekeepingTask(type=CLEANING, status=PENDING)
     + Log to RoomStatusLog
```

### 2. Check-in Approval Service
```
OLD: Room.status (unchanged or set to BOOKED)
NEW: Room.status = 'OCCUPIED'
     + Set Booking.actual_check_in_time = NOW()
     + Log to RoomStatusLog
```

### 3. New Scheduled Job: Overdue Checkout Detector
```
NEW: Run every 5-15 minutes
     Find CHECKED_IN bookings where check_out_time < NOW()
     Set Room.status = 'CHECKOUT_PENDING'
     Create HousekeepingTask(type=OVERDUE_CHECKOUT, priority=HIGH)
     Log to RoomStatusLog
```

### 4. New Housekeeping Controller/Service
```
NEW: HousekeepingController
     - GET /housekeeping/tasks (list active tasks)
     - GET /housekeeping/tasks/{id} (task detail + checklist)
     - POST /housekeeping/tasks/{id}/start (begin cleaning)
     - POST /housekeeping/tasks/{id}/complete (finish cleaning)
     - POST /housekeeping/tasks/{id}/maintenance (report issue)
     - PUT /housekeeping/tasks/{id}/checklist/{checklistId} (toggle item)
```

### 5. Room Pricing Read Logic
```
OLD: price = room.getBasePrice()
NEW: price = roomType.getBasePrice() != null ? roomType.getBasePrice() : room.getBasePrice()
```

### 6. Payment Success Handler
```
OLD: paid_at set automatically by DEFAULT
NEW: Explicitly SET paid_at = sysdatetime() only when payment_status → SUCCESS
```

---

*End of Report*

