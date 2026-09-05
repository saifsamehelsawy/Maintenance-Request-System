


USE [master];
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MaintenanceRequestDB')
BEGIN
    CREATE DATABASE [MaintenanceRequestDB];
END
GO
USE [MaintenanceRequestDB];
GO


IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [AspNetRoles] (
        [Id] nvarchar(450) NOT NULL,
        [Name] nvarchar(256) NULL,
        [NormalizedName] nvarchar(256) NULL,
        [ConcurrencyStamp] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [AspNetUsers] (
        [Id] nvarchar(450) NOT NULL,
        [FullName] nvarchar(max) NOT NULL,
        [Department] nvarchar(max) NULL,
        [IsActive] bit NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        [LastLoginAt] datetime2 NULL,
        [UserName] nvarchar(256) NULL,
        [NormalizedUserName] nvarchar(256) NULL,
        [Email] nvarchar(256) NULL,
        [NormalizedEmail] nvarchar(256) NULL,
        [EmailConfirmed] bit NOT NULL,
        [PasswordHash] nvarchar(max) NULL,
        [SecurityStamp] nvarchar(max) NULL,
        [ConcurrencyStamp] nvarchar(max) NULL,
        [PhoneNumber] nvarchar(max) NULL,
        [PhoneNumberConfirmed] bit NOT NULL,
        [TwoFactorEnabled] bit NOT NULL,
        [LockoutEnd] datetimeoffset NULL,
        [LockoutEnabled] bit NOT NULL,
        [AccessFailedCount] int NOT NULL,
        CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [Categories] (
        [Id] int NOT NULL IDENTITY,
        [Name] nvarchar(100) NOT NULL,
        [Description] nvarchar(500) NULL,
        [IsActive] bit NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        CONSTRAINT [PK_Categories] PRIMARY KEY ([Id])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [AspNetRoleClaims] (
        [Id] int NOT NULL IDENTITY,
        [RoleId] nvarchar(450) NOT NULL,
        [ClaimType] nvarchar(max) NULL,
        [ClaimValue] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [AspNetUserClaims] (
        [Id] int NOT NULL IDENTITY,
        [UserId] nvarchar(450) NOT NULL,
        [ClaimType] nvarchar(max) NULL,
        [ClaimValue] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [AspNetUserLogins] (
        [LoginProvider] nvarchar(450) NOT NULL,
        [ProviderKey] nvarchar(450) NOT NULL,
        [ProviderDisplayName] nvarchar(max) NULL,
        [UserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
        CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [AspNetUserRoles] (
        [UserId] nvarchar(450) NOT NULL,
        [RoleId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
        CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [AspNetUserTokens] (
        [UserId] nvarchar(450) NOT NULL,
        [LoginProvider] nvarchar(450) NOT NULL,
        [Name] nvarchar(450) NOT NULL,
        [Value] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
        CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [MaintenanceRequests] (
        [Id] int NOT NULL IDENTITY,
        [RequestNumber] nvarchar(20) NOT NULL,
        [Title] nvarchar(150) NOT NULL,
        [Description] nvarchar(2000) NOT NULL,
        [Status] nvarchar(450) NOT NULL,
        [Priority] nvarchar(max) NOT NULL,
        [ResolutionNotes] nvarchar(2000) NULL,
        [CreatedAt] datetime2 NOT NULL,
        [UpdatedAt] datetime2 NOT NULL,
        [ResolvedAt] datetime2 NULL,
        [ClosedAt] datetime2 NULL,
        [IsDeleted] bit NOT NULL,
        [DeletedAt] datetime2 NULL,
        [CategoryId] int NOT NULL,
        [EmployeeId] nvarchar(450) NOT NULL,
        [TechnicianId] nvarchar(450) NULL,
        CONSTRAINT [PK_MaintenanceRequests] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_MaintenanceRequests_AspNetUsers_EmployeeId] FOREIGN KEY ([EmployeeId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_MaintenanceRequests_AspNetUsers_TechnicianId] FOREIGN KEY ([TechnicianId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_MaintenanceRequests_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [RequestComments] (
        [Id] int NOT NULL IDENTITY,
        [CommentText] nvarchar(1000) NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        [RequestId] int NOT NULL,
        [UserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_RequestComments] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_RequestComments_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION,
        CONSTRAINT [FK_RequestComments_MaintenanceRequests_RequestId] FOREIGN KEY ([RequestId]) REFERENCES [MaintenanceRequests] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE TABLE [RequestHistories] (
        [Id] int NOT NULL IDENTITY,
        [Action] nvarchar(max) NOT NULL,
        [Description] nvarchar(500) NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        [RequestId] int NOT NULL,
        [UserId] nvarchar(450) NULL,
        CONSTRAINT [PK_RequestHistories] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_RequestHistories_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE SET NULL,
        CONSTRAINT [FK_RequestHistories_MaintenanceRequests_RequestId] FOREIGN KEY ([RequestId]) REFERENCES [MaintenanceRequests] ([Id]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CreatedAt', N'Description', N'IsActive', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] ON;
    EXEC(N'INSERT INTO [Categories] ([Id], [CreatedAt], [Description], [IsActive], [Name])
    VALUES (1, ''2025-01-01T00:00:00.0000000Z'', N''Electrical systems and wiring issues'', CAST(1 AS bit), N''Electrical''),
    (2, ''2025-01-01T00:00:00.0000000Z'', N''Water and drainage issues'', CAST(1 AS bit), N''Plumbing''),
    (3, ''2025-01-01T00:00:00.0000000Z'', N''Heating, ventilation, and air conditioning'', CAST(1 AS bit), N''HVAC''),
    (4, ''2025-01-01T00:00:00.0000000Z'', N''Computers, printers, and network equipment'', CAST(1 AS bit), N''IT Equipment''),
    (5, ''2025-01-01T00:00:00.0000000Z'', N''Furniture repair and replacement'', CAST(1 AS bit), N''Furniture'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CreatedAt', N'Description', N'IsActive', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] OFF;
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL');
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_MaintenanceRequests_CategoryId] ON [MaintenanceRequests] ([CategoryId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_MaintenanceRequests_EmployeeId] ON [MaintenanceRequests] ([EmployeeId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_MaintenanceRequests_IsDeleted_Status] ON [MaintenanceRequests] ([IsDeleted], [Status]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE UNIQUE INDEX [IX_MaintenanceRequests_RequestNumber] ON [MaintenanceRequests] ([RequestNumber]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_MaintenanceRequests_TechnicianId] ON [MaintenanceRequests] ([TechnicianId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_RequestComments_RequestId] ON [RequestComments] ([RequestId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_RequestComments_UserId] ON [RequestComments] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_RequestHistories_RequestId] ON [RequestHistories] ([RequestId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    CREATE INDEX [IX_RequestHistories_UserId] ON [RequestHistories] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260905071508_Initial'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260905071508_Initial', N'10.0.0');
END;

COMMIT;
GO


GO


INSERT INTO [AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (N'88e31399-38ee-429b-8b9f-825cb4c4d63a', N'Admin', N'ADMIN', N'c58a5c1d-0281-4e2e-8bc5-be12f251afb3');
INSERT INTO [AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (N'b61d2b1e-fa18-4319-b55e-c5608eb5889a', N'Employee', N'EMPLOYEE', N'f204305e-897e-4c3e-b827-ff8c2eeaf2f9');
INSERT INTO [AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (N'ccf0a756-e8af-49d8-89e5-8bd0d1c49caf', N'Technician', N'TECHNICIAN', N'875bec8f-bacd-44d0-8465-10f87441ebd6');
GO


INSERT INTO [AspNetUsers] ([Id], [FullName], [Department], [IsActive], [CreatedAt], [LastLoginAt], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (N'034d8d40-b765-4b2a-9ff1-f668bc12e6d2', N'System Administrator', N'IT', 1, N'2026-09-05 08:17:13.188', N'2026-09-05 09:26:35.343', N'admin@maintenance.com', N'ADMIN@MAINTENANCE.COM', N'admin@maintenance.com', N'ADMIN@MAINTENANCE.COM', 1, N'AQAAAAIAAYagAAAAEJDGm542sTZb1Wug+GpMyl4t9IakHE/VxXIVgFYWxaQKhlDSGqeemPwrErHnuRdk6w==', N'Y2FHYJWUDKIOPZX24NSVQLG6TP372AW3', N'2fdbf393-0d7f-4881-9f0c-5898ebb6acac', NULL, 0, 0, NULL, 1, 0);
INSERT INTO [AspNetUsers] ([Id], [FullName], [Department], [IsActive], [CreatedAt], [LastLoginAt], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (N'227ae5fa-b6e6-469b-9110-274b36e79134', N'Saif Sameh', N'HR', 1, N'2026-09-05 08:17:14.149', N'2026-09-05 09:28:03.157', N'emp@maintenance.com', N'EMP@MAINTENANCE.COM', N'emp@maintenance.com', N'EMP@MAINTENANCE.COM', 1, N'AQAAAAIAAYagAAAAECCq+NSamyXI+Syi/XDRgGnf68niS65gbFHFsp8+I34wVbcmWgj1BFyjwoMhF5zw7A==', N'VFJZX7OH4EVPPVC2XPZYVAH7PMAQ67RD', N'eae0279a-5d6e-4fd3-a5c9-437120f538ae', N'010 96263228', 0, 0, NULL, 1, 0);
INSERT INTO [AspNetUsers] ([Id], [FullName], [Department], [IsActive], [CreatedAt], [LastLoginAt], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (N'6b0eb0a5-5b6f-4e4f-b356-8e8272e38e4f', N'Mazen Baza', N'Maintenance', 1, N'2026-09-05 09:26:13.426', NULL, N'mazen238@maintenance.com', N'MAZEN238@MAINTENANCE.COM', N'mazen238@maintenance.com', N'MAZEN238@MAINTENANCE.COM', 0, N'AQAAAAIAAYagAAAAEA9l5yZo6TMLmsBGCa5EhOcf1EDkysMR5HSEQuS411Zi6qzCbXKxCbV6+ODfTqpSLg==', N'J33ZOAQIUWMXADYDFGIO3VHSMOS7F5P7', N'b4d830e4-fcf9-4adc-9651-9a88a1220a0c', NULL, 0, 0, NULL, 1, 0);
INSERT INTO [AspNetUsers] ([Id], [FullName], [Department], [IsActive], [CreatedAt], [LastLoginAt], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (N'8d9c953a-b7b4-4ff0-b8a0-fe942109b196', N'Abdallah Waleed Kamal', N'Maintenance', 1, N'2026-09-05 08:17:13.902', N'2026-09-05 09:17:21.513', N'tech@maintenance.com', N'TECH@MAINTENANCE.COM', N'tech@maintenance.com', N'TECH@MAINTENANCE.COM', 1, N'AQAAAAIAAYagAAAAECv9BoOtGhY9aulKET+e0vE6UZPS7pIJ915P2hCSPxmVeRpA8VuOM6fmP0no0e7Q3w==', N'YLZJC5DO253JOC2AD3RYOSDZWA25UCNT', N'8fb061ad-4cb6-424e-9445-e304e3cd82aa', N'01005831772', 0, 0, NULL, 1, 0);
INSERT INTO [AspNetUsers] ([Id], [FullName], [Department], [IsActive], [CreatedAt], [LastLoginAt], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (N'b5aade59-8427-46f8-aa17-cd4a3c2abc5b', N'Amina Essam', N'Maintenance', 1, N'2026-09-05 09:24:22.007', NULL, N'amina123@maintenance.com', N'AMINA123@MAINTENANCE.COM', N'amina123@maintenance.com', N'AMINA123@MAINTENANCE.COM', 0, N'AQAAAAIAAYagAAAAEHcyOZw+3fDC48oUAcnOIxK/vvBG0qPkOPs6Ov0LeByKuHL2p2Uhgk0XYU2f2dlW1w==', N'TZ7NZROKAFJZH6ILSA3P43C4SCC6HUG4', N'b9a62cce-cb8b-4f15-80f8-467ea5a1be25', NULL, 0, 0, NULL, 1, 0);
INSERT INTO [AspNetUsers] ([Id], [FullName], [Department], [IsActive], [CreatedAt], [LastLoginAt], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (N'e21c1241-8887-484b-84c2-514f0a963a24', N'Abdelrahman Khaled', N'Maintenance', 1, N'2026-09-05 09:23:33.419', NULL, N'abdelrahman238@maintenance.com', N'ABDELRAHMAN238@MAINTENANCE.COM', N'abdelrahman238@maintenance.com', N'ABDELRAHMAN238@MAINTENANCE.COM', 0, N'AQAAAAIAAYagAAAAEP/5hLAK//YJEuhOxxVf+ph1MAFiBih5JUKExIPZLXM2LKDdi6q+yYk4wQUmrvHwmw==', N'DFAYEP3IUBEJIJVVPEUU2Q6U65WE367L', N'861a9b49-9cfa-48ed-9794-1d85394238f5', NULL, 0, 0, NULL, 1, 0);
GO


INSERT INTO [AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'034d8d40-b765-4b2a-9ff1-f668bc12e6d2', N'88e31399-38ee-429b-8b9f-825cb4c4d63a');
INSERT INTO [AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'227ae5fa-b6e6-469b-9110-274b36e79134', N'b61d2b1e-fa18-4319-b55e-c5608eb5889a');
INSERT INTO [AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'6b0eb0a5-5b6f-4e4f-b356-8e8272e38e4f', N'b61d2b1e-fa18-4319-b55e-c5608eb5889a');
INSERT INTO [AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'8d9c953a-b7b4-4ff0-b8a0-fe942109b196', N'ccf0a756-e8af-49d8-89e5-8bd0d1c49caf');
INSERT INTO [AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'b5aade59-8427-46f8-aa17-cd4a3c2abc5b', N'ccf0a756-e8af-49d8-89e5-8bd0d1c49caf');
INSERT INTO [AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'e21c1241-8887-484b-84c2-514f0a963a24', N'b61d2b1e-fa18-4319-b55e-c5608eb5889a');
GO

SET IDENTITY_INSERT [Categories] ON;
GO
INSERT INTO [Categories] ([Id], [Name], [Description], [IsActive], [CreatedAt]) VALUES (1, N'Electrical', N'Electrical systems and wiring issues', 1, N'2025-01-01 00:00:00.000');
INSERT INTO [Categories] ([Id], [Name], [Description], [IsActive], [CreatedAt]) VALUES (2, N'Plumbing', N'Water and drainage issues', 1, N'2025-01-01 00:00:00.000');
INSERT INTO [Categories] ([Id], [Name], [Description], [IsActive], [CreatedAt]) VALUES (3, N'HVAC', N'Heating, ventilation, and air conditioning', 1, N'2025-01-01 00:00:00.000');
INSERT INTO [Categories] ([Id], [Name], [Description], [IsActive], [CreatedAt]) VALUES (4, N'IT Equipment', N'Computers, printers, and network equipment', 1, N'2025-01-01 00:00:00.000');
INSERT INTO [Categories] ([Id], [Name], [Description], [IsActive], [CreatedAt]) VALUES (5, N'Furniture', N'Furniture repair and replacement', 1, N'2025-01-01 00:00:00.000');
SET IDENTITY_INSERT [Categories] OFF;
GO

SET IDENTITY_INSERT [MaintenanceRequests] ON;
GO
INSERT INTO [MaintenanceRequests] ([Id], [RequestNumber], [Title], [Description], [Status], [Priority], [ResolutionNotes], [CreatedAt], [UpdatedAt], [ResolvedAt], [ClosedAt], [IsDeleted], [DeletedAt], [CategoryId], [EmployeeId], [TechnicianId]) VALUES (1, N'REQ-2026-0001', N'Air Conditioner Leaking Water', N'Water dripping from unit onto desk in Room 302', N'InProgress', N'High', NULL, N'2026-09-05 09:01:54.178', N'2026-09-05 09:01:57.119', NULL, NULL, 0, NULL, 1, N'227ae5fa-b6e6-469b-9110-274b36e79134', N'8d9c953a-b7b4-4ff0-b8a0-fe942109b196');
INSERT INTO [MaintenanceRequests] ([Id], [RequestNumber], [Title], [Description], [Status], [Priority], [ResolutionNotes], [CreatedAt], [UpdatedAt], [ResolvedAt], [ClosedAt], [IsDeleted], [DeletedAt], [CategoryId], [EmployeeId], [TechnicianId]) VALUES (2, N'REQ-2026-0002', N'Air Conditioner Leaking Water', N'Water dripping from unit onto desk in Room 302', N'Resolved', N'High', NULL, N'2026-09-05 09:08:57.940', N'2026-09-05 09:19:21.020', N'2026-09-05 09:19:21.020', NULL, 0, NULL, 1, N'227ae5fa-b6e6-469b-9110-274b36e79134', N'8d9c953a-b7b4-4ff0-b8a0-fe942109b196');
INSERT INTO [MaintenanceRequests] ([Id], [RequestNumber], [Title], [Description], [Status], [Priority], [ResolutionNotes], [CreatedAt], [UpdatedAt], [ResolvedAt], [ClosedAt], [IsDeleted], [DeletedAt], [CategoryId], [EmployeeId], [TechnicianId]) VALUES (3, N'REQ-2026-0003', N'Air Conditioner Leaking Water', N'Water dripping from unit onto desk in Room 302', N'Resolved', N'High', NULL, N'2026-09-05 09:10:31.840', N'2026-09-05 09:18:23.552', N'2026-09-05 09:18:23.552', NULL, 0, NULL, 1, N'227ae5fa-b6e6-469b-9110-274b36e79134', N'8d9c953a-b7b4-4ff0-b8a0-fe942109b196');
SET IDENTITY_INSERT [MaintenanceRequests] OFF;
GO


SET IDENTITY_INSERT [RequestHistories] ON;
GO
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (1, N'RequestCreated', N'Maintenance request created', N'2026-09-05 09:01:54.414', 1, N'227ae5fa-b6e6-469b-9110-274b36e79134');
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (2, N'TechnicianAssigned', N'Technician assigned to request', N'2026-09-05 09:01:56.488', 1, N'034d8d40-b765-4b2a-9ff1-f668bc12e6d2');
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (3, N'StatusChanged', N'Status changed to InProgress', N'2026-09-05 09:01:57.127', 1, N'8d9c953a-b7b4-4ff0-b8a0-fe942109b196');
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (4, N'RequestCreated', N'Maintenance request created', N'2026-09-05 09:08:58.225', 2, N'227ae5fa-b6e6-469b-9110-274b36e79134');
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (5, N'TechnicianAssigned', N'Technician assigned to request', N'2026-09-05 09:09:00.533', 2, N'034d8d40-b765-4b2a-9ff1-f668bc12e6d2');
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (6, N'StatusChanged', N'Status changed to InProgress', N'2026-09-05 09:09:01.116', 2, N'8d9c953a-b7b4-4ff0-b8a0-fe942109b196');
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (7, N'RequestCreated', N'Maintenance request created', N'2026-09-05 09:10:32.101', 3, N'227ae5fa-b6e6-469b-9110-274b36e79134');
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (8, N'TechnicianAssigned', N'Technician assigned to request', N'2026-09-05 09:10:34.225', 3, N'034d8d40-b765-4b2a-9ff1-f668bc12e6d2');
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (9, N'StatusChanged', N'Status changed to InProgress', N'2026-09-05 09:10:34.738', 3, N'8d9c953a-b7b4-4ff0-b8a0-fe942109b196');
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (10, N'StatusChanged', N'Status changed to Resolved', N'2026-09-05 09:18:23.612', 3, N'8d9c953a-b7b4-4ff0-b8a0-fe942109b196');
INSERT INTO [RequestHistories] ([Id], [Action], [Description], [CreatedAt], [RequestId], [UserId]) VALUES (11, N'StatusChanged', N'Status changed to Resolved', N'2026-09-05 09:19:21.027', 2, N'034d8d40-b765-4b2a-9ff1-f668bc12e6d2');
SET IDENTITY_INSERT [RequestHistories] OFF;
GO

