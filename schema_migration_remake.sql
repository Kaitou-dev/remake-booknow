/*
  BookNow production migration script
  Generated: 2026-03-19
  Target: Existing book_now schema (SQL Server)
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    /* ---------------------------------------------------------
       0) PRECHECKS
       --------------------------------------------------------- */
    IF OBJECT_ID('dbo.Customer', 'U') IS NULL THROW 50010, 'Missing dbo.Customer', 1;
    IF OBJECT_ID('dbo.StaffAccounts', 'U') IS NULL AND OBJECT_ID('dbo.StaffAccount', 'U') IS NULL THROW 50011, 'Missing dbo.StaffAccounts/dbo.StaffAccount', 1;
    IF OBJECT_ID('dbo.Room', 'U') IS NULL THROW 50012, 'Missing dbo.Room', 1;
    IF OBJECT_ID('dbo.RoomType', 'U') IS NULL THROW 50013, 'Missing dbo.RoomType', 1;
    IF OBJECT_ID('dbo.Amenity', 'U') IS NULL THROW 50014, 'Missing dbo.Amenity', 1;
    IF OBJECT_ID('dbo.RoomAmenity', 'U') IS NULL THROW 50015, 'Missing dbo.RoomAmenity', 1;
    IF OBJECT_ID('dbo.Booking', 'U') IS NULL THROW 50016, 'Missing dbo.Booking', 1;
    IF OBJECT_ID('dbo.Payment', 'U') IS NULL THROW 50017, 'Missing dbo.Payment', 1;

    /* ---------------------------------------------------------
       1) STAFF TABLE COMPATIBILITY
       Keep existing table and create compatibility view if needed.
       --------------------------------------------------------- */
    IF OBJECT_ID('dbo.StaffAccount', 'U') IS NULL AND OBJECT_ID('dbo.StaffAccounts', 'U') IS NOT NULL
    BEGIN
        EXEC('CREATE VIEW dbo.StaffAccount AS SELECT * FROM dbo.StaffAccounts');
    END

    /* ---------------------------------------------------------
       2) AUDIT COLUMNS + COLUMN STANDARDIZATION
       --------------------------------------------------------- */
    IF COL_LENGTH('dbo.Booking', 'update_at') IS NOT NULL AND COL_LENGTH('dbo.Booking', 'updated_at') IS NULL
    BEGIN
        EXEC sp_rename 'dbo.Booking.update_at', 'updated_at', 'COLUMN';
    END

    IF COL_LENGTH('dbo.Booking', 'updated_at') IS NULL
        ALTER TABLE dbo.Booking ADD updated_at DATETIME2(7) NULL;

    IF COL_LENGTH('dbo.Room', 'created_at') IS NULL
        ALTER TABLE dbo.Room ADD created_at DATETIME2(7) NOT NULL CONSTRAINT DF_room_created_at_mig DEFAULT SYSUTCDATETIME();

    IF COL_LENGTH('dbo.Room', 'updated_at') IS NULL
        ALTER TABLE dbo.Room ADD updated_at DATETIME2(7) NULL;

    IF COL_LENGTH('dbo.RoomType', 'created_at') IS NULL
        ALTER TABLE dbo.RoomType ADD created_at DATETIME2(7) NOT NULL CONSTRAINT DF_roomtype_created_at_mig DEFAULT SYSUTCDATETIME();

    IF COL_LENGTH('dbo.RoomType', 'updated_at') IS NULL
        ALTER TABLE dbo.RoomType ADD updated_at DATETIME2(7) NULL;

    IF COL_LENGTH('dbo.Amenity', 'created_at') IS NULL
        ALTER TABLE dbo.Amenity ADD created_at DATETIME2(7) NOT NULL CONSTRAINT DF_amenity_created_at_mig DEFAULT SYSUTCDATETIME();

    IF COL_LENGTH('dbo.Amenity', 'updated_at') IS NULL
        ALTER TABLE dbo.Amenity ADD updated_at DATETIME2(7) NULL;

    IF COL_LENGTH('dbo.Payment', 'created_at') IS NULL
        ALTER TABLE dbo.Payment ADD created_at DATETIME2(7) NOT NULL CONSTRAINT DF_payment_created_at_mig DEFAULT SYSUTCDATETIME();

    IF COL_LENGTH('dbo.Payment', 'updated_at') IS NULL
        ALTER TABLE dbo.Payment ADD updated_at DATETIME2(7) NULL;

    IF COL_LENGTH('dbo.Payment', 'transaction_time') IS NULL
        ALTER TABLE dbo.Payment ADD transaction_time DATETIME2(7) NULL;

    IF COL_LENGTH('dbo.Booking', 'approved_by_staff_id') IS NULL
        ALTER TABLE dbo.Booking ADD approved_by_staff_id BIGINT NULL;

    IF COL_LENGTH('dbo.Booking', 'booking_code') IS NULL
        ALTER TABLE dbo.Booking ADD booking_code NVARCHAR(50) NULL;

    /* ---------------------------------------------------------
       2.1) CLOUDINARY MEDIA COLUMNS
       Store URL + public_id for safe delete/update in Cloudinary
       --------------------------------------------------------- */
    IF COL_LENGTH('dbo.Customer', 'avatar_public_id') IS NULL
        ALTER TABLE dbo.Customer ADD avatar_public_id NVARCHAR(255) NULL;

    IF COL_LENGTH('dbo.Amenity', 'icon_public_id') IS NULL
        ALTER TABLE dbo.Amenity ADD icon_public_id NVARCHAR(255) NULL;

    IF OBJECT_ID('dbo.RoomImage', 'U') IS NOT NULL
    BEGIN
        IF COL_LENGTH('dbo.RoomImage', 'image_public_id') IS NULL
            ALTER TABLE dbo.RoomImage ADD image_public_id NVARCHAR(255) NULL;
    END
    ELSE IF OBJECT_ID('dbo.Image', 'U') IS NOT NULL
    BEGIN
        IF COL_LENGTH('dbo.Image', 'image_public_id') IS NULL
            ALTER TABLE dbo.Image ADD image_public_id NVARCHAR(255) NULL;

        /* Backfill from legacy column public_id when available */
        IF COL_LENGTH('dbo.Image', 'public_id') IS NOT NULL
        BEGIN
            UPDATE dbo.Image
            SET image_public_id = COALESCE(image_public_id, public_id)
            WHERE image_public_id IS NULL;
        END
    END

    /* ---------------------------------------------------------
       3) STATUS VALUE STANDARDIZATION
       Booking status target:
       PENDING_PAYMENT -> PAID -> APPROVED -> CHECKED_IN -> CHECKED_OUT -> COMPLETED
       terminal: FAILED, CANCELED, REJECTED
       --------------------------------------------------------- */
    UPDATE dbo.Booking SET booking_status = 'PENDING_PAYMENT' WHERE booking_status IN ('PENDING', 'WAITING_PAYMENT');
    UPDATE dbo.Booking SET booking_status = 'CANCELED' WHERE booking_status IN ('CANCELLED', 'CANCEL');

    /* Payment status target: SUCCESS, FAILURE */
    UPDATE dbo.Payment SET payment_status = 'FAILURE' WHERE payment_status IN ('FAILED', 'PENDING', 'CANCELLED', 'CANCELED');

    /* Backfill transaction_time if missing */
    UPDATE p
    SET transaction_time = ISNULL(p.transaction_time, ISNULL(p.paid_at, DATEADD(MINUTE, 10, b.created_at))),
        created_at = ISNULL(p.created_at, DATEADD(MINUTE, 5, b.created_at))
    FROM dbo.Payment p
    JOIN dbo.Booking b ON b.booking_id = p.booking_id;

    /* ---------------------------------------------------------
       4) ROOM NUMBER NORMALIZATION TO ^[A-Z]-[A-Za-z]+-\d{2}$
       --------------------------------------------------------- */
    IF OBJECT_ID('tempdb..#room_map') IS NOT NULL DROP TABLE #room_map;
    CREATE TABLE #room_map (
        room_id BIGINT PRIMARY KEY,
        new_room_number NVARCHAR(50) NOT NULL
    );

    INSERT INTO #room_map (room_id, new_room_number) VALUES
    (1, 'A-OceanCity-01'),
    (2, 'A-CookChill-02'),
    (3, 'A-PinkParadise-03'),
    (4, 'A-TigerWoods-04'),
    (5, 'A-BallChill-05'),
    (6, 'A-GameHub-06'),
    (7, 'A-HoneyHouse-07'),
    (8, 'A-Ocean-08'),
    (9, 'A-CineRoom-09'),
    (10, 'A-IvyGarden-10'),
    (11, 'A-BaeBear-11'),
    (12, 'A-WoodMood-12'),
    (13, 'A-CalmCloud-13'),
    (14, 'A-BassBar-14'),
    (15, 'A-Mellow-15'),
    (16, 'A-LionKing-16'),
    (17, 'A-LoveBlaze-17'),
    (18, 'A-SquidGame-18'),
    (19, 'A-Lavender-19'),
    (20, 'A-RubyBida-20'),
    (21, 'B-CinemaZone-21'),
    (22, 'B-SoloGaming-22'),
    (23, 'B-GreenHaven-23'),
    (24, 'B-ZoneXBida-24'),
    (25, 'B-Mykonos-25'),
    (26, 'B-OrangePop-26'),
    (27, 'B-MoonSpace-27'),
    (28, 'B-CheeseBep-28'),
    (29, 'B-LovePink-29'),
    (30, 'B-BlueWave-30'),
    (31, 'B-FiniHome-31'),
    (32, 'B-LucaHome-32'),
    (33, 'B-CCVCinema-33'),
    (34, 'B-Beach-34'),
    (35, 'B-SweetDreams-35'),
    (36, 'B-DaLat-36'),
    (37, 'B-PinkDream-37'),
    (38, 'B-BlueVibe-38'),
    (39, 'B-PureRelax-39'),
    (40, 'B-HoneyGlow-40'),
    (41, 'C-CGVRoom-41'),
    (42, 'C-SmokeKitchen-42'),
    (43, 'C-EightBallHouse-43'),
    (44, 'C-LaMaison-44'),
    (45, 'C-MasterChef-45'),
    (46, 'C-Atlantis-46'),
    (47, 'C-Forest-47'),
    (48, 'C-VibeHome-48'),
    (49, 'C-WineBall-49'),
    (50, 'C-VideoGame-50'),
    (51, 'C-Lasaoma-51'),
    (52, 'C-Doraemon-52'),
    (53, 'C-GameRoomPS-53');

    UPDATE r
    SET r.room_number = m.new_room_number,
        r.updated_at = SYSUTCDATETIME()
    FROM dbo.Room r
    JOIN #room_map m ON m.room_id = r.room_id;

    /* ---------------------------------------------------------
       5) CONSTRAINT CLEANUP + RECREATE
       --------------------------------------------------------- */
    DECLARE @drop_booking_ck NVARCHAR(MAX) = N'';
    SELECT @drop_booking_ck = STRING_AGG('ALTER TABLE dbo.Booking DROP CONSTRAINT ' + QUOTENAME(name) + ';', ' ')
    FROM sys.check_constraints
    WHERE parent_object_id = OBJECT_ID('dbo.Booking')
      AND name LIKE 'CK_Booking%';
    IF @drop_booking_ck IS NOT NULL AND LEN(@drop_booking_ck) > 0 EXEC sp_executesql @drop_booking_ck;

    ALTER TABLE dbo.Booking WITH NOCHECK
    ADD CONSTRAINT CK_Booking_Status_Remake CHECK (
        booking_status IN (
            'PENDING_PAYMENT','PAID','APPROVED','CHECKED_IN','CHECKED_OUT','COMPLETED','FAILED','CANCELED','REJECTED'
        )
    );

    IF NOT EXISTS (
        SELECT 1 FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('dbo.Booking') AND name = 'CK_Booking_Time_Window_Remake'
    )
    BEGIN
        ALTER TABLE dbo.Booking WITH NOCHECK
        ADD CONSTRAINT CK_Booking_Time_Window_Remake CHECK (check_out_time > check_in_time);
    END

    DECLARE @drop_payment_ck NVARCHAR(MAX) = N'';
    SELECT @drop_payment_ck = STRING_AGG('ALTER TABLE dbo.Payment DROP CONSTRAINT ' + QUOTENAME(name) + ';', ' ')
    FROM sys.check_constraints
    WHERE parent_object_id = OBJECT_ID('dbo.Payment')
      AND name LIKE 'CK_Payment%';
    IF @drop_payment_ck IS NOT NULL AND LEN(@drop_payment_ck) > 0 EXEC sp_executesql @drop_payment_ck;

    ALTER TABLE dbo.Payment WITH NOCHECK
    ADD CONSTRAINT CK_Payment_Status_Remake CHECK (payment_status IN ('SUCCESS','FAILURE'));

    DECLARE @drop_room_ck NVARCHAR(MAX) = N'';
    SELECT @drop_room_ck = STRING_AGG('ALTER TABLE dbo.Room DROP CONSTRAINT ' + QUOTENAME(name) + ';', ' ')
    FROM sys.check_constraints
    WHERE parent_object_id = OBJECT_ID('dbo.Room')
      AND name LIKE 'CK_Room%';
    IF @drop_room_ck IS NOT NULL AND LEN(@drop_room_ck) > 0 EXEC sp_executesql @drop_room_ck;

    ALTER TABLE dbo.Room WITH NOCHECK
    ADD CONSTRAINT CK_Room_Status_Remake CHECK (
        status IN ('AVAILABLE','BOOKED','OCCUPIED','DIRTY','CLEANING','MAINTENANCE','OUT_OF_SERVICE','INACTIVE')
    );

    ALTER TABLE dbo.Room WITH NOCHECK
    ADD CONSTRAINT CK_Room_Number_Format_Remake CHECK (room_number LIKE '[A-Z]-[A-Za-z]%-[0-9][0-9]');

    /* Cloudinary pair constraints: url present => public_id present */
    IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('dbo.Customer') AND name = 'CK_Customer_Avatar_Cloudinary_Pair_Remake')
        ALTER TABLE dbo.Customer WITH NOCHECK
        ADD CONSTRAINT CK_Customer_Avatar_Cloudinary_Pair_Remake CHECK (avatar_url IS NULL OR avatar_public_id IS NOT NULL);

    IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('dbo.Amenity') AND name = 'CK_Amenity_Icon_Cloudinary_Pair_Remake')
        ALTER TABLE dbo.Amenity WITH NOCHECK
        ADD CONSTRAINT CK_Amenity_Icon_Cloudinary_Pair_Remake CHECK (icon_url IS NULL OR icon_public_id IS NOT NULL);

    IF OBJECT_ID('dbo.RoomImage', 'U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('dbo.RoomImage') AND name = 'CK_RoomImage_Cloudinary_Pair_Remake')
            ALTER TABLE dbo.RoomImage WITH NOCHECK
            ADD CONSTRAINT CK_RoomImage_Cloudinary_Pair_Remake CHECK (image_url IS NULL OR image_public_id IS NOT NULL);
    END
    ELSE IF OBJECT_ID('dbo.Image', 'U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('dbo.Image') AND name = 'CK_Image_Cloudinary_Pair_Remake')
            ALTER TABLE dbo.Image WITH NOCHECK
            ADD CONSTRAINT CK_Image_Cloudinary_Pair_Remake CHECK (image_url IS NULL OR image_public_id IS NOT NULL);
    END

    /* ---------------------------------------------------------
       6) FOREIGN KEY ADDITIONS
       --------------------------------------------------------- */
    IF NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Booking_ApprovedBy_Remake'
    )
    BEGIN
        IF OBJECT_ID('dbo.StaffAccounts', 'U') IS NOT NULL
            ALTER TABLE dbo.Booking ADD CONSTRAINT FK_Booking_ApprovedBy_Remake FOREIGN KEY (approved_by_staff_id) REFERENCES dbo.StaffAccounts(staff_account_id);
        ELSE
            ALTER TABLE dbo.Booking ADD CONSTRAINT FK_Booking_ApprovedBy_Remake FOREIGN KEY (approved_by_staff_id) REFERENCES dbo.StaffAccount(staff_account_id);
    END

    /* Payment one-to-one per booking */
    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Payment') AND name = 'UQ_Payment_Booking_Remake'
    )
    BEGIN
        CREATE UNIQUE INDEX UQ_Payment_Booking_Remake ON dbo.Payment(booking_id);
    END

    /* Booking code unique when present */
    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Booking') AND name = 'UQ_Booking_Code_Remake'
    )
    BEGIN
        CREATE UNIQUE INDEX UQ_Booking_Code_Remake ON dbo.Booking(booking_code) WHERE booking_code IS NOT NULL;
    END

    /* ---------------------------------------------------------
       7) BOOKING STATUS TRANSITION GOVERNANCE
       --------------------------------------------------------- */
    IF OBJECT_ID('dbo.BookingStatusTransition', 'U') IS NULL
    BEGIN
        CREATE TABLE dbo.BookingStatusTransition (
            from_status VARCHAR(30) NOT NULL,
            to_status   VARCHAR(30) NOT NULL,
            CONSTRAINT PK_BookingStatusTransition PRIMARY KEY (from_status, to_status)
        );
    END

    IF OBJECT_ID('dbo.BookingStatusHistory', 'U') IS NULL
    BEGIN
        CREATE TABLE dbo.BookingStatusHistory (
            booking_status_history_id BIGINT IDENTITY(1,1) PRIMARY KEY,
            booking_id                BIGINT NOT NULL,
            old_status                VARCHAR(30) NULL,
            new_status                VARCHAR(30) NOT NULL,
            changed_by_staff_id       BIGINT NULL,
            changed_at                DATETIME2(7) NOT NULL CONSTRAINT DF_bookinghistory_changed_at_mig DEFAULT SYSUTCDATETIME(),
            reason                    NVARCHAR(500) NULL,
            CONSTRAINT FK_bookinghistory_booking_mig FOREIGN KEY (booking_id) REFERENCES dbo.Booking(booking_id) ON DELETE CASCADE
        );

        IF OBJECT_ID('dbo.StaffAccounts', 'U') IS NOT NULL
            ALTER TABLE dbo.BookingStatusHistory ADD CONSTRAINT FK_bookinghistory_staff_mig FOREIGN KEY (changed_by_staff_id) REFERENCES dbo.StaffAccounts(staff_account_id);
        ELSE
            ALTER TABLE dbo.BookingStatusHistory ADD CONSTRAINT FK_bookinghistory_staff_mig FOREIGN KEY (changed_by_staff_id) REFERENCES dbo.StaffAccount(staff_account_id);
    END

    DELETE FROM dbo.BookingStatusTransition;
    INSERT INTO dbo.BookingStatusTransition (from_status, to_status) VALUES
    ('PENDING_PAYMENT','PAID'),
    ('PENDING_PAYMENT','FAILED'),
    ('PENDING_PAYMENT','CANCELED'),
    ('PAID','APPROVED'),
    ('PAID','REJECTED'),
    ('PAID','CANCELED'),
    ('APPROVED','CHECKED_IN'),
    ('CHECKED_IN','CHECKED_OUT'),
    ('CHECKED_OUT','COMPLETED');

    IF OBJECT_ID('dbo.trg_booking_status_transition_guard', 'TR') IS NOT NULL
        DROP TRIGGER dbo.trg_booking_status_transition_guard;

    EXEC('
    CREATE TRIGGER dbo.trg_booking_status_transition_guard
    ON dbo.Booking
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN deleted d ON i.booking_id = d.booking_id
            WHERE i.booking_status <> d.booking_status
              AND NOT EXISTS (
                  SELECT 1
                  FROM dbo.BookingStatusTransition t
                  WHERE t.from_status = d.booking_status
                    AND t.to_status = i.booking_status
              )
        )
        BEGIN
            THROW 50002, ''Invalid booking status transition.'', 1;
        END;

        INSERT INTO dbo.BookingStatusHistory (booking_id, old_status, new_status, changed_at)
        SELECT i.booking_id, d.booking_status, i.booking_status, SYSUTCDATETIME()
        FROM inserted i
        JOIN deleted d ON i.booking_id = d.booking_id
        WHERE i.booking_status <> d.booking_status;
    END
    ');

    /* ---------------------------------------------------------
       8) DOUBLE BOOKING PREVENTION
       --------------------------------------------------------- */
    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Booking') AND name = 'IX_Booking_Room_Time_Remake'
    )
    BEGIN
        CREATE INDEX IX_Booking_Room_Time_Remake ON dbo.Booking(room_id, check_in_time, check_out_time);
    END

    IF OBJECT_ID('dbo.trg_booking_prevent_overlap', 'TR') IS NOT NULL
        DROP TRIGGER dbo.trg_booking_prevent_overlap;

    EXEC('
    CREATE TRIGGER dbo.trg_booking_prevent_overlap
    ON dbo.Booking
    AFTER INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN dbo.Booking b WITH (UPDLOCK, HOLDLOCK)
              ON b.room_id = i.room_id
             AND b.booking_id <> i.booking_id
             AND b.booking_status IN (''PENDING_PAYMENT'',''PAID'',''APPROVED'',''CHECKED_IN'')
             AND i.booking_status IN (''PENDING_PAYMENT'',''PAID'',''APPROVED'',''CHECKED_IN'')
             AND i.check_in_time < b.check_out_time
             AND i.check_out_time > b.check_in_time
        )
        BEGIN
            THROW 50001, ''Overlapping booking for the same room is not allowed.'', 1;
        END
    END
    ');

    /* ---------------------------------------------------------
       9) TIME NORMALIZATION TO RECENT WINDOW (LAST 60 DAYS)
       --------------------------------------------------------- */
    DECLARE @anchor DATETIME2(7) = DATEADD(DAY, -45, SYSUTCDATETIME());

    IF OBJECT_ID('tempdb..#booking_shift') IS NOT NULL DROP TABLE #booking_shift;
    SELECT
        b.booking_id,
        shift_days = DATEDIFF(DAY, CAST(b.check_in_time AS DATE), CAST(@anchor AS DATE))
    INTO #booking_shift
    FROM dbo.Booking b;

    UPDATE b
    SET
        created_at = DATEADD(DAY, s.shift_days, b.created_at),
        updated_at = CASE WHEN b.updated_at IS NULL THEN NULL ELSE DATEADD(DAY, s.shift_days, b.updated_at) END,
        check_in_time = DATEADD(DAY, s.shift_days, b.check_in_time),
        check_out_time = DATEADD(DAY, s.shift_days, b.check_out_time),
        actual_check_in_time = CASE WHEN b.actual_check_in_time IS NULL THEN NULL ELSE DATEADD(DAY, s.shift_days, b.actual_check_in_time) END,
        actual_check_out_time = CASE WHEN b.actual_check_out_time IS NULL THEN NULL ELSE DATEADD(DAY, s.shift_days, b.actual_check_out_time) END
    FROM dbo.Booking b
    JOIN #booking_shift s ON s.booking_id = b.booking_id;

    UPDATE p
    SET
        transaction_time = DATEADD(DAY, s.shift_days, p.transaction_time),
        created_at = DATEADD(DAY, s.shift_days, p.created_at),
        updated_at = CASE WHEN p.updated_at IS NULL THEN NULL ELSE DATEADD(DAY, s.shift_days, p.updated_at) END
    FROM dbo.Payment p
    JOIN dbo.Booking b ON b.booking_id = p.booking_id
    JOIN #booking_shift s ON s.booking_id = b.booking_id;

    IF OBJECT_ID('dbo.Feedback', 'U') IS NOT NULL
    BEGIN
        IF COL_LENGTH('dbo.Feedback', 'updated_at') IS NULL
            ALTER TABLE dbo.Feedback ADD updated_at DATETIME2(7) NULL;

        UPDATE f
        SET
            created_at = DATEADD(DAY, s.shift_days, f.created_at),
            updated_at = CASE WHEN f.updated_at IS NULL THEN NULL ELSE DATEADD(DAY, s.shift_days, f.updated_at) END
        FROM dbo.Feedback f
        JOIN dbo.Booking b ON b.booking_id = f.booking_id
        JOIN #booking_shift s ON s.booking_id = b.booking_id;
    END

    IF OBJECT_ID('dbo.HousekeepingTask', 'U') IS NOT NULL
    BEGIN
        IF COL_LENGTH('dbo.HousekeepingTask', 'updated_at') IS NULL
            ALTER TABLE dbo.HousekeepingTask ADD updated_at DATETIME2(7) NULL;

        UPDATE h
        SET
            created_at = DATEADD(DAY, s.shift_days, h.created_at),
            started_at = CASE WHEN h.started_at IS NULL THEN NULL ELSE DATEADD(DAY, s.shift_days, h.started_at) END,
            completed_at = CASE WHEN h.completed_at IS NULL THEN NULL ELSE DATEADD(DAY, s.shift_days, h.completed_at) END,
            updated_at = CASE WHEN h.updated_at IS NULL THEN NULL ELSE DATEADD(DAY, s.shift_days, h.updated_at) END
        FROM dbo.HousekeepingTask h
        JOIN dbo.Booking b ON b.booking_id = h.booking_id
        JOIN #booking_shift s ON s.booking_id = b.booking_id;
    END

    IF OBJECT_ID('dbo.RoomStatusLog', 'U') IS NOT NULL
    BEGIN
        UPDATE l
        SET l.created_at = DATEADD(DAY, s.shift_days, l.created_at)
        FROM dbo.RoomStatusLog l
        JOIN #booking_shift s ON s.booking_id = l.booking_id;
    END

    DECLARE @max_allowed DATETIME2(7) = DATEADD(MINUTE, -5, SYSUTCDATETIME());
    UPDATE dbo.Booking
    SET check_in_time = CASE WHEN check_in_time > @max_allowed THEN @max_allowed ELSE check_in_time END,
        check_out_time = CASE WHEN check_out_time > DATEADD(HOUR, 2, @max_allowed) THEN DATEADD(HOUR, 2, @max_allowed) ELSE check_out_time END;

    UPDATE dbo.Booking
    SET check_out_time = DATEADD(HOUR, 2, check_in_time)
    WHERE check_out_time <= check_in_time;

    UPDATE p
    SET transaction_time = DATEADD(MINUTE, 10, b.created_at)
    FROM dbo.Payment p
    JOIN dbo.Booking b ON b.booking_id = p.booking_id
    WHERE p.transaction_time < b.created_at;

    /* ---------------------------------------------------------
       10) PERFORMANCE INDEXES
       --------------------------------------------------------- */
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Booking') AND name = 'IX_Booking_Status_CreatedAt_Remake')
        CREATE INDEX IX_Booking_Status_CreatedAt_Remake ON dbo.Booking(booking_status, created_at);

    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Booking') AND name = 'IX_Booking_Customer_CreatedAt_Remake')
        CREATE INDEX IX_Booking_Customer_CreatedAt_Remake ON dbo.Booking(customer_id, created_at DESC);

    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Payment') AND name = 'IX_Payment_TransactionTime_Remake')
        CREATE INDEX IX_Payment_TransactionTime_Remake ON dbo.Payment(transaction_time);

    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Room') AND name = 'IX_Room_Status_Remake')
        CREATE INDEX IX_Room_Status_Remake ON dbo.Room(status) INCLUDE (room_type_id, room_number);

    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Customer') AND name = 'IX_Customer_AvatarPublicId_Remake')
        CREATE INDEX IX_Customer_AvatarPublicId_Remake ON dbo.Customer(avatar_public_id) WHERE avatar_public_id IS NOT NULL;

    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Amenity') AND name = 'IX_Amenity_IconPublicId_Remake')
        CREATE INDEX IX_Amenity_IconPublicId_Remake ON dbo.Amenity(icon_public_id) WHERE icon_public_id IS NOT NULL;

    IF OBJECT_ID('dbo.RoomImage', 'U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.RoomImage') AND name = 'IX_RoomImage_PublicId_Remake')
            CREATE INDEX IX_RoomImage_PublicId_Remake ON dbo.RoomImage(image_public_id) WHERE image_public_id IS NOT NULL;
    END
    ELSE IF OBJECT_ID('dbo.Image', 'U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.Image') AND name = 'IX_Image_PublicId_Remake')
            CREATE INDEX IX_Image_PublicId_Remake ON dbo.Image(image_public_id) WHERE image_public_id IS NOT NULL;
    END

    /* ---------------------------------------------------------
       11) VALIDATION CHECKPOINTS
       --------------------------------------------------------- */
    IF EXISTS (
        SELECT 1
        FROM dbo.Room
        WHERE room_number NOT LIKE '[A-Z]-[A-Za-z]%-[0-9][0-9]'
    ) THROW 50030, 'Invalid room_number remains after migration.', 1;

    IF EXISTS (
        SELECT 1
        FROM dbo.Booking
        WHERE booking_status NOT IN ('PENDING_PAYMENT','PAID','APPROVED','CHECKED_IN','CHECKED_OUT','COMPLETED','FAILED','CANCELED','REJECTED')
    ) THROW 50031, 'Invalid booking_status remains after migration.', 1;

    IF EXISTS (
        SELECT 1
        FROM dbo.Payment
        WHERE payment_status NOT IN ('SUCCESS','FAILURE')
    ) THROW 50032, 'Invalid payment_status remains after migration.', 1;

    IF EXISTS (
        SELECT 1
        FROM dbo.Customer
        WHERE avatar_url IS NOT NULL AND avatar_public_id IS NULL
    ) THROW 50033, 'Customer avatar_url exists but avatar_public_id is missing.', 1;

    IF EXISTS (
        SELECT 1
        FROM dbo.Amenity
        WHERE icon_url IS NOT NULL AND icon_public_id IS NULL
    ) THROW 50034, 'Amenity icon_url exists but icon_public_id is missing.', 1;

    IF OBJECT_ID('dbo.RoomImage', 'U') IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM dbo.RoomImage
            WHERE image_url IS NOT NULL AND image_public_id IS NULL
        ) THROW 50035, 'RoomImage image_url exists but image_public_id is missing.', 1;
    END
    ELSE IF OBJECT_ID('dbo.Image', 'U') IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM dbo.Image
            WHERE image_url IS NOT NULL AND image_public_id IS NULL
        ) THROW 50036, 'Image image_url exists but image_public_id is missing.', 1;
    END

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @num INT = ERROR_NUMBER();
    DECLARE @state INT = ERROR_STATE();
    RAISERROR('Migration failed: %s', 16, 1, @msg) WITH NOWAIT;
    THROW @num, @msg, @state;
END CATCH;

/* Post-run reports */
SELECT 'Room invalid format' AS check_name, COUNT(*) AS issue_count
FROM dbo.Room
WHERE room_number NOT LIKE '[A-Z]-[A-Za-z]%-[0-9][0-9]'
UNION ALL
SELECT 'Booking invalid status', COUNT(*)
FROM dbo.Booking
WHERE booking_status NOT IN ('PENDING_PAYMENT','PAID','APPROVED','CHECKED_IN','CHECKED_OUT','COMPLETED','FAILED','CANCELED','REJECTED')
UNION ALL
SELECT 'Payment invalid status', COUNT(*)
FROM dbo.Payment
WHERE payment_status NOT IN ('SUCCESS','FAILURE');

SELECT 'Customer missing avatar_public_id' AS check_name, COUNT(*) AS issue_count
FROM dbo.Customer
WHERE avatar_url IS NOT NULL AND avatar_public_id IS NULL
UNION ALL
SELECT 'Amenity missing icon_public_id', COUNT(*)
FROM dbo.Amenity
WHERE icon_url IS NOT NULL AND icon_public_id IS NULL
UNION ALL
SELECT 'RoomImage/Image missing image_public_id',
       CASE
           WHEN OBJECT_ID('dbo.RoomImage', 'U') IS NOT NULL THEN (SELECT COUNT(*) FROM dbo.RoomImage WHERE image_url IS NOT NULL AND image_public_id IS NULL)
           WHEN OBJECT_ID('dbo.Image', 'U') IS NOT NULL THEN (SELECT COUNT(*) FROM dbo.Image WHERE image_url IS NOT NULL AND image_public_id IS NULL)
           ELSE 0
       END;
