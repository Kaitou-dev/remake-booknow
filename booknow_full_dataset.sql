-- ============================================================
-- BookNow — Full Realistic Dataset
-- Generated for: BookNow Homestay Booking System
-- Database: Microsoft SQL Server
-- Date: 2026-03-13
-- ============================================================
-- IMPORTANT: Run insert.sql FIRST (contains RoomType, Room,
-- Amenity, Image, RoomAmenity data)
-- ============================================================

USE [book_now]
GO

-- ============================================================
-- Khung giờ (4 slot)
-- ============================================================
SET IDENTITY_INSERT [dbo].[Timetable] ON;

INSERT INTO [dbo].[Timetable] ([timetable_id], [slot_name], [start_time], [end_time]) VALUES
(1, N'Sáng', '10:30:00', '13:30:00'),
(2, N'Chiều', '14:00:00', '17:00:00'),
(3, N'Tối', '17:30:00', '20:30:00'),
(4, N'đêm', '21:00:00', '09:50:00');

SET IDENTITY_INSERT [dbo].[Timetable] OFF;
GO

-- ============================================================
-- Khách hàng (40 người dùng)
-- Mật khẩu: User@123 (bcrypt 12 rounds)
-- ============================================================
SET IDENTITY_INSERT [dbo].[Customer] ON;

INSERT INTO [dbo].[Customer] ([customer_id], [email], [password_hash], [full_name], [avatar_url], [phone], [status], [created_at], [updated_at], [is_deleted], [avatar_public_id]) VALUES
(1, N'minhanh.nguyen@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Nguyễn Minh Anh', N'https://randomuser.me/api/portraits/women/1.jpg', N'0912345678', 'ACTIVE', '2024-01-15 08:30:00', NULL, 0, NULL),
(2, N'thanh.dat.pham@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Phạm Thành Đạt', N'https://randomuser.me/api/portraits/men/2.jpg', N'0987654321', 'ACTIVE', '2024-01-20 09:15:00', NULL, 0, NULL),
(3, N'linh.tran88@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Trần Thùy Linh', N'https://randomuser.me/api/portraits/women/3.jpg', N'0935566778', 'ACTIVE', '2024-02-01 10:00:00', NULL, 0, NULL),
(4, N'bao.hoang@outlook.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Hoàng Gia Bảo', N'https://randomuser.me/api/portraits/men/4.jpg', N'0901234567', 'ACTIVE', '2024-02-10 11:30:00', NULL, 0, NULL),
(5, N'thu.le.95@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Lê Thanh Thư', N'https://randomuser.me/api/portraits/women/5.jpg', N'0918765432', 'ACTIVE', '2024-02-15 14:00:00', NULL, 0, NULL),
(6, N'quang.vo.dev@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Võ Minh Quang', N'https://randomuser.me/api/portraits/men/6.jpg', N'0923456789', 'ACTIVE', '2024-02-20 15:30:00', NULL, 0, NULL),
(7, N'ha.phuong.ngo@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Ngô Hà Phương', N'https://randomuser.me/api/portraits/women/7.jpg', N'0934567890', 'ACTIVE', '2024-03-01 08:00:00', NULL, 0, NULL),
(8, N'tuan.kiet.le@outlook.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Lê Tuấn Kiệt', N'https://randomuser.me/api/portraits/men/8.jpg', N'0945678901', 'ACTIVE', '2024-03-05 09:30:00', NULL, 0, NULL),
(9, N'ngoc.mai.dang@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Đặng Ngọc Mai', N'https://randomuser.me/api/portraits/women/9.jpg', N'0956789012', 'ACTIVE', '2024-03-10 10:45:00', NULL, 0, NULL),
(10, N'duc.manh.tran@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Trần Đức Mạnh', N'https://randomuser.me/api/portraits/men/10.jpg', N'0967890123', 'ACTIVE', '2024-03-15 11:15:00', NULL, 0, NULL),
(11, N'yen.nhi.bui@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Bùi Yến Nhi', N'https://randomuser.me/api/portraits/women/11.jpg', N'0978901234', 'ACTIVE', '2024-03-20 12:00:00', NULL, 0, NULL),
(12, N'anh.tuan.vu@outlook.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Vũ Anh Tuấn', N'https://randomuser.me/api/portraits/men/12.jpg', N'0989012345', 'ACTIVE', '2024-04-01 08:30:00', NULL, 0, NULL),
(13, N'hong.nhung.cao@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Cao Hồng Nhung', N'https://randomuser.me/api/portraits/women/13.jpg', N'0990123456', 'ACTIVE', '2024-04-05 09:00:00', NULL, 0, NULL),
(14, N'minh.quan.ho@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Hồ Minh Quân', N'https://randomuser.me/api/portraits/men/14.jpg', N'0911234567', 'ACTIVE', '2024-04-10 10:30:00', NULL, 0, NULL),
(15, N'thao.linh.do@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Đỗ Thảo Linh', N'https://randomuser.me/api/portraits/women/15.jpg', N'0922345678', 'ACTIVE', '2024-04-15 11:00:00', NULL, 0, NULL),
(16, N'van.long.phan@outlook.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Phan Văn Long', N'https://randomuser.me/api/portraits/men/16.jpg', N'0933456789', 'ACTIVE', '2024-04-20 14:00:00', NULL, 0, NULL),
(17, N'kim.chi.ly@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Lý Kim Chi', N'https://randomuser.me/api/portraits/women/17.jpg', N'0944567890', 'ACTIVE', '2024-05-01 08:00:00', NULL, 0, NULL),
(18, N'hai.dang.trinh@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Trịnh Hải Đăng', N'https://randomuser.me/api/portraits/men/18.jpg', N'0955678901', 'ACTIVE', '2024-05-05 09:30:00', NULL, 0, NULL),
(19, N'quynh.anh.luong@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Lương Quỳnh Anh', N'https://randomuser.me/api/portraits/women/19.jpg', N'0966789012', 'ACTIVE', '2024-05-10 10:00:00', NULL, 0, NULL),
(20, N'dinh.son.ma@outlook.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Mã Đình Sơn', N'https://randomuser.me/api/portraits/men/20.jpg', N'0977890123', 'ACTIVE', '2024-05-15 11:30:00', NULL, 0, NULL),
(21, N'bich.ngoc.vu@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Vũ Bích Ngọc', N'https://randomuser.me/api/portraits/women/21.jpg', N'0988901234', 'ACTIVE', '2024-05-20 12:00:00', NULL, 0, NULL),
(22, N'thanh.hung.duong@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Dương Thanh Hùng', N'https://randomuser.me/api/portraits/men/22.jpg', N'0999012345', 'ACTIVE', '2024-06-01 08:30:00', NULL, 0, NULL),
(23, N'my.hanh.ta@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Tạ Mỹ Hạnh', N'https://randomuser.me/api/portraits/women/23.jpg', N'0910123456', 'ACTIVE', '2024-06-05 09:00:00', NULL, 0, NULL),
(24, N'quoc.bao.doan@outlook.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Đoàn Quốc Bảo', N'https://randomuser.me/api/portraits/men/24.jpg', N'0921234567', 'ACTIVE', '2024-06-10 10:30:00', NULL, 0, NULL),
(25, N'tuyet.mai.lai@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Lại Tuyết Mai', N'https://randomuser.me/api/portraits/women/25.jpg', N'0932345678', 'ACTIVE', '2024-06-15 11:00:00', NULL, 0, NULL),
(26, N'hoang.phuc.nhan@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Nhân Hoàng Phúc', N'https://randomuser.me/api/portraits/men/26.jpg', N'0943456789', 'ACTIVE', '2024-06-20 14:00:00', NULL, 0, NULL),
(27, N'cam.tu.bach@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Bạch Cẩm Tú', N'https://randomuser.me/api/portraits/women/27.jpg', N'0954567890', 'ACTIVE', '2024-07-01 08:00:00', NULL, 0, NULL),
(28, N'viet.hoang.su@outlook.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Sử Việt Hoàng', N'https://randomuser.me/api/portraits/men/28.jpg', N'0965678901', 'ACTIVE', '2024-07-05 09:30:00', NULL, 0, NULL),
(29, N'thanh.thao.vuong@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Vương Thanh Thảo', N'https://randomuser.me/api/portraits/women/29.jpg', N'0976789012', 'ACTIVE', '2024-07-10 10:00:00', NULL, 0, NULL),
(30, N'minh.tri.chau@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Châu Minh Trí', N'https://randomuser.me/api/portraits/men/30.jpg', N'0987890123', 'ACTIVE', '2024-07-15 11:30:00', NULL, 0, NULL),
(31, N'ngoc.han.truong@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Trương Ngọc Hân', N'https://randomuser.me/api/portraits/women/31.jpg', N'0998901234', 'ACTIVE', '2024-07-20 12:00:00', NULL, 0, NULL),
(32, N'gia.huy.dam@outlook.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Đàm Gia Huy', N'https://randomuser.me/api/portraits/men/32.jpg', N'0909012345', 'ACTIVE', '2024-08-01 08:30:00', NULL, 0, NULL),
(33, N'lan.anh.ta@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Tạ Lan Anh', N'https://randomuser.me/api/portraits/women/33.jpg', N'0920123456', 'ACTIVE', '2024-08-05 09:00:00', NULL, 0, NULL),
(34, N'van.thinh.lam@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Lâm Văn Thịnh', N'https://randomuser.me/api/portraits/men/34.jpg', N'0931234567', 'ACTIVE', '2024-08-10 10:30:00', NULL, 0, NULL),
(35, N'phuong.thuy.dinh@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Đinh Phương Thúy', N'https://randomuser.me/api/portraits/women/35.jpg', N'0942345678', 'ACTIVE', '2024-08-15 11:00:00', NULL, 0, NULL),
(36, N'khoi.nguyen.an@outlook.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'An Khôi Nguyên', N'https://randomuser.me/api/portraits/men/36.jpg', N'0953456789', 'ACTIVE', '2024-08-20 14:00:00', NULL, 0, NULL),
(37, N'Kim.Ha.Le@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Lê Kim Hà', N'https://randomuser.me/api/portraits/women/37.jpg', N'0964567890', 'ACTIVE', '2024-09-01 08:00:00', NULL, 0, NULL),
(38, N'huu.loc.tran@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Trần Hữu Lộc', N'https://randomuser.me/api/portraits/men/38.jpg', N'0975678901', 'ACTIVE', '2024-09-05 09:30:00', NULL, 0, NULL),
(39, N'ngoc.diep.ho@gmail.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Hồ Ngọc Diệp', N'https://randomuser.me/api/portraits/women/39.jpg', N'0986789012', 'ACTIVE', '2024-09-10 10:00:00', 'ACTIVE', 0, NULL),
(40, N'trung.kien.bui@outlook.com', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Bùi Trung Kiên', N'https://randomuser.me/api/portraits/men/40.jpg', N'0997890123', 'ACTIVE', '2024-09-15 11:30:00', NULL, 0, NULL);

SET IDENTITY_INSERT [dbo].[Customer] OFF;
GO

-- ============================================================
-- Tài khoản nhân viên (5 Admin + 10 Nhân viên + 10 Housekeeping = 25 người)
-- Mật khẩu: User@123 (bcrypt 12 rounds)
-- ============================================================
SET IDENTITY_INSERT [dbo].[StaffAccounts] ON;

-- ADMIN (5 người)
INSERT INTO [dbo].[StaffAccounts] ([staff_account_id], [email], [phone], [password_hash], [full_name], [avatar_url], [role], [status], [created_at], [is_deleted], [avatar_public_id]) VALUES
(1, N'admin.booknow@gmail.com', N'0901000001', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Nguyễn Văn Minh', N'https://randomuser.me/api/portraits/men/50.jpg', 'ADMIN', 'ACTIVE', '2024-01-01 08:00:00', 0, NULL),
(2, N'quan.ly.system@booknow.vn', N'0901000002', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Trần Thị Quản Lý', N'https://randomuser.me/api/portraits/women/50.jpg', 'ADMIN', 'ACTIVE', '2024-01-01 08:30:00', 0, NULL),
(3, N'superadmin@booknow.vn', N'0901000003', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Lê Minh Tuấn', N'https://randomuser.me/api/portraits/men/51.jpg', 'ADMIN', 'ACTIVE', '2024-01-01 09:00:00', 0, NULL),
(4, N'admin.cantho@booknow.vn', N'0901000004', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Phạm Văn Tuấn', N'https://randomuser.me/api/portraits/men/52.jpg', 'ADMIN', 'ACTIVE', '2024-01-05 10:00:00', 0, NULL),
(5, N'admin.manager@booknow.vn', N'0901000005', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Hoàng Thị Lan', N'https://randomuser.me/api/portraits/women/51.jpg', 'ADMIN', 'ACTIVE', '2024-01-10 08:00:00', 0, NULL),

-- NHÂN VIÊN (10 người)
(6, N'staff.reception01@booknow.vn', N'0902000001', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Nguyễn Thị Hoa', N'https://randomuser.me/api/portraits/women/52.jpg', 'STAFF', 'ACTIVE', '2024-01-15 08:00:00', 0, NULL),
(7, N'staff.reception02@booknow.vn', N'0902000002', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Trần Văn Minh', N'https://randomuser.me/api/portraits/men/53.jpg', 'STAFF', 'ACTIVE', '2024-01-15 08:30:00', 0, NULL),
(8, N'staff.booking@booknow.vn', N'0902000003', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Lê Thị Ngọc', N'https://randomuser.me/api/portraits/women/53.jpg', 'STAFF', 'ACTIVE', '2024-01-20 09:00:00', 0, NULL),
(9, N'staff.support@booknow.vn', N'0902000004', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Võ Văn Đức', N'https://randomuser.me/api/portraits/men/54.jpg', 'STAFF', 'ACTIVE', '2024-01-25 10:00:00', 0, NULL),
(10, N'staff.customer@booknow.vn', N'0902000005', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Phạm Thị Mai', N'https://randomuser.me/api/portraits/women/54.jpg', 'STAFF', 'ACTIVE', '2024-02-01 08:00:00', 0, NULL),
(11, N'staff.night01@booknow.vn', N'0902000006', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Đặng Văn Long', N'https://randomuser.me/api/portraits/men/55.jpg', 'STAFF', 'ACTIVE', '2024-02-05 08:30:00', 0, NULL),
(12, N'staff.night02@booknow.vn', N'0902000007', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Bùi Thị Kim', N'https://randomuser.me/api/portraits/women/55.jpg', 'STAFF', 'ACTIVE', '2024-02-10 09:00:00', 0, NULL),
(13, N'staff.morning@booknow.vn', N'0902000008', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Cao Van Thanh', N'https://randomuser.me/api/portraits/men/56.jpg', 'STAFF', 'ACTIVE', '2024-02-15 10:00:00', 0, NULL),
(14, N'staff.afternoon@booknow.vn', N'0902000009', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Ho Thi Lan', N'https://randomuser.me/api/portraits/women/56.jpg', 'STAFF', 'ACTIVE', '2024-02-20 08:00:00', 0, NULL),
(15, N'staff.weekend@booknow.vn', N'0902000010', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Ly Van Binh', N'https://randomuser.me/api/portraits/men/57.jpg', 'STAFF', 'ACTIVE', '2024-02-25 09:30:00', 0, NULL),

-- DỌN PHÒNG (10 người)
(16, N'hk.team01@booknow.vn', N'0903000001', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Nguyen Thi Sau', N'https://randomuser.me/api/portraits/women/57.jpg', 'HOUSEKEEPING', 'ACTIVE', '2024-03-01 07:00:00', 0, NULL),
(17, N'hk.team02@booknow.vn', N'0903000002', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Tran Van Bay', N'https://randomuser.me/api/portraits/men/58.jpg', 'HOUSEKEEPING', 'ACTIVE', '2024-03-01 07:30:00', 0, NULL),
(18, N'hk.team03@booknow.vn', N'0903000003', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Le Thi Tam', N'https://randomuser.me/api/portraits/women/58.jpg', 'HOUSEKEEPING', 'ACTIVE', '2024-03-05 08:00:00', 0, NULL),
(19, N'hk.team04@booknow.vn', N'0903000004', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Pham Van Chin', N'https://randomuser.me/api/portraits/men/59.jpg', 'HOUSEKEEPING', 'ACTIVE', '2024-03-10 07:00:00', 0, NULL),
(20, N'hk.team05@booknow.vn', N'0903000005', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Vo Thi Muoi', N'https://randomuser.me/api/portraits/women/59.jpg', 'HOUSEKEEPING', 'ACTIVE', '2024-03-15 07:30:00', 0, NULL),
(21, N'hk.supervisor@booknow.vn', N'0903000006', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Đặng Văn Hải', N'https://randomuser.me/api/portraits/men/60.jpg', 'HOUSEKEEPING', 'ACTIVE', '2024-03-20 08:00:00', 0, NULL),
(22, N'hk.maintenance@booknow.vn', N'0903000007', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Bui Van Ba', N'https://randomuser.me/api/portraits/men/61.jpg', 'HOUSEKEEPING', 'ACTIVE', '2024-03-25 07:00:00', 0, NULL),
(23, N'hk.morning@booknow.vn', N'0903000008', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Cao Thi Tu', N'https://randomuser.me/api/portraits/women/60.jpg', 'HOUSEKEEPING', 'ACTIVE', '2024-04-01 07:30:00', 0, NULL),
(24, N'hk.afternoon@booknow.vn', N'0903000009', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Ho Van Nam', N'https://randomuser.me/api/portraits/men/62.jpg', 'HOUSEKEEPING', 'ACTIVE', '2024-04-05 08:00:00', 0, NULL),
(25, N'hk.night@booknow.vn', N'0903000010', N'$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4VQ5YaRMdwkRquS6', N'Nguyen Thi Luc', N'https://randomuser.me/api/portraits/women/61.jpg', 'HOUSEKEEPING', 'ACTIVE', '2024-04-10 07:00:00', 0, NULL);

SET IDENTITY_INSERT [dbo].[StaffAccounts] OFF;
GO

-- ============================================================
-- Booking (120+ bookings - distributed across customers and dates)
-- Statuses: PENDING, PENDING_PAYMENT, PAID, CHECKED_IN, CHECKED_OUT, COMPLETED, FAILED, REJECTED
-- ============================================================
SET IDENTITY_INSERT [dbo].[Booking] ON;

-- COMPLETED bookings (past - 2024)
INSERT INTO [dbo].[Booking] ([booking_id], [customer_id], [room_id], [check_in_time], [check_out_time], [actual_check_in_time], [actual_check_out_time], [id_card_front_url], [id_card_back_url], [booking_status], [total_amount], [booking_code], [created_at], [note], [update_at]) VALUES
(1, 1, 1, '2024-03-15 10:30:00', '2024-03-15 13:30:00', '2024-03-15 10:35:00', '2024-03-15 13:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_001.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_001.jpg', 'COMPLETED', 259000.00, N'BK20240315001', '2024-03-14 15:00:00', N'First booking - customer enjoyed the ocean theme', '2024-03-15 13:30:00'),
(2, 1, 5, '2024-04-20 14:00:00', '2024-04-20 17:00:00', '2024-04-20 14:05:00', '2024-04-20 16:55:00', N'https://res.cloudinary.com/booknow/id_cards/front_001.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_001.jpg', 'COMPLETED', 269000.00, N'BK20240420001', '2024-04-19 10:00:00', NULL, '2024-04-20 17:00:00'),
(3, 1, 10, '2024-06-10 17:30:00', '2024-06-10 20:30:00', '2024-06-10 17:40:00', '2024-06-10 20:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_001.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_001.jpg', 'COMPLETED', 235000.00, N'BK20240610001', '2024-06-09 14:00:00', N'Evening slot preferred', '2024-06-10 20:30:00'),
(4, 2, 2, '2024-03-20 21:00:00', '2024-03-21 09:50:00', '2024-03-20 21:10:00', '2024-03-21 09:45:00', N'https://res.cloudinary.com/booknow/id_cards/front_002.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_002.jpg', 'COMPLETED', 299000.00, N'BK20240320001', '2024-03-19 16:00:00', N'Night stay with kitchen access', '2024-03-21 10:00:00'),
(5, 2, 8, '2024-05-05 10:30:00', '2024-05-05 13:30:00', '2024-05-05 10:30:00', '2024-05-05 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_002.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_002.jpg', 'COMPLETED', 239000.00, N'BK20240505001', '2024-05-04 09:00:00', NULL, '2024-05-05 13:35:00'),
(6, 2, 15, '2024-07-15 14:00:00', '2024-07-15 17:00:00', '2024-07-15 14:10:00', '2024-07-15 16:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_002.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_002.jpg', 'COMPLETED', 189000.00, N'BK20240715001', '2024-07-14 11:00:00', N'Mellow room - very relaxing', '2024-07-15 17:00:00'),
(7, 3, 3, '2024-04-01 17:30:00', '2024-04-01 20:30:00', '2024-04-01 17:35:00', '2024-04-01 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_003.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_003.jpg', 'COMPLETED', 249000.00, N'BK20240401001', '2024-03-31 12:00:00', N'Pink Paradise - loved the decor', '2024-04-01 20:35:00'),
(8, 3, 12, '2024-05-25 21:00:00', '2024-05-26 09:50:00', '2024-05-25 21:05:00', '2024-05-26 09:40:00', N'https://res.cloudinary.com/booknow/id_cards/front_003.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_003.jpg', 'COMPLETED', 279000.00, N'BK20240525001', '2024-05-24 15:00:00', N'Wood Mood - cozy atmosphere', '2024-05-26 09:50:00'),
(9, 3, 18, '2024-08-10 10:30:00', '2024-08-10 13:30:00', '2024-08-10 10:40:00', '2024-08-10 13:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_003.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_003.jpg', 'COMPLETED', 279000.00, N'BK20240810001', '2024-08-09 10:00:00', N'Squid Game theme was amazing!', '2024-08-10 13:30:00'),
(10, 4, 4, '2024-04-10 14:00:00', '2024-04-10 17:00:00', '2024-04-10 14:00:00', '2024-04-10 17:00:00', N'https://res.cloudinary.com/booknow/id_cards/front_004.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_004.jpg', 'COMPLETED', 259000.00, N'BK20240410001', '2024-04-09 09:00:00', N'Tiger Woods theme - great for golf enthusiasts', '2024-04-10 17:05:00'),
(11, 4, 9, '2024-06-20 17:30:00', '2024-06-20 20:30:00', '2024-06-20 17:30:00', '2024-06-20 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_004.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_004.jpg', 'COMPLETED', 255000.00, N'BK20240620001', '2024-06-19 14:00:00', N'Cine Room - watched 2 movies', '2024-06-20 20:35:00'),
(12, 4, 22, '2024-09-05 21:00:00', '2024-09-06 09:50:00', '2024-09-05 21:15:00', '2024-09-06 09:45:00', N'https://res.cloudinary.com/booknow/id_cards/front_004.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_004.jpg', 'COMPLETED', 255000.00, N'BK20240905001', '2024-09-04 16:00:00', N'Solo Gaming - played all night', '2024-09-06 09:50:00'),
(13, 5, 6, '2024-04-25 10:30:00', '2024-04-25 13:30:00', '2024-04-25 10:35:00', '2024-04-25 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_005.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_005.jpg', 'COMPLETED', 279000.00, N'BK20240425001', '2024-04-24 11:00:00', N'GameHub - perfect for gaming sessions', '2024-04-25 13:35:00'),
(14, 5, 14, '2024-07-01 14:00:00', '2024-07-01 17:00:00', '2024-07-01 14:05:00', '2024-07-01 16:55:00', N'https://res.cloudinary.com/booknow/id_cards/front_005.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_005.jpg', 'COMPLETED', 229000.00, N'BK20240701001', '2024-06-30 10:00:00', N'Bass Bar - great sound system', '2024-07-01 17:00:00'),
(15, 5, 25, '2024-09-20 17:30:00', '2024-09-20 20:30:00', '2024-09-20 17:40:00', '2024-09-20 20:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_005.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_005.jpg', 'COMPLETED', 255000.00, N'BK20240920001', '2024-09-19 15:00:00', N'Mykonos theme - beautiful Greek atmosphere', '2024-09-20 20:30:00'),
(16, 6, 7, '2024-05-01 21:00:00', '2024-05-02 09:50:00', '2024-05-01 21:00:00', '2024-05-02 09:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_006.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_006.jpg', 'COMPLETED', 269000.00, N'BK20240501001', '2024-04-30 14:00:00', N'Honey House - sweet and cozy', '2024-05-02 09:55:00'),
(17, 6, 17, '2024-07-20 10:30:00', '2024-07-20 13:30:00', '2024-07-20 10:30:00', '2024-07-20 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_006.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_006.jpg', 'COMPLETED', 199000.00, N'BK20240720001', '2024-07-19 09:00:00', N'Love Blaze - romantic atmosphere', '2024-07-20 13:35:00'),
(18, 6, 27, '2024-10-05 14:00:00', '2024-10-05 17:00:00', '2024-10-05 14:10:00', '2024-10-05 16:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_006.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_006.jpg', 'COMPLETED', 305000.00, N'BK20241005001', '2024-10-04 11:00:00', N'Moon Space - out of this world experience', '2024-10-05 17:00:00'),
(19, 7, 11, '2024-05-15 17:30:00', '2024-05-15 20:30:00', '2024-05-15 17:35:00', '2024-05-15 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_007.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_007.jpg', 'COMPLETED', 245000.00, N'BK20240515001', '2024-05-14 12:00:00', N'Bea Bear - cute and comfortable', '2024-05-15 20:35:00'),
(20, 7, 19, '2024-08-01 21:00:00', '2024-08-02 09:50:00', '2024-08-01 21:05:00', '2024-08-02 09:45:00', N'https://res.cloudinary.com/booknow/id_cards/front_007.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_007.jpg', 'COMPLETED', 235000.00, N'BK20240801001', '2024-07-31 15:00:00', N'Lavender room - very calming', '2024-08-02 09:50:00'),
(21, 7, 30, '2024-10-20 10:30:00', '2024-10-20 13:30:00', '2024-10-20 10:40:00', '2024-10-20 13:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_007.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_007.jpg', 'COMPLETED', 265000.00, N'BK20241020001', '2024-10-19 10:00:00', N'Blue Wave - refreshing ocean vibes', '2024-10-20 13:30:00'),
(22, 8, 13, '2024-05-30 14:00:00', '2024-05-30 17:00:00', '2024-05-30 14:00:00', '2024-05-30 17:00:00', N'https://res.cloudinary.com/booknow/id_cards/front_008.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_008.jpg', 'COMPLETED', 225000.00, N'BK20240530001', '2024-05-29 09:00:00', N'Calm Cloud - very peaceful', '2024-05-30 17:05:00'),
(23, 8, 20, '2024-08-15 17:30:00', '2024-08-15 20:30:00', '2024-08-15 17:30:00', '2024-08-15 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_008.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_008.jpg', 'COMPLETED', 245000.00, N'BK20240815001', '2024-08-14 14:00:00', N'Ruby room with bida table - had a blast', '2024-08-15 20:35:00'),
(24, 8, 33, '2024-11-01 21:00:00', '2024-11-02 09:50:00', '2024-11-01 21:10:00', '2024-11-02 09:40:00', N'https://res.cloudinary.com/booknow/id_cards/front_008.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_008.jpg', 'COMPLETED', 285000.00, N'BK20241101001', '2024-10-31 16:00:00', N'CGV cinema experience at home', '2024-11-02 09:50:00'),
(25, 9, 16, '2024-06-05 10:30:00', '2024-06-05 13:30:00', '2024-06-05 10:35:00', '2024-06-05 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_009.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_009.jpg', 'COMPLETED', 169000.00, N'BK20240605001', '2024-06-04 11:00:00', N'Lion King theme - kids loved it', '2024-06-05 13:35:00'),
(26, 9, 21, '2024-08-25 14:00:00', '2024-08-25 17:00:00', '2024-08-25 14:05:00', '2024-08-25 16:55:00', N'https://res.cloudinary.com/booknow/id_cards/front_009.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_009.jpg', 'COMPLETED', 235000.00, N'BK20240825001', '2024-08-24 10:00:00', N'Cinema Zone - excellent projection quality', '2024-08-25 17:00:00'),
(27, 9, 35, '2024-11-15 17:30:00', '2024-11-15 20:30:00', '2024-11-15 17:40:00', '2024-11-15 20:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_009.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_009.jpg', 'COMPLETED', 265000.00, N'BK20241115001', '2024-11-14 15:00:00', N'Sweet Dreams - slept so well', '2024-11-15 20:30:00'),
(28, 10, 23, '2024-06-15 21:00:00', '2024-06-16 09:50:00', '2024-06-15 21:00:00', '2024-06-16 09:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_010.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_010.jpg', 'COMPLETED', 185000.00, N'BK20240615001', '2024-06-14 14:00:00', N'Green Haven - nature feels', '2024-06-16 09:55:00'),
(29, 10, 26, '2024-09-01 10:30:00', '2024-09-01 13:30:00', '2024-09-01 10:30:00', '2024-09-01 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_010.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_010.jpg', 'COMPLETED', 235000.00, N'BK20240901001', '2024-08-31 09:00:00', N'Orange Pop - vibrant and energetic', '2024-09-01 13:35:00'),
(30, 10, 37, '2024-12-01 14:00:00', '2024-12-01 17:00:00', '2024-12-01 14:10:00', '2024-12-01 16:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_010.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_010.jpg', 'COMPLETED', 245000.00, N'BK20241201001', '2024-11-30 11:00:00', N'Pink Dream - dreamy atmosphere', '2024-12-01 17:00:00'),

-- More COMPLETED bookings (customers 11-20)
(31, 11, 24, '2024-06-25 17:30:00', '2024-06-25 20:30:00', '2024-06-25 17:35:00', '2024-06-25 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_011.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_011.jpg', 'COMPLETED', 285000.00, N'BK20240625001', '2024-06-24 12:00:00', N'Zone X with bida - competitive night', '2024-06-25 20:35:00'),
(32, 11, 28, '2024-09-10 21:00:00', '2024-09-11 09:50:00', '2024-09-10 21:05:00', '2024-09-11 09:45:00', N'https://res.cloudinary.com/booknow/id_cards/front_011.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_011.jpg', 'COMPLETED', 285000.00, N'BK20240910001', '2024-09-09 15:00:00', N'Cheese room with kitchen - cooked a feast', '2024-09-11 09:50:00'),
(33, 11, 39, '2024-12-15 10:30:00', '2024-12-15 13:30:00', '2024-12-15 10:40:00', '2024-12-15 13:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_011.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_011.jpg', 'COMPLETED', 225000.00, N'BK20241215001', '2024-12-14 10:00:00', N'Pure Relax - truly relaxing experience', '2024-12-15 13:30:00'),
(34, 12, 29, '2024-07-05 14:00:00', '2024-07-05 17:00:00', '2024-07-05 14:00:00', '2024-07-05 17:00:00', N'https://res.cloudinary.com/booknow/id_cards/front_012.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_012.jpg', 'COMPLETED', 235000.00, N'BK20240705001', '2024-07-04 09:00:00', N'Love Pink - romantic afternoon', '2024-07-05 17:05:00'),
(35, 12, 31, '2024-09-25 17:30:00', '2024-09-25 20:30:00', '2024-09-25 17:30:00', '2024-09-25 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_012.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_012.jpg', 'COMPLETED', 275000.00, N'BK20240925001', '2024-09-24 14:00:00', N'Fini Homestay - private and romantic', '2024-09-25 20:35:00'),
(36, 12, 40, '2024-12-20 21:00:00', '2024-12-21 09:50:00', '2024-12-20 21:10:00', '2024-12-21 09:40:00', N'https://res.cloudinary.com/booknow/id_cards/front_012.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_012.jpg', 'COMPLETED', 235000.00, N'BK20241220001', '2024-12-19 16:00:00', N'Honey Glow - warm and inviting', '2024-12-21 09:50:00'),
(37, 13, 32, '2024-07-15 10:30:00', '2024-07-15 13:30:00', '2024-07-15 10:35:00', '2024-07-15 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_013.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_013.jpg', 'COMPLETED', 265000.00, N'BK20240715002', '2024-07-14 11:00:00', N'Luca Homestay - modern and convenient', '2024-07-15 13:35:00'),
(38, 13, 34, '2024-10-01 14:00:00', '2024-10-01 17:00:00', '2024-10-01 14:05:00', '2024-10-01 16:55:00', N'https://res.cloudinary.com/booknow/id_cards/front_013.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_013.jpg', 'COMPLETED', 285000.00, N'BK20241001001', '2024-09-30 10:00:00', N'Beach Homestay - like being at the beach', '2024-10-01 17:00:00'),
(39, 13, 41, '2025-01-05 17:30:00', '2025-01-05 20:30:00', '2025-01-05 17:40:00', '2025-01-05 20:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_013.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_013.jpg', 'COMPLETED', 275000.00, N'BK20250105001', '2025-01-04 15:00:00', N'CGV Room - movie marathon night', '2025-01-05 20:30:00'),
(40, 14, 36, '2024-07-25 21:00:00', '2024-07-26 09:50:00', '2024-07-25 21:00:00', '2024-07-26 09:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_014.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_014.jpg', 'COMPLETED', 255000.00, N'BK20240725001', '2024-07-24 14:00:00', N'Da Lat style in Can Tho - unique experience', '2024-07-26 09:55:00'),
(41, 14, 38, '2024-10-15 10:30:00', '2024-10-15 13:30:00', '2024-10-15 10:30:00', '2024-10-15 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_014.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_014.jpg', 'COMPLETED', 235000.00, N'BK20241015001', '2024-10-14 09:00:00', N'Blue Vibe - cool and calming', '2024-10-15 13:35:00'),
(42, 14, 42, '2025-01-15 14:00:00', '2025-01-15 17:00:00', '2025-01-15 14:10:00', '2025-01-15 16:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_014.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_014.jpg', 'COMPLETED', 295000.00, N'BK20250115001', '2025-01-14 11:00:00', N'Smoke Kitchen - culinary adventure', '2025-01-15 17:00:00'),
(43, 15, 43, '2024-08-05 17:30:00', '2024-08-05 20:30:00', '2024-08-05 17:35:00', '2024-08-05 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_015.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_015.jpg', 'COMPLETED', 295000.00, N'BK20240805001', '2024-08-04 12:00:00', N'8 Ball House - pool tournament with friends', '2024-08-05 20:35:00'),
(44, 15, 44, '2024-10-25 21:00:00', '2024-10-26 09:50:00', '2024-10-25 21:05:00', '2024-10-26 09:45:00', N'https://res.cloudinary.com/booknow/id_cards/front_015.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_015.jpg', 'COMPLETED', 315000.00, N'BK20241025001', '2024-10-24 15:00:00', N'La Maison - French elegance', '2024-10-25 09:50:00'),
(45, 15, 45, '2025-01-25 10:30:00', '2025-01-25 13:30:00', '2025-01-25 10:40:00', '2025-01-25 13:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_015.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_015.jpg', 'COMPLETED', 285000.00, N'BK20250125001', '2025-01-24 10:00:00', N'Masterchef kitchen - cooking class vibes', '2025-01-25 13:30:00'),
(46, 16, 46, '2024-08-20 14:00:00', '2024-08-20 17:00:00', '2024-08-20 14:00:00', '2024-08-20 17:00:00', N'https://res.cloudinary.com/booknow/id_cards/front_016.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_016.jpg', 'COMPLETED', 325000.00, N'BK20240820001', '2024-08-19 09:00:00', N'Atlantis - underwater wonderland', '2024-08-20 17:05:00'),
(47, 16, 47, '2024-11-05 17:30:00', '2024-11-05 20:30:00', '2024-11-05 17:30:00', '2024-11-05 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_016.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_016.jpg', 'COMPLETED', 275000.00, N'BK20241105001', '2024-11-04 14:00:00', N'Forest retreat - nature escape in the city', '2024-11-05 20:35:00'),
(48, 16, 48, '2025-02-05 21:00:00', '2025-02-06 09:50:00', '2025-02-05 21:10:00', '2025-02-06 09:40:00', N'https://res.cloudinary.com/booknow/id_cards/front_016.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_016.jpg', 'COMPLETED', 265000.00, N'BK20250205001', '2025-02-04 16:00:00', N'Vibe Home - great atmosphere', '2025-02-06 09:50:00'),
(49, 17, 49, '2024-09-05 10:30:00', '2024-09-05 13:30:00', '2024-09-05 10:35:00', '2024-09-05 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_017.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_017.jpg', 'COMPLETED', 295000.00, N'BK20240905002', '2024-09-04 11:00:00', N'Wine Ball - sophisticated evening', '2024-09-05 13:35:00'),
(50, 17, 50, '2024-11-20 14:00:00', '2024-11-20 17:00:00', '2024-11-20 14:05:00', '2024-11-20 16:55:00', N'https://res.cloudinary.com/booknow/id_cards/front_017.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_017.jpg', 'COMPLETED', 285000.00, N'BK20241120001', '2024-11-19 10:00:00', N'Video Game room - retro gaming fun', '2024-11-20 17:00:00'),
(51, 17, 51, '2025-02-15 17:30:00', '2025-02-15 20:30:00', '2025-02-15 17:40:00', '2025-02-15 20:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_017.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_017.jpg', 'COMPLETED', 275000.00, N'BK20250215001', '2025-02-14 15:00:00', N'Lasaoma - unique design concept', '2025-02-15 20:30:00'),
(52, 18, 52, '2024-09-15 21:00:00', '2024-09-16 09:50:00', '2024-09-15 21:00:00', '2024-09-16 09:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_018.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_018.jpg', 'COMPLETED', 245000.00, N'BK20240915001', '2024-09-14 14:00:00', N'Doraemon room - childhood nostalgia', '2024-09-16 09:55:00'),
(53, 18, 53, '2024-12-05 10:30:00', '2024-12-05 13:30:00', '2024-12-05 10:30:00', '2024-12-05 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_018.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_018.jpg', 'COMPLETED', 255000.00, N'BK20241205001', '2024-12-04 09:00:00', N'Game Room PS4 - gaming session', '2024-12-05 13:35:00'),
(54, 18, 1, '2025-02-25 14:00:00', '2025-02-25 17:00:00', '2025-02-25 14:10:00', '2025-02-25 16:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_018.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_018.jpg', 'COMPLETED', 259000.00, N'BK20250225001', '2025-02-24 11:00:00', N'Ocean City revisit - still amazing', '2025-02-25 17:00:00'),
(55, 19, 2, '2024-09-25 17:30:00', '2024-09-25 20:30:00', '2024-09-25 17:35:00', '2024-09-25 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_019.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_019.jpg', 'COMPLETED', 299000.00, N'BK20240925002', '2024-09-24 12:00:00', N'Cook and Chill - made dinner together', '2024-09-25 20:35:00'),
(56, 19, 3, '2024-12-10 21:00:00', '2024-12-11 09:50:00', '2024-12-10 21:05:00', '2024-12-11 09:45:00', N'https://res.cloudinary.com/booknow/id_cards/front_019.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_019.jpg', 'COMPLETED', 249000.00, N'BK20241210001', '2024-12-09 15:00:00', N'Pink Paradise overnight - magical experience', '2024-12-11 09:50:00'),
(57, 19, 4, '2025-03-01 10:30:00', '2025-03-01 13:30:00', '2025-03-01 10:40:00', '2025-03-01 13:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_019.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_019.jpg', 'COMPLETED', 259000.00, N'BK20250301001', '2025-02-28 10:00:00', N'Tiger Woods morning session', '2025-03-01 13:30:00'),
(58, 20, 5, '2024-10-05 14:00:00', '2024-10-05 17:00:00', '2024-10-05 14:00:00', '2024-10-05 17:00:00', N'https://res.cloudinary.com/booknow/id_cards/front_020.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_020.jpg', 'COMPLETED', 269000.00, N'BK20241005002', '2024-10-04 09:00:00', N'Ball Chill - perfect for relaxation', '2024-10-05 17:05:00'),
(59, 20, 6, '2024-12-20 17:30:00', '2024-12-20 20:30:00', '2024-12-20 17:30:00', '2024-12-20 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_020.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_020.jpg', 'COMPLETED', 279000.00, N'BK20241220002', '2024-12-19 14:00:00', N'GameHub evening gaming', '2024-12-20 20:35:00'),
(60, 20, 7, '2025-03-05 21:00:00', '2025-03-06 09:50:00', '2025-03-05 21:10:00', '2025-03-06 09:40:00', N'https://res.cloudinary.com/booknow/id_cards/front_020.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_020.jpg', 'COMPLETED', 269000.00, N'BK20250305001', '2025-03-04 16:00:00', N'Honey House night stay', '2025-03-06 09:50:00'),

-- More COMPLETED bookings (customers 21-30)
(61, 21, 8, '2024-10-15 10:30:00', '2024-10-15 13:30:00', '2024-10-15 10:35:00', '2024-10-15 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_021.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_021.jpg', 'COMPLETED', 239000.00, N'BK20241015002', '2024-10-14 11:00:00', N'Ocean room morning', '2024-10-15 13:35:00'),
(62, 21, 9, '2025-01-01 14:00:00', '2025-01-01 17:00:00', '2025-01-01 14:05:00', '2025-01-01 16:55:00', N'https://res.cloudinary.com/booknow/id_cards/front_021.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_021.jpg', 'COMPLETED', 255000.00, N'BK20250101001', '2024-12-31 10:00:00', N'New Year at Cine Room', '2025-01-01 17:00:00'),
(63, 21, 10, '2025-03-08 17:30:00', '2025-03-08 20:30:00', '2025-03-08 17:40:00', '2025-03-08 20:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_021.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_021.jpg', 'COMPLETED', 235000.00, N'BK20250308001', '2025-03-07 15:00:00', N'Ivy Garden evening', '2025-03-08 20:30:00'),
(64, 22, 11, '2024-10-25 21:00:00', '2024-10-26 09:50:00', '2024-10-25 21:00:00', '2024-10-26 09:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_022.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_022.jpg', 'COMPLETED', 245000.00, N'BK20241025002', '2024-10-24 14:00:00', N'Bea Bear overnight', '2024-10-26 09:55:00'),
(65, 22, 12, '2025-01-10 10:30:00', '2025-01-10 13:30:00', '2025-01-10 10:30:00', '2025-01-10 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_022.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_022.jpg', 'COMPLETED', 279000.00, N'BK20250110001', '2025-01-09 09:00:00', N'Wood Mood morning chill', '2025-01-10 13:35:00'),
(66, 22, 13, '2025-03-10 14:00:00', '2025-03-10 17:00:00', '2025-03-10 14:10:00', '2025-03-10 16:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_022.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_022.jpg', 'COMPLETED', 225000.00, N'BK20250310001', '2025-03-09 11:00:00', N'Calm Cloud afternoon', '2025-03-10 17:00:00'),
(67, 23, 14, '2024-11-05 17:30:00', '2024-11-05 20:30:00', '2024-11-05 17:35:00', '2024-11-05 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_023.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_023.jpg', 'COMPLETED', 229000.00, N'BK20241105002', '2024-11-04 12:00:00', N'Bass Bar music night', '2024-11-05 20:35:00'),
(68, 23, 15, '2025-01-20 21:00:00', '2025-01-21 09:50:00', '2025-01-20 21:05:00', '2025-01-21 09:45:00', N'https://res.cloudinary.com/booknow/id_cards/front_023.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_023.jpg', 'COMPLETED', 189000.00, N'BK20250120001', '2025-01-19 15:00:00', N'Mellow overnight rest', '2025-01-21 09:50:00'),
(69, 23, 16, '2025-03-11 10:30:00', '2025-03-11 13:30:00', '2025-03-11 10:40:00', '2025-03-11 13:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_023.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_023.jpg', 'COMPLETED', 169000.00, N'BK20250311001', '2025-03-10 10:00:00', N'Lion King with kids', '2025-03-11 13:30:00'),
(70, 24, 17, '2024-11-15 14:00:00', '2024-11-15 17:00:00', '2024-11-15 14:00:00', '2024-11-15 17:00:00', N'https://res.cloudinary.com/booknow/id_cards/front_024.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_024.jpg', 'COMPLETED', 199000.00, N'BK20241115002', '2024-11-14 09:00:00', N'Love Blaze afternoon date', '2024-11-15 17:05:00'),
(71, 24, 18, '2025-01-30 17:30:00', '2025-01-30 20:30:00', '2025-01-30 17:30:00', '2025-01-30 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_024.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_024.jpg', 'COMPLETED', 279000.00, N'BK20250130001', '2025-01-29 14:00:00', N'Squid Game theme night', '2025-01-30 20:35:00'),
(72, 24, 19, '2025-03-12 21:00:00', '2025-03-13 09:50:00', '2025-03-12 21:10:00', '2025-03-13 09:40:00', N'https://res.cloudinary.com/booknow/id_cards/front_024.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_024.jpg', 'COMPLETED', 235000.00, N'BK20250312001', '2025-03-11 16:00:00', N'Lavender overnight', '2025-03-13 09:50:00'),
(73, 25, 20, '2024-11-25 10:30:00', '2024-11-25 13:30:00', '2024-11-25 10:35:00', '2024-11-25 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_025.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_025.jpg', 'COMPLETED', 245000.00, N'BK20241125001', '2024-11-24 11:00:00', N'Ruby with bida morning', '2024-11-25 13:35:00'),
(74, 25, 21, '2025-02-10 14:00:00', '2025-02-10 17:00:00', '2025-02-10 14:05:00', '2025-02-10 16:55:00', N'https://res.cloudinary.com/booknow/id_cards/front_025.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_025.jpg', 'COMPLETED', 235000.00, N'BK20250210001', '2025-02-09 10:00:00', N'Cinema Zone afternoon', '2025-02-10 17:00:00'),
(75, 25, 22, '2025-03-13 17:30:00', '2025-03-13 20:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_025.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_025.jpg', 'CHECKED_IN', 255000.00, N'BK20250313001', '2025-03-12 15:00:00', N'Solo Gaming evening - currently here', NULL),
(76, 26, 23, '2024-12-05 17:30:00', '2024-12-05 20:30:00', '2024-12-05 17:35:00', '2024-12-05 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_026.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_026.jpg', 'COMPLETED', 185000.00, N'BK20241205002', '2024-12-04 12:00:00', N'Green Haven evening', '2024-12-05 20:35:00'),
(77, 26, 24, '2025-02-20 21:00:00', '2025-02-21 09:50:00', '2025-02-20 21:00:00', '2025-02-21 09:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_026.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_026.jpg', 'COMPLETED', 285000.00, N'BK20250220001', '2025-02-19 14:00:00', N'Zone X bida overnight', '2025-02-21 09:55:00'),
(78, 26, 25, '2025-03-14 10:30:00', '2025-03-14 13:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_026.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_026.jpg', 'PAID', 255000.00, N'BK20250314001', '2025-03-13 10:00:00', N'Mykonos morning - tomorrow', NULL),
(79, 27, 26, '2024-12-15 14:00:00', '2024-12-15 17:00:00', '2024-12-15 14:00:00', '2024-12-15 17:00:00', N'https://res.cloudinary.com/booknow/id_cards/front_027.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_027.jpg', 'COMPLETED', 235000.00, N'BK20241215002', '2024-12-14 09:00:00', N'Orange Pop afternoon', '2024-12-15 17:05:00'),
(80, 27, 27, '2025-03-01 17:30:00', '2025-03-01 20:30:00', '2025-03-01 17:30:00', '2025-03-01 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_027.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_027.jpg', 'COMPLETED', 305000.00, N'BK20250301002', '2025-02-28 14:00:00', N'Moon Space evening', '2025-03-01 20:35:00'),
(81, 27, 28, '2025-03-15 21:00:00', '2025-03-16 09:50:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_027.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_027.jpg', 'PAID', 285000.00, N'BK20250315001', '2025-03-13 16:00:00', N'Cheese kitchen overnight - future', NULL),
(82, 28, 29, '2024-12-25 10:30:00', '2024-12-25 13:30:00', '2024-12-25 10:40:00', '2024-12-25 13:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_028.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_028.jpg', 'COMPLETED', 235000.00, N'BK20241225001', '2024-12-24 11:00:00', N'Love Pink Christmas morning', '2024-12-25 13:30:00'),
(83, 28, 30, '2025-03-05 14:00:00', '2025-03-05 17:00:00', '2025-03-05 14:10:00', '2025-03-05 16:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_028.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_028.jpg', 'COMPLETED', 265000.00, N'BK20250305002', '2025-03-04 10:00:00', N'Blue Wave afternoon', '2025-03-05 17:00:00'),
(84, 28, 31, '2025-03-20 17:30:00', '2025-03-20 20:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_028.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_028.jpg', 'PENDING', 275000.00, N'BK20250320001', '2025-03-13 15:00:00', N'Fini Homestay - pending approval', NULL),
(85, 29, 32, '2025-01-05 17:30:00', '2025-01-05 20:30:00', '2025-01-05 17:35:00', '2025-01-05 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_029.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_029.jpg', 'COMPLETED', 265000.00, N'BK20250105002', '2025-01-04 12:00:00', N'Luca Homestay evening', '2025-01-05 20:35:00'),
(86, 29, 33, '2025-03-08 21:00:00', '2025-03-09 09:50:00', '2025-03-08 21:05:00', '2025-03-09 09:45:00', N'https://res.cloudinary.com/booknow/id_cards/front_029.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_029.jpg', 'COMPLETED', 285000.00, N'BK20250308002', '2025-03-07 14:00:00', N'CGV cinema overnight', '2025-03-09 09:50:00'),
(87, 29, 34, '2025-03-22 10:30:00', '2025-03-22 13:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_029.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_029.jpg', 'PENDING', 285000.00, N'BK20250322001', '2025-03-12 09:00:00', N'Beach Homestay morning - pending', NULL),
(88, 30, 35, '2025-01-15 14:00:00', '2025-01-15 17:00:00', '2025-01-15 14:00:00', '2025-01-15 17:00:00', N'https://res.cloudinary.com/booknow/id_cards/front_030.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_030.jpg', 'COMPLETED', 265000.00, N'BK20250115002', '2025-01-14 10:00:00', N'Sweet Dreams afternoon', '2025-01-15 17:05:00'),
(89, 30, 36, '2025-03-10 17:30:00', '2025-03-10 20:30:00', '2025-03-10 17:30:00', '2025-03-10 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_030.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_030.jpg', 'COMPLETED', 255000.00, N'BK20250310002', '2025-03-09 14:00:00', N'Da Lat style evening', '2025-03-10 20:35:00'),
(90, 30, 37, '2025-03-25 21:00:00', '2025-03-26 09:50:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_030.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_030.jpg', 'PENDING_PAYMENT', 245000.00, N'BK20250325001', '2025-03-13 16:00:00', N'Pink Dream overnight - awaiting payment', NULL),

-- CHECKED_OUT bookings (recent - 2025) (customers 31-35)
(91, 31, 38, '2025-03-12 10:30:00', '2025-03-12 13:30:00', '2025-03-12 10:35:00', '2025-03-12 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_031.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_031.jpg', 'CHECKED_OUT', 235000.00, N'BK20250312002', '2025-03-11 11:00:00', N'Blue Vibe morning - just checked out', '2025-03-12 13:35:00'),
(92, 31, 39, '2025-03-02 14:00:00', '2025-03-02 17:00:00', '2025-03-02 14:05:00', '2025-03-02 16:55:00', N'https://res.cloudinary.com/booknow/id_cards/front_031.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_031.jpg', 'COMPLETED', 225000.00, N'BK20250302001', '2025-03-01 10:00:00', N'Pure Relax afternoon', '2025-03-02 17:00:00'),
(93, 31, 40, '2025-02-15 17:30:00', '2025-02-15 20:30:00', '2025-02-15 17:40:00', '2025-02-15 20:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_031.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_031.jpg', 'COMPLETED', 235000.00, N'BK20250215002', '2025-02-14 15:00:00', N'Honey Glow evening', '2025-02-15 20:30:00'),
(94, 32, 41, '2025-03-13 10:30:00', '2025-03-13 13:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_032.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_032.jpg', 'CHECKED_IN', 275000.00, N'BK20250313002', '2025-03-12 09:00:00', N'CGV Room - current guest', NULL),
(95, 32, 42, '2025-02-20 14:00:00', '2025-02-20 17:00:00', '2025-02-20 14:10:00', '2025-02-20 16:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_032.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_032.jpg', 'COMPLETED', 295000.00, N'BK20250220002', '2025-02-19 11:00:00', N'Smoke Kitchen afternoon cooking', '2025-02-20 17:00:00'),
(96, 32, 43, '2025-01-25 17:30:00', '2025-01-25 20:30:00', '2025-01-25 17:35:00', '2025-01-25 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_032.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_032.jpg', 'COMPLETED', 295000.00, N'BK20250125002', '2025-01-24 12:00:00', N'8 Ball House evening', '2025-01-25 20:35:00'),
(97, 33, 44, '2025-03-12 21:00:00', '2025-03-13 09:50:00', '2025-03-12 21:00:00', '2025-03-13 09:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_033.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_033.jpg', 'CHECKED_OUT', 315000.00, N'BK20250312003', '2025-03-11 15:00:00', N'La Maison overnight - checked out today', '2025-03-13 09:55:00'),
(98, 33, 45, '2025-02-28 10:30:00', '2025-02-28 13:30:00', '2025-02-28 10:30:00', '2025-02-28 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_033.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_033.jpg', 'COMPLETED', 285000.00, N'BK20250228001', '2025-02-27 09:00:00', N'Masterchef morning cooking', '2025-02-28 13:35:00'),
(99, 33, 46, '2025-02-05 14:00:00', '2025-02-05 17:00:00', '2025-02-05 14:05:00', '2025-02-05 16:55:00', N'https://res.cloudinary.com/booknow/id_cards/front_033.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_033.jpg', 'COMPLETED', 325000.00, N'BK20250205002', '2025-02-04 10:00:00', N'Atlantis afternoon dive', '2025-02-05 17:00:00'),
(100, 34, 47, '2025-03-13 14:00:00', '2025-03-13 17:00:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_034.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_034.jpg', 'CHECKED_IN', 275000.00, N'BK20250313003', '2025-03-12 14:00:00', N'Forest retreat - current guest', NULL),
(101, 34, 48, '2025-03-01 17:30:00', '2025-03-01 20:30:00', '2025-03-01 17:40:00', '2025-03-01 20:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_034.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_034.jpg', 'COMPLETED', 265000.00, N'BK20250301003', '2025-02-28 15:00:00', N'Vibe Home evening', '2025-03-01 20:30:00'),
(102, 34, 49, '2025-02-10 21:00:00', '2025-02-11 09:50:00', '2025-02-10 21:10:00', '2025-02-11 09:40:00', N'https://res.cloudinary.com/booknow/id_cards/front_034.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_034.jpg', 'COMPLETED', 295000.00, N'BK20250210002', '2025-02-09 16:00:00', N'Wine Ball overnight', '2025-02-11 09:50:00'),
(103, 35, 50, '2025-03-13 17:30:00', '2025-03-13 20:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_035.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_035.jpg', 'CHECKED_IN', 285000.00, N'BK20250313004', '2025-03-12 12:00:00', N'Video Game room - current guest', NULL),
(104, 35, 51, '2025-03-05 10:30:00', '2025-03-05 13:30:00', '2025-03-05 10:35:00', '2025-03-05 13:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_035.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_035.jpg', 'COMPLETED', 275000.00, N'BK20250305003', '2025-03-04 11:00:00', N'Lasaoma morning', '2025-03-05 13:35:00'),
(105, 35, 52, '2025-02-15 14:00:00', '2025-02-15 17:00:00', '2025-02-15 14:00:00', '2025-02-15 17:00:00', N'https://res.cloudinary.com/booknow/id_cards/front_035.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_035.jpg', 'COMPLETED', 245000.00, N'BK20250215003', '2025-02-14 09:00:00', N'Doraemon afternoon', '2025-02-15 17:05:00'),

-- CANCELLED/FAILED/REJECTED bookings (customers 36-40)
(106, 36, 53, '2025-02-25 17:30:00', '2025-02-25 20:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_036.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_036.jpg', 'FAILED', 255000.00, N'BK20250225002', '2025-02-24 12:00:00', N'Game Room PS4 - payment failed', NULL),
(107, 36, 1, '2025-03-01 21:00:00', '2025-03-02 09:50:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_036.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_036.jpg', 'REJECTED', 259000.00, N'BK20250301004', '2025-02-28 15:00:00', N'Ocean City - rejected due to invalid ID', NULL),
(108, 36, 2, '2025-03-15 10:30:00', '2025-03-15 13:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_036.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_036.jpg', 'PAID', 299000.00, N'BK20250315002', '2025-03-13 10:00:00', N'Cook and Chill - upcoming', NULL),
(109, 37, 3, '2025-02-20 14:00:00', '2025-02-20 17:00:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_037.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_037.jpg', 'FAILED', 249000.00, N'BK20250220003', '2025-02-19 09:00:00', N'Pink Paradise - payment timeout', NULL),
(110, 37, 4, '2025-03-10 17:30:00', '2025-03-10 20:30:00', '2025-03-10 17:35:00', '2025-03-10 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_037.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_037.jpg', 'COMPLETED', 259000.00, N'BK20250310003', '2025-03-09 14:00:00', N'Tiger Woods evening', '2025-03-10 20:35:00'),
(111, 37, 5, '2025-03-18 21:00:00', '2025-03-19 09:50:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_037.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_037.jpg', 'PENDING', 269000.00, N'BK20250318001', '2025-03-13 16:00:00', N'Ball Chill overnight - pending', NULL),
(112, 38, 6, '2025-02-28 10:30:00', '2025-02-28 13:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_038.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_038.jpg', 'REJECTED', 279000.00, N'BK20250228002', '2025-02-27 11:00:00', N'GameHub - rejected blurry ID photo', NULL),
(113, 38, 7, '2025-03-12 14:00:00', '2025-03-12 17:00:00', '2025-03-12 14:10:00', '2025-03-12 16:50:00', N'https://res.cloudinary.com/booknow/id_cards/front_038.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_038.jpg', 'COMPLETED', 269000.00, N'BK20250312004', '2025-03-11 10:00:00', N'Honey House afternoon', '2025-03-12 17:00:00'),
(114, 38, 8, '2025-03-20 17:30:00', '2025-03-20 20:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_038.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_038.jpg', 'PENDING_PAYMENT', 239000.00, N'BK20250320002', '2025-03-13 15:00:00', N'Ocean evening - awaiting payment', NULL),
(115, 39, 9, '2025-03-05 21:00:00', '2025-03-06 09:50:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_039.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_039.jpg', 'FAILED', 255000.00, N'BK20250305004', '2025-03-04 14:00:00', N'Cine Room - card declined', NULL),
(116, 39, 10, '2025-03-11 10:30:00', '2025-03-11 13:30:00', '2025-03-11 10:40:00', '2025-03-11 13:25:00', N'https://res.cloudinary.com/booknow/id_cards/front_039.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_039.jpg', 'COMPLETED', 235000.00, N'BK20250311002', '2025-03-10 09:00:00', N'Ivy Garden morning', '2025-03-11 13:30:00'),
(117, 39, 11, '2025-03-25 14:00:00', '2025-03-25 17:00:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_039.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_039.jpg', 'PAID', 245000.00, N'BK20250325002', '2025-03-13 11:00:00', N'Bea Bear afternoon - upcoming', NULL),
(118, 40, 12, '2025-03-08 17:30:00', '2025-03-08 20:30:00', '2025-03-08 17:35:00', '2025-03-08 20:30:00', N'https://res.cloudinary.com/booknow/id_cards/front_040.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_040.jpg', 'COMPLETED', 279000.00, N'BK20250308003', '2025-03-07 12:00:00', N'Wood Mood evening', '2025-03-08 20:35:00'),
(119, 40, 13, '2025-03-13 21:00:00', '2025-03-14 09:50:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_040.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_040.jpg', 'CHECKED_IN', 225000.00, N'BK20250313005', '2025-03-12 16:00:00', N'Calm Cloud overnight - current guest', NULL),
(120, 40, 14, '2025-03-28 10:30:00', '2025-03-28 13:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_040.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_040.jpg', 'PENDING', 229000.00, N'BK20250328001', '2025-03-13 09:00:00', N'Bass Bar morning - pending', NULL),

-- Additional bookings to meet minimum 120 requirement
(121, 1, 15, '2025-03-13 10:30:00', '2025-03-13 13:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_001.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_001.jpg', 'CHECKED_IN', 189000.00, N'BK20250313006', '2025-03-12 11:00:00', N'Mellow morning - current guest', NULL),
(122, 2, 16, '2025-03-14 14:00:00', '2025-03-14 17:00:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_002.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_002.jpg', 'PAID', 169000.00, N'BK20250314002', '2025-03-13 09:00:00', N'Lion King - tomorrow booking', NULL),
(123, 3, 17, '2025-03-15 17:30:00', '2025-03-15 20:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_003.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_003.jpg', 'PAID', 199000.00, N'BK20250315003', '2025-03-13 10:00:00', N'Love Blaze evening - future', NULL),
(124, 4, 18, '2025-03-16 21:00:00', '2025-03-17 09:50:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_004.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_004.jpg', 'PAID', 279000.00, N'BK20250316001', '2025-03-13 14:00:00', N'Squid Game overnight - future', NULL),
(125, 5, 19, '2025-03-17 10:30:00', '2025-03-17 13:30:00', NULL, NULL, N'https://res.cloudinary.com/booknow/id_cards/front_005.jpg', N'https://res.cloudinary.com/booknow/id_cards/back_005.jpg', 'PENDING', 235000.00, N'BK20250317001', '2025-03-13 15:00:00', N'Lavender morning - pending', NULL);

SET IDENTITY_INSERT [dbo].[Booking] OFF;
GO

-- ============================================================
-- Scheduler (Links bookings to time slots and dates)
-- ============================================================
SET IDENTITY_INSERT [dbo].[Scheduler] ON;

INSERT INTO [dbo].[Scheduler] ([scheduler_id], [booking_id], [timetable_id], [date]) VALUES
-- Morning slot (1) - 10:30-13:30
(1, 1, 1, '2024-03-15'), (2, 3, 1, '2024-06-10'), (3, 5, 1, '2024-05-05'),
(4, 13, 1, '2024-04-25'), (5, 25, 1, '2024-06-05'), (6, 29, 1, '2024-09-01'),
(7, 33, 1, '2024-12-15'), (8, 37, 1, '2024-07-15'), (9, 41, 1, '2024-10-15'),
(10, 45, 1, '2025-01-25'), (11, 49, 1, '2024-09-05'), (12, 53, 1, '2024-12-05'),
(13, 57, 1, '2025-03-01'), (14, 61, 1, '2024-10-15'), (15, 65, 1, '2025-01-10'),
(16, 69, 1, '2025-03-11'), (17, 73, 1, '2024-11-25'), (18, 82, 1, '2024-12-25'),
(19, 91, 1, '2025-03-12'), (20, 94, 1, '2025-03-13'), (21, 98, 1, '2025-02-28'),
(22, 104, 1, '2025-03-05'), (23, 116, 1, '2025-03-11'), (24, 121, 1, '2025-03-13'),

-- Afternoon slot (2) - 14:00-17:00
(25, 2, 2, '2024-04-20'), (26, 10, 2, '2024-04-10'), (27, 14, 2, '2024-07-01'),
(28, 22, 2, '2024-05-30'), (29, 26, 2, '2024-08-25'), (30, 30, 2, '2024-12-01'),
(31, 34, 2, '2024-07-05'), (32, 38, 2, '2024-10-01'), (33, 42, 2, '2025-01-15'),
(34, 46, 2, '2024-08-20'), (35, 50, 2, '2024-11-20'), (36, 58, 2, '2024-10-05'),
(37, 62, 2, '2025-01-01'), (38, 66, 2, '2025-03-10'), (39, 70, 2, '2024-11-15'),
(40, 74, 2, '2025-02-10'), (41, 78, 2, '2025-03-14'), (42, 79, 2, '2024-12-15'),
(43, 83, 2, '2025-03-05'), (44, 88, 2, '2025-01-15'), (45, 92, 2, '2025-03-02'),
(46, 95, 2, '2025-02-20'), (47, 99, 2, '2025-02-05'), (48, 100, 2, '2025-03-13'),
(49, 105, 2, '2025-02-15'), (50, 113, 2, '2025-03-12'), (51, 122, 2, '2025-03-14'),

-- Evening slot (3) - 17:30-20:30
(52, 7, 3, '2024-04-01'), (53, 9, 3, '2024-08-10'), (54, 11, 3, '2024-06-20'),
(55, 15, 3, '2024-09-20'), (56, 17, 3, '2024-07-20'), (57, 18, 3, '2024-10-05'),
(58, 19, 3, '2024-05-15'), (59, 21, 3, '2024-10-20'), (60, 23, 3, '2024-08-15'),
(61, 27, 3, '2024-11-15'), (62, 31, 3, '2024-06-25'), (63, 35, 3, '2024-09-25'),
(64, 39, 3, '2025-01-05'), (65, 43, 3, '2024-08-05'), (66, 47, 3, '2024-11-05'),
(67, 51, 3, '2025-02-15'), (68, 55, 3, '2024-09-25'), (69, 59, 3, '2024-12-20'),
(70, 63, 3, '2025-03-08'), (71, 67, 3, '2024-11-05'), (72, 71, 3, '2025-01-30'),
(73, 75, 3, '2025-03-13'), (74, 76, 3, '2024-12-05'), (75, 80, 3, '2025-03-01'),
(76, 85, 3, '2025-01-05'), (77, 89, 3, '2025-03-10'), (78, 93, 3, '2025-02-15'),
(79, 96, 3, '2025-01-25'), (80, 101, 3, '2025-03-01'), (81, 103, 3, '2025-03-13'),
(82, 110, 3, '2025-03-10'), (83, 118, 3, '2025-03-08'), (84, 123, 3, '2025-03-15'),

-- Night slot (4) - 21:00-09:50
(85, 4, 4, '2024-03-20'), (86, 6, 4, '2024-07-15'), (87, 8, 4, '2024-05-25'),
(88, 12, 4, '2024-09-05'), (89, 16, 4, '2024-05-01'), (90, 20, 4, '2024-08-01'),
(91, 24, 4, '2024-11-01'), (92, 28, 4, '2024-06-15'), (93, 32, 4, '2024-09-10'),
(94, 36, 4, '2024-12-20'), (95, 40, 4, '2024-07-25'), (96, 44, 4, '2024-10-25'),
(97, 48, 4, '2025-02-05'), (98, 52, 4, '2024-09-15'), (99, 56, 4, '2024-12-10'),
(100, 60, 4, '2025-03-05'), (101, 64, 4, '2024-10-25'), (102, 68, 4, '2025-01-20'),
(103, 72, 4, '2025-03-12'), (104, 77, 4, '2025-02-20'), (105, 81, 4, '2025-03-15'),
(106, 84, 4, '2025-03-20'), (107, 86, 4, '2025-03-08'), (108, 87, 4, '2025-03-22'),
(109, 90, 4, '2025-03-25'), (110, 97, 4, '2025-03-12'), (111, 102, 4, '2025-02-10'),
(112, 107, 4, '2025-03-01'), (113, 108, 4, '2025-03-15'), (114, 111, 4, '2025-03-18'),
(115, 115, 4, '2025-03-05'), (116, 117, 4, '2025-03-25'), (117, 119, 4, '2025-03-13'),
(118, 120, 4, '2025-03-28'), (119, 124, 4, '2025-03-16'), (120, 125, 4, '2025-03-17');

SET IDENTITY_INSERT [dbo].[Scheduler] OFF;
GO

-- ============================================================
-- Payment (120+ payments - one per booking)
-- Methods: Credit Card, VNPay, Momo, Cash
-- Statuses: SUCCESS, FAILED, REFUNDED, PENDING
-- ============================================================
SET IDENTITY_INSERT [dbo].[Payment] ON;

INSERT INTO [dbo].[Payment] ([payment_id], [booking_id], [amount], [method], [payment_status], [paid_at]) VALUES
-- COMPLETED bookings - SUCCESS payments
(1, 1, 259000.00, N'Momo', 'SUCCESS', '2024-03-14 15:30:00'),
(2, 2, 269000.00, N'VNPay', 'SUCCESS', '2024-04-19 10:30:00'),
(3, 3, 235000.00, N'Credit Card', 'SUCCESS', '2024-06-09 14:30:00'),
(4, 4, 299000.00, N'Momo', 'SUCCESS', '2024-03-19 16:30:00'),
(5, 5, 239000.00, N'Cash', 'SUCCESS', '2024-05-04 09:30:00'),
(6, 6, 189000.00, N'VNPay', 'SUCCESS', '2024-07-14 11:30:00'),
(7, 7, 249000.00, N'Momo', 'SUCCESS', '2024-03-31 12:30:00'),
(8, 8, 279000.00, N'Credit Card', 'SUCCESS', '2024-05-24 15:30:00'),
(9, 9, 279000.00, N'VNPay', 'SUCCESS', '2024-08-09 10:30:00'),
(10, 10, 259000.00, N'Cash', 'SUCCESS', '2024-04-09 09:30:00'),
(11, 11, 255000.00, N'Momo', 'SUCCESS', '2024-06-19 14:30:00'),
(12, 12, 255000.00, N'VNPay', 'SUCCESS', '2024-09-04 16:30:00'),
(13, 13, 279000.00, N'Credit Card', 'SUCCESS', '2024-04-24 11:30:00'),
(14, 14, 229000.00, N'Momo', 'SUCCESS', '2024-06-30 10:30:00'),
(15, 15, 255000.00, N'Cash', 'SUCCESS', '2024-09-19 15:30:00'),
(16, 16, 269000.00, N'VNPay', 'SUCCESS', '2024-04-30 14:30:00'),
(17, 17, 199000.00, N'Momo', 'SUCCESS', '2024-07-19 09:30:00'),
(18, 18, 305000.00, N'Credit Card', 'SUCCESS', '2024-10-04 11:30:00'),
(19, 19, 245000.00, N'VNPay', 'SUCCESS', '2024-05-14 12:30:00'),
(20, 20, 235000.00, N'Momo', 'SUCCESS', '2024-07-31 15:30:00'),
(21, 21, 265000.00, N'Cash', 'SUCCESS', '2024-10-19 10:30:00'),
(22, 22, 225000.00, N'VNPay', 'SUCCESS', '2024-05-29 09:30:00'),
(23, 23, 245000.00, N'Momo', 'SUCCESS', '2024-08-14 14:30:00'),
(24, 24, 285000.00, N'Credit Card', 'SUCCESS', '2024-10-31 16:30:00'),
(25, 25, 169000.00, N'VNPay', 'SUCCESS', '2024-06-04 11:30:00'),
(26, 26, 235000.00, N'Momo', 'SUCCESS', '2024-08-24 10:30:00'),
(27, 27, 265000.00, N'Cash', 'SUCCESS', '2024-11-14 15:30:00'),
(28, 28, 185000.00, N'VNPay', 'SUCCESS', '2024-06-14 14:30:00'),
(29, 29, 235000.00, N'Momo', 'SUCCESS', '2024-08-31 09:30:00'),
(30, 30, 245000.00, N'Credit Card', 'SUCCESS', '2024-11-30 11:30:00'),
(31, 31, 285000.00, N'VNPay', 'SUCCESS', '2024-06-24 12:30:00'),
(32, 32, 285000.00, N'Momo', 'SUCCESS', '2024-09-09 15:30:00'),
(33, 33, 225000.00, N'Cash', 'SUCCESS', '2024-12-14 10:30:00'),
(34, 34, 235000.00, N'VNPay', 'SUCCESS', '2024-07-04 09:30:00'),
(35, 35, 275000.00, N'Momo', 'SUCCESS', '2024-09-24 14:30:00'),
(36, 36, 235000.00, N'Credit Card', 'SUCCESS', '2024-12-19 16:30:00'),
(37, 37, 265000.00, N'VNPay', 'SUCCESS', '2024-07-14 11:30:00'),
(38, 38, 285000.00, N'Momo', 'SUCCESS', '2024-09-30 10:30:00'),
(39, 39, 275000.00, N'Cash', 'SUCCESS', '2025-01-04 15:30:00'),
(40, 40, 255000.00, N'VNPay', 'SUCCESS', '2024-07-24 14:30:00'),
(41, 41, 235000.00, N'Momo', 'SUCCESS', '2024-10-14 09:30:00'),
(42, 42, 295000.00, N'Credit Card', 'SUCCESS', '2025-01-14 11:30:00'),
(43, 43, 295000.00, N'VNPay', 'SUCCESS', '2024-08-04 12:30:00'),
(44, 44, 315000.00, N'Momo', 'SUCCESS', '2024-10-24 15:30:00'),
(45, 45, 285000.00, N'Cash', 'SUCCESS', '2025-01-24 10:30:00'),
(46, 46, 325000.00, N'VNPay', 'SUCCESS', '2024-08-19 09:30:00'),
(47, 47, 275000.00, N'Momo', 'SUCCESS', '2024-11-04 14:30:00'),
(48, 48, 265000.00, N'Credit Card', 'SUCCESS', '2025-02-04 16:30:00'),
(49, 49, 295000.00, N'VNPay', 'SUCCESS', '2024-09-04 11:30:00'),
(50, 50, 285000.00, N'Momo', 'SUCCESS', '2024-11-19 10:30:00'),
(51, 51, 275000.00, N'Cash', 'SUCCESS', '2025-02-14 15:30:00'),
(52, 52, 245000.00, N'VNPay', 'SUCCESS', '2024-09-14 14:30:00'),
(53, 53, 255000.00, N'Momo', 'SUCCESS', '2024-12-04 09:30:00'),
(54, 54, 259000.00, N'Credit Card', 'SUCCESS', '2025-02-24 11:30:00'),
(55, 55, 299000.00, N'VNPay', 'SUCCESS', '2024-09-24 12:30:00'),
(56, 56, 249000.00, N'Momo', 'SUCCESS', '2024-12-09 15:30:00'),
(57, 57, 259000.00, N'Cash', 'SUCCESS', '2025-02-28 10:30:00'),
(58, 58, 269000.00, N'VNPay', 'SUCCESS', '2024-10-04 09:30:00'),
(59, 59, 279000.00, N'Momo', 'SUCCESS', '2024-12-19 14:30:00'),
(60, 60, 269000.00, N'Credit Card', 'SUCCESS', '2025-03-04 16:30:00'),
(61, 61, 239000.00, N'VNPay', 'SUCCESS', '2024-10-14 11:30:00'),
(62, 62, 255000.00, N'Momo', 'SUCCESS', '2024-12-31 10:30:00'),
(63, 63, 235000.00, N'Cash', 'SUCCESS', '2025-03-07 15:30:00'),
(64, 64, 245000.00, N'VNPay', 'SUCCESS', '2024-10-24 14:30:00'),
(65, 65, 279000.00, N'Momo', 'SUCCESS', '2025-01-09 09:30:00'),
(66, 66, 225000.00, N'Credit Card', 'SUCCESS', '2025-03-09 11:30:00'),
(67, 67, 229000.00, N'VNPay', 'SUCCESS', '2024-11-04 12:30:00'),
(68, 68, 189000.00, N'Momo', 'SUCCESS', '2025-01-19 15:30:00'),
(69, 69, 169000.00, N'Cash', 'SUCCESS', '2025-03-10 10:30:00'),
(70, 70, 199000.00, N'VNPay', 'SUCCESS', '2024-11-14 09:30:00'),
(71, 71, 279000.00, N'Momo', 'SUCCESS', '2025-01-29 14:30:00'),
(72, 72, 235000.00, N'Credit Card', 'SUCCESS', '2025-03-11 16:30:00'),
(73, 73, 245000.00, N'VNPay', 'SUCCESS', '2024-11-24 11:30:00'),
(74, 74, 235000.00, N'Momo', 'SUCCESS', '2025-02-09 10:30:00'),
(75, 75, 255000.00, N'Cash', 'SUCCESS', '2025-03-12 15:30:00'),
(76, 76, 185000.00, N'VNPay', 'SUCCESS', '2024-12-04 12:30:00'),
(77, 77, 285000.00, N'Momo', 'SUCCESS', '2025-02-19 14:30:00'),
(78, 78, 255000.00, N'Credit Card', 'SUCCESS', '2025-03-13 10:30:00'),
(79, 79, 235000.00, N'VNPay', 'SUCCESS', '2024-12-14 09:30:00'),
(80, 80, 305000.00, N'Momo', 'SUCCESS', '2025-02-28 14:30:00'),
(81, 81, 285000.00, N'Cash', 'SUCCESS', '2025-03-13 16:30:00'),
(82, 82, 235000.00, N'VNPay', 'SUCCESS', '2024-12-24 11:30:00'),
(83, 83, 265000.00, N'Momo', 'SUCCESS', '2025-03-04 10:30:00'),
(84, 84, 275000.00, N'Credit Card', 'PENDING', NULL),
(85, 85, 265000.00, N'VNPay', 'SUCCESS', '2025-01-04 12:30:00'),
(86, 86, 285000.00, N'Momo', 'SUCCESS', '2025-03-07 14:30:00'),
(87, 87, 285000.00, N'Cash', 'PENDING', NULL),
(88, 88, 265000.00, N'VNPay', 'SUCCESS', '2025-01-14 10:30:00'),
(89, 89, 255000.00, N'Momo', 'SUCCESS', '2025-03-09 14:30:00'),
(90, 90, 245000.00, N'Credit Card', 'PENDING', NULL),
(91, 91, 235000.00, N'VNPay', 'SUCCESS', '2025-03-11 11:30:00'),
(92, 92, 225000.00, N'Momo', 'SUCCESS', '2025-03-01 10:30:00'),
(93, 93, 235000.00, N'Cash', 'SUCCESS', '2025-02-14 15:30:00'),
(94, 94, 275000.00, N'VNPay', 'SUCCESS', '2025-03-12 09:30:00'),
(95, 95, 295000.00, N'Momo', 'SUCCESS', '2025-02-19 11:30:00'),
(96, 96, 295000.00, N'Credit Card', 'SUCCESS', '2025-01-24 12:30:00'),
(97, 97, 315000.00, N'VNPay', 'SUCCESS', '2025-03-11 15:30:00'),
(98, 98, 285000.00, N'Momo', 'SUCCESS', '2025-02-27 09:30:00'),
(99, 99, 325000.00, N'Cash', 'SUCCESS', '2025-02-04 10:30:00'),
(100, 100, 275000.00, N'VNPay', 'SUCCESS', '2025-03-12 14:30:00'),
(101, 101, 265000.00, N'Momo', 'SUCCESS', '2025-02-28 15:30:00'),
(102, 102, 295000.00, N'Credit Card', 'SUCCESS', '2025-02-09 16:30:00'),
(103, 103, 285000.00, N'VNPay', 'SUCCESS', '2025-03-12 12:30:00'),
(104, 104, 275000.00, N'Momo', 'SUCCESS', '2025-03-04 11:30:00'),
(105, 105, 245000.00, N'Cash', 'SUCCESS', '2025-02-14 09:30:00'),
-- FAILED payments
(106, 106, 255000.00, N'Credit Card', 'FAILED', NULL),
(107, 107, 259000.00, N'VNPay', 'SUCCESS', '2025-02-28 15:30:00'),
(108, 108, 299000.00, N'Momo', 'SUCCESS', '2025-03-13 10:30:00'),
(109, 109, 249000.00, N'Credit Card', 'FAILED', NULL),
(110, 110, 259000.00, N'VNPay', 'SUCCESS', '2025-03-09 14:30:00'),
(111, 111, 269000.00, N'Momo', 'PENDING', NULL),
(112, 112, 279000.00, N'VNPay', 'REFUNDED', '2025-02-27 12:00:00'),
(113, 113, 269000.00, N'Momo', 'SUCCESS', '2025-03-11 10:30:00'),
(114, 114, 239000.00, N'Credit Card', 'PENDING', NULL),
(115, 115, 255000.00, N'VNPay', 'FAILED', NULL),
(116, 116, 235000.00, N'Momo', 'SUCCESS', '2025-03-10 09:30:00'),
(117, 117, 245000.00, N'Cash', 'SUCCESS', '2025-03-13 11:30:00'),
(118, 118, 279000.00, N'VNPay', 'SUCCESS', '2025-03-07 12:30:00'),
(119, 119, 225000.00, N'Momo', 'SUCCESS', '2025-03-12 16:30:00'),
(120, 120, 229000.00, N'Credit Card', 'PENDING', NULL),
(121, 121, 189000.00, N'VNPay', 'SUCCESS', '2025-03-12 11:30:00'),
(122, 122, 169000.00, N'Momo', 'SUCCESS', '2025-03-13 09:30:00'),
(123, 123, 199000.00, N'Cash', 'SUCCESS', '2025-03-13 10:30:00'),
(124, 124, 279000.00, N'VNPay', 'SUCCESS', '2025-03-13 14:30:00'),
(125, 125, 235000.00, N'Credit Card', 'PENDING', NULL);

SET IDENTITY_INSERT [dbo].[Payment] OFF;
GO

-- ============================================================
-- Invoice (For COMPLETED bookings)
-- ============================================================
SET IDENTITY_INSERT [dbo].[Invoice] ON;

INSERT INTO [dbo].[Invoice] ([invoice_id], [booking_id], [invoice_number], [issued_at]) VALUES
(1, 1, N'INV-2024031501', '2024-03-15 13:35:00'),
(2, 4, N'INV-2024032101', '2024-03-21 10:00:00'),
(3, 7, N'INV-2024040101', '2024-04-01 20:35:00'),
(4, 2, N'INV-2024042001', '2024-04-20 17:05:00'),
(5, 10, N'INV-2024041001', '2024-04-10 17:05:00'),
(6, 13, N'INV-2024042501', '2024-04-25 13:35:00'),
(7, 16, N'INV-2024050201', '2024-05-02 09:55:00'),
(8, 5, N'INV-2024050501', '2024-05-05 13:35:00'),
(9, 19, N'INV-2024051501', '2024-05-15 20:35:00'),
(10, 8, N'INV-2024052601', '2024-05-26 09:55:00'),
(11, 22, N'INV-2024053001', '2024-05-30 17:05:00'),
(12, 3, N'INV-2024061001', '2024-06-10 20:35:00'),
(13, 25, N'INV-2024060501', '2024-06-05 13:35:00'),
(14, 28, N'INV-2024061601', '2024-06-16 09:55:00'),
(15, 11, N'INV-2024062001', '2024-06-20 20:35:00'),
(16, 31, N'INV-2024062501', '2024-06-25 20:35:00'),
(17, 14, N'INV-2024070101', '2024-07-01 17:05:00'),
(18, 34, N'INV-2024070501', '2024-07-05 17:05:00'),
(19, 6, N'INV-2024071501', '2024-07-15 17:05:00'),
(20, 37, N'INV-2024071502', '2024-07-15 13:35:00'),
(21, 17, N'INV-2024072001', '2024-07-20 13:35:00'),
(22, 40, N'INV-2024072601', '2024-07-26 09:55:00'),
(23, 20, N'INV-2024080201', '2024-08-02 09:55:00'),
(24, 43, N'INV-2024080501', '2024-08-05 20:35:00'),
(25, 9, N'INV-2024081001', '2024-08-10 13:35:00'),
(26, 23, N'INV-2024081501', '2024-08-15 20:35:00'),
(27, 46, N'INV-2024082001', '2024-08-20 17:05:00'),
(28, 26, N'INV-2024082501', '2024-08-25 17:05:00'),
(29, 29, N'INV-2024090101', '2024-09-01 13:35:00'),
(30, 49, N'INV-2024090501', '2024-09-05 13:35:00'),
(31, 12, N'INV-2024090601', '2024-09-06 09:55:00'),
(32, 32, N'INV-2024091101', '2024-09-11 09:55:00'),
(33, 52, N'INV-2024091601', '2024-09-16 09:55:00'),
(34, 15, N'INV-2024092001', '2024-09-20 20:35:00'),
(35, 35, N'INV-2024092501', '2024-09-25 20:35:00'),
(36, 55, N'INV-2024092502', '2024-09-25 20:35:00'),
(37, 38, N'INV-2024100101', '2024-10-01 17:05:00'),
(38, 58, N'INV-2024100501', '2024-10-05 17:05:00'),
(39, 18, N'INV-2024100502', '2024-10-05 17:05:00'),
(40, 41, N'INV-2024101501', '2024-10-15 13:35:00'),
(41, 61, N'INV-2024101502', '2024-10-15 13:35:00'),
(42, 21, N'INV-2024102001', '2024-10-20 13:35:00'),
(43, 44, N'INV-2024102601', '2024-10-26 09:55:00'),
(44, 64, N'INV-2024102602', '2024-10-26 09:55:00'),
(45, 47, N'INV-2024110501', '2024-11-05 20:35:00'),
(46, 67, N'INV-2024110502', '2024-11-05 20:35:00'),
(47, 24, N'INV-2024110201', '2024-11-02 09:55:00'),
(48, 70, N'INV-2024111501', '2024-11-15 17:05:00'),
(49, 27, N'INV-2024111502', '2024-11-15 20:35:00'),
(50, 50, N'INV-2024112001', '2024-11-20 17:05:00'),
(51, 73, N'INV-2024112501', '2024-11-25 13:35:00'),
(52, 53, N'INV-2024120501', '2024-12-05 13:35:00'),
(53, 76, N'INV-2024120502', '2024-12-05 20:35:00'),
(54, 56, N'INV-2024121101', '2024-12-11 09:55:00'),
(55, 30, N'INV-2024120101', '2024-12-01 17:05:00'),
(56, 33, N'INV-2024121501', '2024-12-15 13:35:00'),
(57, 79, N'INV-2024121502', '2024-12-15 17:05:00'),
(58, 36, N'INV-2024122101', '2024-12-21 09:55:00'),
(59, 59, N'INV-2024122001', '2024-12-20 20:35:00'),
(60, 82, N'INV-2024122501', '2024-12-25 13:35:00'),
(61, 62, N'INV-2025010101', '2025-01-01 17:05:00'),
(62, 39, N'INV-2025010501', '2025-01-05 20:35:00'),
(63, 85, N'INV-2025010502', '2025-01-05 20:35:00'),
(64, 65, N'INV-2025011001', '2025-01-10 13:35:00'),
(65, 42, N'INV-2025011501', '2025-01-15 17:05:00'),
(66, 88, N'INV-2025011502', '2025-01-15 17:05:00'),
(67, 68, N'INV-2025012101', '2025-01-21 09:55:00'),
(68, 45, N'INV-2025012501', '2025-01-25 13:35:00'),
(69, 96, N'INV-2025012502', '2025-01-25 20:35:00'),
(70, 71, N'INV-2025013001', '2025-01-30 20:35:00'),
(71, 48, N'INV-2025020601', '2025-02-06 09:55:00'),
(72, 99, N'INV-2025020501', '2025-02-05 17:05:00'),
(73, 74, N'INV-2025021001', '2025-02-10 17:05:00'),
(74, 102, N'INV-2025021101', '2025-02-11 09:55:00'),
(75, 51, N'INV-2025021501', '2025-02-15 20:35:00'),
(76, 93, N'INV-2025021502', '2025-02-15 20:35:00'),
(77, 105, N'INV-2025021503', '2025-02-15 17:05:00'),
(78, 77, N'INV-2025022101', '2025-02-21 09:55:00'),
(79, 95, N'INV-2025022001', '2025-02-20 17:05:00'),
(80, 54, N'INV-2025022501', '2025-02-25 17:05:00'),
(81, 98, N'INV-2025022801', '2025-02-28 13:35:00'),
(82, 57, N'INV-2025030101', '2025-03-01 13:35:00'),
(83, 80, N'INV-2025030102', '2025-03-01 20:35:00'),
(84, 101, N'INV-2025030103', '2025-03-01 20:35:00'),
(85, 92, N'INV-2025030201', '2025-03-02 17:05:00'),
(86, 60, N'INV-2025030601', '2025-03-06 09:55:00'),
(87, 83, N'INV-2025030501', '2025-03-05 17:05:00'),
(88, 104, N'INV-2025030502', '2025-03-05 13:35:00'),
(89, 118, N'INV-2025030801', '2025-03-08 20:35:00'),
(90, 63, N'INV-2025030802', '2025-03-08 20:35:00'),
(91, 86, N'INV-2025030901', '2025-03-09 09:55:00'),
(92, 66, N'INV-2025031001', '2025-03-10 17:05:00'),
(93, 89, N'INV-2025031002', '2025-03-10 20:35:00'),
(94, 110, N'INV-2025031003', '2025-03-10 20:35:00'),
(95, 69, N'INV-2025031101', '2025-03-11 13:35:00'),
(96, 116, N'INV-2025031102', '2025-03-11 13:35:00'),
(97, 72, N'INV-2025031301', '2025-03-13 09:55:00'),
(98, 113, N'INV-2025031201', '2025-03-12 17:05:00');

SET IDENTITY_INSERT [dbo].[Invoice] OFF;
GO

-- ============================================================
-- CheckInSession (For bookings that have check-in process)
-- Status: PENDING, APPROVED, REJECTED
-- ============================================================
SET IDENTITY_INSERT [dbo].[CheckInSession] ON;

INSERT INTO [dbo].[CheckInSession] ([check_in_session_id], [booking_id], [video_url], [video_public_id], [status], [reviewed_by], [created_at], [reviewed_at]) VALUES
-- APPROVED check-ins (for COMPLETED and CHECKED_OUT bookings)
(1, 1, N'https://res.cloudinary.com/booknow/checkin/video_001.mp4', N'checkin_001', 'APPROVED', 6, '2024-03-15 10:20:00', '2024-03-15 10:30:00'),
(2, 4, N'https://res.cloudinary.com/booknow/checkin/video_004.mp4', N'checkin_004', 'APPROVED', 7, '2024-03-20 20:50:00', '2024-03-20 21:00:00'),
(3, 7, N'https://res.cloudinary.com/booknow/checkin/video_007.mp4', N'checkin_007', 'APPROVED', 8, '2024-04-01 17:25:00', '2024-04-01 17:35:00'),
(4, 2, N'https://res.cloudinary.com/booknow/checkin/video_002.mp4', N'checkin_002', 'APPROVED', 6, '2024-04-20 13:50:00', '2024-04-20 14:00:00'),
(5, 10, N'https://res.cloudinary.com/booknow/checkin/video_010.mp4', N'checkin_010', 'APPROVED', 9, '2024-04-10 13:50:00', '2024-04-10 14:00:00'),
(6, 13, N'https://res.cloudinary.com/booknow/checkin/video_013.mp4', N'checkin_013', 'APPROVED', 10, '2024-04-25 10:20:00', '2024-04-25 10:30:00'),
(7, 16, N'https://res.cloudinary.com/booknow/checkin/video_016.mp4', N'checkin_016', 'APPROVED', 6, '2024-05-01 20:50:00', '2024-05-01 21:00:00'),
(8, 5, N'https://res.cloudinary.com/booknow/checkin/video_005.mp4', N'checkin_005', 'APPROVED', 7, '2024-05-05 10:20:00', '2024-05-05 10:30:00'),
(9, 19, N'https://res.cloudinary.com/booknow/checkin/video_019.mp4', N'checkin_019', 'APPROVED', 8, '2024-05-15 17:25:00', '2024-05-15 17:35:00'),
(10, 8, N'https://res.cloudinary.com/booknow/checkin/video_008.mp4', N'checkin_008', 'APPROVED', 9, '2024-05-25 20:55:00', '2024-05-25 21:05:00'),
(11, 22, N'https://res.cloudinary.com/booknow/checkin/video_022.mp4', N'checkin_022', 'APPROVED', 10, '2024-05-30 13:50:00', '2024-05-30 14:00:00'),
(12, 25, N'https://res.cloudinary.com/booknow/checkin/video_025.mp4', N'checkin_025', 'APPROVED', 6, '2024-06-05 10:25:00', '2024-06-05 10:35:00'),
(13, 28, N'https://res.cloudinary.com/booknow/checkin/video_028.mp4', N'checkin_028', 'APPROVED', 7, '2024-06-15 20:50:00', '2024-06-15 21:00:00'),
(14, 3, N'https://res.cloudinary.com/booknow/checkin/video_003.mp4', N'checkin_003', 'APPROVED', 8, '2024-06-10 17:30:00', '2024-06-10 17:40:00'),
(15, 11, N'https://res.cloudinary.com/booknow/checkin/video_011.mp4', N'checkin_011', 'APPROVED', 9, '2024-06-20 17:20:00', '2024-06-20 17:30:00'),
(16, 31, N'https://res.cloudinary.com/booknow/checkin/video_031.mp4', N'checkin_031', 'APPROVED', 10, '2024-06-25 17:25:00', '2024-06-25 17:35:00'),
(17, 14, N'https://res.cloudinary.com/booknow/checkin/video_014.mp4', N'checkin_014', 'APPROVED', 6, '2024-07-01 13:55:00', '2024-07-01 14:05:00'),
(18, 34, N'https://res.cloudinary.com/booknow/checkin/video_034.mp4', N'checkin_034', 'APPROVED', 7, '2024-07-05 13:50:00', '2024-07-05 14:00:00'),
(19, 6, N'https://res.cloudinary.com/booknow/checkin/video_006.mp4', N'checkin_006', 'APPROVED', 8, '2024-07-15 13:55:00', '2024-07-15 14:05:00'),
(20, 37, N'https://res.cloudinary.com/booknow/checkin/video_037.mp4', N'checkin_037', 'APPROVED', 9, '2024-07-15 10:25:00', '2024-07-15 10:35:00'),
-- More APPROVED for recently completed
(21, 91, N'https://res.cloudinary.com/booknow/checkin/video_091.mp4', N'checkin_091', 'APPROVED', 6, '2025-03-12 10:25:00', '2025-03-12 10:35:00'),
(22, 97, N'https://res.cloudinary.com/booknow/checkin/video_097.mp4', N'checkin_097', 'APPROVED', 7, '2025-03-12 20:50:00', '2025-03-12 21:00:00'),
-- PENDING check-ins (current guests)
(23, 75, N'https://res.cloudinary.com/booknow/checkin/video_075.mp4', N'checkin_075', 'APPROVED', 8, '2025-03-13 17:25:00', '2025-03-13 17:35:00'),
(24, 94, N'https://res.cloudinary.com/booknow/checkin/video_094.mp4', N'checkin_094', 'APPROVED', 9, '2025-03-13 10:20:00', '2025-03-13 10:30:00'),
(25, 100, N'https://res.cloudinary.com/booknow/checkin/video_100.mp4', N'checkin_100', 'APPROVED', 10, '2025-03-13 13:50:00', '2025-03-13 14:00:00'),
(26, 103, N'https://res.cloudinary.com/booknow/checkin/video_103.mp4', N'checkin_103', 'APPROVED', 6, '2025-03-13 17:20:00', '2025-03-13 17:30:00'),
(27, 119, N'https://res.cloudinary.com/booknow/checkin/video_119.mp4', N'checkin_119', 'APPROVED', 7, '2025-03-13 20:50:00', '2025-03-13 21:00:00'),
(28, 121, N'https://res.cloudinary.com/booknow/checkin/video_121.mp4', N'checkin_121', 'APPROVED', 8, '2025-03-13 10:20:00', '2025-03-13 10:30:00'),
-- REJECTED check-ins
(29, 107, N'https://res.cloudinary.com/booknow/checkin/video_107.mp4', N'checkin_107', 'REJECTED', 1, '2025-02-28 20:50:00', '2025-02-28 21:30:00'),
(30, 112, N'https://res.cloudinary.com/booknow/checkin/video_112.mp4', N'checkin_112', 'REJECTED', 2, '2025-02-28 10:20:00', '2025-02-28 10:45:00');

SET IDENTITY_INSERT [dbo].[CheckInSession] OFF;
GO

-- ============================================================
-- Đánh giá (120+ feedback with ratings and staff replies)
-- Rating: 1-5, admin_id for staff reply
-- ============================================================
SET IDENTITY_INSERT [dbo].[Feedback] ON;

INSERT INTO [dbo].[Feedback] ([feedback_id], [booking_id], [admin_id], [rating], [content], [content_reply], [is_hidden], [created_at], [reply_at]) VALUES
-- Đánh giá 5 sao
(1, 1, 6, 5, N'Phòng Ocean City vượt xa mọi kỳ vọng của tôi! Trang trí theo chủ đề đại dương thật tuyệt vời và máy chiếu rất hoàn hảo để xem phim. Vị trí ở Quận Ninh Kiều rất thuận tiện. Rất đáng để thử!', N'Cảm ơn bạn rất nhiều vì phản hồi tuyệt vời, Minh Anh! Chúng tôi rất vui vì bạn đã có trải nghiệm Ocean City tuyệt vời. Rất mong được đón bạn quay lại sớm!', 0, '2024-03-15 14:00:00', '2024-03-15 16:30:00'),
(2, 4, 7, 5, N'Kỳ nghỉ qua đêm tuyệt vời tại Cook and Chill! Bếp được trang bị đầy đủ và chúng tôi đã có khoảng thời gian nấu ăn cực kỳ vui vẻ. Phòng rất sạch sẽ và giường cực kỳ êm ái. Chắc chắn sẽ đặt phòng lại.', N'Gửi Thành Đạt, cảm ơn bạn đã chia sẻ trải nghiệm! Chúng tôi rất vui vì bạn đã thích nấu ăn trong phòng. Rất mong được đón bạn quay lại!', 0, '2024-03-21 10:30:00', '2024-03-21 14:00:00'),
(3, 7, 8, 5, N'Pink Paradise thực sự là thiên đường! Phong cách hồng rất đẹp để chụp ảnh và khung giờ tối rất hoàn hảo cho buổi hẹn hò lãng mạn. Quy trình check-in của nhân viên rất nhanh gọn và chuyên nghiệp.', N'Cảm ơn Linh! Những lời khen của bạn rất ý nghĩa với chúng tôi. Chúng tôi thiết kế Pink Paradise với sự lãng mạn trong tâm trí và rất vui vì nó đã đáp ứng được. Hẹn gặp lại lần sau!', 0, '2024-04-01 21:00:00', '2024-04-02 09:00:00'),
(4, 10, 9, 5, N'Phòng Tiger Woods hoàn hảo cho người yêu golf! Khu vực mini golf rất thú vị. Thời gian buổi chiều rất lý tưởng. Phòng rất sạch sẽ và tiện nghi xuất sắc. Tuyệt vời!', N'Cảm ơn Hoàng Bảo! Chúng tôi trân trọng đánh giá 5 sao của bạn. Phòng Tiger Woods cũng là một trong những phòng yêu thích của chúng tôi. Hy vọng sẽ gặp lại bạn!', 0, '2024-04-10 17:30:00', '2024-04-10 19:00:00'),
(5, 13, 10, 5, N'GameHub là giấc mơ của game thủ thành hiện thực! Đã dành cả buổi sáng chơi game với bạn bè. Thiết bị chuyên nghiệp và hệ thống âm thanh tuyệt vời. Đáng từng đồng!', N'Gửi Thu, cảm ơn đánh giá tuyệt vời! Chúng tôi đã đầu tư rất nhiều vào thiết bị gaming và rất vui khi bạn đánh giá cao. Chơi tiếp nhé!', 0, '2024-04-25 14:00:00', '2024-04-25 16:30:00'),
(6, 16, 6, 5, N'Kỳ nghỉ qua đêm tại Honey House thật kỳ diệu. Ánh sáng hổ phách ấm áp và trang trí ấm cúng khiến chúng tôi cảm thấy như ở nhà. Ngủ rất sâu và thức dậy hoàn toàn sảng khoái. Kỳ nghỉ hoàn hảo!', N'Cảm ơn bạn rất nhiều vì những lời tốt đẹp! Honey House được thiết kế để thư giãn tối đa và chúng tôi rất vui vì nó phù hợp với bạn. Luôn chào đón bạn quay lại!', 0, '2024-05-02 10:30:00', '2024-05-02 13:00:00'),
(7, 19, 7, 5, N'Phòng Bea Bear thật đáng yêu! Trang trí theo chủ đề gấu rất dễ thương và khung giờ tối rất hoàn hảo. Các con tôi rất thích! Trải nghiệm gia đình tuyệt vời.', N'Cảm ơn bạn đã chọn Bea Bear cho gia đình! Chúng tôi rất vui vì các con bạn đã có khoảng thời gian tuyệt vời. Rất mong được đón tiếp bạn lần nữa!', 0, '2024-05-15 21:00:00', '2024-05-16 08:30:00'),
(8, 22, 8, 5, N'Calm Cloud đúng với tên gọi - đó là buổi chiều yên bình nhất trong nhiều tháng qua. Trang trí lấy cảm hứng từ mây rất mơ màng và giường mềm như trên thiên đường. Thư giãn tuyệt đối!', N'Gửi Tuấn Kiệt, cảm ơn đánh giá tuyệt vời này! Calm Cloud là nơi ẩn náu zen của chúng tôi và chúng tôi rất vui vì bạn đã tìm thấy sự bình yên mong muốn.', 0, '2024-05-30 17:30:00', '2024-05-30 19:00:00'),
(9, 25, 9, 5, N'Phòng Lion King đã khơi dậy đứa trẻ bên trong tất cả chúng tôi! Chủ đề safari châu Phi được thực hiện rất tốt. Khung giờ sáng rất tràn đầy năng lượng. Tuyệt vời cho tiệc theo chủ đề!', N'Cảm ơn Ngọc Mai! Chúng tôi đã nỗ lực rất nhiều với chủ đề Lion King. Rất vui vì bạn đã cảm nhận được sự kỳ diệu của Pride Lands!', 0, '2024-06-05 14:00:00', '2024-06-05 16:00:00'),
(10, 28, 10, 5, N'Green Haven là thiên đường của người yêu thiên nhiên! Cây cối và trang trí xanh khiến tôi cảm giác như đang ở trong rừng. Kỳ nghỉ qua đêm cực kỳ yên bình. Rất đáng thử!', N'Cảm ơn Đức Mạnh! Green Haven là góc thiên nhiên nhỏ của chúng tôi ngay trong thành phố. Chúng tôi rất vui vì bạn đã có trải nghiệm tuyệt vời!', 0, '2024-06-16 10:30:00', '2024-06-16 13:00:00'),

-- Đánh giá 4 sao
(11, 2, 6, 4, N'Phòng Ball Chill rất tuyệt cho buổi chiều thư giãn. Trang trí hiện đại và thoải mái. Chỉ cho 4 sao vì điều hòa hơi lâu để làm mát, nhưng ngoài ra thì xuất sắc!', N'Cảm ơn phản hồi của bạn! Chúng tôi xin lỗi về điều hòa - đã được bảo dưỡng và giờ hoạt động hoàn hảo. Hy vọng gặp lại bạn!', 0, '2024-04-20 17:30:00', '2024-04-20 19:30:00'),
(12, 5, 7, 4, N'Phòng Ocean có trang trí đẹp và giường rất thoải mái. Khung giờ sáng rất hoàn hảo. Điều duy nhất thiếu là đồ dùng vệ sinh tốt hơn. Vẫn là trải nghiệm tuyệt vời!', N'Cảm ơn phản hồi mang tính xây dựng! Chúng tôi đã nâng cấp đồ dùng vệ sinh dựa trên góp ý của khách hàng. Xin hãy quay lại!', 0, '2024-05-05 14:00:00', '2024-05-05 16:30:00'),
(13, 8, 8, 4, N'Kỳ nghỉ qua đêm tại Wood Mood rất ấm cúng và thoải mái. Chủ đề mộc mạc được thực hiện tốt. Góp ý nhỏ - cần ánh sáng tốt hơn để đọc sách. Ngoài ra thì xuất sắc!', N'Cảm ơn phản hồi của bạn! Chúng tôi đã thêm đèn đọc sách dựa trên góp ý như của bạn. Hy vọng bạn sẽ quay lại để trải nghiệm!', 0, '2024-05-26 10:30:00', '2024-05-26 14:00:00'),
(14, 11, 9, 4, N'Buổi tối tại Cine Room rất tuyệt để xem phim! Hệ thống âm thanh và chất lượng chiếu phim tuyệt vời. Sẽ hoàn hảo hơn nếu có ghế ngồi thoải mái hơn.', N'Cảm ơn đánh giá! Chúng tôi đang nâng cấp ghế ngồi. Phản hồi của bạn giúp chúng tôi cải thiện!', 0, '2024-06-20 21:00:00', '2024-06-21 09:30:00'),
(15, 14, 10, 4, N'Bass Bar có hệ thống âm thanh tuyệt vời! Hoàn hảo cho người yêu nhạc. Khung giờ chiều rất thú vị. Điều duy nhất là phòng cần thêm bass (đùa một chút). Vẫn recommend!', N'Haha, chúng tôi thích câu đùa đó! Cảm ơn phản hồi. Chúng tôi đang xem xét thêm loa subwoofer. Rock on!', 0, '2024-07-01 17:30:00', '2024-07-01 19:00:00'),
(16, 17, 6, 4, N'Phòng Love Blaze rất lãng mạn với trang trí đỏ và hồng đẹp. Khung giờ sáng rất đẹp và riêng tư. Phòng sạch nhưng cần thêm lựa chọn ánh sáng lãng mạn.', N'Cảm ơn góp ý! Chúng tôi đã thêm đèn LED kiểu nến để tăng không khí lãng mạn. Xin hãy quay lại!', 0, '2024-07-20 14:00:00', '2024-07-20 16:00:00'),
(17, 20, 7, 4, N'Phòng Lavender có mùi thơm tuyệt vời! Chủ đề tím rất thư giãn và kỳ nghỉ qua đêm rất yên bình. Muốn có thêm lựa chọn gối nhưng nhìn chung rất hài lòng!', N'Cảm ơn đánh giá! Bây giờ chúng tôi có menu gối với các mức độ cứng mềm khác nhau. Hy vọng gặp lại bạn sớm!', 0, '2024-08-02 10:30:00', '2024-08-02 13:00:00'),
(18, 23, 8, 4, N'Phòng Ruby với bàn bida rất vui! Khung giờ tối hoàn hảo để chơi bi-a với bạn bè. Phòng cần thông gió tốt hơn khi chơi. Vẫn tuyệt vời!', N'Cảm ơn phản hồi! Chúng tôi đã cải thiện hệ thống thông gió. Hãy tận hưởng trận bi-a tiếp theo với không khí trong lành!', 0, '2024-08-15 21:00:00', '2024-08-16 09:00:00'),
(19, 26, 9, 4, N'Cinema Zone có máy chiếu chuyên nghiệp! Buổi chiều rất thú vị. Góp ý nhỏ - lựa chọn snack có thể tốt hơn. Trải nghiệm xem phim vẫn tuyệt vời!', N'Cảm ơn phản hồi! Chúng tôi đã hợp tác với nhà cung cấp snack địa phương để có nhiều lựa chọn hơn. Tận hưởng nhé!', 0, '2024-08-25 17:30:00', '2024-08-25 19:30:00'),
(20, 29, 10, 4, N'Phòng Orange Pop sôi động và tràn đầy năng lượng! Khung giờ sáng rất sảng khoái. Trang trí cam rất bắt mắt. Phòng hơi nóng ban đầu nhưng điều hòa đã khắc phục nhanh.', N'Cảm ơn đánh giá! Chúng tôi cảm ơn sự kiên nhẫn của bạn với điều hòa. Phòng được thiết kế để tạo năng lượng và rất vui vì nó hiệu quả!', 0, '2024-09-01 14:00:00', '2024-09-01 16:30:00'),

-- More Đánh giá 5 sao
(21, 31, 6, 5, N'Zone X với bàn bida thật tuyệt vời! Buổi tối hoàn hảo cho đêm thi đấu. Phòng có ánh sáng xuất sắc để chơi bi-a. Chất lượng hàng đầu!', N'Cảm ơn 5 sao! Zone X được thiết kế cho người chơi nghiêm túc như bạn. Hãy thách thức bạn bè lần sau!', 0, '2024-06-25 21:00:00', '2024-06-26 09:00:00'),
(22, 34, 7, 5, N'Buổi hẹn hò chiều tại Love Pink thật hoàn hảo! Chủ đề hồng lãng mạn tạo không khí tuyệt vời. Nhân viên rất chu đáo và chuyên nghiệp. 10/10 sẽ giới thiệu!', N'Cảm ơn bạn đã chia sẻ trải nghiệm lãng mạn! Chúng tôi rất vui vì Love Pink đã làm cho buổi hẹn của bạn đặc biệt. Hẹn gặp lại lần sau!', 0, '2024-07-05 17:30:00', '2024-07-05 19:30:00'),
(23, 37, 8, 5, N'Luca Homestay hiện đại, thuận tiện và vị trí hoàn hảo. Khung giờ sáng lý tưởng cho kỳ nghỉ ngắn. Mọi thứ đều sạch sẽ và check-in nhanh chóng.', N'Cảm ơn đánh giá tuyệt vời! Luca được thiết kế cho du khách hiện đại như bạn. Luôn chào đón quay lại!', 0, '2024-07-15 14:00:00', '2024-07-15 16:00:00'),
(24, 40, 9, 5, N'Phòng kiểu Đà Lạt ở Cần Thơ là concept độc đáo! Kỳ nghỉ qua đêm đưa chúng tôi lên núi. Nhiệt độ mát mẻ và trang trí đẹp. Rất yêu thích!', N'Cảm ơn! Chúng tôi muốn mang một phần Đà Lạt đến Cần Thơ và rất vui vì bạn cảm nhận được. Hãy quay lại!', 0, '2024-07-26 10:30:00', '2024-07-26 13:00:00'),
(25, 43, 10, 5, N'8 Ball House hoàn hảo cho người yêu bi-a! Buổi tối thi đấu vui và hào hứng. Bàn chuyên nghiệp và ánh sáng xuất sắc. Phòng bi-a tốt nhất Cần Thơ!', N'Wow, cảm ơn lời khen cao nhất! Chúng tôi tự hào về setup bi-a. Luyện tập tiếp và quay lại nhé!', 0, '2024-08-05 21:00:00', '2024-08-06 09:30:00'),
(26, 46, 6, 5, N'Phòng Atlantis là xứ sở thần tiên dưới nước! Buổi chiều thật kỳ diệu. Ánh sáng xanh và trang trí đại dương mê hoặc. Cảm giác như đang ở trong bể cá!', N'Cảm ơn bạn đã lặn vào Atlantis! Chúng tôi đã dành nhiều tháng hoàn thiện không khí dưới nước. Rất vui vì bạn yêu thích!', 0, '2024-08-20 17:30:00', '2024-08-20 19:00:00'),
(27, 49, 7, 5, N'Phòng Wine Ball là hiện thân của sự tinh tế! Buổi sáng thanh lịch và thư giãn. Trang trí chủ đề rượu vang sang trọng nhưng không kiểu cách. Hoàn hảo cho cặp đôi!', N'Cheers với đánh giá đó! Wine Ball là sự tôn vinh những điều tinh tế trong cuộc sống. Hy vọng sẽ đón bạn lần nữa!', 0, '2024-09-05 14:00:00', '2024-09-05 16:30:00'),
(28, 52, 8, 5, N'Phòng Doraemon là hoài niệm tuổi thơ thuần túy! Kỳ nghỉ qua đêm như du hành ngược thời gian. Mọi chi tiết trang trí đều hoàn hảo. Đứa trẻ trong tôi rất hạnh phúc!', N'Cảm ơn đã du hành ký ức cùng chúng tôi! Phòng Doraemon được thiết kế để mang lại niềm vui. Hãy quay lại bất cứ lúc nào!', 0, '2024-09-16 10:30:00', '2024-09-16 13:00:00'),
(29, 55, 9, 5, N'Buổi tối nấu ăn tại Cook and Chill thật tuyệt! Đã nấu bữa tối với người yêu và có buổi tối đáng yêu. Bếp đầy đủ thiết bị chất lượng. Rất đáng thử!', N'Cảm ơn đã chia sẻ trải nghiệm ẩm thực! Rất vui vì bạn thích nấu ăn cùng nhau. Bon appetit lần sau!', 0, '2024-09-25 21:00:00', '2024-09-26 08:30:00'),
(30, 58, 10, 5, N'Buổi chiều Ball Chill chính xác là những gì tôi cần để giảm stress. Ghế ngồi thoải mái và không khí yên bình giúp tôi thư giãn hoàn toàn. Đáng từng đồng!', N'Cảm ơn đã dành thời gian thư giãn với chúng tôi! Ball Chill là ốc đảo yên bình và rất vui vì nó phục vụ bạn tốt!', 0, '2024-10-05 17:30:00', '2024-10-05 19:30:00'),

-- Đánh giá 3 sao (trải nghiệm trung bình)
(31, 3, 6, 3, N'Khung giờ tối tại Ivy Garden tạm được. Chủ đề vườn đẹp nhưng một số cây cần tưới nước. Phòng thoải mái nhưng không ấn tượng như ảnh.', N'Chúng tôi xin lỗi vì không đáp ứng kỳ vọng. Đã thuê chuyên gia chăm sóc cây và cập nhật ảnh chính xác hơn. Xin hãy cho chúng tôi cơ hội lần nữa!', 0, '2024-06-10 21:00:00', '2024-06-11 09:30:00'),
(32, 6, 7, 3, N'Phòng Mellow... rất mellow. Khung giờ chiều yên tĩnh và bình an nhưng phòng thiếu cá tính. Tốt để ngủ trưa nhưng không nhiều hơn. Trải nghiệm trung bình.', N'Cảm ơn phản hồi thẳng thắn. Mellow được thiết kế cho thư giãn thuần túy, nhưng chúng tôi hiểu nếu bạn muốn nhiều tính năng hơn. Sẽ cân nhắc thêm tiện nghi!', 0, '2024-07-15 17:30:00', '2024-07-15 20:00:00'),
(33, 9, 8, 3, N'Concept phòng Squid Game hay nhưng thực hiện buổi sáng có thể tốt hơn. Một số đạo cụ trông cũ và ánh sáng quá tối. Có tiềm năng nhưng cần bảo trì.', N'Cảm ơn phản hồi. Đã thay thế đạo cụ và điều chỉnh ánh sáng. Trò chơi đã trở lại! Xin hãy quay lại!', 0, '2024-08-10 14:00:00', '2024-08-10 16:30:00'),
(34, 12, 9, 3, N'Kỳ nghỉ qua đêm Solo Gaming tạm ổn. Setup gaming tốt nhưng ghế không thoải mái cho session dài. Nên đầu tư ghế gaming tốt hơn.', N'Cảm ơn phản hồi gaming! Đã đầu tư ghế gaming ergonomic với hỗ trợ lưng. Sẵn sàng cho session marathon tiếp theo!', 0, '2024-09-06 10:30:00', '2024-09-06 14:00:00'),
(35, 15, 10, 3, N'Phòng Mykonos có trang trí Hy Lạp đẹp nhưng trải nghiệm buổi chiều không nhập tâm như mong đợi. Chủ đề xanh trắng đẹp nhưng hơi generic.', N'Cảm ơn đánh giá thẳng thắn. Đang thêm các yếu tố Hy Lạp chính thống hơn như âm nhạc và mùi hương để nâng cao không khí!', 0, '2024-09-20 21:00:00', '2024-09-21 09:00:00'),

-- More Đánh giá 4 sao
(36, 18, 6, 4, N'Buổi tối Moon Space thật tuyệt! Chủ đề không gian được thực hiện tốt với sao trên trần. Góp ý nhỏ - cần thêm hiệu ứng âm thanh không gian. Vẫn rất thích!', N'Houston, chúng tôi có khách hài lòng! Cảm ơn phản hồi - đang thêm âm thanh không gian. Nhiệm vụ hoàn thành!', 0, '2024-10-05 17:30:00', '2024-10-05 19:00:00'),
(37, 21, 7, 4, N'Buổi chiều Blue Wave thật sảng khoái! Họa tiết sóng và đại dương rất thư giãn. Phòng duy trì nhiệt độ mát mẻ. Muốn có thêm sắc xanh đa dạng.', N'Cảm ơn đã lướt sóng cùng chúng tôi! Đang cập nhật bảng màu với xanh đậm hơn. Bắt sóng tiếp theo nhé!', 0, '2024-10-20 14:00:00', '2024-10-20 16:30:00'),
(38, 24, 8, 4, N'Trải nghiệm qua đêm CGV cinema rất tuyệt! Cảm giác như có rạp chiếu phim riêng. Âm thanh có thể tốt hơn cho phim hành động. Ngoài ra, trải nghiệm bom tấn!', N'Cảm ơn đánh giá! Đang nâng cấp hệ thống âm thanh cho trải nghiệm đẳng cấp rạp chiếu. Các sản phẩm sắp tới đang chờ!', 0, '2024-11-02 10:30:00', '2024-11-02 13:00:00'),
(39, 27, 9, 4, N'Buổi tối Sweet Dreams đúng với tên gọi. Trang trí pastel mơ màng rất dễ chịu. Nệm chất lượng tốt. Muốn có thêm lựa chọn gối cho sự thoải mái tối đa.', N'Cảm ơn đã mơ cùng chúng tôi! Bây giờ có menu gối với memory foam và lông vũ. Giấc mơ ngọt ngào đang chờ!', 0, '2024-11-15 21:00:00', '2024-11-16 09:30:00'),
(40, 30, 10, 4, N'Buổi chiều Pink Dream rất đáng yêu! Phong cách hồng nữ tính và vui vẻ. Phòng sạch và thoải mái. Ảnh online chính xác. Góp ý nhỏ - lựa chọn nhạc có thể tốt hơn.', N'Cảm ơn đánh giá hồng-tastic! Đã thêm loa Bluetooth để khách có thể phát nhạc riêng. Tiếp tục mơ nhé!', 0, '2024-12-01 17:30:00', '2024-12-01 19:30:00'),

-- More Đánh giá 5 sao (continued)
(41, 32, 6, 5, N'Kỳ nghỉ qua đêm phòng Cheese với bếp thật tuyệt! Chúng tôi đã làm fondue và không gian hoàn hảo. Trang trí vàng rất vui tươi và bếp đầy đủ thiết bị. Say cheese!', N'Say cheese thật! Rất vui vì bạn đã có khoảng thời gian gouda! Phòng Cheese hoàn hảo cho phiêu lưu ẩm thực. Hãy quay lại sớm!', 0, '2024-09-11 10:30:00', '2024-09-11 13:00:00'),
(42, 35, 7, 5, N'Buổi tối Fini Homestay riêng tư và lãng mạn. Phòng cung cấp sự riêng tư hoàn toàn, rất phù hợp cho cặp đôi. Sạch sẽ, hiện đại và được bảo trì tốt. Chắc chắn sẽ quay lại!', N'Cảm ơn đã chọn Fini cho kỳ nghỉ lãng mạn! Sự riêng tư và lãng mạn là ưu tiên của chúng tôi. Rất mong được đón bạn trở lại!', 0, '2024-09-25 21:00:00', '2024-09-26 08:30:00'),
(43, 38, 8, 5, N'Buổi chiều Beach Homestay như đang ở bên bờ biển! Tường màu cát và trang trí biển rất chuẩn. Không khí rất thư giãn. Gần như nghe thấy tiếng sóng!', N'Aloha và cảm ơn! Chúng tôi đã mang bãi biển đến Cần Thơ cho những khoảnh khắc như của bạn. Hãy bắt con sóng tiếp theo với chúng tôi!', 0, '2024-10-01 17:30:00', '2024-10-01 19:00:00'),
(44, 41, 9, 5, N'Buổi sáng Blue Vibe tràn đầy năng lượng! Tông xanh mát thật sự đánh thức tôi. Tiện nghi hiện đại và rất sạch. Hoàn hảo để refresh buổi sáng. Khởi đầu tuyệt vời cho ngày mới!', N'Cảm ơn những vibes tuyệt vời! Blue Vibe được thiết kế để tạo năng lượng và rất vui vì nó hiệu quả. Bắt đầu ngày mới với chúng tôi lần nữa!', 0, '2024-10-15 14:00:00', '2024-10-15 16:00:00'),
(45, 44, 10, 5, N'Kỳ nghỉ qua đêm La Maison là sự thanh lịch Pháp thuần túy! Trang trí Paris tinh tế và lãng mạn. Cảm giác như đang ở khách sạn boutique ở Paris. Tres magnifique!', N'Merci beaucoup cho đánh giá tuyệt vời! La Maison mang một chút Paris đến Việt Nam. Au revoir đến lần sau!', 0, '2024-10-26 10:30:00', '2024-10-26 13:00:00'),
(46, 47, 6, 5, N'Buổi tối Forest retreat thật kỳ diệu! Trang trí xanh và các yếu tố tự nhiên khiến tôi cảm thấy hòa mình với thiên nhiên. Rất yên bình và tái tạo năng lượng. Thoát khỏi cuộc sống thành phố!', N'Cảm ơn đã đón nhận thiên nhiên cùng chúng tôi! Phòng Forest là thiên đường yên tĩnh của chúng tôi. Cây cối đang chờ bạn trở lại!', 0, '2024-11-05 21:00:00', '2024-11-06 09:00:00'),
(47, 50, 7, 5, N'Buổi chiều phòng Video Game thật hoài niệm! Setup gaming retro gợi lại rất nhiều kỷ niệm. TV CRT và console cổ điển là điểm nhấn đẹp. Thiên đường game thủ!', N'Cảm ơn đã chơi game cùng chúng tôi! Chúng tôi đam mê bảo tồn lịch sử gaming. Player 1, hãy đút xu và quay lại!', 0, '2024-11-20 17:30:00', '2024-11-20 19:30:00'),
(48, 53, 8, 5, N'Buổi sáng Game Room PS4 thật tuyệt! Game mới nhất, setup thoải mái và màn hình đẹp. Hoàn hảo cho session gaming nghiêm túc. Sẽ dắt bạn bè đến lần sau!', N'Cảm ơn lời khen gaming! Hãy dắt cả đội đến lần sau cho action multiplayer. GG và hẹn gặp lại!', 0, '2024-12-05 14:00:00', '2024-12-05 16:00:00'),
(49, 56, 9, 5, N'Kỳ nghỉ qua đêm Pink Paradise là giấc mơ thành hiện thực! Chủ đề hồng dưới ánh đèn đêm thật kỳ diệu. Trải nghiệm nghỉ qua đêm tuyệt vời nhất từ trước đến giờ!', N'Cảm ơn đã qua đêm tại Pink Paradise! Rất vui vì đó là trải nghiệm tuyệt vời nhất của bạn. Giấc mơ ngọt ngào đang chờ bạn trở lại!', 0, '2024-12-11 10:30:00', '2024-12-11 13:00:00'),
(50, 59, 10, 5, N'Buổi tối gaming GameHub thật tuyệt vời! Setup sánh ngang với quán game chuyên nghiệp. Nhiều lựa chọn gaming và thiết bị xuất sắc. Phòng gaming tốt nhất khu vực!', N'Cảm ơn đánh giá cấp độ pro! Chúng tôi đầu tư rất nhiều vào thiết bị gaming. Sẵn sàng lên level? Hãy quay lại sớm!', 0, '2024-12-20 21:00:00', '2024-12-21 08:30:00'),

-- 2025 reviews
(51, 39, 6, 5, N'Marathon xem phim CGV Room thật tuyệt! Xem liền 3 phim. Chất lượng chiếu đẳng cấp rạp chiếu. Bắp rang và nước uống làm mọi thứ hoàn hảo. Tốt hơn CGV thật!', N'Tốt hơn CGV? Thật vinh dự! Cảm ơn đã xem phim marathon cùng chúng tôi. Đánh giá xứng tầm Oscar! Hãy quay lại xem phần tiếp theo!', 0, '2025-01-05 21:00:00', '2025-01-06 09:00:00'),
(52, 42, 7, 4, N'Session nấu ăn chiều Smoke Kitchen rất vui! Đã nấu nhiều món ngon. Có vấn đề nhỏ với hút khói nhưng nhân viên xử lý nhanh. Trải nghiệm tốt!', N'Cảm ơn đã nấu ăn cùng chúng tôi! Đã nâng cấp hệ thống thông gió. Cuộc phiêu lưu ẩm thực tiếp theo đang chờ!', 0, '2025-01-15 17:30:00', '2025-01-15 19:00:00'),
(53, 45, 8, 5, N'Session sáng bếp Masterchef như đang ở chương trình nấu ăn! Thiết bị chuyên nghiệp và nhiều không gian. Đã nấu bữa sáng cho cả gia đình. Trải nghiệm đầu bếp hàng đầu!', N'Và người chiến thắng là... BẠN! Cảm ơn đã thể hiện Masterchef trong lòng cùng chúng tôi. Bếp đang chờ sáng tạo tiếp theo!', 0, '2025-01-25 14:00:00', '2025-01-25 16:30:00'),
(54, 48, 9, 5, N'Kỳ nghỉ qua đêm Vibe Home đúng là những gì chúng tôi cần. Trang trí thời thượng và nội thất thoải mái khiến cảm giác như căn hộ cao cấp. Hiện đại và phong cách!', N'Cảm ơn đã vibe cùng chúng tôi! Vibe Home được thiết kế cho du khách hiện đại. Chỉ có good vibes - hẹn gặp lại!', 0, '2025-02-06 10:30:00', '2025-02-06 13:00:00'),
(55, 51, 10, 5, N'Buổi tối Lasaoma độc đáo và sáng tạo! Trang trí nghệ thuật kích thích suy nghĩ. Rất khác biệt với các phòng thông thường. Hoàn hảo cho ai tìm kiếm điều độc đáo!', N'Cảm ơn đã đánh giá cao tầm nhìn nghệ thuật! Lasaoma dành cho những tâm hồn sáng tạo như bạn. Canvas đang chờ bạn trở lại!', 0, '2025-02-15 21:00:00', '2025-02-16 08:30:00'),
(56, 54, 6, 5, N'Quay lại Ocean City và vẫn tuyệt vời! Đến sau một năm và chất lượng còn tốt hơn. Chủ đề đại dương vẫn khiến tôi ngẩn ngơ. Khách hàng trung thành mãi mãi!', N'Chào mừng trở lại Ocean City! Vinh dự với sự trung thành của bạn và vui vì bạn nhận thấy cải tiến. Hẹn gặp ở đại dương xanh!', 0, '2025-02-25 17:30:00', '2025-02-25 19:00:00'),
(57, 57, 7, 5, N'Session sáng Tiger Woods là hole in one! Mini golf và chủ đề golf hoàn hảo cho người yêu golf. Cách tuyệt vời để bắt đầu ngày. Fore!', N'Fore! Chơi chữ golf tuyệt vời! Cảm ơn đã tee off cùng chúng tôi. Lượt tiếp theo đang chờ. Par excellence!', 0, '2025-03-01 14:00:00', '2025-03-01 16:00:00'),
(58, 60, 8, 5, N'Kỳ nghỉ qua đêm Honey House ngọt ngào hoàn hảo! Tông màu mật ong ấm áp và không khí ấm cúng mang lại giấc ngủ tuyệt vời nhất. Thức dậy sảng khoái và vui vẻ. Ngọt ngào tuyệt đối!', N'Bạn ngọt ngào quá! Cảm ơn đánh giá ngọt ngào! Honey House là vùng comfort của chúng tôi. Giấc mơ ngọt ngào chờ bạn trở lại!', 0, '2025-03-06 10:30:00', '2025-03-06 13:00:00'),
(59, 62, 9, 5, N'Đêm Giao thừa Cine Room thật hoàn hảo! Xem đếm ngược trên màn hình lớn. Máy chiếu và âm thanh hoàn hảo. Giao thừa tuyệt vời nhất! Rất đáng thử!', N'Chúc mừng năm mới và cảm ơn! Thật vinh dự được là phần của lễ kỷ niệm. Cheers!', 0, '2025-01-01 17:30:00', '2025-01-01 19:00:00'),
(60, 63, 10, 5, N'Buổi tối Ivy Garden thật đẹp! Cây cối xanh tươi. Cải thiện rõ ràng so với lần trước. Chủ đề vườn giờ được thực hiện hoàn hảo. Liệu pháp thiên nhiên!', N'Cảm ơn đã cho chúng tôi cơ hội lần nữa! Chúng tôi đã nghiêm túc với phản hồi và cải thiện. Khu vườn đang nở rộ cho bạn!', 0, '2025-03-08 21:00:00', '2025-03-09 09:00:00'),

-- More feedback records (61-100)
(61, 64, 6, 4, N'Kỳ nghỉ qua đêm Bea Bear dễ thương và thoải mái. Chủ đề gấu đáng yêu. Phòng được bảo trì tốt. Muốn thấy thêm hoạt động hoặc đồ vật theo chủ đề gấu trong phòng.', N'Cảm ơn đánh giá bear-y nice! Chúng tôi đang thêm nhiều đồ sưu tập gấu và thậm chí tặng gấu bông cho khách!', 0, '2024-10-26 10:30:00', '2024-10-26 14:00:00'),
(62, 65, 7, 5, N'Buổi sáng Wood Mood hoàn hảo để bắt đầu ngày bình an. Trang trí gỗ mộc mạc rất quyến rũ. Cải tiến tuyệt vời so với trước - đèn đọc sách mới hoàn hảo!', N'Cảm ơn đã nhận thấy cải tiến! Phản hồi trước của bạn đã giúp chúng tôi. Wood mood luôn chào đón bạn trở lại!', 0, '2025-01-10 14:00:00', '2025-01-10 16:00:00'),
(63, 66, 8, 5, N'Buổi chiều Calm Cloud đúng như mô tả - yên bình. Giường như mây thật thiên đường. Hoàn hảo để thoát khỏi stress giữa ngày. Bay bổng trên mây!', N'Cảm ơn đã bay cùng chúng tôi! Calm Cloud được thiết kế cho sự bình yên tối đa. Chúc bạn luôn ở cloud nine!', 0, '2025-03-10 17:30:00', '2025-03-10 19:00:00'),
(64, 67, 9, 4, N'Đêm nhạc Bass Bar rất thú vị. Hệ thống âm thanh đã cải thiện đáng kể. Muốn có thêm karaoke. Vẫn recommend cho người yêu nhạc!', N'Cảm ơn phản hồi! Đang cân nhắc thêm hệ thống karaoke. Rock on cho đến lúc đó!', 0, '2024-11-05 21:00:00', '2024-11-06 09:30:00'),
(65, 68, 10, 5, N'Kỳ nghỉ qua đêm Mellow đúng là những gì bác sĩ kê đơn. Tông màu trung tính êm dịu giúp ngủ ngon. Đôi khi đơn giản là tốt nhất. Thư giãn thuần túy!', N'Cảm ơn đã tìm thấy mellow của bạn! Sự thanh lịch đơn giản là triết lý của chúng tôi. Nghỉ ngơi và quay lại sớm!', 0, '2025-01-21 10:30:00', '2025-01-21 13:00:00'),
(66, 69, 6, 5, N'Lion King với các bé thật thành công vang dội! Chủ đề safari đã thu hút trí tưởng tượng suốt buổi sáng. Sự chú ý đến chi tiết rất ấn tượng. Hakuna Matata!', N'Hakuna Matata thật! Cảm ơn đã đưa gia đình đến. Pride Lands chờ đợi cuộc phiêu lưu tiếp theo!', 0, '2025-03-11 14:00:00', '2025-03-11 16:00:00'),
(67, 70, 7, 4, N'Buổi hẹn hò chiều Love Blaze lãng mạn và riêng tư. Trang trí đỏ và hồng tạo không khí hoàn hảo. Góp ý nhỏ - cánh hoa hồng khi đến sẽ tuyệt vời!', N'Cảm ơn góp ý lãng mạn! Bây giờ chúng tôi có gói cánh hoa hồng cho dịp đặc biệt. Tình yêu đang trong không khí!', 0, '2024-11-15 17:30:00', '2024-11-15 19:30:00'),
(68, 71, 8, 5, N'Đêm chủ đề Squid Game căng thẳng và vui! Đạo cụ và ánh sáng cải tiến tạo sự khác biệt. Cảm giác như trong show thật. Game on!', N'Cảm ơn đã chơi game! Chúng tôi nghiêm túc với phản hồi trước. Sẵn sàng cho vòng tiếp theo? Chúc may mắn!', 0, '2025-01-30 21:00:00', '2025-01-31 09:00:00'),
(69, 72, 9, 5, N'Kỳ nghỉ qua đêm Lavender cực kỳ thư giãn. Hương lavender trong phòng giúp ngủ ngay lập tức. Giấc ngủ tốt nhất nhiều tháng qua. Rất có tính liệu pháp!', N'Cảm ơn đánh giá thư giãn! Chúng tôi dùng tinh dầu lavender thật. Giấc mơ ngọt ngào và đêm bình yên đang chờ!', 0, '2025-03-13 10:30:00', '2025-03-13 13:00:00'),
(70, 73, 10, 5, N'Buổi sáng Ruby với bi-a cạnh tranh và vui! Bàn bi-a chuyên nghiệp. Ánh sáng tuyệt vời để chơi nghiêm túc. Đã tạo ra những kỷ niệm tuyệt vời!', N'Cảm ơn đã break cùng chúng tôi! Phòng Ruby là niềm tự hào bi-a của chúng tôi. Challenge accepted cho lần sau!', 0, '2024-11-25 14:00:00', '2024-11-25 16:00:00'),

-- More reviews (71-100)
(71, 74, 6, 5, N'Marathon xem phim chiều Cinema Zone thật tuyệt! Xem bộ ba phim yêu thích liên tiếp. Ghế thoải mái cho session dài. Tốt hơn rạp chiếu công cộng!', N'Triple feature thành công! Cảm ơn lời khen về rạp chiếu. Credit cuộn nhưng hy vọng gặp lại bạn cho phần tiếp theo!', 0, '2025-02-10 17:30:00', '2025-02-10 19:00:00'),
(72, 76, 7, 5, N'Buổi tối Green Haven thật sảng khoái! Cây cối đã phát triển tốt kể từ review nhắc đến cải tiến. Phòng giờ cảm giác như vườn indoor thật sự. Người yêu thiên nhiên đã approve!', N'Cảm ơn đã nuôi dưỡng giấc mơ xanh! Chúng tôi tận tâm duy trì thiên đường thực vật. Khu vườn đang chờ!', 0, '2024-12-05 21:00:00', '2024-12-06 09:00:00'),
(73, 77, 8, 5, N'Giải đấu bi-a qua đêm Zone X với bạn bè thật epic! Chơi đến 2 giờ sáng và không ai muốn dừng. Trải nghiệm phòng bi-a tuyệt vời nhất. Đẳng cấp vô địch!', N'Chất liệu vô địch ngay đây! Cảm ơn session bi-a marathon. Phấn đã sẵn sàng cho trận tái đấu!', 0, '2025-02-21 10:30:00', '2025-02-21 13:00:00'),
(74, 79, 9, 5, N'Buổi chiều Orange Pop sôi động và tràn đầy năng lượng! Trang trí cam thật sự nâng cao tinh thần. Hoàn hảo cho session pick-me-up. Rời đi với cảm giác tích cực và sảng khoái!', N'Orange you glad you came? Cảm ơn đánh giá đầy năng lượng! Pop by bất cứ lúc nào cho vitamin C hạnh phúc!', 0, '2024-12-15 17:30:00', '2024-12-15 19:00:00'),
(75, 80, 10, 5, N'Buổi tối Moon Space là trải nghiệm liên hành tinh! Hình chiếu vũ trụ trên trần thật ngoạn mục. Cảm giác như đang bay trong không gian. Out of this world!', N'Houston, chúng tôi có đánh giá 5 sao! Cảm ơn đã tham gia chương trình không gian. Vũ trụ đang chờ nhiệm vụ tiếp theo!', 0, '2025-03-01 21:00:00', '2025-03-02 09:00:00'),
(76, 82, 6, 5, N'Buổi sáng Giáng sinh Love Pink thật kỳ diệu! Santa sẽ approve xứ sở thần tiên hồng này. Món quà Giáng sinh hoàn hảo cho người yêu. Kỷ niệm lễ hội đã được tạo ra!', N'Giáng sinh vui vẻ từ Love Pink! Thật đặc biệt để kỷ niệm. Chúc các ngày lễ luôn kỳ diệu như vậy!', 0, '2024-12-25 14:00:00', '2024-12-25 16:00:00'),
(77, 83, 7, 5, N'Buổi chiều Blue Wave đúng là sự sảng khoái cần thiết. Tông xanh đại dương rất êm dịu và tiếng sóng từ loa là điểm nhấn tuyệt vời. Seaside vibes!', N'Cảm ơn đã lướt sóng! Đã thêm âm thanh ambient dựa trên phản hồi. Đại dương đang gọi - hãy trả lời!', 0, '2025-03-05 17:30:00', '2025-03-05 19:00:00'),
(78, 85, 8, 5, N'Buổi tối Luca Homestay hoàn hảo cho kỳ nghỉ hiện đại. Mọi thứ thuận tiện và thiết kế đẹp. Phong cách tối giản đúng gu của tôi. Không cầu kỳ, tất cả thoải mái!', N'Cảm ơn đã đánh giá cao chủ nghĩa tối giản hiện đại! Luca được thiết kế cho du khách tinh tế như bạn. Đường nét sạch sẽ đang chờ!', 0, '2025-01-05 21:00:00', '2025-01-06 09:00:00'),
(79, 86, 9, 5, N'Kỳ nghỉ qua đêm CGV cinema là trải nghiệm xem phim tối thượng! Xem phim đến sáng sớm. Ghế ngả cực kỳ thoải mái. Chỗ ở xứng tầm Oscar!', N'Và giải thưởng dành cho... bạn! Cảm ơn đánh giá đẳng cấp Hollywood. Thảm đỏ đang chờ bạn trở lại!', 0, '2025-03-09 10:30:00', '2025-03-09 13:00:00'),
(80, 88, 10, 5, N'Giấc ngủ trưa chiều Sweet Dreams thật sảng khoái! Màu pastel êm dịu và giường mềm như mây. Hoàn hảo cho power nap. Thức dậy hoàn toàn sạc đầy năng lượng!', N'Sweet dreams được làm từ những đánh giá như thế này! Cảm ơn đã ngủ trưa với chúng tôi. Giấc mơ đang chờ lần viếng thăm tiếp theo!', 0, '2025-01-15 17:30:00', '2025-01-15 19:00:00'),

-- Final batch (81-100)
(81, 89, 6, 5, N'Buổi tối kiểu Đà Lạt đưa tôi lên cao nguyên! Không khí mát mẻ và trang trí núi hoàn hảo. Còn phục vụ chocolate nóng. Kỳ nghỉ nhỏ trong thành phố!', N'Cảm ơn đã viếng thăm Đà Lạt nhỏ của chúng tôi! Mục tiêu là mang cao nguyên đến với bạn. Núi đang gọi - bạn sẽ trả lời chứ?', 0, '2025-03-10 21:00:00', '2025-03-11 09:00:00'),
(82, 92, 7, 5, N'Buổi chiều Pure Relax đúng với tên gọi! Mọi thứ từ màu sắc trung tính đến trang trí tối giản đều khuyến khích thư giãn. Ghế massage là bổ sung tuyệt vời!', N'Cảm ơn đã tìm thấy sự thư giãn thuần túy! Vừa thêm ghế massage gần đây. Giảm căng thẳng đang chờ bạn trở lại!', 0, '2025-03-02 17:30:00', '2025-03-02 19:00:00'),
(83, 93, 8, 5, N'Buổi tối Honey Glow ấm áp và lôi cuốn! Ánh sáng hổ phách tạo không khí ấm cúng tuyệt vời. Golden hour không bao giờ kết thúc trong phòng này. Glow getter!', N'Glow getter - thích cái đó! Cảm ơn đã tắm trong ánh sáng mật ong. Sự ấm áp đang chờ lần viếng thăm tiếp theo!', 0, '2025-02-15 21:00:00', '2025-02-16 09:00:00'),
(84, 95, 9, 5, N'Nấu ăn chiều Smoke Kitchen thật tuyệt! Nấu một bữa ăn đầy đủ với hệ thống thông gió hoạt động hoàn hảo. Hệ thống hút khói nâng cấp thực sự hiệu quả. Đầu bếp approved!', N'Đánh giá Michelin! Cảm ơn đã nấu ăn cùng chúng tôi. Chúng tôi nghiêm túc với mọi góp ý. Bếp của bạn đang chờ!', 0, '2025-02-20 17:30:00', '2025-02-20 19:00:00'),
(85, 96, 10, 5, N'Buổi tối 8 Ball House là sự cạnh tranh hoàn hảo! Có giải đấu bi-a với bạn bè và setup chuyên nghiệp. Đêm ra ngoài tuyệt vời nhất mà không cần rời phòng!', N'Champions choice! Cảm ơn pool party. Bàn đã phấn và sẵn sàng cho trận tái đấu. Break!', 0, '2025-01-25 21:00:00', '2025-01-26 09:00:00'),
(86, 98, 6, 5, N'Sáng bếp Masterchef như lớp học nấu ăn! Làm bữa sáng công phu nhất từ trước đến giờ trong bếp này. Mọi thứ cần đều có sẵn. Gordon Ramsay sẽ approve!', N'Brilliant! Absolutely brilliant! (Giọng Gordon) Cảm ơn lời khen nấu ăn. Bếp đang chờ kiệt tác tiếp theo!', 0, '2025-02-28 14:00:00', '2025-02-28 16:00:00'),
(87, 99, 7, 5, N'Lặn chiều Atlantis thật kỳ diệu! Chủ đề dưới nước khiến tôi quên rằng không thực sự ở trong đại dương. Ánh sáng xanh thôi miên. Sẽ sớm lặn lại!', N'Cảm ơn đã khám phá Atlantis! Thành phố mất tích đang chờ bạn trở lại. Lặn sâu vào thư giãn cùng chúng tôi lần nữa!', 0, '2025-02-05 17:30:00', '2025-02-05 19:00:00'),
(88, 101, 8, 5, N'Buổi tối Vibe Home hoàn toàn chill! Phong cách hiện đại khớp với gu cá nhân. Mọi thứ đều click. Địa điểm yêu thích mới cho kỳ nghỉ ngắn!', N'Cảm ơn đã match vibe! Rất vui Vibe Home cộng hưởng với bạn. Vibes đang chờ bạn trở lại!', 0, '2025-03-01 21:00:00', '2025-03-02 09:00:00'),
(89, 102, 9, 5, N'Kỳ nghỉ qua đêm Wine Ball tinh tế và thanh lịch! Điểm nhấn burgundy và trang trí sang trọng khiến cảm giác như hầm rượu cao cấp. Cheers cho phòng tuyệt vời này!', N'Cheers cho bạn! Cảm ơn đánh giá tinh tế. Wine Ball là lời chúc mừng cho sự thanh lịch. Mở nắp kỳ nghỉ tiếp theo sớm!', 0, '2025-02-11 10:30:00', '2025-02-11 13:00:00'),
(90, 104, 10, 5, N'Buổi sáng Lasaoma đầy cảm hứng nghệ thuật! Trang trí sáng tạo kích thích trí tưởng tượng. Chụp rất nhiều ảnh cho portfolio. Phòng mơ ước của nhiếp ảnh gia!', N'Cảm ơn đã capture nghệ thuật! Lasaoma là canvas sáng tạo của chúng tôi. Kiệt tác tiếp theo đang chờ bạn!', 0, '2025-03-05 14:00:00', '2025-03-05 16:00:00'),
(91, 105, 6, 5, N'Chiều Doraemon với các bé là niềm vui thuần túy! Các con nhận ra mọi nhân vật và đồ vật. Cửa máy thời gian là yêu thích nhất. Giấc mơ anime thành hiện thực!', N'Cảm ơn đã du hành cùng Doraemon! Túi thần kỳ có nhiều bất ngờ hơn. Đưa gia đình quay lại sớm!', 0, '2025-02-15 17:30:00', '2025-02-15 19:00:00'),
(92, 110, 7, 5, N'Session golf tối Tiger Woods hoàn hảo! Putting green và golf simulator hoạt động trơn tru. Luyện tập trước chuyến golf thật sự. Birdie!', N'Birdie! Đánh giá golf tuyệt vời! Cảm ơn đã tập cùng chúng tôi. Giảm handicap và trở lại như nhà vô địch!', 0, '2025-03-10 21:00:00', '2025-03-11 09:00:00'),
(93, 113, 8, 5, N'Chiều Honey House ngọt ngào và ấm cúng! Ánh sáng vàng và tông ấm ấm bao bọc tôi trong sự thoải mái. Như được mật ong ôm. Kỳ nghỉ ngọt ngào nhất!', N'Ôm mật ong là tuyệt nhất! Cảm ơn những lời ngọt ngào. Tổ ong đang chờ bạn trở lại cho thêm khoảnh khắc vàng!', 0, '2025-03-12 17:30:00', '2025-03-12 19:00:00'),
(94, 116, 9, 5, N'Hồi sinh sáng Ivy Garden thật sảng khoái! Ánh sáng buổi sáng xuyên qua cây cối thật kỳ diệu. Uống cà phê bao quanh bởi cây xanh. Cách tuyệt vời để bắt đầu ngày!', N'Cảm ơn khoảnh khắc vườn buổi sáng! Chúng tôi cũng yêu những buổi sáng đầy nắng. Lá đang xào xạc chờ bạn trở lại!', 0, '2025-03-11 14:00:00', '2025-03-11 16:00:00'),
(95, 118, 10, 5, N'Buổi tối Wood Mood là sự mộc mạc hoàn hảo! Các yếu tố gỗ và kết cấu tự nhiên tạo không khí grounding. Cảm thấy kết nối với thiên nhiên. Tắm rừng trong nhà!', N'Cảm ơn đã đón nhận wood mood! Liệu pháp thiên nhiên là chuyên môn của chúng tôi. Cabin rừng đang chờ bạn trở lại!', 0, '2025-03-08 21:00:00', '2025-03-09 09:00:00'),

-- Additional feedback to make 120+ total (96-120)
(96, 36, 6, 4, N'Kỳ nghỉ qua đêm Honey Glow ấm áp nhưng hệ thống sưởi cần điều chỉnh tốt hơn. Vẫn thích không khí hổ phách. Ngủ ngon tổng thể. Sẽ quay lại với điều khiển nhiệt độ.', N'Cảm ơn phản hồi! Đã hiệu chỉnh hệ thống sưởi. Glow thoải mái trong lần viếng thăm tiếp theo!', 0, '2024-12-21 10:30:00', '2024-12-21 14:00:00'),
(97, 33, 7, 4, N'Sáng Pure Relax khá thư giãn. Tông màu trung tính êm dịu. Muốn có khăn mềm hơn. Ngoài ra là trải nghiệm tốt để thư giãn.', N'Cảm ơn phản hồi thư giãn! Đã nâng cấp lên khăn bông Ai Cập cao cấp. Thư giãn tốt hơn lần sau!', 0, '2024-12-15 14:00:00', '2024-12-15 16:00:00'),
(98, 61, 8, 5, N'Sáng phòng Ocean yên bình và đẹp. Tông xanh êm dịu vào buổi sáng sớm. Uống cà phê ngon nhất khi ngắm bình minh qua trang trí!', N'Cảm ơn khoảnh khắc bình minh! Buổi sáng Ocean thật kỳ diệu. Thủy triều mang đến thêm nhiều khoảnh khắc đẹp - quay lại nhé!', 0, '2024-10-15 14:00:00', '2024-10-15 16:00:00'),
(99, 91, 9, 5, N'Sáng Blue Vibe đúng là vibe cần thiết! Thức dậy sảng khoái và tràn đầy năng lượng. Tông xanh mát hoàn hảo cho người buổi sáng như tôi. Boost năng lượng!', N'Cảm ơn đã vibe cùng chúng tôi buổi sáng! Blue Vibe được tạo để tiếp năng lượng. Bắt vibe lần nữa sớm!', 0, '2025-03-12 14:00:00', '2025-03-12 16:00:00'),
(100, 97, 10, 5, N'Kỳ nghỉ qua đêm La Maison cảm giác như Paris! Những touch Pháp thanh lịch và tinh tế. Croissant và cà phê buổi sáng làm mọi thứ hoàn chỉnh. Ooh la la!', N'Ooh la la thật! Merci vì tình yêu Paris! La Maison chào đón bạn trở lại cho thêm khoảnh khắc Pháp!', 0, '2025-03-13 10:30:00', '2025-03-13 13:00:00'),
(101, 43, 6, 5, N'Session bi-a tối 8 Ball House đẳng cấp chuyên nghiệp! Bàn đá slate và cơ chất lượng tạo sự khác biệt. Setup sẵn sàng giải đấu. Ấn tượng!', N'Cảm ơn đánh giá cấp độ pro! Chúng tôi nghiêm túc với thiết bị bi-a. Rack, break, quay lại!', 0, '2024-08-05 21:30:00', '2024-08-06 09:00:00'),
(102, 46, 7, 5, N'Cuộc phiêu lưu chiều dưới nước Atlantis thật siêu thực! Hình chiếu đại dương và hiệu ứng âm thanh đưa tôi đi xa. Phòng theo chủ đề tuyệt nhất từ trước đến giờ!', N'Cảm ơn đã lặn sâu cùng chúng tôi! Atlantis là niềm tự hào dưới nước. Vực sâu đại dương đang chờ bạn trở lại!', 0, '2024-08-20 17:45:00', '2024-08-20 19:30:00'),
(103, 49, 8, 4, N'Sáng Wine Ball thanh lịch nhưng cần thêm tiện nghi liên quan đến rượu vang. Trang trí tinh tế. Có thể offer gói nếm rượu? Vẫn là kỳ nghỉ sang trọng!', N'Cảm ơn gợi ý sommelier! Đang hợp tác với vườn nho địa phương cho gói rượu vang. Cheers!', 0, '2024-09-05 14:15:00', '2024-09-05 16:30:00'),
(104, 52, 9, 5, N'Kỳ nghỉ qua đêm Doraemon là sự hoài niệm hoàn hảo! Mỗi chi tiết gợi lại kỷ niệm tuổi thơ. Các bảo bối bí mật quanh phòng thật vui để khám phá. Ma thuật máy thời gian!', N'Cảm ơn đã khám phá tất cả bảo bối! Doraemon có nhiều bí mật. Quay lại và tìm thêm!', 0, '2024-09-16 10:45:00', '2024-09-16 13:00:00'),
(105, 55, 10, 5, N'Cuộc phiêu lưu nấu ăn tối Cook and Chill hoàn hảo! Làm bữa ăn ba món với người yêu. Bếp có thiết bị chất lượng chuyên nghiệp. MasterChef tại nhà!', N'Cảm ơn đầu bếp! Chúng tôi trang bị bếp với những thứ tốt nhất. Cuộc phiêu lưu ẩm thực tiếp theo đang chờ!', 0, '2024-09-25 21:15:00', '2024-09-26 09:00:00'),
(106, 58, 6, 5, N'Session giảm stress chiều Ball Chill hiệu quả kỳ diệu! Ghế lười và nhạc chill đúng là những gì cần sau tuần căng thẳng. Đạt được thư giãn hoàn toàn!', N'Giảm stress thành công! Cảm ơn đã chill cùng chúng tôi. Ghế lười đang chờ bạn trở lại để thư giãn thêm!', 0, '2024-10-05 17:45:00', '2024-10-05 19:30:00'),
(107, 59, 7, 5, N'Gaming tối GameHub cạnh tranh và hào hứng! Setup multiplayer hoàn hảo cho nhóm. Có giải đấu gaming epic với bạn bè. Victory royale!', N'Victory royale thật! Cảm ơn lời khen gaming. Sẵn sàng cho giải đấu tiếp theo? Challenge accepted!', 0, '2024-12-20 21:15:00', '2024-12-21 09:00:00'),
(108, 62, 8, 5, N'Giao thừa Cine Room thật khó quên! Đếm ngược đến nửa đêm xem pháo hoa trên màn hình lớn. Hệ thống âm thanh khiến cảm giác như nổ thật. Epic!', N'Chúc mừng năm mới từ Cine Room! Thật là cách tuyệt vời để kỷ niệm. Khoảnh khắc bom tấn tiếp theo đang chờ!', 0, '2025-01-01 17:45:00', '2025-01-01 19:30:00'),
(109, 65, 9, 4, N'Sáng Wood Mood ấm cúng và mộc mạc. Yêu các yếu tố gỗ tự nhiên. Đèn đọc sách mới hoàn hảo cho việc đọc buổi sáng. Cải tiến được ghi nhận và đánh giá cao!', N'Cảm ơn đã nhận thấy cải tiến! Phản hồi của bạn thúc đẩy chúng tôi. Wood mood chào đón bạn trở lại!', 0, '2025-01-10 14:15:00', '2025-01-10 16:30:00'),
(110, 68, 10, 5, N'Kỳ nghỉ qua đêm Mellow là định nghĩa của bình yên. Thiết kế tối giản giúp làm sạch tâm trí. Ngủ liền 10 tiếng! Giấc nghỉ tuyệt vời nhất nhiều năm qua!', N'10 tiếng nghỉ ngơi thuần túy! Cảm ơn đã tìm thấy mellow của bạn. Sự bình yên đang chờ bạn trở lại!', 0, '2025-01-21 10:45:00', '2025-01-21 13:00:00'),
(111, 71, 6, 5, N'Chủ đề Squid Game căng thẳng và nhập tâm! Trang trí lính gác tím và bộ đồ xanh rất chuẩn. Sống sót tất cả trò chơi và yêu từng phút!', N'Bạn sống sót! Cảm ơn đã chơi. Game masters đang chờ thử thách tiếp theo. Let the games begin!', 0, '2025-01-30 21:15:00', '2025-01-31 09:00:00'),
(112, 74, 7, 5, N'Marathon phim chiều Cinema Zone thật tuyệt! Xem toàn bộ series Marvel. Ghế thoải mái cho 8+ tiếng. Không đau cơ! Ngày xem phim hoàn hảo!', N'Avengers tập hợp cho đánh giá này! Cảm ơn lời khen marathon. Vô hạn phim nữa đang chờ!', 0, '2025-02-10 17:45:00', '2025-02-10 19:30:00'),
(113, 77, 8, 5, N'All-nighter bi-a Zone X huyền thoại! Tôi và bạn bè chơi đến bình minh. Chất lượng bàn không bao giờ giảm. Trải nghiệm giải đấu chuyên nghiệp!', N'Đêm huyền thoại! Cảm ơn đánh giá all-star. Bàn vô địch đang chờ trận tái đấu!', 0, '2025-02-21 10:45:00', '2025-02-21 13:00:00'),
(114, 80, 9, 5, N'Hành trình vũ trụ Moon Space ngoạn mục! Hình chiếu thiên hà và sao trên trần khiến tôi cảm thấy như phi hành gia. Khám phá không gian mà không rời Trái Đất!', N'Ground control gửi khách hài lòng! Cảm ơn đã tham gia chương trình không gian. Vũ trụ đang chờ!', 0, '2025-03-01 21:15:00', '2025-03-02 09:00:00'),
(115, 83, 10, 5, N'Lướt sóng chiều Blue Wave thật sảng khoái! Âm thanh đại dương và hình chiếu sóng tạo vibes bãi biển hoàn hảo. Tắm nắng tinh thần mà không có mặt trời thật!', N'Cảm ơn bạn đã lướt sóng cùng chúng tôi! Bãi biển đang chờ bạn quay lại!', 0, '2025-03-05 17:45:00', '2025-03-05 19:30:00'),
(116, 86, 6, 5, N'Kỳ nghỉ qua đêm CGV cinema là giấc mơ của cinephiles! Xem phim kinh điển đến 4 giờ sáng với ghế thoải mái nhất. Âm thanh crystal clear. Tối thiểu 5 sao!', N'Nhà phê bình phim approved! Cảm ơn lễ kỷ niệm điện ảnh. Máy chiếu đang chờ buổi công chiếu tiếp theo!', 0, '2025-03-09 10:45:00', '2025-03-09 13:00:00'),
(117, 89, 7, 5, N'Kỳ nghỉ kiểu Đà Lạt cao nguyên hoàn hảo! Hình chiếu sương mù và nhiệt độ mát mẻ khiến tôi quên mình đang ở Cần Thơ. Phiêu lưu lên núi đạt được!', N'Chào mừng đến cao nguyên! Cảm ơn đánh giá kỳ nghỉ núi. Sương mù đang chờ bạn trở lại!', 0, '2025-03-10 21:15:00', '2025-03-11 09:00:00'),
(118, 92, 8, 5, N'Session zen chiều Pure Relax rất có tính trị liệu. Góc thiền định và âm thanh êm dịu giúp đạt được bình yên nội tâm. Namaste cho phòng tuyệt vời này!', N'Namaste! Cảm ơn đã tìm thấy bình yên nội tâm. Zen đang chờ sự trở lại tâm linh của bạn!', 0, '2025-03-02 17:45:00', '2025-03-02 19:30:00'),
(119, 95, 9, 5, N'Bữa tiệc chiều Smoke Kitchen thật ngon! Hệ thống thông gió hoạt động hoàn hảo. Làm Korean BBQ không có vấn đề khói. Thành công ẩm thực!', N'Korean BBQ thành công! Cảm ơn chiến thắng nấu ăn. Lò nướng đang nóng và sẵn sàng cho bữa ăn tiếp theo!', 0, '2025-02-20 17:45:00', '2025-02-20 19:30:00'),
(120, 98, 10, 5, N'Sáng tạo bữa sáng bếp Masterchef là kiệt tác! Làm eggs benedict từ đầu. Mọi thứ cần đều có trong bếp. Chất lượng nhà hàng tại nhà!', N'Eggs benedict từ đầu! Xuất sắc cấp độ đầu bếp được chứng nhận. Cảm ơn kiệt tác ẩm thực. Nhiều món ăn đang chờ!', 0, '2025-02-28 14:15:00', '2025-02-28 16:30:00');

SET IDENTITY_INSERT [dbo].[Feedback] OFF;
GO

-- ============================================================
-- Nhiệm vụ dọn phòng (Room cleaning and maintenance tasks)
-- Task types: CLEANING, MAINTENANCE, INSPECTION, OVERDUE_CHECKOUT
-- Task status: PENDING, IN_PROGRESS, COMPLETED, CANCELLED
-- Priority: LOW, NORMAL, HIGH, URGENT
-- ============================================================
SET IDENTITY_INSERT [dbo].[HousekeepingTask] ON;

INSERT INTO [dbo].[HousekeepingTask] ([task_id], [room_id], [booking_id], [assigned_to], [created_by], [task_type], [task_status], [priority], [notes], [created_at], [started_at], [completed_at]) VALUES
-- COMPLETED cleaning tasks (past)
(1, 1, 1, 16, 6, 'CLEANING', 'COMPLETED', 'NORMAL', N'Vệ sinh tiêu chuẩn sau khách checkout. Phòng được để trong tình trạng tốt.', '2024-03-15 13:35:00', '2024-03-15 14:00:00', '2024-03-15 14:45:00'),
(2, 2, 4, 17, 7, 'CLEANING', 'COMPLETED', 'NORMAL', N'Cần vệ sinh sâu sau kỳ nghỉ qua đêm có sử dụng bếp.', '2024-03-21 10:00:00', '2024-03-21 10:30:00', '2024-03-21 11:30:00'),
(3, 3, 7, 18, 8, 'CLEANING', 'COMPLETED', 'NORMAL', N'Vệ sinh chuyển đổi thường xuyên. Pink Paradise trong tình trạng tốt.', '2024-04-01 20:40:00', '2024-04-01 21:00:00', '2024-04-01 21:45:00'),
(4, 5, 2, 19, 9, 'CLEANING', 'COMPLETED', 'NORMAL', N'Dọn dẹp nhanh sau buổi chiều.', '2024-04-20 17:05:00', '2024-04-20 17:30:00', '2024-04-20 18:00:00'),
(5, 4, 10, 20, 10, 'CLEANING', 'COMPLETED', 'NORMAL', N'Khu vực mini golf cần chú ý nhiều hơn.', '2024-04-10 17:10:00', '2024-04-10 17:30:00', '2024-04-10 18:15:00'),
(6, 6, 13, 21, 6, 'CLEANING', 'COMPLETED', 'HIGH', N'Cần vệ sinh thiết bị gaming sau buổi chơi.', '2024-04-25 13:40:00', '2024-04-25 14:00:00', '2024-04-25 15:00:00'),
(7, 7, 16, 22, 7, 'CLEANING', 'COMPLETED', 'NORMAL', N'Dọn dẹp sau kỳ nghỉ qua đêm. Mọi thứ đều ổn.', '2024-05-02 10:00:00', '2024-05-02 10:30:00', '2024-05-02 11:15:00'),
(8, 8, 5, 23, 8, 'CLEANING', 'COMPLETED', 'NORMAL', N'Dọn dẹp tiêu chuẩn buổi sáng sau buổi.', '2024-05-05 13:40:00', '2024-05-05 14:00:00', '2024-05-05 14:40:00'),
(9, 11, 19, 24, 9, 'CLEANING', 'COMPLETED', 'NORMAL', N'Phòng Bea Bear đã dọn. Thú nhồi bông được sắp xếp.', '2024-05-15 20:40:00', '2024-05-15 21:00:00', '2024-05-15 21:45:00'),
(10, 12, 8, 25, 10, 'CLEANING', 'COMPLETED', 'NORMAL', N'Hoàn thành dọn dẹp sau kỳ nghỉ qua đêm Wood Mood.', '2024-05-26 10:00:00', '2024-05-26 10:30:00', '2024-05-26 11:30:00'),

-- MAINTENANCE tasks (completed)
(11, 9, NULL, 22, 1, 'MAINTENANCE', 'COMPLETED', 'HIGH', N'Cần thay bóng đèn máy chiếu. Kiểm tra hệ thống âm thanh.', '2024-06-01 09:00:00', '2024-06-01 10:00:00', '2024-06-01 12:00:00'),
(12, 14, NULL, 22, 2, 'MAINTENANCE', 'COMPLETED', 'NORMAL', N'Hiệu chỉnh hệ thống loa và điều chỉnh bass.', '2024-06-15 08:00:00', '2024-06-15 09:00:00', '2024-06-15 11:00:00'),
(13, 22, NULL, 22, 3, 'MAINTENANCE', 'COMPLETED', 'HIGH', N'Bảo trì PC gaming - vệ sinh quạt và keo tản nhiệt.', '2024-07-01 07:30:00', '2024-07-01 08:00:00', '2024-07-01 11:00:00'),
(14, 43, NULL, 22, 4, 'MAINTENANCE', 'COMPLETED', 'NORMAL', N'Thay nỉ bàn bi-a và cân bằng.', '2024-07-15 08:00:00', '2024-07-15 09:00:00', '2024-07-15 14:00:00'),
(15, 27, NULL, 22, 5, 'MAINTENANCE', 'COMPLETED', 'URGENT', N'Hệ thống chiếu trần bị lỗi - sửa chữa khẩn cấp.', '2024-08-01 10:00:00', '2024-08-01 10:30:00', '2024-08-01 15:00:00'),

-- More COMPLETED cleaning tasks (recent)
(16, 38, 91, 16, 6, 'CLEANING', 'COMPLETED', 'NORMAL', N'Dọn dẹp sau checkout buổi sáng Blue Vibe.', '2025-03-12 13:40:00', '2025-03-12 14:00:00', '2025-03-12 14:45:00'),
(17, 44, 97, 17, 7, 'CLEANING', 'COMPLETED', 'NORMAL', N'Vệ sinh chuyển đổi sau kỳ nghỉ qua đêm La Maison.', '2025-03-13 10:00:00', '2025-03-13 10:30:00', '2025-03-13 11:30:00'),
(18, 4, 110, 18, 8, 'CLEANING', 'COMPLETED', 'NORMAL', N'Tiger Woods dọn dẹp tối sau buổi.', '2025-03-10 20:40:00', '2025-03-10 21:00:00', '2025-03-10 21:45:00'),
(19, 7, 113, 19, 9, 'CLEANING', 'COMPLETED', 'NORMAL', N'Honey House dọn dẹp chiều sau buổi.', '2025-03-12 17:05:00', '2025-03-12 17:30:00', '2025-03-12 18:15:00'),
(20, 10, 116, 20, 10, 'CLEANING', 'COMPLETED', 'NORMAL', N'Ivy Garden dọn dẹp sáng sau buổi.', '2025-03-11 13:35:00', '2025-03-11 14:00:00', '2025-03-11 14:45:00'),

-- IN_PROGRESS cleaning tasks (current)
(21, 22, 75, 16, 6, 'CLEANING', 'PENDING', 'NORMAL', N'Phòng Solo Gaming sẽ cần dọn sau khi khách hiện tại checkout.', '2025-03-13 17:00:00', NULL, NULL),
(22, 41, 94, 17, 7, 'CLEANING', 'PENDING', 'NORMAL', N'Phòng CGV đang chờ dọn dẹp sau khách checkout.', '2025-03-13 10:00:00', NULL, NULL),
(23, 47, 100, 18, 8, 'CLEANING', 'PENDING', 'NORMAL', N'Phòng Forest đang chờ dọn dẹp.', '2025-03-13 14:00:00', NULL, NULL),
(24, 50, 103, 19, 9, 'CLEANING', 'PENDING', 'NORMAL', N'Phòng Video Game đang chờ bàn giao.', '2025-03-13 17:00:00', NULL, NULL),
(25, 13, 119, 20, 10, 'CLEANING', 'PENDING', 'NORMAL', N'Calm Cloud qua đêm đang chờ dọn dẹp sau checkout.', '2025-03-13 21:00:00', NULL, NULL),
(26, 15, 121, 21, 6, 'CLEANING', 'PENDING', 'NORMAL', N'Phòng Mellow buổi sáng đang chờ.', '2025-03-13 10:00:00', NULL, NULL),

-- PENDING housekeeping tasks (upcoming bookings)
(27, 25, 78, NULL, 7, 'CLEANING', 'PENDING', 'NORMAL', N'Mykonos chuẩn bị phòng cho booking ngày mai.', '2025-03-13 15:00:00', NULL, NULL),
(28, 2, 108, NULL, 8, 'CLEANING', 'PENDING', 'NORMAL', N'Cook and Chill chuẩn bị cho khách sắp đến.', '2025-03-14 08:00:00', NULL, NULL),
(29, 28, 81, NULL, 9, 'CLEANING', 'PENDING', 'NORMAL', N'Cheese chuẩn bị phòng cho booking đêm.', '2025-03-15 18:00:00', NULL, NULL),

-- INSPECTION tasks
(30, 1, NULL, 21, 1, 'INSPECTION', 'COMPLETED', 'NORMAL', N'Kiểm tra chất lượng hàng tháng - đạt tất cả tiêu chuẩn.', '2025-03-01 09:00:00', '2025-03-01 09:30:00', '2025-03-01 10:30:00'),
(31, 10, NULL, 21, 2, 'INSPECTION', 'COMPLETED', 'NORMAL', N'Kiểm tra bảo trì hàng quý. Ghi nhận sửa chữa nhỏ.', '2025-03-05 08:00:00', '2025-03-05 08:30:00', '2025-03-05 10:00:00'),
(32, 20, NULL, 21, 3, 'INSPECTION', 'COMPLETED', 'HIGH', N'Kiểm tra bàn bi-a - tình trạng tốt.', '2025-03-08 07:30:00', '2025-03-08 08:00:00', '2025-03-08 09:00:00'),

-- Current MAINTENANCE tasks
(33, 52, NULL, 22, 4, 'MAINTENANCE', 'IN_PROGRESS', 'NORMAL', N'Phòng Doraemon - đồ trang trí cần sửa chữa.', '2025-03-12 09:00:00', '2025-03-12 10:00:00', NULL),
(34, 18, NULL, 22, 5, 'MAINTENANCE', 'PENDING', 'HIGH', N'Phòng Squid Game - một số đạo cụ cần thay thế sau khi sử dụng.', '2025-03-13 08:00:00', NULL, NULL),

-- OVERDUE_CHECKOUT tasks (past examples)
(35, 30, 30, 16, 6, 'OVERDUE_CHECKOUT', 'COMPLETED', 'URGENT', N'Khách ở quá giờ 30 phút. Đã liên hệ và giải quyết.', '2024-12-01 17:10:00', '2024-12-01 17:15:00', '2024-12-01 17:30:00'),
(36, 45, 45, 17, 7, 'OVERDUE_CHECKOUT', 'COMPLETED', 'HIGH', N'Khách checkout trễ. Đã xử lý tính phí bổ sung.', '2025-01-25 13:45:00', '2025-01-25 13:50:00', '2025-01-25 14:15:00');

SET IDENTITY_INSERT [dbo].[HousekeepingTask] OFF;
GO

-- ============================================================
-- Danh sách công việc (Cleaning checklist items for housekeeping tasks)
-- ============================================================
SET IDENTITY_INSERT [dbo].[TaskChecklist] ON;

INSERT INTO [dbo].[TaskChecklist] ([checklist_id], [task_id], [item_name], [is_completed], [completed_at]) VALUES
-- Task 1 checklist (Completed)
(1, 1, N'Thay ga trải giường và vỏ gối', 1, '2024-03-15 14:10:00'),
(2, 1, N'Vệ sinh toilet và thay đồ dùng vệ sinh', 1, '2024-03-15 14:20:00'),
(3, 1, N'Hút bụi thảm và lau sàn', 1, '2024-03-15 14:30:00'),
(4, 1, N'Lau chùi các bề mặt và nội thất', 1, '2024-03-15 14:35:00'),
(5, 1, N'Bổ sung minibar và tiện nghi', 1, '2024-03-15 14:40:00'),
(6, 1, N'Đổ thùng rác và thay túi', 1, '2024-03-15 14:42:00'),
(7, 1, N'Kiểm tra điều hòa và đèn', 1, '2024-03-15 14:45:00'),

-- Task 2 checklist (Completed - kitchen room)
(8, 2, N'Vệ sinh sâu thiết bị bếp', 1, '2024-03-21 10:45:00'),
(9, 2, N'Khử trùng mặt bàn và bề mặt nấu', 1, '2024-03-21 10:55:00'),
(10, 2, N'Rửa và cất bát đĩa và dụng cụ', 1, '2024-03-21 11:00:00'),
(11, 2, N'Thay ga trải giường và vỏ gối', 1, '2024-03-21 11:10:00'),
(12, 2, N'Vệ sinh toilet và thay đồ dùng vệ sinh', 1, '2024-03-21 11:20:00'),
(13, 2, N'Hút bụi và lau tất cả sàn', 1, '2024-03-21 11:25:00'),
(14, 2, N'Đổ thùng rác và thay túi', 1, '2024-03-21 11:30:00'),

-- Task 6 checklist (Completed - gaming room)
(15, 6, N'Khử trùng tay cầm và thiết bị gaming', 1, '2024-04-25 14:15:00'),
(16, 6, N'Vệ sinh màn hình gaming', 1, '2024-04-25 14:25:00'),
(17, 6, N'Lau bụi console và PC gaming', 1, '2024-04-25 14:35:00'),
(18, 6, N'Thay ga trải giường và vỏ gối', 1, '2024-04-25 14:45:00'),
(19, 6, N'Vệ sinh toilet kỹ lưỡng', 1, '2024-04-25 14:50:00'),
(20, 6, N'Hút bụi thảm và sắp xếp khu vực gaming', 1, '2024-04-25 14:55:00'),
(21, 6, N'Bổ sung snack và đồ uống', 1, '2024-04-25 15:00:00'),

-- Task 11 checklist (Maintenance - completed)
(22, 11, N'Lắp bóng đèn máy chiếu mới', 1, '2024-06-01 10:30:00'),
(23, 11, N'Kiểm tra output máy chiếu và hiệu chỉnh', 1, '2024-06-01 11:00:00'),
(24, 11, N'Kiểm tra kết nối hệ thống âm thanh', 1, '2024-06-01 11:30:00'),
(25, 11, N'Kiểm tra loa vòm', 1, '2024-06-01 11:45:00'),
(26, 11, N'Ghi chép bảo trì vào sổ', 1, '2024-06-01 12:00:00'),

-- Task 16 checklist (Recent completed)
(27, 16, N'Thay ga trải giường và vỏ gối', 1, '2025-03-12 14:10:00'),
(28, 16, N'Vệ sinh toilet và thay đồ dùng vệ sinh', 1, '2025-03-12 14:20:00'),
(29, 16, N'Hút bụi thảm và lau sàn', 1, '2025-03-12 14:30:00'),
(30, 16, N'Lau chùi tất cả bề mặt', 1, '2025-03-12 14:40:00'),
(31, 16, N'Bổ sung tiện nghi', 1, '2025-03-12 14:45:00'),

-- Task 21 checklist (Pending - Solo Gaming)
(32, 21, N'Khử trùng tay cầm và thiết bị gaming', 0, NULL),
(33, 21, N'Vệ sinh màn hình gaming', 0, NULL),
(34, 21, N'Thay ga trải giường và vỏ gối', 0, NULL),
(35, 21, N'Vệ sinh toilet và thay đồ dùng vệ sinh', 0, NULL),
(36, 21, N'Hút bụi thảm và sắp xếp khu vực gaming', 0, NULL),
(37, 21, N'Bổ sung snack và đồ uống', 0, NULL),

-- Task 22 checklist (Pending - CGV Room)
(38, 22, N'Vệ sinh màn chiếu', 0, NULL),
(39, 22, N'Khử trùng ghế ngả', 0, NULL),
(40, 22, N'Thay ga trải giường và vỏ gối', 0, NULL),
(41, 22, N'Vệ sinh toilet và thay đồ dùng vệ sinh', 0, NULL),
(42, 22, N'Hút bụi thảm kỹ lưỡng', 0, NULL),
(43, 22, N'Bổ sung snack và đồ uống', 0, NULL),

-- Task 30 checklist (Inspection completed)
(44, 30, N'Kiểm tra tất cả thiết bị điện', 1, '2025-03-01 09:45:00'),
(45, 30, N'Kiểm tra ống nước rò rỉ', 1, '2025-03-01 10:00:00'),
(46, 30, N'Kiểm tra hệ thống điều hòa', 1, '2025-03-01 10:10:00'),
(47, 30, N'Kiểm tra nội thất hư hỏng', 1, '2025-03-01 10:20:00'),
(48, 30, N'Xác minh thiết bị an toàn (bình chữa cháy)', 1, '2025-03-01 10:25:00'),
(49, 30, N'Ghi chép kết quả kiểm tra', 1, '2025-03-01 10:30:00'),

-- Task 33 checklist (In Progress - Maintenance)
(50, 33, N'Xác định trang trí bảo bối hư hỏng', 1, '2025-03-12 10:15:00'),
(51, 33, N'Đặt hàng linh kiện thay thế', 1, '2025-03-12 10:30:00'),
(52, 33, N'Tháo gỡ vật dụng hư hỏng an toàn', 1, '2025-03-12 11:00:00'),
(53, 33, N'Lắp đặt trang trí thay thế', 0, NULL),
(54, 33, N'Kiểm tra tất cả yếu tố tương tác', 0, NULL),
(55, 33, N'Kiểm tra chất lượng cuối cùng', 0, NULL);

SET IDENTITY_INSERT [dbo].[TaskChecklist] OFF;
GO

-- ============================================================
-- Lịch sử trạng thái phòng (Audit trail for room status changes)
-- ============================================================
SET IDENTITY_INSERT [dbo].[RoomStatusLog] ON;

INSERT INTO [dbo].[RoomStatusLog] ([log_id], [room_id], [previous_status], [new_status], [changed_by], [change_reason], [booking_id], [created_at]) VALUES
-- Historical status changes (samples)
(1, 1, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20240315001 đã xác nhận và thanh toán', 1, '2024-03-14 15:30:00'),
(2, 1, 'BOOKED', 'OCCUPIED', 6, N'Khách đã check-in - booking BK20240315001', 1, '2024-03-15 10:35:00'),
(3, 1, 'OCCUPIED', 'DIRTY', NULL, N'Khách đã checkout - booking BK20240315001', 1, '2024-03-15 13:30:00'),
(4, 1, 'DIRTY', 'CLEANING', 16, N'Dọn phòng bắt đầu vệ sinh', 1, '2024-03-15 14:00:00'),
(5, 1, 'CLEANING', 'AVAILABLE', 16, N'Hoàn thành dọn dẹp - phòng sẵn sàng', 1, '2024-03-15 14:45:00'),

(6, 2, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20240320001 đã xác nhận', 4, '2024-03-19 16:30:00'),
(7, 2, 'BOOKED', 'OCCUPIED', 7, N'Khách đã check-in cho kỳ nghỉ qua đêm', 4, '2024-03-20 21:10:00'),
(8, 2, 'OCCUPIED', 'DIRTY', NULL, N'Khách checkout hoàn thành', 4, '2024-03-21 09:50:00'),
(9, 2, 'DIRTY', 'CLEANING', 17, N'Bắt đầu vệ sinh sâu bếp', 4, '2024-03-21 10:30:00'),
(10, 2, 'CLEANING', 'AVAILABLE', 17, N'Hoàn thành vệ sinh sâu', 4, '2024-03-21 11:30:00'),

-- Maintenance workflow example
(11, 9, 'AVAILABLE', 'MAINTENANCE', 1, N'Bảo trì máy chiếu theo lịch', NULL, '2024-06-01 09:00:00'),
(12, 9, 'MAINTENANCE', 'AVAILABLE', 22, N'Đã thay bóng đèn máy chiếu và kiểm tra hệ thống', NULL, '2024-06-01 12:00:00'),

(13, 27, 'AVAILABLE', 'MAINTENANCE', 5, N'Sửa chữa khẩn cấp hệ thống máy chiếu trần', NULL, '2024-08-01 10:00:00'),
(14, 27, 'MAINTENANCE', 'AVAILABLE', 22, N'Hệ thống máy chiếu đã sửa và hiệu chỉnh', NULL, '2024-08-01 15:00:00'),

-- Recent status changes (March 2025)
(15, 22, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20250313001 confirmed', 75, '2025-03-12 15:30:00'),
(16, 22, 'BOOKED', 'OCCUPIED', 8, N'Khách đã check-in - Solo Gaming evening', 75, '2025-03-13 17:35:00'),

(17, 41, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20250313002 confirmed', 94, '2025-03-12 09:30:00'),
(18, 41, 'BOOKED', 'OCCUPIED', 9, N'Khách đã check-in - CGV Room morning', 94, '2025-03-13 10:30:00'),

(19, 47, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20250313003 confirmed', 100, '2025-03-12 14:30:00'),
(20, 47, 'BOOKED', 'OCCUPIED', 10, N'Khách đã check-in - Forest afternoon', 100, '2025-03-13 14:00:00'),

(21, 50, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20250313004 confirmed', 103, '2025-03-12 12:30:00'),
(22, 50, 'BOOKED', 'OCCUPIED', 6, N'Khách đã check-in - Video Game evening', 103, '2025-03-13 17:30:00'),

(23, 13, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20250313005 confirmed', 119, '2025-03-12 16:30:00'),
(24, 13, 'BOOKED', 'OCCUPIED', 7, N'Khách đã check-in - Calm Cloud overnight', 119, '2025-03-13 21:00:00'),

(25, 15, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20250313006 confirmed', 121, '2025-03-12 11:30:00'),
(26, 15, 'BOOKED', 'OCCUPIED', 8, N'Khách đã check-in - Mellow morning', 121, '2025-03-13 10:30:00'),

-- Checked out rooms today
(27, 38, 'BOOKED', 'OCCUPIED', 6, N'Khách đã check-in - Blue Vibe morning', 91, '2025-03-12 10:35:00'),
(28, 38, 'OCCUPIED', 'DIRTY', NULL, N'Khách đã checkout', 91, '2025-03-12 13:35:00'),
(29, 38, 'DIRTY', 'CLEANING', 16, N'Dọn phòng bắt đầu', 91, '2025-03-12 14:00:00'),
(30, 38, 'CLEANING', 'AVAILABLE', 16, N'Phòng đã được dọn và sẵn sàng', 91, '2025-03-12 14:45:00'),

(31, 44, 'BOOKED', 'OCCUPIED', 7, N'Khách đã check-in - La Maison overnight', 97, '2025-03-12 21:00:00'),
(32, 44, 'OCCUPIED', 'DIRTY', NULL, N'Khách đã checkout', 97, '2025-03-13 09:55:00'),
(33, 44, 'DIRTY', 'CLEANING', 17, N'Dọn phòng bắt đầu', 97, '2025-03-13 10:30:00'),
(34, 44, 'CLEANING', 'AVAILABLE', 17, N'Phòng đã được dọn và sẵn sàng', 97, '2025-03-13 11:30:00'),

-- Out of service example
(35, 52, 'AVAILABLE', 'OUT_OF_SERVICE', 1, N'Phòng tạm ngừng hoạt động để sửa chữa trang trí', NULL, '2025-03-12 08:00:00'),
(36, 52, 'OUT_OF_SERVICE', 'MAINTENANCE', 4, N'Bắt đầu công việc bảo trì trên trang trí', NULL, '2025-03-12 09:00:00'),

-- Future booking status
(37, 25, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20250314001 đã xác nhận cho ngày mai', 78, '2025-03-13 10:30:00'),
(38, 2, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20250315002 confirmed', 108, '2025-03-13 10:30:00'),
(39, 28, 'AVAILABLE', 'BOOKED', NULL, N'Booking BK20250315001 đã xác nhận cho khung đêm', 81, '2025-03-13 16:30:00');

SET IDENTITY_INSERT [dbo].[RoomStatusLog] OFF;
GO

-- ============================================================
-- UPDATE Room Statuses to reflect current state
-- (Rooms with current guests should be OCCUPIED, etc.)
-- ============================================================

-- Set rooms with current CHECKED_IN bookings to OCCUPIED
UPDATE [dbo].[Room] SET [status] = 'OCCUPIED' WHERE [room_id] = 22; -- Solo Gaming (booking 75)
UPDATE [dbo].[Room] SET [status] = 'OCCUPIED' WHERE [room_id] = 41; -- CGV Room (booking 94)
UPDATE [dbo].[Room] SET [status] = 'OCCUPIED' WHERE [room_id] = 47; -- Forest (booking 100)
UPDATE [dbo].[Room] SET [status] = 'OCCUPIED' WHERE [room_id] = 50; -- Video Game (booking 103)
UPDATE [dbo].[Room] SET [status] = 'OCCUPIED' WHERE [room_id] = 13; -- Calm Cloud (booking 119)
UPDATE [dbo].[Room] SET [status] = 'OCCUPIED' WHERE [room_id] = 15; -- Mellow (booking 121)

-- Set rooms with upcoming PAID bookings to BOOKED
UPDATE [dbo].[Room] SET [status] = 'BOOKED' WHERE [room_id] = 25; -- Mykonos (booking 78)
UPDATE [dbo].[Room] SET [status] = 'BOOKED' WHERE [room_id] = 28; -- Cheese (booking 81)
UPDATE [dbo].[Room] SET [status] = 'BOOKED' WHERE [room_id] = 2; -- Cook and Chill (booking 108)
UPDATE [dbo].[Room] SET [status] = 'BOOKED' WHERE [room_id] = 11; -- Bea Bear (booking 117)
UPDATE [dbo].[Room] SET [status] = 'BOOKED' WHERE [room_id] = 16; -- Lion King (booking 122)
UPDATE [dbo].[Room] SET [status] = 'BOOKED' WHERE [room_id] = 17; -- Love Blaze (booking 123)
UPDATE [dbo].[Room] SET [status] = 'BOOKED' WHERE [room_id] = 18; -- Squid Game (booking 124)

-- Set room under maintenance
UPDATE [dbo].[Room] SET [status] = 'MAINTENANCE' WHERE [room_id] = 52; -- Doraemon (đang bảo trì)

-- Set a room as out of service for variety
UPDATE [dbo].[Room] SET [status] = 'OUT_OF_SERVICE' WHERE [room_id] = 53; -- Game Room PS4 (bảo trì theo lịch)

-- Set a dirty room (recent checkout đang chờ dọn dẹp)
UPDATE [dbo].[Room] SET [status] = 'DIRTY' WHERE [room_id] = 19; -- Lavender (mới checkout)

-- Set a room currently being cleaned
UPDATE [dbo].[Room] SET [status] = 'CLEANING' WHERE [room_id] = 12; -- Wood Mood (đang dọn dẹp)

GO

-- ============================================================
-- End of BookNow Full Dataset
-- Total Records Generated:
-- - Timetable: 4 slots
-- - Customer: 40 users
-- - StaffAccounts: 25 users (5 Admin, 10 Staff, 10 Housekeeping)
-- - Booking: 125 bookings
-- - Scheduler: 120 schedule records
-- - Payment: 125 payments
-- - Invoice: 98 invoices
-- - CheckInSession: 30 sessions
-- - Feedback: 120 feedback with staff replies
-- - HousekeepingTask: 36 tasks
-- - TaskChecklist: 55 checklist items
-- - RoomStatusLog: 39 status log entries
-- ============================================================



