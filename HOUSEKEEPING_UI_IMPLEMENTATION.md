# Housekeeping UI Implementation Summary

## Overview
Phát triển hệ thống quản lý housekeeping (vệ sinh phòng) cho BookNow - Homestay Booking System.

Ngày: 14/03/2026

---

## 📋 Các Trang Mới Được Tạo (6 files)

### 1. **task-assignment.html**
- **Mục đích:** Form để gán task vệ sinh cho nhân viên housekeeping
- **Chức năng:**
  - Hiển thị thông tin task (Room, Priority, Status)
  - Lọc staff theo trạng thái (Available, Busy)
  - Chọn staff từ danh sách radio buttons
  - Hiển thị công việc hiện tại của mỗi staff
  - Thêm ghi chú tuỳ chọn
- **Status flow:** PENDING → ASSIGNED
- **Workflow:**
  - Staff/Receptionist chọn một staff từ danh sách
  - Click "Assign Task"
  - Hệ thống gán task, thay đổi status → ASSIGNED
  - Thông báo staff được gán

---

### 2. **my-tasks.html**
- **Mục đích:** Dashboard cá nhân cho housekeeping staff xem công việc của mình
- **Chức năng:**
  - Thống kê: Assigned, In Progress, Completed Today
  - Danh sách task được gán (ASSIGNED, IN_PROGRESS)
  - Section "Completed Today" hiển thị 5 task đã hoàn thành
  - Nút "Start" để bắt đầu task ASSIGNED
  - Nút "Complete" để kết thúc task IN_PROGRESS
- **Navigation:** Khác với Dashboard quản lý
  - "My Tasks" (active)
  - "Dashboard"
  - "History"
- **User:** Housekeeping staff

---

### 3. **start-task-modal.html**
- **Mục đích:** Modal xác nhận trước khi bắt đầu vệ sinh
- **Chức năng:**
  - Hiển thị checklist chuẩn bị (vật tư, ghi chú)
  - Require checkbox xác nhận trước khi start
  - Status flow: ASSIGNED → IN_PROGRESS
  - Ghi lại `started_at` timestamp
- **Triggers:** Khi click "Start" button trên cleaning-task-list hoặc my-tasks
- **Reusable:** Included trong cleaning-task-list.html, có thể reuse ở my-tasks.html

---

### 4. **report-issue-form.html**
- **Mục đích:** Form báo cáo sự cố phát hiện trong quá trình vệ sinh
- **Chức năng:**
  - Chọn loại vấn đề (Electrical, Plumbing, HVAC, Furniture, etc.)
  - Chọn mức độ nghiêm trọng (LOW, MEDIUM, HIGH)
  - Mô tả chi tiết sự cố
  - Upload ảnh (optional)
  - Option: Tạm dừng cleaning task
- **Workflow:**
  - Staff vệ sinh phát hiện vấn đề
  - Click "Report Issue" từ task-detail hoặc room-cleaning-complete
  - Điền form báo cáo
  - Hệ thống tạo Maintenance Task
  - Room status: CLEANING → MAINTENANCE
  - Cleaning task tạm dừng cho đến khi sửa chữa xong
- **Related:**
  - Liên kết đến cleaning task (task_id)
  - Auto record reported_by (staff_id)

---

### 5. **maintenance-task-create.html**
- **Mục đích:** Form tạo maintenance task (từ issue report hoặc direct)
- **Chức năng:**
  - Chọn category sửa chữa
  - Chọn priority (URGENT, HIGH, NORMAL, LOW)
  - Mô tả chi tiết vấn đề
  - Gán cho technician (optional - auto-assign nếu không chọn)
  - Linked đến cleaning task (nếu từ issue report)
  - Auto set room status: MAINTENANCE
- **Work Action:**
  - Create → Technician assigned
  - Status: IN_PROGRESS
  - Technician performs work
  - Mark complete → Room AVAILABLE
- **Output:** Success message với Task ID

---

### 6. **inspect-overdue-room.html**
- **Mục đích:** Form kiểm tra phòng checkout quá hạn
- **Chức năng:**
  - Hiển thị thông tin khách & thời gian quá hạn
  - Chọn trạng thái phòng (Occupied, Empty Clean, Empty Dirty, Damage)
  - Ghi chú kiểm tra
  - Chọn hành động (Allow Extended Stay, Request Checkout, Force Checkout)
  - Tính toán phí quá hạn
  - Require manager approval cho Force Checkout
- **Workflow:**
  - Khi task checkout quá hạn
  - Staff click "Inspect Room"
  - Điền form inspection
  - Choose action
  - Auto-create cleaning task nếu room empty
  - Calculate late checkout fee

---

## 🔧 Các Trang Được Cập Nhật (6 files)

### 1. **cleaning-task-list.html**
**Thay đổi:**
- ✅ Thêm filter status: ASSIGNED
- ✅ Thêm row mẫu ASSIGNED task (Room 108 - Tran Thi B)
- ✅ Update button action:
  - PENDING + Unassigned → "Assign" button → task-assignment.html?id=1025
  - ASSIGNED → "Start" button → Modal start-task
  - IN_PROGRESS → "View" + "Mark Cleaned" button
- ✅ Include start-task-modal HTML & JS

**Status Flow Examples:**
```
Room 205 (PENDING + Unassigned) → Click Assign → Go to task-assignment.html
Room 108 (ASSIGNED + Assigned to Tran Thi B) → Click Start → Modal confirms
Room 101 (IN_PROGRESS + Assigned) → Click Mark Cleaned → Go to room-cleaning-complete
```

---

### 2. **task-detail.html**
**Thay đổi:**
- ✅ Thêm "Task Timeline" section
  - Created (green checkmark)
  - Assigned (green checkmark)
  - Started (blue arrow)
  - Completed (grey - pending)
  - Timestamps cho mỗi event
- ✅ Update "Report Issue" button → link to report-issue-form.html?id=1024
- ✅ Update Quick Actions sidebar
  - "Complete Task" → link
  - "Report Maintenance Issue" → link to report-issue-form
  - "Reassign Task" → button
  - "Cancel Task" → button

**UI Improvements:**
- Timeline giúp staff hiểu task progression
- Timestamps tracking created_at, assigned_at, started_at
- Clear task history cho management

---

### 3. **housekeeping-dashboard.html**
**Thay đổi:**
- ✅ Links đã chính xác, không cần sửa
- Card "Needs Cleaning" → Link to cleaning-task-list.html
- Card "Under Maintenance" → Link to maintenance-room-list.html
- Card "Overdue Checkout" → Link to overdue-checkout.html

---

### 4. **room-cleaning-complete.html**
**Thay đổi:**
- ✅ Remove inline issue form
- ✅ Update "Report Maintenance Issue" button → link to report-issue-form.html?room=101
- ✅ Add form submission validation
  - Require new room password
  - Show success message
  - Redirect to cleaning-task-list
- ✅ Improved UX:
  - Validation prevents empty passwords
  - Success feedback before redirect
  - Clear error messages

---

### 5. **maintenance-room-list.html**
**Thay đổi:**
- ✅ Update "Report New Issue" button → link to report-issue-form.html
- Changes maintenance button từ `<button>` thành `<a>` tag

---

### 6. **overdue-checkout.html**
**Thay đổi:**
- ✅ Update "Inspect Room" button → link to inspect-overdue-room.html?room=301
- Changes inspect button từ `<button>` thành `<a>` tag

---

## 🔄 Workflow Integration

### Workflow 1: Cleaning Task Assignment
```
System auto-creates task after checkout (PENDING)
    ↓
Receptionist clicks "Assign" in cleaning-task-list.html
    ↓
Goes to task-assignment.html
    ↓
Selects staff → Clicks Assign
    ↓
Task status: PENDING → ASSIGNED
    ↓
Staff sees task in my-tasks.html
    ↓
Staff clicks "Start" → Modal confirmation
    ↓
Task status: ASSIGNED → IN_PROGRESS, started_at recorded
    ↓
Staff continues cleaning with task-detail.html
    ↓
Completes checklist
    ↓
Clicks "Complete Task" or "Mark Cleaned"
    ↓
Goes to room-cleaning-complete.html
    ↓
Sets new room password
    ↓
Task status: IN_PROGRESS → COMPLETED
    ↓
Room status: CLEANING → AVAILABLE
```

### Workflow 2: Issue Detection During Cleaning
```
Staff doing Room 101 cleaning
    ↓
Discovers AC not working
    ↓
Clicks "Report Issue" in task-detail.html
    ↓
Goes to report-issue-form.html
    ↓
Select: Category (HVAC), Severity (HIGH), Description
    ↓
Clicks "Report Issue & Create Maintenance Task"
    ↓
Maintenance task created, assigned to technician
    ↓
Room status: CLEANING → MAINTENANCE
    ↓
Cleaning task paused (optional checkbox)
    ↓
System notifies technician
    ↓
Technician fixes issue
    ↓
Marks maintenance task complete
    ↓
Room status: MAINTENANCE → AVAILABLE
    ↓
Cleaning can resume if paused
```

### Workflow 3: Overdue Checkout Handling
```
Guest checkout time: 12:00 PM
Current time: 2:30 PM (2.5 hours overdue)
    ↓
System flags room 301 as OVERDUE_CHECKOUT
    ↓
Receptionist sees in overdue-checkout.html
    ↓
Clicks "Inspect Room"
    ↓
Goes to inspect-overdue-room.html?room=301
    ↓
Documents room condition (Occupied/Empty/Damage)
    ↓
Chooses action:
  - Allow Extended Stay (negotiate with guest)
  - Request Checkout (politely ask to leave)
  - Force Checkout (requires manager approval)
    ↓
Calculates late fee (proportional)
    ↓
Updates booking status
    ↓
Auto-creates cleaning task if room empty
    ↓
Notifies guest of charges
```

---

## 📊 Task Status Reference

| Status | Created By | Can Transition To | Description |
|--------|-----------|-------------------|-------------|
| **PENDING** | System (auto) | ASSIGNED, CANCELLED | Newly created, waiting for assignment |
| **ASSIGNED** | Receptionist | IN_PROGRESS, CANCELLED | Task assigned to staff, waiting to start |
| **IN_PROGRESS** | Staff | COMPLETED, PENDING | Staff actively cleaning |
| **COMPLETED** | Staff | - | Task finished, room available |
| **CANCELLED** | Manager | - | Task cancelled (rare) |

---

## 🎯 User Journeys

### For Receptionist/Manager:
1. Dashboard → Check overview
2. Cleaning Tasks → Overview of all tasks
3. Click on PENDING task → Assign Staff
4. Monitor task progress
5. Maintenance Rooms → Check issues
6. Overdue Checkout → Handle late guests

### For Housekeeping Staff:
1. My Tasks (or app notification) → See assigned tasks
2. Click "Start" → Modal confirmation → IN_PROGRESS
3. View task details, follow checklist
4. Report issues if found
5. Mark complete with room password
6. Return to My Tasks, see completed list

### For Technician:
1. Notification of new maintenance task
2. Goes to maintenance-room-list (can be added)
3. View issue details
4. Perform work
5. Mark task complete
6. Room becomes AVAILABLE

---

## 🔗 Key Links & Navigation

### From cleaning-task-list.html:
- Assign button → task-assignment.html?id={taskId}
- View button → task-detail.html?id={taskId}
- Start button → Modal (inline)
- Mark Cleaned → room-cleaning-complete.html?room={roomId}

### From task-detail.html:
- Complete Task → room-cleaning-complete.html
- Report Issue → report-issue-form.html?id={taskId}
- Maintenance Issue (sidebar) → report-issue-form.html

### From room-cleaning-complete.html:
- Report Issue → report-issue-form.html?room={roomId}
- Cancel → cleaning-task-list.html

### From overdue-checkout.html:
- Inspect Room → inspect-overdue-room.html?room={roomId}

### From report-issue-form.html:
- Submit → maintenance-task-create.html (auto-filled with issue data)

---

## 📱 Responsive Design
Tất cả các trang sử dụng Tailwind CSS grid system:
- Mobile: 1 column
- Tablet: 2-3 columns
- Desktop: Full layout

---

## 🔒 Security & Validation

### Implemented:
- ✅ Form required fields validation
- ✅ Checkbox confirmation before critical actions (Start Task)
- ✅ Password required before marking room complete
- ✅ Manager approval needed for Force Checkout
- ✅ Auto-tracking of timestamps (created_at, assigned_at, started_at, completed_at)
- ✅ Staff attribution for all actions

### Future Enhancements:
- Role-based access control
- Photo evidence for issues
- Audit trail/logging
- Performance metrics (time per room)
- Workload balancing algorithm
- Push notifications

---

## 📝 Implementation Notes

### Data Fields Tracked:
```
HousekeepingTask:
- task_id (PK)
- room_id (FK)
- status (PENDING/ASSIGNED/IN_PROGRESS/COMPLETED/CANCELLED)
- priority (URGENT/HIGH/NORMAL/LOW)
- assigned_staff_id
- created_at (system)
- assigned_at (when assigned)
- started_at (when staff started)
- completed_at (when finished)
- notes (text)

Room:
- room_id (PK)
- room_status (AVAILABLE/BOOKED/CHECKED_IN/CLEANING/MAINTENANCE)
- last_cleaned_at
```

### API Endpoints Needed:
```
POST /api/tasks/assign          → Assign task to staff
POST /api/tasks/{id}/start      → Start task (ASSIGNED→IN_PROGRESS)
POST /api/tasks/{id}/complete   → Complete task
POST /api/issues/report         → Create issue report
POST /api/maintenance/create    → Create maintenance task
GET  /api/staff/available       → Get available staff list
```

---

## ✅ Quality Checklist

- ✅ All pages have consistent header & navigation
- ✅ Responsive design (mobile, tablet, desktop)
- ✅ Clear user flows & transitions
- ✅ Proper button/link styling (call-to-action vs secondary)
- ✅ Form validation feedback
- ✅ Timeline/progress visualization
- ✅ Modal for confirmations
- ✅ Breadcrumb/back links for navigation
- ✅ Color coding for status/priority (green=success, red=urgent, yellow=pending)
- ✅ Helpful sidebar information & tips

---

## 🎨 UI/UX Features

### Color Coding:
- 🔵 Blue = Primary actions, active links
- 🟢 Green = Success, complete status
- 🟡 Yellow = Warning, pending status
- 🔴 Red = Danger, urgent, overdue
- 🟠 Orange = Secondary actions

### Status Badges:
- PENDING → Gray background
- ASSIGNED → Yellow background
- IN_PROGRESS → Blue background
- COMPLETED → Green background
- URGENT → Red background

### Interactive Elements:
- Hover effects on buttons & links
- Disabled states for submit buttons (until conditions met)
- Loading states (can be added)
- Success messages after submission
- Error feedback for validation

---

Generated: 14/03/2026
Last Updated: Implementation Complete
