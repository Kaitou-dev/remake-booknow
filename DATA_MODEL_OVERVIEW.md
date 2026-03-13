# Data Model Overview

## Entity Summary

| # | Entity | Description | Key Attributes |
|---|--------|-------------|---------------|
| 01 | **Customer** | Registered guest user | `customer_id` (PK), `email` (UNIQUE), `password_hash`, `full_name`, `avatar_url`, `phone`, `status`, `created_at`, `updated_at`, `is_deleted` |
| 02 | **StaffAccount** | Staff, admin, or housekeeping user account | `staff_account_id` (PK), `email` (UNIQUE), `phone`, `password_hash`, `full_name`, `avatar_url`, `role` (ADMIN/STAFF/HOUSEKEEPING), `status`, `created_at`, `is_deleted` |
| 03 | **RefreshToken** | JWT refresh token for session management | `id` (PK), `customer_id` (FK, nullable), `staff_account_id` (FK, nullable), `token_hash` (UNIQUE), `is_revoked`, `revoked_at`, `expires_at`, `created_at` |
| 04 | **RoomType** | Category/classification of rooms | `room_type_id` (PK), `name` (UNIQUE), `description`, `base_price`, `over_price`, `max_guests`, `image_url`, `is_deleted` |
| 05 | **Room** | Individual bookable room | `room_id` (PK), `room_type_id` (FK→RoomType), `room_number` (UNIQUE), `status`, `area_m2`, `is_deleted` |
| 06 | **Amenity** | Feature/facility available in rooms | `amenity_id` (PK), `name` (UNIQUE), `icon_url`, `is_deleted` |
| 07 | **RoomAmenity** | Many-to-many link between Room and Amenity | `room_amenity_id` (PK), `amenity_id` (FK→Amenity), `room_id` (FK→Room), UNIQUE(`room_id`, `amenity_id`) |
| 08 | **Image** | Room photos | `image_id` (PK), `room_id` (FK→Room), `image_url`, `is_cover` (BIT) |
| 09 | **Booking** | Customer room reservation | `booking_id` (PK), `customer_id` (FK→Customer), `room_id` (FK→Room), `check_in_time`, `check_out_time`, `actual_check_in_time`, `actual_check_out_time`, `id_card_front_url`, `id_card_back_url`, `booking_status`, `total_amount`, `booking_code`, `note`, `created_at`, `update_at` |
| 10 | **Payment** | Payment transaction for a booking | `payment_id` (PK), `booking_id` (FK→Booking), `amount`, `method`, `payment_status`, `paid_at` (nullable) |
| 11 | **Invoice** | Issued invoice for a booking | `invoice_id` (PK), `booking_id` (FK→Booking), `invoice_number` (UNIQUE), `issued_at` |
| 12 | **Feedback** | Customer review/rating for a booking | `feedback_id` (PK), `booking_id` (FK→Booking), `admin_id` (FK→StaffAccount, nullable), `rating` (1–5), `content`, `content_reply`, `is_hidden`, `created_at` |
| 13 | **Timetable** | Time slots for scheduling | `timetable_id` (PK), `slot_name`, `start_time`, `end_time` |
| 14 | **Scheduler** | Links bookings to timetable slots | `scheduler_id` (PK), `booking_id` (FK→Booking), `timetable_id` (FK→Timetable), `date` |
| 15 | **CheckInSession** | Check-in video submission and approval tracking | `check_in_session_id` (PK), `booking_id` (FK→Booking), `video_url`, `video_public_id`, `status`, `reviewed_by` (FK→StaffAccount, nullable), `created_at`, `reviewed_at` |
| 16 | **HousekeepingTask** | Cleaning, maintenance, and inspection tasks | `task_id` (PK), `room_id` (FK→Room), `booking_id` (FK→Booking, nullable), `assigned_to` (FK→StaffAccount, nullable), `created_by` (FK→StaffAccount, nullable), `task_type`, `task_status`, `priority`, `notes`, `created_at`, `started_at`, `completed_at` |
| 17 | **TaskChecklist** | Individual checklist items within a housekeeping task | `checklist_id` (PK), `task_id` (FK→HousekeepingTask), `item_name`, `is_completed`, `completed_at` |
| 18 | **RoomStatusLog** | Audit trail for room status changes | `log_id` (PK), `room_id` (FK→Room), `previous_status`, `new_status`, `changed_by` (FK→StaffAccount, nullable), `change_reason`, `booking_id` (FK→Booking, nullable), `created_at` |

---

## Entity Relationships

```
Customer ──────────< Booking >──────────── Room ──────── RoomType
    │                   │                    │
    │                   ├──< Payment         ├──<< RoomAmenity >>──── Amenity
    │                   │                    │
    │                   ├──< Invoice         ├──< Image
    │                   │                    │
    │                   ├──< Feedback ──┐    ├──< RoomStatusLog
    │                   │               │    │
    │                   ├──< Scheduler  │    └──< HousekeepingTask ──< TaskChecklist
    │                   │    │          │              │
    │                   └──< CheckIn    │              │
    │                        Session    │              │
    │                                   │              │
    └──< RefreshToken >── StaffAccount ◄──────────────┘
                              │
                              ├── assigned_to (HousekeepingTask)
                              ├── created_by (HousekeepingTask)
                              ├── changed_by (RoomStatusLog)
                              ├── reviewed_by (CheckInSession)
                              └── admin_id (Feedback)
```

### Relationship Details

| Relationship | Cardinality | Description |
|-------------|-------------|-------------|
| Customer → Booking | 1 : N | A customer can have many bookings |
| Room → Booking | 1 : N | A room can be associated with many bookings (over time) |
| Booking → Payment | 1 : N | A booking can have multiple payment attempts |
| Booking → Invoice | 1 : N | A booking can have one or more invoices |
| Booking → Feedback | 1 : N | A booking can have feedback entries |
| Booking → Scheduler | 1 : N | A booking maps to one or more timetable slots |
| Booking → CheckInSession | 1 : N | A booking can have check-in session records |
| Room → RoomType | N : 1 | Each room belongs to exactly one room type |
| Room ↔ Amenity | N : M | Many-to-many via RoomAmenity junction table |
| Room → Image | 1 : N | A room has multiple images; one can be `is_cover = 1` |
| Room → RoomStatusLog | 1 : N | A room has many status change log entries |
| Room → HousekeepingTask | 1 : N | A room can have many housekeeping tasks over time |
| HousekeepingTask → TaskChecklist | 1 : N | A task has multiple checklist items (CASCADE delete) |
| HousekeepingTask → Booking | N : 1 | A task may be linked to a specific booking (nullable) |
| Scheduler → Timetable | N : 1 | Each scheduler entry references one timetable slot |
| StaffAccount → Feedback | 1 : N | Admin who replies to feedback |
| StaffAccount → HousekeepingTask (assigned_to) | 1 : N | Staff assigned to housekeeping tasks |
| StaffAccount → HousekeepingTask (created_by) | 1 : N | Staff who created the task |
| StaffAccount → RoomStatusLog | 1 : N | Staff who changed room status |
| StaffAccount → CheckInSession | 1 : N | Admin who reviewed check-in video |
| Customer → RefreshToken | 1 : N | Customer session tokens |
| StaffAccount → RefreshToken | 1 : N | Staff/Admin/Housekeeping session tokens |

---

## New Tables (Housekeeping Module)

### HousekeepingTask

Central table for tracking cleaning, maintenance, and inspection tasks.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `task_id` | BIGINT IDENTITY | PK | Auto-increment identifier |
| `room_id` | BIGINT | FK → Room, NOT NULL | Room this task applies to |
| `booking_id` | BIGINT | FK → Booking, NULL | Associated booking (if applicable) |
| `assigned_to` | BIGINT | FK → StaffAccount, NULL | Housekeeping staff assigned |
| `created_by` | BIGINT | FK → StaffAccount, NULL | Staff who created task (NULL = system) |
| `task_type` | VARCHAR(30) | NOT NULL, CHECK | CLEANING, MAINTENANCE, INSPECTION, OVERDUE_CHECKOUT |
| `task_status` | VARCHAR(20) | NOT NULL, DEFAULT 'PENDING' | PENDING, IN_PROGRESS, COMPLETED, CANCELLED |
| `priority` | VARCHAR(10) | NOT NULL, DEFAULT 'NORMAL' | LOW, NORMAL, HIGH, URGENT |
| `notes` | NVARCHAR(1000) | NULL | Staff notes about the task |
| `created_at` | DATETIME2 | NOT NULL, DEFAULT NOW | Task creation timestamp |
| `started_at` | DATETIME2 | NULL | When task was started |
| `completed_at` | DATETIME2 | NULL | When task was completed |

**Workflow Integration**:
- Created automatically when room becomes DIRTY (checkout)
- Created automatically when overdue checkout detected
- Created manually by staff for maintenance/inspection

### TaskChecklist

Pre-defined checklist items for cleaning tasks.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `checklist_id` | BIGINT IDENTITY | PK | Auto-increment identifier |
| `task_id` | BIGINT | FK → HousekeepingTask, NOT NULL, ON DELETE CASCADE | Parent task |
| `item_name` | NVARCHAR(200) | NOT NULL | Description of checklist item |
| `is_completed` | BIT | NOT NULL, DEFAULT 0 | Whether item is done |
| `completed_at` | DATETIME2 | NULL | When item was completed |

**Standard Cleaning Checklist Items**:
- Change bedsheets
- Clean bathroom
- Vacuum/mop floor
- Restock amenities
- Check minibar
- Inspect for damage
- Wipe surfaces
- Empty trash

### RoomStatusLog

Audit trail for every room status change.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `log_id` | BIGINT IDENTITY | PK | Auto-increment identifier |
| `room_id` | BIGINT | FK → Room, NOT NULL | Room that changed status |
| `previous_status` | VARCHAR(30) | NULL | Status before change (NULL for initial) |
| `new_status` | VARCHAR(30) | NOT NULL | Status after change |
| `changed_by` | BIGINT | FK → StaffAccount, NULL | Staff who made change (NULL = system) |
| `change_reason` | NVARCHAR(500) | NULL | Description of why status changed |
| `booking_id` | BIGINT | FK → Booking, NULL | Related booking (if applicable) |
| `created_at` | DATETIME2 | NOT NULL, DEFAULT NOW | When change occurred |

**Use Cases**:
- Debug room availability issues
- Audit housekeeping performance
- Track maintenance history
- Investigate guest complaints

### CheckInSession (Updated)

Tracks check-in video submissions and admin reviews.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `check_in_session_id` | BIGINT IDENTITY | PK | Auto-increment identifier |
| `booking_id` | BIGINT | FK → Booking, NOT NULL | Associated booking |
| `video_url` | NVARCHAR(500) | NOT NULL | Cloudinary video URL |
| `video_public_id` | NVARCHAR(255) | NULL | Cloudinary public ID for deletion |
| `status` | VARCHAR(20) | NOT NULL, DEFAULT 'PENDING' | PENDING, APPROVED, REJECTED |
| `reviewed_by` | BIGINT | FK → StaffAccount, NULL | Admin who reviewed |
| `created_at` | DATETIME2 | NOT NULL, DEFAULT NOW | Video upload timestamp |
| `reviewed_at` | DATETIME2 | NULL | When admin reviewed |

---

## Key Data Constraints

| Entity | Constraint | Details |
|--------|-----------|---------|
| Customer | Status CHECK | `IN ('ACTIVE', 'INACTIVE')`, default `ACTIVE` |
| StaffAccount | Role CHECK | `IN ('ADMIN', 'STAFF', 'HOUSEKEEPING')` |
| StaffAccount | Status CHECK | `IN ('ACTIVE', 'INACTIVE')`, default `ACTIVE` |
| Room | Status CHECK | `IN ('AVAILABLE', 'BOOKED', 'OCCUPIED', 'CHECKOUT_PENDING', 'DIRTY', 'CLEANING', 'MAINTENANCE', 'OUT_OF_SERVICE')`, default `AVAILABLE` |
| Booking | Status CHECK | `IN ('PENDING', 'WAITING_PAYMENT', 'PAID', 'CHECKED_IN', 'CHECKED_OUT', 'COMPLETED', 'CANCELLED')` |
| Feedback | Rating CHECK | `BETWEEN 1 AND 5` |
| Feedback | admin_id | NULLABLE — only set when staff replies |
| Payment | paid_at | NULLABLE — only set on successful payment |
| RefreshToken | Owner CHECK | Exactly one of `customer_id` or `staff_account_id` must be NOT NULL |
| RoomAmenity | Unique | `UNIQUE (room_id, amenity_id)` — prevent duplicates |
| HousekeepingTask | Type CHECK | `IN ('CLEANING', 'MAINTENANCE', 'INSPECTION', 'OVERDUE_CHECKOUT')` |
| HousekeepingTask | Status CHECK | `IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')` |
| HousekeepingTask | Priority CHECK | `IN ('LOW', 'NORMAL', 'HIGH', 'URGENT')` |
| CheckInSession | Status CHECK | `IN ('PENDING', 'APPROVED', 'REJECTED')` |
| All entities | Soft Delete | `is_deleted BIT DEFAULT 0` — records are never physically deleted |

---

## Data Types Reference

| Type | SQL Server Type | Usage |
|------|----------------|-------|
| Primary Keys | `BIGINT IDENTITY` (or `INT` for Customer) | Auto-increment identifiers |
| Money | `DECIMAL(12,2)` | Prices, amounts |
| Short Text | `NVARCHAR(50–255)` | Names, emails, phone numbers |
| Long Text | `NVARCHAR(500–1000)` | Descriptions, URLs, content, notes |
| Boolean Flags | `BIT` | `is_deleted`, `is_cover`, `is_hidden`, `is_revoked`, `is_completed` |
| Timestamps | `DATETIME2` / `DATE` | Created/updated/expired timestamps |
| Status Fields | `VARCHAR(20–50)` / `NVARCHAR(20)` | Constrained status enums |

---

## Index Recommendations

| Table | Index | Columns | Purpose |
|-------|-------|---------|---------|
| Room | IX_Room_Status | `status` INCLUDE `room_number`, `room_type_id` WHERE `is_deleted = 0` | Housekeeping dashboard queries |
| HousekeepingTask | IX_HousekeepingTask_Status_Type | `task_status`, `task_type` INCLUDE `room_id`, `assigned_to`, `priority` | Task list queries |
| HousekeepingTask | IX_HousekeepingTask_AssignedTo | `assigned_to`, `task_status` INCLUDE `room_id`, `task_type`, `priority` | "My tasks" queries |
| Booking | IX_Booking_Room_Status | `room_id`, `booking_status` INCLUDE `customer_id`, `check_in_time`, `check_out_time` | Room availability checks |
| Booking | IX_Booking_CheckedIn_CheckoutTime | `booking_status`, `check_out_time` INCLUDE `room_id`, `customer_id` WHERE `booking_status = 'CHECKED_IN'` | Overdue detection |
| RoomStatusLog | IX_RoomStatusLog_Room_CreatedAt | `room_id`, `created_at DESC` INCLUDE `previous_status`, `new_status`, `changed_by` | Room history lookup |
| TaskChecklist | IX_TaskChecklist_TaskId | `task_id` INCLUDE `item_name`, `is_completed` | Checklist retrieval |
