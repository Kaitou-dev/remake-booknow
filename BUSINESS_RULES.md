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
- **Rule**: Booking status must follow the defined lifecycle: `PENDING` → `WAITING_PAYMENT` → `PAID` → `CHECKED_IN` → `CHECKED_OUT`. No skipping or backward transitions.
- **Enforcement**: Service-layer validation in `UpdateBookingStatusService` methods (`approveBooking`, `confirmPayment`, `approveCheckInAndAssignRoom`).

### BR-09: Check-out Requires Checked-in State
- **Rule**: A booking can only be checked out if its current status is `CHECKED_IN`.
- **Enforcement**: `CheckoutService.getBookingForCheckout` validates the status before processing.

### BR-10: Check-out Releases Room
- **Rule**: When a booking is checked out, the associated room must be automatically set back to `AVAILABLE`.
- **Enforcement**: `UPDATE Room SET status = 'AVAILABLE' WHERE room_id = (SELECT room_id FROM Booking WHERE booking_id = ?)` executed during checkout.

---

## Payment Rules

### BR-11: Payment Window
- **Rule**: Payment must be completed within 15 minutes of booking creation. After 15 minutes, the payment request is rejected.
- **Enforcement**: `MoMoGatewayService.validateCallbackSignature` checks `current time ≤ createdAt + 15 minutes`.

### BR-12: Payment Signature Verification
- **Rule**: All MoMo payment callbacks must be verified by recalculating the HMAC-SHA256 signature using the secret key and comparing it with the signature provided by MoMo.
- **Enforcement**: `PaymentService.verifyAndCompletePayment` performs cryptographic signature validation.

### BR-13: Payment Precedes Check-in
- **Rule**: A booking must have a successful payment (Payment.payment_status = 'SUCCESS') before staff can confirm payment status and the booking can proceed to check-in.
- **Enforcement**: `PaymentRepository.findByBookingId` checked before confirming payment in booking status update.

---

## Room Rules

### BR-14: Unique Room Number
- **Rule**: No two active (non-deleted) rooms can share the same room number.
- **Enforcement**: `RoomRepository.existsByRoomNumber` check on create. `existsByRoomNumberExceptId` check on update.

### BR-15: Room Deletion Blocked by Active Bookings
- **Rule**: A room cannot be deleted (even soft-deleted) if it has any active bookings (status = 'CONFIRMED' and currently within the check-in/check-out time range).
- **Enforcement**: `existsActiveBooking(roomId)` query checked before soft delete.

### BR-16: Soft Delete Only
- **Rule**: Rooms are never physically deleted. Deletion sets `is_deleted = 1`.
- **Enforcement**: All delete operations use `UPDATE Room SET is_deleted = 1` rather than `DELETE FROM Room`.

### BR-17: Room Status Values
- **Rule**: Room status must be one of: `AVAILABLE`, `BOOKED`, `MAINTENANCE`.
- **Enforcement**: DB CHECK constraint `CHECK (status IN ('AVAILABLE', 'BOOKED', 'MAINTENANCE'))`.

---

## Feedback Rules

### BR-18: Rating Range
- **Rule**: Feedback rating must be between 1 and 5 (inclusive).
- **Enforcement**: DB CHECK constraint `CHECK (rating BETWEEN 1 AND 5)`.

### BR-19: Feedback Linked to Booking
- **Rule**: Every feedback entry must be associated with a valid booking.
- **Enforcement**: `booking_id` is NOT NULL FK in Feedback table.

### BR-20: Feedback Visibility Control
- **Rule**: Staff can hide or show individual feedback items. Hidden feedback should not be displayed to customers.
- **Enforcement**: `is_hidden` BIT flag on Feedback, toggled by `FeedbackVisibilityService`.

---

## User Management Rules

### BR-21: Account Status Values
- **Rule**: Customer and StaffAccount status must be one of: `ACTIVE`, `INACTIVE`.
- **Enforcement**: DB CHECK constraint `CHECK (status IN ('ACTIVE', 'INACTIVE'))`.

### BR-22: Staff Role Values
- **Rule**: StaffAccount role must be one of: `ADMIN`, `STAFF`.
- **Enforcement**: DB CHECK constraint `CHECK (role IN ('ADMIN', 'STAFF'))`.

### BR-23: Only Admin Creates Staff
- **Rule**: Only users with role `ADMIN` can create new staff accounts or update staff roles.
- **Enforcement**: Role check query `SELECT role FROM StaffAccount WHERE admin_id = ? AND role = 'ADMIN'` before creation.

### BR-24: Inactive Accounts Cannot Login
- **Rule**: Users with status `INACTIVE` must be prevented from logging in.
- **Enforcement**: Service-layer check during authentication (`status = 'ACTIVE'` in queries).

---

## Reporting Rules

### BR-25: Revenue Counts Completed Bookings Only
- **Rule**: Revenue reports only aggregate bookings with `booking_status = 'COMPLETED'` from non-deleted rooms.
- **Enforcement**: WHERE clause `b.booking_status = 'COMPLETED' AND r.is_deleted = 0` in all revenue report queries.
