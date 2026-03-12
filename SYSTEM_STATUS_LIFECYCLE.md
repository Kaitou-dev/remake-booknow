# System Status Lifecycle

## 1. Booking Status

The booking status is the central lifecycle in the system, governing the entire customer journey from reservation to departure.

### States

| Status | Description |
|--------|-------------|
| `PENDING` | Booking created by customer, awaiting staff approval |
| `WAITING_PAYMENT` | Staff approved; customer must pay within 15 minutes |
| `PAID` | Payment successfully completed via MoMo |
| `CHECKED_IN` | Customer physically checked in (video verified by admin) |
| `CHECKED_OUT` | Customer checked out; room released |
| `COMPLETED` | Booking fully completed (used for revenue reporting) |

### Transition Diagram

```
┌──────────┐   Staff approves   ┌───────────────────┐   MoMo payment   ┌──────┐
│  PENDING  │ ────────────────► │  WAITING_PAYMENT   │ ───────────────► │ PAID │
└──────────┘                    └───────────────────┘                   └──────┘
                                                                          │
                                                      Admin approves      │
                                                      check-in video      │
                                                          ▼               │
                                                    ┌────────────┐ ◄──────┘
                                                    │ CHECKED_IN  │
                                                    └────────────┘
                                                          │
                                                    Customer confirms
                                                      check-out
                                                          ▼
                                                    ┌─────────────┐
                                                    │ CHECKED_OUT  │
                                                    └─────────────┘
                                                          │
                                                          ▼
                                                    ┌───────────┐
                                                    │ COMPLETED  │
                                                    └───────────┘
```

### Transition Rules

| From | To | Trigger | Actor |
|------|----|---------|-------|
| `PENDING` | `WAITING_PAYMENT` | Staff approves booking | Staff/Admin |
| `WAITING_PAYMENT` | `PAID` | MoMo callback with valid signature | System (MoMo callback) |
| `PAID` | `CHECKED_IN` | Admin approves check-in video | Admin |
| `CHECKED_IN` | `CHECKED_OUT` | Customer confirms checkout | Customer |
| `CHECKED_OUT` | `COMPLETED` | System finalizes | System |

### Side Effects

| Transition | Side Effect |
|-----------|------------|
| → `PAID` | Payment record updated to `SUCCESS` |
| → `CHECKED_IN` | `check_in_time` set to current timestamp |
| → `CHECKED_OUT` | Room status set to `AVAILABLE` |

---

## 2. Room Status

### States

| Status | Description |
|--------|-------------|
| `AVAILABLE` | Room is free and can be booked |
| `BOOKED` | Room is reserved by an active booking |
| `MAINTENANCE` | Room is under maintenance, not bookable |

### Transition Diagram

```
┌───────────┐   Booking created   ┌────────┐
│ AVAILABLE  │ ──────────────────► │ BOOKED │
└───────────┘                      └────────┘
     ▲                                 │
     │        Customer checks out      │
     └─────────────────────────────────┘
     │
     ▼
┌─────────────┐
│ MAINTENANCE  │
└─────────────┘
```

### Transition Rules

| From | To | Trigger |
|------|----|---------|
| `AVAILABLE` | `BOOKED` | Booking created for this room |
| `BOOKED` | `AVAILABLE` | Booking checked out (automatic release) |
| `AVAILABLE` | `MAINTENANCE` | Staff sets room to maintenance |
| `MAINTENANCE` | `AVAILABLE` | Staff restores room from maintenance |

---

## 3. Payment Status

### States

| Status | Description |
|--------|-------------|
| `PENDING` | Payment record created; awaiting MoMo callback |
| `SUCCESS` | MoMo confirmed payment was successful |

### Transition Diagram

```
┌─────────┐   MoMo callback   ┌─────────┐
│ PENDING  │ ───────────────► │ SUCCESS  │
└─────────┘  (valid signature) └─────────┘
```

### Transition Rules

| From | To | Trigger |
|------|----|---------|
| `PENDING` | `SUCCESS` | MoMo callback received with valid HMAC-SHA256 signature |

---

## 4. Customer Account Status

### States

| Status | Description |
|--------|-------------|
| `ACTIVE` | Account is operational; user can log in and use the system |
| `INACTIVE` | Account is deactivated by admin; user cannot log in |

### Transition Diagram

```
┌────────┐   Admin deactivates   ┌──────────┐
│ ACTIVE  │ ◄──────────────────► │ INACTIVE  │
└────────┘   Admin reactivates   └──────────┘
```

---

## 5. Staff Account Status

Identical to Customer Account Status.

| Status | Description |
|--------|-------------|
| `ACTIVE` | Staff can log in and perform management tasks |
| `INACTIVE` | Staff account deactivated by admin |

---

## 6. Check-In Session Status

### States

| Status | Description |
|--------|-------------|
| `PENDING` | Video uploaded, waiting for admin review |
| `APPROVED` | Admin approved the check-in (triggers booking → CHECKED_IN) |

### Transition Diagram

```
┌─────────┐   Admin approves   ┌──────────┐
│ PENDING  │ ────────────────► │ APPROVED  │
└─────────┘                    └──────────┘
```

---

## 7. Refresh Token Status

### States

| Status | Description |
|--------|-------------|
| `Active` | `is_revoked = 0` and `expires_at > NOW()` — token is valid |
| `Revoked` | `is_revoked = 1` — explicitly invalidated (logout) |
| `Expired` | `expires_at ≤ NOW()` — naturally expired |

### Transition Rules

| From | To | Trigger |
|------|----|---------|
| Active | Revoked | User logs out → token deleted from DB |
| Active | Expired | Time passes beyond `expires_at` |

---

## 8. Feedback Visibility Status

### States

| Status | Description |
|--------|-------------|
| `Visible` | `is_hidden = 0` — Feedback shown to customers |
| `Hidden` | `is_hidden = 1` — Feedback hidden from public view |

### Transition

Bidirectional toggle by Staff/Admin via `changeFeedbackVisibility`.

---

## 9. Soft Delete Flag (`is_deleted`)

Applies to: Customer, StaffAccount, RoomType, Room, Amenity

| Value | Meaning |
|-------|---------|
| `0` | Active record |
| `1` | Logically deleted — excluded from all queries via `WHERE is_deleted = 0` |

All queries in the system filter by `is_deleted = 0`. Physical deletion is never performed.
