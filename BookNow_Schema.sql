-- ============================================================
-- BookNow — Final Optimized Database Schema
-- Version: 2.0 (with Housekeeping Module)
-- Database: Microsoft SQL Server
-- Generated from: DATABASE_REDESIGN_REPORT.md
-- ============================================================

USE [book_now]
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
