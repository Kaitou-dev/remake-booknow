# Data Model Overview

## Entity Summary

| # | Entity | Description | Key Attributes |
|---|--------|-------------|---------------|
| 01 | **Customer** | Registered guest user | `customer_id` (PK), `email` (UNIQUE), `password_hash`, `full_name`, `avatar_url`, `phone`, `status`, `created_at`, `updated_at`, `is_deleted` |
| 02 | **StaffAccount** | Staff or admin user account | `staff_account_id` (PK), `email` (UNIQUE), `phone`, `password_hash`, `full_name`, `avatar_url`, `role` (ADMIN/STAFF), `status`, `created_at`, `is_deleted` |
| 03 | **RefreshToken** | JWT refresh token for session management | `id` (PK), `customer_id` (FK, nullable), `staff_account_id` (FK, nullable), `token_hash` (UNIQUE), `is_revoked`, `revoked_at`, `expires_at`, `created_at` |
| 04 | **RoomType** | Category/classification of rooms | `room_type_id` (PK), `name` (UNIQUE), `description`, `base_price`, `over_price`, `max_guests`, `image_url`, `is_deleted` |
| 05 | **Room** | Individual bookable room | `room_id` (PK), `room_type_id` (FK→RoomType), `room_number` (UNIQUE), `status`, `area_m2`, `is_deleted` |
| 06 | **Amenity** | Feature/facility available in rooms | `amenity_id` (PK), `name` (UNIQUE), `icon_url`, `is_deleted` |
| 07 | **RoomAmenity** | Many-to-many link between Room and Amenity | `room_amenity_id` (PK), `amenity_id` (FK→Amenity), `room_id` (FK→Room) |
| 08 | **Image** | Room photos | `image_id` (PK), `room_id` (FK→Room), `image_url`, `is_cover` (BIT) |
| 09 | **Booking** | Customer room reservation | `booking_id` (PK), `customer_id` (FK→Customer), `room_id` (FK→Room), `check_in_time`, `check_out_time`, `id_card_front_url`, `id_card_back_url`, `booking_status`, `total_amount`, `booking_code`, `note`, `created_at` |
| 10 | **Payment** | Payment transaction for a booking | `payment_id` (PK), `booking_id` (FK→Booking), `amount`, `method`, `payment_status`, `paid_at` |
| 11 | **Invoice** | Issued invoice for a booking | `invoice_id` (PK), `booking_id` (FK→Booking), `invoice_number` (UNIQUE), `issued_at` |
| 12 | **Feedback** | Customer review/rating for a booking | `feedback_id` (PK), `booking_id` (FK→Booking), `admin_id` (FK→StaffAccount), `rating` (1–5), `content`, `content_reply`, `is_hidden`, `created_at` |
| 13 | **Timetable** | Time slots for scheduling | `timetable_id` (PK), `slot_name`, `start_time`, `end_time` |
| 14 | **Scheduler** | Links bookings to timetable slots | `scheduler_id` (PK), `booking_id` (FK→Booking), `timetable_id` (FK→Timetable), `date` |
| 15 | **CheckInSession** | Check-in video submission and approval tracking | `id` (PK), `booking_id` (FK→Booking), `video_url`, `status`, `created_at` |

---

## Entity Relationships

```
Customer ──────────< Booking >──────────── Room
    │                   │                    │
    │                   ├──< Payment         ├──── RoomType
    │                   │                    │
    │                   ├──< Invoice         ├──<< RoomAmenity >>──── Amenity
    │                   │                    │
    │                   ├──< Feedback        ├──< Image
    │                   │
    │                   ├──< Scheduler >──── Timetable
    │                   │
    │                   └──< CheckInSession
    │
    └──< RefreshToken >── StaffAccount
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
| Scheduler → Timetable | N : 1 | Each scheduler entry references one timetable slot |
| StaffAccount → Feedback | 1 : N | Admin who replies to feedback |
| Customer → RefreshToken | 1 : N | Customer session tokens |
| StaffAccount → RefreshToken | 1 : N | Staff/Admin session tokens |

---

## Key Data Constraints

| Entity | Constraint | Details |
|--------|-----------|---------|
| Customer | Status CHECK | `IN ('ACTIVE', 'INACTIVE')`, default `ACTIVE` |
| StaffAccount | Role CHECK | `IN ('ADMIN', 'STAFF')` |
| StaffAccount | Status CHECK | `IN ('ACTIVE', 'INACTIVE')`, default `ACTIVE` |
| Room | Status CHECK | `IN ('AVAILABLE', 'BOOKED', 'MAINTENANCE')`, default `AVAILABLE` |
| Feedback | Rating CHECK | `BETWEEN 1 AND 5` |
| RefreshToken | Owner CHECK | Exactly one of `customer_id` or `staff_account_id` must be NOT NULL |
| All entities | Soft Delete | `is_deleted BIT DEFAULT 0` — records are never physically deleted |

---

## Data Types Reference

| Type | SQL Server Type | Usage |
|------|----------------|-------|
| Primary Keys | `BIGINT IDENTITY` (or `INT` for Customer) | Auto-increment identifiers |
| Money | `DECIMAL(12,2)` | Prices, amounts |
| Short Text | `NVARCHAR(50–255)` | Names, emails, phone numbers |
| Long Text | `NVARCHAR(500–1000)` | Descriptions, URLs, content |
| Boolean Flags | `BIT` | `is_deleted`, `is_cover`, `is_hidden`, `is_revoked` |
| Timestamps | `DATETIME2` / `DATE` | Created/updated/expired timestamps |
| Status Fields | `VARCHAR(20–50)` / `NVARCHAR(20)` | Constrained status enums |
