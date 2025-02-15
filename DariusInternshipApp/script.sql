USE [LeaderTrailers]
GO
/****** Object:  Table [dbo].[parts]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[parts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[partNumber] [varchar](max) NULL,
	[name] [varchar](max) NULL,
	[partsCategoryID] [int] NULL,
	[description] [varchar](max) NULL,
	[price] [decimal](19, 4) NULL,
	[expectedStock] [int] NULL,
	[stockOnHand] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[partsCategory]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[partsCategory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_partsValuePerCategory]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_partsValuePerCategory]
as
	select 
	--* ,
	--expectedStock - stockOnHand [qtyToOrder],
	p.partsCategoryID,
	pc.[name],
	sum(p.stockOnHand * p.price) [totalPerCategory]
	from [LeaderTrailers].[dbo].[parts] p
	left join [LeaderTrailers].[dbo].[partsCategory] pc on pc.id = p.partsCategoryID
	--where partsCategoryID = 1
	group by p.partsCategoryID, pc.[name]
GO
/****** Object:  View [dbo].[vw_partsValueTotal]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_partsValueTotal]
as
	select 
	sum(totalPerCategory) [total]
	from vw_partsValuePerCategory
GO
/****** Object:  View [dbo].[vw_parts]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_parts]
as
SELECT p.[id]
      ,p.[partNumber]
      ,p.[name]
      ,p.[partsCategoryID]
      ,p.[description]
      ,p.[price] [pricePerUnit]
      ,p.[expectedStock]
      ,p.[stockOnHand]
	  ,(p.[expectedStock] - p.[stockOnHand]) [stockToOrder]
	  ,(p.[stockOnHand] * p.[price]) [priceForStockOnHand]
	  ,pc.id partCategoryID
	  ,pc.[name] partCategoryName
  FROM [parts] p
  left join partsCategory pc on pc.id = p.partsCategoryID
GO
/****** Object:  View [dbo].[vw_partsCategories]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_partsCategories]
as
select id, [name] from partsCategory
GO
/****** Object:  Table [dbo].[partsMovement]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[partsMovement](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[price] [decimal](19, 4) NULL,
	[stockOnHand] [int] NULL,
	[partsID] [int] NULL,
	[dateAltered] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_partsMovement]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vw_partsMovement]
as
SELECT p.[id]
      ,p.[price]
      ,p.[stockOnHand]
      ,p.[partsID]
      ,p.[dateAltered]
  FROM [partsMovement] p
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  Table [dbo].[Audits]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  View [dbo].[vw_audit]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  Table [dbo].[Roles]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  View [dbo].[vw_role]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_role]
as
	select id, [description] from Roles
GO
ALTER TABLE [dbo].[Audits] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Audits] ADD  CONSTRAINT [DF_Audits_Date]  DEFAULT (getdate()) FOR [dateOfChange]
GO
ALTER TABLE [dbo].[Roles] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[parts]  WITH CHECK ADD FOREIGN KEY([partsCategoryID])
REFERENCES [dbo].[partsCategory] ([id])
GO
ALTER TABLE [dbo].[partsMovement]  WITH CHECK ADD FOREIGN KEY([partsID])
REFERENCES [dbo].[parts] ([id])
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD FOREIGN KEY([roleID])
REFERENCES [dbo].[Roles] ([id])
GO
/****** Object:  StoredProcedure [dbo].[sp_create_part]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_create_part]
    @partNumber VARCHAR(MAX),
    @name VARCHAR(MAX),
    @partsCategoryID INT,
    @description VARCHAR(MAX),
    @price DECIMAL(19, 4),
    @expectedStock INT,
    @stockOnHand INT
AS
BEGIN
    INSERT INTO [Parts] (
        partNumber, 
        name, 
        partsCategoryID, 
        description, 
        price, 
        expectedStock, 
        stockOnHand
    )
    VALUES (
        @partNumber, 
        @name, 
        @partsCategoryID, 
        @description, 
        @price, 
        @expectedStock, 
        @stockOnHand
    );
END
GO
/****** Object:  StoredProcedure [dbo].[sp_create_user]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_delete_part]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_delete_part]
    @partID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Optionally delete related records from partsMovement (if necessary)
    DELETE FROM [partsMovement] WHERE partsID = @partID;

    -- Delete the part from the parts table
    DELETE FROM [parts] WHERE id = @partID;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_user]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_userPassword]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_users]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_usersMaxPaging]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_insert_audit]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_insert_partsMovement]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_insert_partsMovement] 
	@partID int
    ,@partPrice decimal(19,4)
	,@stockOnHand int
as
BEGIN
	update p
	set 
    p.stockOnHand = @stockOnHand 
	from [parts] p 
	where 1=1
	and p.id = @partID

	insert into partsMovement
	(price,stockOnHand,partsID,dateAltered)
	values
	(@partPrice,@stockOnHand,@partID,current_timestamp)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_update_parts]    Script Date: 2025/02/04 21:37:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_update_parts] 
	@partID int
	,@partName VARCHAR(255) 
    ,@partNumber VARCHAR(255) 
    ,@partpartsCategoryID int
    ,@partPrice decimal(19,4)
    ,@partExpectedStock int
as
BEGIN
	update p
	set 
	p.[name] = @partName
	,p.[partNumber] = @partNumber 
    ,p.[partsCategoryID] = @partpartsCategoryID 
    ,p.[price] = @partPrice 
    ,p.[expectedStock] = @partExpectedStock 
	from [parts] p 
	where 1=1
	and p.id = @partID
END
GO
/****** Object:  StoredProcedure [dbo].[sp_update_userDetails]    Script Date: 2025/02/04 21:37:38 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_update_userPassword]    Script Date: 2025/02/04 21:37:38 ******/
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
