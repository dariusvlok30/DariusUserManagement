USE [master]
GO
/****** Object:  Database [DariusInternship]    Script Date: 2024/10/24 14:29:30 ******/
CREATE DATABASE [DariusInternship]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DariusInternship', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\DariusInternship.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DariusInternship_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\DariusInternship_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DariusInternship] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DariusInternship].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DariusInternship] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DariusInternship] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DariusInternship] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DariusInternship] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DariusInternship] SET ARITHABORT OFF 
GO
ALTER DATABASE [DariusInternship] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DariusInternship] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DariusInternship] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DariusInternship] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DariusInternship] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DariusInternship] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DariusInternship] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DariusInternship] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DariusInternship] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DariusInternship] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DariusInternship] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DariusInternship] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DariusInternship] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DariusInternship] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DariusInternship] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DariusInternship] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DariusInternship] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DariusInternship] SET RECOVERY FULL 
GO
ALTER DATABASE [DariusInternship] SET  MULTI_USER 
GO
ALTER DATABASE [DariusInternship] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DariusInternship] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DariusInternship] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DariusInternship] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DariusInternship] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DariusInternship] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DariusInternship', N'ON'
GO
ALTER DATABASE [DariusInternship] SET QUERY_STORE = ON
GO
ALTER DATABASE [DariusInternship] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DariusInternship]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [uniqueidentifier] NOT NULL,
	[username] [varchar](255) NULL,
	[password] [varchar](max) NULL,
	[roleID] [uniqueidentifier] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Audits]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Audits](
	[id] [uniqueidentifier] NULL,
	[dateOfChange] [datetime] NULL,
	[changedBy] [uniqueidentifier] NULL,
	[description] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_audit]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_audit]
as
	select 
	a.id, 
	a.dateOfChange, 
	a.changedBy,
	u.username,
	a.[description] 
	from Audits a
	left join Users u on a.changedBy = u.id
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[id] [uniqueidentifier] NOT NULL,
	[description] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_role]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_role]
as
	select id, [description] from Roles
GO

INSERT [dbo].[Roles] ([id], [description]) VALUES (N'27f62e23-84e4-47b8-95dc-73fab90e50ca', N'User')
INSERT [dbo].[Roles] ([id], [description]) VALUES (N'c185dbed-befd-4e9a-9766-d96a54f1d2f4', N'Admin')
GO
INSERT [dbo].[Users] ([id], [username], [password], [roleID]) VALUES (N'5b1288ec-34ad-4a16-8758-fd87edd7410d', N'1234', N'$2a$11$vG6jOShbnKlsE5/zZffgZeiUz6UdCSje/zIg2/TBPY07w6A5FX7dG', N'27f62e23-84e4-47b8-95dc-73fab90e50ca')
INSERT [dbo].[Users] ([id], [username], [password], [roleID]) VALUES (N'bb76d142-73f0-4e0b-a07e-c115f0d7ec4e', N'123', N'$2a$11$1FrMGTTw9kkZ8ITX/qlAe.Wbm7G2Cwpnulspb.GysrsHzekge0/4C', N'c185dbed-befd-4e9a-9766-d96a54f1d2f4')
GO
ALTER TABLE [dbo].[Audits] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Audits] ADD  CONSTRAINT [DF_Audits_Date]  DEFAULT (getdate()) FOR [dateOfChange]
GO
ALTER TABLE [dbo].[Roles] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD FOREIGN KEY([roleID])
REFERENCES [dbo].[Roles] ([id])
GO
/****** Object:  StoredProcedure [dbo].[sp_create_user]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_create_user]
	@usernameVar varchar(255)
	, @encryptedPassword varchar(max) ,
	@roleID uniqueidentifier
as
begin
	
	insert into Users 
	(username, [password],roleID)
	values
	(@usernameVar,@encryptedPassword, @roleID)

end
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_user]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_delete_user]
	@id [uniqueidentifier]
as
begin
	delete from Users
	where id = @id
end
GO
/****** Object:  StoredProcedure [dbo].[sp_get_userPassword]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_get_userPassword] 
    @username VARCHAR(50)
AS
BEGIN
		SELECT 
		u.[id],
		u.[Password],
		r.id 'roleID',
		r.[description] 'roleName'
		FROM Users u
		LEFT JOIN roles r on u.roleid=r.id
		WHERE u.[username] = @username 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_users]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_get_users]
	@pageNumber int, -- page number variable/parameter
	@pageSize int, -- rows per page variable/parameter
	@pageFilters varchar(max)
as
begin
	SELECT
	u.Id, u.Username, u.roleID, r.[description]
	FROM Users u
	left join Roles r on r.id = u.roleID
	ORDER BY u.username 
	OFFSET 
	@pageNumber * @pageSize -- Page Number
	ROWS FETCH NEXT 
	@pageSize -- Rows Per Page
	ROWS ONLY;
end
GO
/****** Object:  StoredProcedure [dbo].[sp_get_usersMaxPaging]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_get_usersMaxPaging]
	@pageSize int,
	@pageFilters varchar(max)
as
begin
	declare @countOfUsers int = (
		SELECT
		count(*)
		FROM Users 
	);
	declare @MaxPages int =
	CASE 
		WHEN @countOfUsers % @pageSize = 0 -- if the max rows can be divided by the pagesize, go into the Then
			THEN @countOfUsers / @pageSize 
		ELSE (@countOfUsers / @pageSize) + 1 -- else defaults to 1
	END
	select @MaxPages 'pages';
end
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_audit]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_insert_audit]
	@userUUID uniqueidentifier,
	@changeDescription varchar(max)
as
begin
	insert into dbo.Audits 
	(changedBy, [description])
	VALUES
	(@userUUID, @changeDescription)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_update_userDetails]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_update_userDetails]
	@id uniqueidentifier,
	@usernameVar varchar(255),
	@roleID uniqueidentifier
as
begin
	update Users
	set username = @usernameVar, roleID = @roleID
	where id = @id
end
GO
/****** Object:  StoredProcedure [dbo].[sp_update_userPassword]    Script Date: 2024/10/24 14:29:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_update_userPassword]
	@id [uniqueidentifier],
	@encryptedPassword varchar(MAX)
as
begin
	update Users
	set [password] = @encryptedPassword
	where id = @id
end
GO
USE [master]
GO
ALTER DATABASE [DariusInternship] SET  READ_WRITE 
GO
