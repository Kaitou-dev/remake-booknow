# Housekeeping Module Workflow

BookNow – Homestay Booking System

## 1. Overview

The **Housekeeping Module** manages room cleaning and maintenance after guests check out or when issues are reported.

The goal of the module is to ensure:

* Rooms are cleaned before the next booking
* Maintenance issues are handled quickly
* Staff clearly know which rooms require attention
* Room status is always accurate

### Main roles

| Role                 | Responsibility                               |
| -------------------- | -------------------------------------------- |
| Customer             | Stays in room and checks out                 |
| Receptionist / Staff | Manage booking and assign housekeeping tasks |
| Housekeeping Staff   | Clean and inspect rooms                      |
| System               | Automatically creates tasks after checkout   |

---

# 2. Room Status Lifecycle

Room status transitions:

```
AVAILABLE
↓
BOOKED
↓
CHECKED_IN
↓
CHECKED_OUT
↓
CLEANING
↓
AVAILABLE
```

Additional states:

```
MAINTENANCE
OUT_OF_SERVICE
```

---

# 3. Workflow: Room Checkout → Cleaning Task

## Step 1: Customer Checkout

Actor: Customer / Receptionist

1. Customer completes checkout
2. System updates booking status:

```
CHECKED_OUT
```

3. System updates room status:

```
CLEANING
```

4. System automatically creates a housekeeping task.

Task information:

```
task_type = CLEANING
status = PENDING
assigned_staff = NULL
```

---

# 4. Workflow: Staff Manually Assign Task

Actor: Receptionist / Manager / Staff

After the system creates a housekeeping task, **a staff member can manually assign the task to a housekeeping employee**.

### Step 1 — Staff opens housekeeping dashboard

Navigation:

```
Staff Dashboard
→ Housekeeping Management
→ Cleaning Tasks
```

System displays tasks:

| Task ID | Room | Task Type | Status  | Assigned Staff |
| ------- | ---- | --------- | ------- | -------------- |
| 101     | 203  | Cleaning  | Pending | None           |
| 102     | 405  | Cleaning  | Pending | None           |

---

### Step 2 — Staff assigns task

Staff selects:

```
Assign Staff
```

System displays list of housekeeping employees:

| Staff ID | Name | Status    |
| -------- | ---- | --------- |
| 12       | Minh | Available |
| 14       | Huy  | Available |
| 18       | Lan  | Busy      |

Staff selects a staff member.

System updates task:

```
assigned_staff_id = staff_id
status = ASSIGNED
assigned_at = current_time
```

---

### Step 3 — Task assigned

Task status becomes:

```
ASSIGNED
```

Housekeeping staff will see the task in **My Tasks dashboard**.

---

# 5. Workflow: Housekeeping Staff Execute Task

Actor: Housekeeping Staff

### Step 1 — View assigned tasks

Dashboard:

```
My Cleaning Tasks
```

Example:

| Task | Room | Status   |
| ---- | ---- | -------- |
| 101  | 203  | Assigned |

---

### Step 2 — Start cleaning

Staff selects:

```
Start Task
```

System updates:

```
status = IN_PROGRESS
started_at = current_time
```

---

### Step 3 — Cleaning process

Staff performs:

* Change bedsheets
* Clean bathroom
* Vacuum / mop floor
* Refill amenities
* Inspect room condition

If damage is detected:

```
Create Maintenance Task
```

---

### Step 4 — Task completed

Staff selects:

```
Complete Task
```

System updates:

```
status = COMPLETED
completed_at = current_time
```

Room status updates:

```
CLEANING → AVAILABLE
```

---

# 6. Workflow: Maintenance Issue Detected

During cleaning, staff may detect issues such as:

* Broken furniture
* Air conditioner malfunction
* Plumbing issues
* Electrical problems

Workflow:

```
CLEANING
↓
ISSUE DETECTED
↓
MAINTENANCE TASK CREATED
↓
ROOM STATUS = MAINTENANCE
```

Maintenance task includes:

| Field       | Description                       |
| ----------- | --------------------------------- |
| issue_type  | Electrical / Plumbing / Furniture |
| severity    | Low / Medium / High               |
| reported_by | Staff ID                          |

---

# 7. Workflow: Overdue Checkout Monitoring

System periodically checks bookings.

Condition:

```
current_time > checkout_time
AND booking_status != CHECKED_OUT
```

Room flagged as:

```
OVERDUE_CHECKOUT
```

Displayed on staff dashboard:

| Room | Guest | Checkout Time | Status  |
| ---- | ----- | ------------- | ------- |
| 301  | John  | 12:00         | Overdue |

Staff can inspect room before cleaning.

---

# 8. Housekeeping Dashboard

### Staff Dashboard

Staff can:

* View rooms needing cleaning
* Assign cleaning tasks
* Monitor task progress
* Track overdue rooms

### Housekeeping Staff Dashboard

Housekeeping staff can:

* View assigned tasks
* Start cleaning
* Report issues
* Complete tasks

---

# 9. Data Model

## HousekeepingTask

```
HousekeepingTask
-------------------------
task_id (PK)
room_id (FK)
task_type
status
priority
assigned_staff_id
created_at
assigned_at
started_at
completed_at
notes
```

---

## Room

```
Room
---------
room_id
room_number
status
last_cleaned_at
```

Room status enum:

```
AVAILABLE
BOOKED
CHECKED_IN
CLEANING
MAINTENANCE
```

---

# 10. Task Status

```
PENDING
ASSIGNED
IN_PROGRESS
COMPLETED
CANCELLED
```

---

# 11. Business Rules

Rule 1
A room **cannot be booked** when status is:

```
CLEANING
MAINTENANCE
```

Rule 2
A cleaning task **must be completed** before the room becomes AVAILABLE.

Rule 3
Only assigned staff can update a task.

Rule 4
Maintenance issues must be resolved before room becomes AVAILABLE.

---

# 12. Future Improvements

Possible enhancements:

* Mobile interface for housekeeping
* Push notifications for new tasks
* QR code scanning for room verification
* Cleaning performance tracking
* Task workload balancing
