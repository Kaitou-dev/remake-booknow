# Non-Functional Requirements

## 1. Security

| ID | Requirement | Implementation |
|----|-------------|----------------|
| NFR-S01 | Passwords must be hashed before storage | BCrypt hashing algorithm |
| NFR-S02 | Customer login must include bot protection | Google reCAPTCHA verification |
| NFR-S03 | Payment callbacks must be cryptographically verified | HMAC-SHA256 signature recalculation and comparison |
| NFR-S04 | Authentication must use token-based sessions | JWT Access Token + Refresh Token stored in DB |
| NFR-S05 | Refresh tokens must be revocable | DB-stored tokens, deleted on logout |
| NFR-S06 | Role-based access control must be enforced | Spring Security with role checks (CUSTOMER, STAFF, ADMIN) |
| NFR-S07 | Sensitive data must be protected in transit | HTTPS for all external API communications (MoMo, Google, Cloudinary) |
| NFR-S08 | OTP codes must have time-limited validity | 1-minute expiration window |
| NFR-S09 | SQL injection must be prevented | Parameterized queries via JPA/Hibernate ORM |
| NFR-S10 | Session tokens must have expiration | `expires_at` field on RefreshToken, checked on each use |

---

## 2. Performance

| ID | Requirement | Implementation |
|----|-------------|----------------|
| NFR-P01 | Room listings must support pagination | Pageable parameter in repository queries |
| NFR-P02 | Room filtering must be efficient with dynamic criteria | Dynamic SQL with optional WHERE clauses, single query with JOINs |
| NFR-P03 | Payment processing must respect time constraints | 15-minute payment window enforced |
| NFR-P04 | Check-in notifications must be delivered in real-time | WebSocket push notifications (no polling) |
| NFR-P05 | Database queries should avoid N+1 problems | JOINs used in queries (Room + RoomType + Image + Amenity in single query) |

---

## 3. Reliability

| ID | Requirement | Implementation |
|----|-------------|----------------|
| NFR-R01 | Payment state must be consistent | Transaction: Payment status and Booking status updated together after MoMo callback verification |
| NFR-R02 | Room availability must stay consistent after checkout | Booking status → CHECKED_OUT triggers Room status → AVAILABLE atomically |
| NFR-R03 | Data must never be permanently lost | Soft delete pattern (`is_deleted` flag) on all major entities |
| NFR-R04 | Duplicate room numbers must be prevented | DB UNIQUE constraint + application-level pre-check |
| NFR-R05 | Account operations must be auditable | AuditLog table records staff account modifications |

---

## 4. Scalability

| ID | Requirement | Implementation |
|----|-------------|----------------|
| NFR-SC01 | Room listings must handle growing data | Pagination support in all list queries |
| NFR-SC02 | Media storage must not burden the application server | Video files offloaded to Cloudinary CDN |
| NFR-SC03 | Revenue reports must handle historical data efficiently | Indexed date-based aggregation queries with year filter |

---

## 5. Availability

| ID | Requirement | Implementation |
|----|-------------|----------------|
| NFR-A01 | System must handle external service failures gracefully | MoMo payment creates PENDING record first; status updated only on confirmed callback |
| NFR-A02 | Session must persist across browser restarts | Refresh tokens stored server-side in DB with configurable expiry |

---

## 6. Maintainability

| ID | Requirement | Implementation |
|----|-------------|----------------|
| NFR-M01 | Code must follow layered architecture | Controller → Service → Repository separation with clear package structure |
| NFR-M02 | Business logic must be isolated from data access | Service layer handles all rules; Repository handles only DB operations |
| NFR-M03 | DTOs must decouple internal entities from API contracts | `model.dto` package for request/response objects |
| NFR-M04 | Security concern must be separated | Dedicated `security` package for auth filters, config, and role handling |
| NFR-M05 | Customer and Staff logic must be independently maintainable | Split packages: `controllers.customer` / `controllers.staffadmin`, `services.customer` / `services.staffadmin` |

---

## 7. Usability

| ID | Requirement | Implementation |
|----|-------------|----------------|
| NFR-U01 | Registration must verify email ownership | OTP sent to email before account creation |
| NFR-U02 | Login must support social authentication | Google OAuth2 integration for one-click login |
| NFR-U03 | Feedback must include visual ratings | 1–5 star rating system |
| NFR-U04 | Rooms must be discoverable via filters | Price range and amenity-based filtering |
| NFR-U05 | Room images must include a cover image indicator | `is_cover` flag on Image entity |

---

## 8. Data Integrity

| ID | Requirement | Implementation |
|----|-------------|----------------|
| NFR-D01 | Foreign key relationships must be enforced | FK constraints on all relationship columns |
| NFR-D02 | Status values must be constrained | CHECK constraints on status/role columns |
| NFR-D03 | Critical fields must not allow NULL | NOT NULL constraints on `email`, `password_hash`, `booking_status`, `total_amount`, etc. |
| NFR-D04 | Unique business identifiers must be enforced | UNIQUE constraints on `email`, `room_number`, `invoice_number`, `token_hash` |
| NFR-D05 | Timestamps must be auto-populated | `DEFAULT GETDATE()` on `created_at` fields |
