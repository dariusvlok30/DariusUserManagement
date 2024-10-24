USE [DariusInternship]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2024/10/24 12:13:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [uniqueidentifier] NOT NULL,
	[username] [varchar](255) NULL,
	[password] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Audits]    Script Date: 2024/10/24 12:13:37 ******/
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
/****** Object:  View [dbo].[vw_audit]    Script Date: 2024/10/24 12:13:37 ******/
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
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'2d09ea74-5538-4646-ba03-a6ed919c8593', N'darius', N'$2a$11$b6ezhFKr2VvpbED3oJARTufc6WrgvyYQxnkhNiQsxuK7aumEyumr6')
GO
ALTER TABLE [dbo].[Audits] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Audits] ADD  CONSTRAINT [DF_Audits_Date]  DEFAULT (getdate()) FOR [dateOfChange]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (newid()) FOR [id]
GO
/****** Object:  StoredProcedure [dbo].[sp_create_user]    Script Date: 2024/10/24 12:13:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_create_user]
	@usernameVar varchar(255)
	, @encryptedPassword varchar(max) 
as
begin
	
	insert into Users 
	(username, [password])
	values
	(@usernameVar,@encryptedPassword)

end
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_user]    Script Date: 2024/10/24 12:13:37 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_userPassword]    Script Date: 2024/10/24 12:13:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_get_userPassword] 
    @username VARCHAR(50)
AS
BEGIN
		SELECT 
		[id],[Password]
		FROM Users u
		WHERE u.[username] = @username 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_users]    Script Date: 2024/10/24 12:13:37 ******/
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
	Id, Username
	FROM Users 
	ORDER BY username 
	OFFSET 
	@pageNumber * @pageSize -- Page Number
	ROWS FETCH NEXT 
	@pageSize -- Rows Per Page
	ROWS ONLY;
end
GO
/****** Object:  StoredProcedure [dbo].[sp_get_usersMaxPaging]    Script Date: 2024/10/24 12:13:37 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_insert_audit]    Script Date: 2024/10/24 12:13:37 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_update_userDetails]    Script Date: 2024/10/24 12:13:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_update_userDetails]
	@id [uniqueidentifier],
	@usernameVar varchar(255)
as
begin
	update Users
	set username = @usernameVar
	where id = @id
end
GO
/****** Object:  StoredProcedure [dbo].[sp_update_userPassword]    Script Date: 2024/10/24 12:13:37 ******/
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
