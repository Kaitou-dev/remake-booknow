# Business Rules

## Authentication & Account Rules

### BR-01: Email Uniqueness
- **Rule**: Each email address must be unique within the Customer table and within the StaffAccount table.
- **Enforcement**: DB UNIQUE constraint on `Customer.email` and `StaffAccount.email`. Application-level check before insert.

### BR-02: Password Complexity
- **Rule**: Passwords must be at least 8 characters and contain at least one uppercase letter, one lowercase letter, and one number.
- **Enforcement**: Service-layer validation (`validateNewPasswordRules`).

### BR-03: OTP Expiration
- **Rule**: OTP codes for registration and password reset expire after 1 minute.
- **Enforcement**: Service-layer timestamp comparison in `validateOtp`.

### BR-04: Email Immutability
- **Rule**: A customer's email address cannot be changed after registration.
- **Enforcement**: `UpdateProfileService.updateCustomerProfile` rejects email changes.

### BR-05: Refresh Token Single Owner
- **Rule**: A refresh token must belong to exactly one owner — either a Customer or a StaffAccount, never both and never neither.
- **Enforcement**: DB CHECK constraint `CK_RefreshToken_Owner`: `(customer_id IS NOT NULL AND admin_id IS NULL) OR (customer_id IS NULL AND admin_id IS NOT NULL)`.

### BR-06: Phone Number Uniqueness
- **Rule**: A customer's phone number must be unique across all customer accounts.
- **Enforcement**: Application-level query `SELECT COUNT(*) FROM Customer WHERE phone = ? AND customer_id <> ?` before profile update.

---

## Booking Rules

### BR-07: ID Card Required for Booking
- **Rule**: A booking cannot be created without uploading both the front and back images of the customer's ID card.
- **Enforcement**: `id_card_front_url` and `id_card_back_url` are NOT NULL in the Booking table.

### BR-08: Booking Status Transition Order
- **Rule**: Booking status must follow the defined lifecycle: `PENDING` → `WAITING_PAYMENT` → `PAID` → `CHECKED_IN` → `CHECKED_OUT` → `COMPLETED`. No skipping or backward transitions.
- **Enforcement**: Service-layer validation in `UpdateBookingStatusService` methods (`approveBooking`, `confirmPayment`, `approveCheckInAndAssignRoom`).
- **DB Constraint**: `CHECK (booking_status IN ('PENDING', 'WAITING_PAYMENT', 'PAID', 'CHECKED_IN', 'CHECKED_OUT', 'COMPLETED', 'CANCELLED'))`

### BR-09: Check-out Requires Checked-in State
- **Rule**: A booking can only be checked out if its current status is `CHECKED_IN`.
- **Enforcement**: `CheckoutService.getBookingForCheckout` validates the status before processing.

### BR-10: Check-out Triggers Room Cleaning
- **Rule**: When a booking is checked out, the associated room must be automatically set to `DIRTY` status (not `AVAILABLE`).
- **Enforcement**: `UPDATE Room SET status = 'DIRTY' WHERE room_id = (SELECT room_id FROM Booking WHERE booking_id = ?)` executed during checkout.

### BR-11: Check-out Creates Cleaning Task
- **Rule**: When a booking is checked out, the system must automatically create a `HousekeepingTask` with `task_type = 'CLEANING'` for the room.
- **Enforcement**: Service-layer auto-creation in `CheckoutService`.

---

## Payment Rules

### BR-12: Payment Window
- **Rule**: Payment must be completed within 15 minutes of booking creation. After 15 minutes, the payment request is rejected.
- **Enforcement**: `MoMoGatewayService.validateCallbackSignature` checks `current time ≤ createdAt + 15 minutes`.

### BR-13: Payment Signature Verification
- **Rule**: All MoMo payment callbacks must be verified by recalculating the HMAC-SHA256 signature using the secret key and comparing it with the signature provided by MoMo.
- **Enforcement**: `PaymentService.verifyAndCompletePayment` performs cryptographic signature validation.

### BR-14: Payment Precedes Check-in
- **Rule**: A booking must have a successful payment (Payment.payment_status = 'SUCCESS') before staff can confirm payment status and the booking can proceed to check-in.
- **Enforcement**: `PaymentRepository.findByBookingId` checked before confirming payment in booking status update.

### BR-15: Payment Timestamp on Success
- **Rule**: The `paid_at` timestamp must only be set when payment is successful, not at record creation.
- **Enforcement**: `paid_at` is nullable. Set explicitly in payment success handler.

---

## Room Rules

### BR-16: Unique Room Number
- **Rule**: No two active (non-deleted) rooms can share the same room number.
- **Enforcement**: `RoomRepository.existsByRoomNumber` check on create. `existsByRoomNumberExceptId` check on update.

### BR-17: Room Deletion Blocked by Active Bookings
- **Rule**: A room cannot be deleted (even soft-deleted) if it has any active bookings (status = 'CONFIRMED' and currently within the check-in/check-out time range).
- **Enforcement**: `existsActiveBooking(roomId)` query checked before soft delete.

### BR-18: Soft Delete Only
- **Rule**: Rooms are never physically deleted. Deletion sets `is_deleted = 1`.
- **Enforcement**: All delete operations use `UPDATE Room SET is_deleted = 1` rather than `DELETE FROM Room`.

### BR-19: Room Status Values
- **Rule**: Room status must be one of: `AVAILABLE`, `BOOKED`, `OCCUPIED`, `CHECKOUT_PENDING`, `DIRTY`, `CLEANING`, `MAINTENANCE`, `OUT_OF_SERVICE`.
- **Enforcement**: DB CHECK constraint `CHECK (status IN ('AVAILABLE', 'BOOKED', 'OCCUPIED', 'CHECKOUT_PENDING', 'DIRTY', 'CLEANING', 'MAINTENANCE', 'OUT_OF_SERVICE'))`.

### BR-20: Room Booking Restrictions
- **Rule**: A room can only be booked if its status is `AVAILABLE`. Rooms with status `DIRTY`, `CLEANING`, `MAINTENANCE`, or `OUT_OF_SERVICE` cannot be booked.
- **Enforcement**: Service-layer validation in `BookingService.createBooking`.

### BR-21: Room Status Changes Logged
- **Rule**: Every room status change must be logged to `RoomStatusLog` for audit trail.
- **Enforcement**: Service-layer interceptor or trigger inserts log record on each status change.

### BR-22: Room Price on Type
- **Rule**: Room pricing (`base_price`, `over_price`) should be defined at the `RoomType` level for consistency across all rooms of the same type.
- **Enforcement**: Application reads price from `RoomType` first; `Room`-level prices are deprecated.

---

## Room Lifecycle Rules

### BR-23: Payment Reserves Room
- **Rule**: When a booking payment is successful, the room status must change from `AVAILABLE` to `BOOKED`.
- **Enforcement**: Service-layer update in payment success handler.

### BR-24: Check-in Occupies Room
- **Rule**: When admin approves a check-in, the room status must change from `BOOKED` to `OCCUPIED`.
- **Enforcement**: Service-layer update in check-in approval handler.

### BR-25: Checkout Dirties Room
- **Rule**: When customer confirms checkout, the room status must change from `OCCUPIED` to `DIRTY`.
- **Enforcement**: Service-layer update in checkout handler.

### BR-26: Cleaning Required Before Available
- **Rule**: A room cannot transition directly from `DIRTY` to `AVAILABLE`. It must go through `CLEANING` status first.
- **Enforcement**: Service-layer validation in room status change methods.

### BR-27: Maintenance Blocks Booking
- **Rule**: A room with status `MAINTENANCE` or `OUT_OF_SERVICE` cannot accept new bookings until status returns to `AVAILABLE`.
- **Enforcement**: Booking creation checks room status in `BookingService`.

---

## Housekeeping Rules

### BR-28: Cleaning Task Auto-Creation
- **Rule**: A cleaning task must be automatically created when any room transitions to `DIRTY` status.
- **Enforcement**: Service-layer trigger in checkout and forced checkout flows.

### BR-29: Task Assignment Not Required
- **Rule**: A housekeeping task can exist without assignment. Unassigned tasks appear in the common queue.
- **Enforcement**: `assigned_to` is nullable in `HousekeepingTask` table.

### BR-30: Task Status Progression
- **Rule**: Task status must follow: `PENDING` → `IN_PROGRESS` → `COMPLETED`. No backward transitions except for cancellation.
- **Enforcement**: Service-layer validation in task status update methods.
- **DB Constraint**: `CHECK (task_status IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'))`

### BR-31: Cleaning Starts Room Cleaning
- **Rule**: When a housekeeping task with `task_type = 'CLEANING'` transitions to `IN_PROGRESS`, the room status must change from `DIRTY` to `CLEANING`.
- **Enforcement**: Service-layer side effect in task start handler.

### BR-32: Cleaning Completion Releases Room
- **Rule**: When a cleaning task is marked `COMPLETED` with no maintenance issues reported, the room status must change to `AVAILABLE`.
- **Enforcement**: Service-layer side effect in task completion handler.

### BR-33: Maintenance Issue Blocks Room
- **Rule**: When a housekeeping member reports a maintenance issue during cleaning, the room status must change to `MAINTENANCE` and a new maintenance task must be created.
- **Enforcement**: Service-layer logic in maintenance report handler.

### BR-34: Task Type Values
- **Rule**: Housekeeping task type must be one of: `CLEANING`, `MAINTENANCE`, `INSPECTION`, `OVERDUE_CHECKOUT`.
- **Enforcement**: DB CHECK constraint `CHECK (task_type IN ('CLEANING', 'MAINTENANCE', 'INSPECTION', 'OVERDUE_CHECKOUT'))`.

### BR-35: Task Priority Values
- **Rule**: Task priority must be one of: `LOW`, `NORMAL`, `HIGH`, `URGENT`.
- **Enforcement**: DB CHECK constraint `CHECK (priority IN ('LOW', 'NORMAL', 'HIGH', 'URGENT'))`.

---

## Overdue Checkout Rules

### BR-36: Overdue Detection
- **Rule**: The system must detect rooms past checkout time where booking status is `CHECKED_IN` and room status is `OCCUPIED`.
- **Enforcement**: Scheduled job runs every 5-15 minutes with query:
```sql
SELECT booking_id, room_id FROM Booking b
JOIN Room r ON b.room_id = r.room_id
WHERE b.booking_status = 'CHECKED_IN'
  AND r.status = 'OCCUPIED'
  AND b.check_out_time < GETDATE()
```

### BR-37: Overdue Flags Room
- **Rule**: When an overdue checkout is detected, the room status must change from `OCCUPIED` to `CHECKOUT_PENDING`.
- **Enforcement**: Scheduled job updates room status and creates `HousekeepingTask` with `task_type = 'OVERDUE_CHECKOUT'`.

### BR-38: Force Checkout Available
- **Rule**: Staff can force checkout a room in `CHECKOUT_PENDING` status, which transitions the room to `DIRTY` and the booking to `CHECKED_OUT`.
- **Enforcement**: `ForceCheckoutService` validates room status before processing.

---

## Feedback Rules

### BR-39: Rating Range
- **Rule**: Feedback rating must be between 1 and 5 (inclusive).
- **Enforcement**: DB CHECK constraint `CHECK (rating BETWEEN 1 AND 5)`.

### BR-40: Feedback Linked to Booking
- **Rule**: Every feedback entry must be associated with a valid booking.
- **Enforcement**: `booking_id` is NOT NULL FK in Feedback table.

### BR-41: Feedback Visibility Control
- **Rule**: Staff can hide or show individual feedback items. Hidden feedback should not be displayed to customers.
- **Enforcement**: `is_hidden` BIT flag on Feedback, toggled by `FeedbackVisibilityService`.

### BR-42: Feedback Admin ID Optional
- **Rule**: Feedback can be created without an admin assignment. `admin_id` is only set when staff replies.
- **Enforcement**: `admin_id` is nullable in Feedback table.

---

## User Management Rules

### BR-43: Account Status Values
- **Rule**: Customer and StaffAccount status must be one of: `ACTIVE`, `INACTIVE`.
- **Enforcement**: DB CHECK constraint `CHECK (status IN ('ACTIVE', 'INACTIVE'))`.

### BR-44: Staff Role Values
- **Rule**: StaffAccount role must be one of: `ADMIN`, `STAFF`, `HOUSEKEEPING`.
- **Enforcement**: DB CHECK constraint `CHECK (role IN ('ADMIN', 'STAFF', 'HOUSEKEEPING'))`.

### BR-45: Only Admin Creates Staff
- **Rule**: Only users with role `ADMIN` can create new staff accounts or update staff roles.
- **Enforcement**: Role check query `SELECT role FROM StaffAccount WHERE admin_id = ? AND role = 'ADMIN'` before creation.

### BR-46: Inactive Accounts Cannot Login
- **Rule**: Users with status `INACTIVE` must be prevented from logging in.
- **Enforcement**: Service-layer check during authentication (`status = 'ACTIVE'` in queries).

---

## Reporting Rules

### BR-47: Revenue Counts Completed Bookings Only
- **Rule**: Revenue reports only aggregate bookings with `booking_status = 'COMPLETED'` from non-deleted rooms.
- **Enforcement**: WHERE clause `b.booking_status = 'COMPLETED' AND r.is_deleted = 0` in all revenue report queries.

---

## Audit & Logging Rules

### BR-48: Room Status Log Required
- **Rule**: Every room status transition must create a `RoomStatusLog` entry with previous status, new status, timestamp, and actor (if applicable).
- **Enforcement**: Service-layer logging in all room status change methods.

### BR-49: Booking Timestamp Tracking
- **Rule**: Bookings must track both planned (`check_in_time`, `check_out_time`) and actual (`actual_check_in_time`, `actual_check_out_time`) timestamps.
- **Enforcement**: `actual_*` columns set during check-in approval and checkout confirmation.
