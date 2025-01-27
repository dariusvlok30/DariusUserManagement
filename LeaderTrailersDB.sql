USE [LeaderTrailers]
GO
/****** Object:  Table [dbo].[parts]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  Table [dbo].[partsCategory]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  View [dbo].[vw_partsValuePerCategory]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  View [dbo].[vw_partsValueTotal]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  View [dbo].[vw_parts]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  View [dbo].[vw_partsCategories]    Script Date: 2025/01/27 22:03:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_partsCategories]
as
select id, [name] from partsCategory
GO
/****** Object:  Table [dbo].[partsMovement]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  View [dbo].[vw_partsMovement]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  Table [dbo].[Audits]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  View [dbo].[vw_audit]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  Table [dbo].[Roles]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  View [dbo].[vw_role]    Script Date: 2025/01/27 22:03:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_role]
as
	select id, [description] from Roles
GO
SET IDENTITY_INSERT [dbo].[parts] ON 

INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (779, N'1-000-000', N'Latex gloves - Boxes', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 50, 29)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (780, N'1-000-001', N'Lappe / Rags 5 kg', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 29)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (781, N'1-000-002', N'Masking Paper ±25kg/roll', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (782, N'1-000-004', N'Masking Tape 48mm', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (783, N'1-000-005', N'P150 Sand Paper Disk', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (784, N'1-000-006', N'P80 Sand Paper Disk', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (785, N'1-000-007', N'Scotch Brush', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (786, N'1-000-008', N'Body Filler', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (787, N'1-000-009', N'Spray mask Cartidge', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (788, N'1-000-010', N'Paint shop mask', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (789, N'1-000-011', N'Disposable Mask', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (790, N'1-000-012', N'Large Spray Suite', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (791, N'1-000-013', N'Spray mask Filter', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (792, N'1-000-014', N'Sanding pad for Orbital Sander', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (793, N'1-000-015', N'Orbital Sander', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (794, N'1-000-016', N'Spray Gun/Service Kit', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (795, N'1-000-017', N'Spray Gun - Pot Gun', 1, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (796, N'T111', N'Benzine - 200L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (797, N'T222', N'Lacquer Thinners - 200L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (798, N'GEP25', N'Paint Chem Grey Etch 25L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (799, N'LPK-2135/5', N'Super Etch Black Primer 5L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (800, N'LPK-2135/20', N'Super Etch Black Primer 20L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (801, N'LPK-2168/5', N'Super Etch Grey Primer 5L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (802, N'LPK-2168/20', N'Super Etch Grey Primer 20L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (803, N'352-320', N'Thinners Normal 5L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (804, N'922-138', N'Hardener Normal 2,5L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (805, N'568-17', N'Multi Colour Additive', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (806, N'568-M135', N'Mixing Clear 5L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (807, N'RAL9006', N'RAL9006 3,5L', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (808, N'T002', N'T002 3,5L White', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (809, N'T100', N'T100 3,5L Yellow Oxide', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (810, N'T120', N'T120 3,5L Signal Yellow', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (811, N'T141', N'T141 3,5L Citrus Yellow', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (812, N'T144', N'T144 3,5L Sun Yellow', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (813, N'T150', N'T150 3,5L Yellow', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (814, N'T200', N'T200 3,5L Light Orange', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (815, N'T230', N'T230 3,5L Pure Orange', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (816, N'T310', N'T310 3,5L Bordeaux', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (817, N'T311', N'T311 3,5L Red Oxide', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (818, N'T320', N'T320 3,5L Dark Red', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (819, N'T330', N'T330 3,5L Red', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (820, N'T340', N'T340 3,5L Wine Red', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (821, N'T420', N'T420 3,5L Purple', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (822, N'T500', N'T500 3,5L Dark Blue', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (823, N'T523', N'T523 3,5L Medium Blue', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (824, N'T531', N'T531 3,5L Blue', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (825, N'T600', N'T600 3,5L Bottle Green', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (826, N'T900', N'T900 3,5L Blue Black', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (827, N'T920', N'T920 3,5L Yellow Black', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (828, N'T940', N'T940 3,5L Black', 2, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (829, N'2-000-000', N'Diesel - Hoof tank', 3, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (830, N'2-000-001', N'Diesel - Genarator', 3, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (831, N'2-000-002', N'Diesel - Spray Booth', 3, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (832, N'2-000-003', N'Diesel - Edward Genarator', 3, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (833, N'2-000-004', N'Diesel - Reserve', 3, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (834, N'2-000-005', N'Diesel - Yellow "Giant" Trailer', 3, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (835, N'3-000-001', N'385 Alu / Double Star Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (836, N'3-000-002', N'385 Alu / Boto Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (837, N'3-000-003', N'315 Alu / Boto Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (838, N'3-000-004', N'385 Alu Centre Dish / Bridgestone Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (839, N'3-000-005', N'315 Steel / Boto Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (840, N'3-000-006', N'Michelin 385 Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (841, N'3-000-007', N'9’00 x 22,5 Alu Rims', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (842, N'3-000-008', N'Michelin 315', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (843, N'3-000-009', N'11’75 x 22,5 Alu Front Runner Rims', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (844, N'3-000-010', N'9"00 x 22,5 Steel Rims Used', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (845, N'3-000-011', N'11’75 x 22,5 Steel Centre Dish Rims', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (846, N'3-000-012', N'9"00 x 22,5 Steel Rims New', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (847, N'3-000-013', N'Boto 385', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (848, N'3-000-014', N'Firenza Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (849, N'3-000-015', N'315/80 R 22,5 Boto Track', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (850, N'3-000-016', N'315/80 R 22.5 Retread', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (851, N'3-000-017', N'Evergreen 385 Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (852, N'3-000-018', N'385 Alu / Boto Off Centre', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (853, N'3-000-019', N'Tyre Soap', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (854, N'3-000-020', N'385/65 R 22.5 Boto Centre Dish', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (855, N'3-000-021', N'Sumitomo Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (856, N'3-000-022', N'385/65 R 22.5 Other', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (857, N'3-000-023', N'Boto 315', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (858, N'3-000-024', N'Boto 315 Used Tyre Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (859, N'3-000-025', N'Boto 385 Used Tyre Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (860, N'3-000-026', N'385 Other Boto Combo', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (861, N'3-000-027', N'Double Star Combo Offset', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (862, N'3-000-028', N'Dunlop 315', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (863, N'3-000-029', N'Good Year 315', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (864, N'3-000-030', N'Center Dish Alu 11" second hand rim', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (865, N'3-000-031', N'Steel second hand Rim 9"', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (866, N'3-000-032', N'Ni-Pon 315 Steel', 4, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (867, N'3-100-001', N'11’75 x 22,5 Alu Front Runner Off set Rims', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (868, N'3-100-002', N'11’75 x 22,5 Alu Front Runner Center Dish Rims', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (869, N'3-100-003', N'9" Steel Rims New', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (870, N'3-100-004', N'9"00 x 22,5 Steel Rims Used', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (871, N'3-100-005', N'11" Steel Rims Old', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (872, N'3-100-006', N'9’00 x 22,5 Alu Rims', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (873, N'3-100-007', N'9’00 x 22,5 Alu Rims - Second Hand', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (874, N'3-100-008', N'11’75 x 22,5 Alu Centre Dish Rims - Second Hand', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (875, N'3-100-009', N'11" Centre Dish Rims - Damaged', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (876, N'3-100-010', N'9" Steel Rims Old - Damaged', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (877, N'3-100-011', N'Boto 315 Used Tyre', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
GO
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (878, N'3-100-012', N'Boto 385 Used Tyre', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (879, N'3-100-013', N'385 Tyres Only', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (880, N'3-100-014', N'11" Centre Dish Rims Steel New', 5, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (881, N'4-999-991', N'Alform 700 3mm 8650x1500x3', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (882, N'4-999-992', N'Alform 700 4mm 6916x1500x4', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (883, N'4-999-993', N'Alform 700 6mm 5800x1500x6', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (884, N'4-000-001', N'Mild Steel Plate 3000 x 1500 x 2', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (885, N'4-000-002', N'Mild Steel Plate 2450 x 1225 x 2', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (886, N'4-000-005', N'Mild Steel Plate 3000 x 1500 x 3', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (887, N'4-000-008', N'Mild Steel Plate 3000 x 1500 x 4', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (888, N'4-000-014', N'Mild Steel Plate 3000 x 1500 x 6', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (889, N'4-000-020', N'Mild Steel Plate 3000 x 1500 x 8', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (890, N'4-000-025', N'Mild Steel Plate 3000 x 1500 x 10', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (891, N'4-010-026', N'Mild Steel Plate 2500 x 1200 x 12', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (892, N'4-010-032', N'Supraform - 6916 x 1500 x 3', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (893, N'4-000-043', N'Supraform - 6 916 x 1500 x 4', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (894, N'4-000-051', N'Domex - 4 300 x 1 050 x 2', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (895, N'4-010-053', N'Domex 550MC - 6916 x 1500 x 4', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (896, N'4-000-057', N'Domex 700 MCD - 6200 x 1500 x 4', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (897, N'4-000-060', N'Domex 700 MCD - 3100 x 1500 x 6', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (898, N'4-000-061', N'Domex 700 MCD - 6100 x 1500 x 6', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (899, N'4-000-063', N'Supraform 11 000 x 1500 x 10mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (900, N'4-000-064', N'Supraform 9100 x 1500 x 10mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (901, N'4-000-064', N'Strenx 6200 x 1300 x 4mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (902, N'4-000-068', N'Durastat 3mm - 7500 x 1500 x 3', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (903, N'4-000-070', N'Hardox 3mm - 9000 x 1500 x 3', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (904, N'4-010-075', N'Hardox - 6200 x 1500 x 6mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (905, N'4-000-077', N'Graad 55 C - 10100 x 1 550 x 8', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (906, N'4-000-079', N'3 CR 12 Plate - 3000 x 1500 x 3', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (907, N'4-000-080', N'3 CR 12 Plate - 3000 x 1500 x 6', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (908, N'4-000-081', N'3 CR 12 Plate - 7500 x1250 x 3', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (909, N'4-000-082', N'3 CR 12 Plate - 1500 Coil', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (910, N'4-000-084', N'Vas Trap Plate - 2450 x 1225 x 3', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (911, N'4-000-087', N'Allu Vas Trap - 2500 x 1250 x 3', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (912, N'4-000-088', N'Allu Vas Trap - 3000 x 1500 x 3', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (913, N'4-000-089', N'', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (914, N'4-000-090', N'Angle Iron - 60 x 60 x 5', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (915, N'4-000-092', N'Round Bar - 6 mm x 6', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (916, N'4-000-093', N'Round Bar - 10 mm x 6', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (917, N'4-000-094', N'Round Bar - 20 mm x 6', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (918, N'4-000-095', N'Round Bar - 16 mm x 6', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (919, N'4-000-096', N'Round Tube - 32mm x 3mm x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (920, N'4-000-097', N'Round Tube - 34 x 3mm x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (921, N'4-000-098', N'Round Tube - 34 x 6mm x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (922, N'4-000-099', N'Round Tube - 48 x 3mm x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (923, N'4-010-099', N'Round Tube - 38 x 3mm x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (924, N'4-000-102', N'Round Tube / meter - 101 x 6 mm x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (925, N'4-000-103', N'Round Tube / meter - 101 x 6 mm x 12 000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (926, N'4-000-106', N'Round Tube /meter - 114 x 6 mm x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (927, N'4-010-106', N'Round Tube /meter - 114 x 6 mm x 6830mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (928, N'4-010-107', N'Round Tube / meter - 114 x 6 mm x 9,420mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (929, N'4-020-107', N'Round Tube / meter - 114 x 6 mm x 10030mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (930, N'4-000-109', N'Round Tube / meter - 114 x 6 mm x 11,800mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (931, N'4-001-109', N'Round Tube / meter - 114 x 6 mm x 12 000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (932, N'4-000-112', N'Square Tube - 38 x 38 x 3 x 6', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (933, N'4-000-115', N'Flat Bar - 30 x 5 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (934, N'4-000-116', N'Flat Bar- 50 x 6 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (935, N'4-000-117', N'Flat Bar - 40 x 8 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (936, N'4-000-118', N'Flat Bar - 80 x 6 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (937, N'4-000-119', N'Flat Bar - 130 x 8 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (938, N'4-000-120', N'Flat Bar - 130 x 8 x 8500mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (939, N'4-000-121', N'Flat Bar - 40 x 10 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (940, N'4-000-123', N'Flat Bar - 100 x 6 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (941, N'4-000-124', N'Flat Bar - 130 x 10 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (942, N'4-010-130', N'Grade 55 C Flat Bar - 130 x 8 x 13000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (943, N'4-000-132', N'Grade 55 C Flat Bar - 130 x 10 x 10,600mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (944, N'4-000-133', N'Grade 55 C Flat Bar - 130 x 10 x 8,500mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (945, N'4-000-134', N'Grade 55 C Flat Bar - 130 x 10 x 11,500mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (946, N'4-000-135', N'Grade 55 C Flat Bar - 130 x 10 x 13000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (947, N'4-000-136', N'Grade 55C Flat Bar - 130 x 10 x 9500', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (948, N'4-000-137', N'Grade 55C Flat Bar - 130 x 10 x 12000', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (949, N'4-000-138', N'Grade 55 C Flat Bar - 130 x 12 x 12000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (950, N'4-000-139', N'Grade 55 C Flat Bar - 130 x 12 x 13000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (951, N'4-000-141', N'Hot Rolled Channel - 76 x 38 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (952, N'4-000-142', N'Hot Rolled Channel - 100 x 50 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (953, N'4-000-143', N'Hot Rolled Channel - 127 x 64 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (954, N'4-010-143', N'Hot Rolled Channel - 127 x 64 x 13000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (955, N'4-000-144', N'Hot Rolled Channel - 152 x 76 x 6000mm', 6, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (956, N'5-000-001', N'102 x 54 x 1000 HB', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (957, N'5-000-002', N'90 x 45 x 1000 HB', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (958, N'5-000-004', N'100 x 71 x 115 HB Casing for Leapord Bush', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (959, N'5-000-005', N'Graphite Buste / Luiperdbus - China', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (960, N'5-000-009', N'Dia 50 X 115 Shaft', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (961, N'5-000-010', N'Dia 50 X 220 Shaft', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (962, N'5-000-011', N'Dia 60 X 220 Shaft', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (963, N'5-010-011', N'Dencor Brass', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (964, N'5-000-014', N'Luiperd buste - Completed (4)', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (965, N'5-010-014', N'Dencor Brass - Complete', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (966, N'5-000-015', N'Bullets (101 X 6 X 300 Pipe) (4)', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (967, N'5-000-016', N'Taper Bush 80 X 50 X 75 - (90 X 45 HB) (8)', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (968, N'5-000-017', N'Small Nose 100 X 61 X 50 - (102 X 54 HB) (4)', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (969, N'5-000-018', N'Big Nose 100 X 61 X 55 - (102 X 54 HB) (4)', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (970, N'5-000-019', N'Dia 50 X 115 pins', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (971, N'5-000-020', N'Dia 50 X 220 pins', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (972, N'5-000-020', N'Dia 60 X 220 pins', 7, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (973, N'6-000-001', N'Liquid Argon - 1500L', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (974, N'6-000-002', N'Magmix', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (975, N'6-010-002', N'Coogar 98', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (976, N'6-000-003', N'Oxygen', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (977, N'6-000-004', N'Lasox', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
GO
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (978, N'6-010-004', N'Carbon Dioxide', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (979, N'6-000-005', N'Speedcut', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (980, N'6-000-006', N'LPG 9 kg', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (981, N'6-000-007', N'LPG 19 kg', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (982, N'6-000-008', N'LPG 48 kg', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (983, N'6-000-009', N'Welding Wire - Box', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (984, N'6-000-010', N'Welding Wire - Drum', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (985, N'6-000-011', N'Clear Glass', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (986, N'6-000-013', N'Shade 10 Glass', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (987, N'6-000-014', N'Shade 12 Glass', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (988, N'6-000-016', N'Welding Tip 1.4mm', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (989, N'6-000-017', N'Tip Holder 40 A', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (990, N'6-010-016', N'Contact Tip M10 - Beam welder', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (991, N'6-020-016', N'Tip Holder M10 - Beam Welder', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (992, N'6-000-018', N'Gas Diffuser', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (993, N'6-000-019', N'Welding Nozzle - Standard', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (994, N'6-010-019', N'Heating Torch Nozzel', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (995, N'6-000-020', N'Welding Gun / Torch', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (996, N'6-000-021', N'Welding Earth Clamp', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (997, N'6-000-022', N'Boilermaker chalk - Boxes', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (998, N'6-000-023', N'Boilermaker chalk - Loose', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (999, N'6-000-024', N'Welding Liner', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1000, N'6-000-025', N'Anti Spatter Spray', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1001, N'6-010-025', N'Nozzle Cleaner', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1002, N'6-000-026', N'Cutting Disk Large - 230x3x23', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1003, N'6-010-027', N'Cutting Disk Large - Bench Top Disk', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1004, N'6-000-028', N'Cutting Disk Small - 115x1x22', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1005, N'6-010-028', N'Cutting Disk Small - 115x3x22', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1006, N'6-000-029', N'Flap Disk Large - 180x22 P80', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1007, N'6-000-030', N'Flap Disk Small - 115x22 P80', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1008, N'6-000-031', N'Grinding Disk Large - 230x6,4x22', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1009, N'6-000-032', N'Grinding Disk Small - 115x6x22', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1010, N'6-000-033', N'Ear plugs', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1011, N'6-000-034', N'Solar Welding Helmets', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1012, N'6-000-035', N'Welding Machine', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1013, N'6-000-036', N'Welding Machine', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1014, N'6-000-037', N'Welding machines', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1015, N'6-000-038', N'Cheap Weldinig Helmets', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1016, N'6-000-039', N'Cutting Torch Nozzle PMA', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1017, N'6-000-040', N'Dark Goggles', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1018, N'6-000-041', N'Flint Lighters', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1019, N'6-000-042', N'Flint Lighter Refill', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1020, N'6-000-043', N'Brown Earth Cable', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1021, N'6-000-044', N'Clear Goggle', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1022, N'6-000-045', N'Pickling Brush / 50mm Paint brush', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1023, N'6-000-046', N'Pickling Paste', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1024, N'6-000-047', N'Passivating Liquid', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1025, N'6-000-048', N'Stainless Steel Welding Wire', 8, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1026, N'7-000-001', N'BPW Axle Kit Assembly Disk Brakes', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1027, N'7-000-002', N'BPW Disk Brake Eco Plus 3 OS', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1028, N'7-000-003', N'BPW Disk Brake Eco Plus 3 US', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1029, N'7-000-006', N'BPW Intra Disk Brake Booster 16/24 O', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1030, N'7-000-007', N'BPW Axle Kit Assembly Drum Brakes', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1031, N'7-000-008', N'BPW Drum Eco Plus 3 OS', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1032, N'7-000-009', N'BPW Drum Eco Plus 3 US', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1033, N'7-000-012', N'BPW Intra Disk Brake Booster 24/30 - Factory Shop', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1034, N'7-000-004', N'BPW Airbags 36 45/80 - 70/110 - Factory Shop', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1035, N'7-000-005', N'BPW Airbag Base Plates', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1036, N'7-000-013', N'BPW Wheel Nut M22x1.5 Flat Collar - Factory Shop', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1037, N'7-000-014', N'Complete BPW pumping kit - Factory Shop', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1038, N'7-000-015', N'BPW Tyre Inflation Pump', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1039, N'7-000-016', N'BPW Tyre Pilot kit', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1040, N'7-000-017', N'BPW Gauge kit', 9, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1041, N'7-000-020', N'P - Tandem Pumping Kit Air Save Complete - Factory Shop', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1042, N'7-000-021', N'P - BPW Tire Pilot - Factory Shop', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1043, N'7-000-022', N'P - BPW Gauge - Factory Shop', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1044, N'7-000-024', N'P - BPW Intra Disk Brake Booster - Factory Shop', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1045, N'7-000-025', N'P - Airbags Air spring 36 45/80 - 10/110 - Factory Shop', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1046, N'7-000-026', N'P - BPW Intra Disk Base Plates - Factory Shop', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1047, N'7-000-027', N'P - Wheel Nut M22x1.5 Flat Collar - Factory Shop', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1048, N'7-000-028', N'P - BPW Shock absorber stroke 170 - Factory Shop', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1049, N'7-000-029', N'P - Lifting Axle Bracket', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1050, N'7-000-030', N'P - Dual Router', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1051, N'7-000-030', N'P - BPW Caliper - Factory Shop', 10, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1052, N'7-001-002', N'HF - Disk OS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1053, N'7-001-003', N'HF - Disk OS + ABS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1054, N'7-001-004', N'HF - Disk US', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1055, N'7-001-005', N'HF - Disk US + ABS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1056, N'7-011-002', N'HF - Composite Drum MBS OS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1057, N'7-011-003', N'HF - Composite Drum MBS US', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1058, N'7-011-004', N'HF - Composite Drum MBS OS + ABS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1059, N'7-011-005', N'HF - Composite Drum MBS US + ABS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1060, N'7-012-002', N'HF - Standard Drum MBS OS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1061, N'7-012-003', N'HF - Standard Drum MBS US', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1062, N'7-012-004', N'HF - Standard Drum MBS OS + ABS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1063, N'7-012-005', N'HF - Standard Drum MBS US + ABS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1064, N'7-001-006', N'HF - Tandem tyre inflating kit s/s', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1065, N'7-001-007', N'HF - Alignment Bracket', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1066, N'7-001-008', N'HF - Inner wear Plate', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1067, N'7-001-009', N'HF - Outer wear Plate', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1068, N'7-001-010', N'HF - Disk Hangers - 200mm H - Factory Shop', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1069, N'7-001-011', N'HF - Disk Hangers - 300mm H - Factory Shop', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1070, N'7-001-012', N'HF - Disk Pivot Bolt Complete - Factory Shop', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1071, N'7-001-013', N'HF - Disk Shock Bolts Long - Factory Shop', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1072, N'7-001-014', N'HF - Disk Shock Bolts Short - Factory Shop', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1073, N'7-001-015', N'HF - Disk Airbags Firestone', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1074, N'7-001-016', N'HF - Disk Threaded Rod Firestone', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1075, N'7-001-017', N'HF - Disk Boosters 16/24', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1076, N'7-001-018', N'HF - Drum OS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1077, N'7-001-019', N'HF - Drum OS + ABS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
GO
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1078, N'7-001-020', N'HF - Drum US', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1079, N'7-001-021', N'HF - Drum US + ABS', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1080, N'7-001-022', N'HF - Hangers - Standard', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1081, N'7-001-023', N'HF - Hubometer For Axle kit', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1082, N'7-011-023', N'HF - Hubometer Hubcap', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1083, N'7-012-023', N'HF - Hubometer Screws', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1084, N'7-001-024', N'HF / Pivot Bolt - Factory Shop', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1085, N'7-001-025', N'HF/ Brake Booster 24/30', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1086, N'7-001-026', N'HF/ Shock Bolts (Long) - Factory Shop', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1087, N'7-001-027', N'HF/ Shock Bolts (Short) - Factory Shop', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1088, N'7-001-028', N'HF/ Shocks - Factory Shop', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1089, N'7-001-029', N'HF/ Weweler Air Bag {Commercial }', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1090, N'7-001-030', N'HF/ Wheel Nuts Long sleeve M22 HF - Factory Shop', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1091, N'7-001-031', N'HF/ Wheel Nuts M22 HF', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1092, N'7-001-032', N'HF/ Wheel Nuts Short sleeve M22 HF', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1093, N'7-001-033', N'HF/ Wheel Studs Short', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1094, N'7-001-034', N'HF/ Wheel Studs Long', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1095, N'7-001-035', N'HF/Halfmoon Base Plates', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1096, N'7-001-036', N'HF / Base Plate studs', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1097, N'7-001-037', N'HF / Brake Shoes', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1098, N'7-001-038', N'HF/Halfmoon Base Plates - Type 2', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1099, N'7-001-039', N'Lifting Axle Bracket', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1100, N'7-001-040', N'Henred Lead Pipes - 180 Degr', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1101, N'7-001-040', N'Henred Lead Pipes', 12, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1102, N'7-002-001', N'SAF Disk Axle ZI9-IO42 1920/1000 Overslung', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1103, N'7-002-002', N'SAF Disk Axle ZI9-IU42 1920/1000 Underslung', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1104, N'7-002-003', N'SAF Air Spring SAF 2619V Airbag', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1105, N'7-012-001', N'SAF Sauer Axles Overslung', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1106, N'7-012-002', N'SAF Sauer Axles Underslung', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1107, N'7-112-001', N'SAF Sauer Axles Overslung - Storage', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1108, N'7-112-002', N'SAF Sauer Axles Underslung - Storage', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1109, N'7-002-001', N'SAF Disk Axle ZI9-IO42 1920/1000 Overslung - Storage', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1110, N'7-002-002', N'SAF Disk Axle ZI9-IU42 1920/1000 Underslung - Storage', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1111, N'7-002-001', N'SAF Disk Axle ZI9-IO42 2040/1000 Overslung - Storage', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1112, N'7-002-002', N'SAF Disk Axle ZI9-IU42 2040/1000 Underslung - Storage', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1113, N'7-012-003', N'SAF Sauer Airbags', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1114, N'7-002-004', N'SAF Airbags Plates', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1115, N'7-012-004', N'SAF Sauer Spacer Plates', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1116, N'7-022-004', N'SAF Sauer Spacer Plates - Flat', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1117, N'7-002-005', N'Wheelnuts ', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1118, N'7-002-006', N'Intra Lift 1 x side Lifting Axle bracket 300H', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1119, N'7-002-016', N'Intra Lift 1 x side Lifting Axle bracket 200H', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1120, N'7-002-007', N'Tyre Pilot Kit S/SI', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1121, N'7-002-008', N'Trailer Basic Kit - Compressor', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1122, N'7-002-009', N'Gauge Kit', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1123, N'7-002-010', N'Hubometer', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1124, N'7-002-011', N'Hubometer Curved Bracket SZ Bracket', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1125, N'7-002-012', N'Hubometer Hubcap - Factory Shop', 13, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1126, N'7-002-015', N'Axle Kit Tyre Pilot S/SI Comp (Set Single)', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1127, N'7-002-016', N'Axle Kit Tyre Pilot Z/ZI Comp Set (Dual)', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1128, N'7-002-017', N'Connecting Lead Rotor/Valve Eto - 180 Deg', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1129, N'7-002-018', N'Double DiaphragmBrake Chamber 16/24''', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1130, N'7-002-019', N'Excentric Washer 102 x 20', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1131, N'7-002-020', N'Hanger Bracket -200H- - Factory Shop', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1132, N'7-002-021', N'Hanger Bracket -300H- - Factory Shop', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1133, N'7-002-022', N'Hex Bolt Complete M30 x 205 (Pivot Bolt) - Factory Shop', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1134, N'7-002-023', N'Hup Cap S/Z/Zi/Bi - BI - TIRE,PI pilot 01 Met Gatjie', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1135, N'7-002-024', N'Hup Cap S/Z/Zi/Bi - BI - TIRE,PI pilot 01 Sonder Gatjie', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1136, N'7-002-025', N'Nut M22x1,5x27H/SW32', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1137, N'7-002-027', N'Rotor (Psi 31317-04-S-R L=150 mm)', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1138, N'7-002-028', N'Rotor For Duals 6"', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1139, N'7-002-029', N'Shock Absorber 130 HUB, -CD-', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1140, N'7-002-030', N'Shock Bolts Short M20 x 125 (Assembly)', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1141, N'7-002-031', N'Shock Bolts Long M20 X 1.5 X 155 (assembly', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1142, N'7-002-032', N'Shock Absorber 167 HUB, -CD-', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1143, N'7-002-033', N'Strator Pipe for Tire Pilot', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1144, N'7-002-034', N'Thrust Washer D88/30,5 x 20', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1145, N'7-002-035', N'Washer 170/60,5 x 5', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1146, N'7-002-037', N'Low Maintance Fifth Wheel SAF', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1147, N'7-002-038', N'Brake Pad Set - SBS 2220HO1', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1148, N'7-002-039', N'Air Spring SAF 2619V Airbag R1900-25%', 14, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1149, N'8-000-001', N'Bolt Kit 1 - Tarps', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1150, N'8-000-002', N'Bolt Kit 2 - Fifth Wheel', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1151, N'8-000-003', N'Bolt Kit 3 - Finals Mudflaps', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1152, N'8-010-003', N'Bolt Kit 3 - Finals Mudflaps Bracket', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1153, N'8-000-004', N'Bolt Kit 4 - Spare Wheel Carrier', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1154, N'8-000-005', N'Bolt Kit 5 - Finishes', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1155, N'8-000-006', N'Bolt Kit 6 - Hydraulics', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1156, N'8-000-007', N'Bolt Kit 7 - Brakes', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1157, N'8-000-008', N'Bolt Kit 8 - Electrical', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1158, N'8-010-008', N'Bolt Kit 8 - TRM Ratel', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1159, N'8-020-008', N'Bolt Kit 8 - TRM Standard', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1160, N'8-000-009', N'Bolt Kit 9 - Bumper Bolts', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1161, N'8-000-011', N'Bolt Kit 10 - Landing Leg Mounting Bolts', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1162, N'8-010-011', N'Bolt Kit 11 - HF pumping', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1163, N'8-000-012', N'Huck Bolt Kit ready - Swagefast', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1164, N'8-000-013', N'Huck Bolt Kit Stock - Swagefast', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1165, N'8-000-014', N'16 B13', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1166, N'8-000-015', N'16 CF', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1167, N'8-000-016', N'22 B114', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1168, N'8-000-017', N'22 B19', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1169, N'8-000-018', N'22 CF', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1170, N'8-000-019', N'16B13G - Push bar Huck Bolts', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1171, N'8-000-020', N'Huck Bolt Kit ready - China', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1172, N'8-000-021', N'16 B13 - China', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1173, N'8-000-022', N'16 CF - China', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1174, N'8-000-023', N'22 B114 - China', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1175, N'8-000-024', N'22 B19 - China', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1176, N'8-000-025', N'22 CF - China', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1177, N'8-000-027', N'King Pins - Jost', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
GO
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1178, N'8-010-027', N'Container Lock', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1179, N'8-010-028', N'Weld on Load Winch', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1180, N'8-010-029', N'Drop Side - Wedge', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1181, N'8-010-030', N'R - Clamp 6mm', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1182, N'8-010-031', N'Split Pin 6mm', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1183, N'8-000-030', N'12mm Geel PVC Pyp', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1184, N'8-000-031', N'12mm Rooi PVC Pyp - 4 AS Waens', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1185, N'8-000-032', N'12mm Swart PVC Pyp - N/A', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1186, N'8-000-033', N'15mm Swart PVC Pyp', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1187, N'8-000-034', N'8mm Blou PVC Pyp', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1188, N'8-000-035', N'8mm Geel PVC Pyp', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1189, N'8-000-036', N'8mm Rooi PVC Pyp', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1190, N'8-000-038', N'Knorr Brake kit Complete - EBS 411', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1191, N'8-000-039', N'Knorr Brake kit Complete - EBS 412', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1192, N'8-123-039', N'Knorr Brake kit Complete - Mechanical', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1193, N'8-110-039', N'Knorr Brake kit Complete - EBS 715', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1194, N'8-171-540', N'Knorr Brake kit Complete - Tautliner', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1195, N'8-216-840', N'Knorr Brake kit Complete - End Tipper', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1196, N'8-100-039', N'Knorr Brake kit Complete - 9 Axle EBS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1197, N'8-100-040', N'Airtanks', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1198, N'8-100-041', N'Airtanks - 60L', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1199, N'8-100-240', N'Knorr - T.I.M (Tyre Info Module}', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1200, N'8-100-241', N'Double Check Valve Packet - Macdonalds', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1201, N'8-100-242', N'EBS Sensor Cable', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1202, N'8-030-040', N'Haldex Leader Valve', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1203, N'8-030-041', N'Haldex Follower Valve', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1204, N'8-030-042', N'Haldex Leader Kit', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1205, N'8-030-043', N'Haldex Follower Kit', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1206, N'8-030-044', N'Haldex Leader Connection Kit', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1207, N'8-020-040', N'Henred Brake kit - Follower - ABS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1208, N'8-020-041', N'Henred Brake kit - Leader - ABS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1209, N'8-000-043', N'Spiral Bind 12mm x 25m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1210, N'8-010-043', N'Spiral Bind - Macdonalds 24mm x 30m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1211, N'8-000-044', N'2 Core Wire - 30m - PBS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1212, N'8-000-045', N'7 Core wire Spool = 1000m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1213, N'8-000-046', N'7 Core wire 30m roll', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1214, N'8-000-047', N'Cable ties 100 per pack', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1215, N'8-000-048', N'Cable ties loose', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1216, N'8-000-049', N'Chevron', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1217, N'8-000-050', N'Connector blocks', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1218, N'8-000-051', N'Female plugs', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1219, N'8-000-052', N'Heat shrink - Roll', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1220, N'8-000-053', N'Insulation tape', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1221, N'8-000-054', N'Junction boxes - Ou Voorraad', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1222, N'8-000-055', N'License holders', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1223, N'8-000-056', N'Rubber Lightbox rubbers - NR 1 Halfmoon', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1224, N'8-000-057', N'Rubber Lightbox rubbers - NR 3 Leader Lightbox', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1225, N'8-000-058', N'Marker Lights/Arial Lights LHS - Repairs', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1226, N'8-000-059', N'Marker Lights/Arial Lights RHS - Repairs', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1227, N'8-000-062', N'Mono revits', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1228, N'8-010-062', N'Sikaflex', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1229, N'8-000-063', N'Number plate lights - Wonderlite', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1230, N'8-000-064', N'Reflective tape - 75m per link', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1231, N'8-001-064', N'Reflective tape - Red', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1232, N'8-000-065', N'Reflectors Red', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1233, N'8-010-065', N'Reflectors Amber - PBS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1234, N'8-000-066', N'Reflectors White', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1235, N'8-000-067', N'Marker Light Brackets', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1236, N'8-000-067', N'Marker Light Rubber Grommets', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1237, N'8-000-068', N'Side Marker Lights - Amber - PBS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1238, N'8-000-069', N'Side Marker Lights - White', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1239, N'8-000-070', N'Green ABS Light', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1240, N'8-000-071', N'10mm P-Clamp', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1241, N'8-000-072', N'Wonderlites', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1242, N'8-013-072', N'Wonderlites - Stock Off site', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1243, N'8-011-072', N'Wonderlites - Cover Rings', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1244, N'8-010-072', N'Harntec Kit', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1245, N'8-012-072', N'Harness Kit - Advance Harnessing', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1246, N'8-020-072', N'Harntec Plugs', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1247, N'8-030-072', N'Harntec Splitter Cable - Marker Ligte', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1248, N'8-000-073', N'Grommets 2.5cm', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1249, N'8-000-074', N'Grommets 2cm', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1250, N'8-010-074', N'Strobe Light - PBS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1251, N'8-010-072', N'Henred LED Lights', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1252, N'8-010-063', N'Henred Number plate lights', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1253, N'8-111-072', N'Sealing Foam Tape - Nuwe Lightboxes', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1254, N'8-000-075', N'Fifth Wheel Jost - Low Maintance 37C - With Vesconite', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1255, N'8-010-075', N'Jost Landing leg sets', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1256, N'8-000-077', N'Fifth Wheel - 37C Standard - Sell for Commercial', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1257, N'8-000-079', N'Catwalk rubber - NR 4', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1258, N'8-000-080', N'Fire Extinguisher Boxes', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1259, N'8-000-081', N'Fire Extinguishers', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1260, N'8-000-082', N'Grease nippels M8 X 45°', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1261, N'8-000-082', N'Grease nippels M10 Straight', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1262, N'8-010-082', N'Grease nippels M10 X 45° (Interpump)', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1263, N'8-000-083', N'Hydraulic Cylinders - Jost Production', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1264, N'8-010-083', N'Hydraulic Cylinders - Interpump Production', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1265, N'8-000-084', N'Hydraulic Cylinders - Hydroscand Production', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1266, N'8-000-085', N'Complete Hydraulic Kit Ratel', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1267, N'8-000-086', N'Complete Hydraulic STD', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1268, N'8-100-087', N'Hydraulic Kit Duisend Poot - Hydroscand', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1269, N'8-000-087', N'Hydraulic Kit Ratel Leader Fittings', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1270, N'8-000-088', N'Hydraulic Kit Ratel Follower Fittings', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1271, N'8-000-089', N'Hydraulic Kit Ratel hoses', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1272, N'8-000-090', N'Hydraulic Kit STD Leader Fittings', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1273, N'8-000-091', N'Hydraulic Kit STD Follower Fittings', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1274, N'8-000-092', N'Hydraulic Kit STD hoses', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1275, N'8-100-090', N'Hydraulic Kit Duisend Poot Leader Fittings', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1276, N'8-100-091', N'Hydraulic Kit Duisend Poot Follower Fittings', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1277, N'8-100-092', N'Hydraulic Kit - Duisend Poot Hoses', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
GO
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1278, N'8-100-092', N'Hydraulic Modification Kit', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1279, N'8-333-009', N'Ratel Steel Tubing Kit', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1280, N'8-000-095', N'Hydraulic Oil - 20L Dromme', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1281, N'8-000-096', N'Hydraulic Steel tubing', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1282, N'8-010-096', N'Flat face Coupling Set', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1283, N'8-030-097', N'S Bent pipes', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1284, N'8-040-098', N'Leader 05 Pipes - Ratel', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1285, N'8-000-098', N'Crossby clamps', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1286, N'8-000-099', N'Spare wheel cable 1.5m Cut to size', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1287, N'8-000-100', N'Spare wheel Cable 100m Roll - Meters', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1288, N'8-000-101', N'Rubbers Spare wheel rubber - NR 2', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1289, N'8-000-102', N'Spare wheel winch', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1290, N'8-000-104', N'Ratchets', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1291, N'8-000-113', N'Perspex mudflaps - Leader', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1292, N'8-010-113', N'Perspex mudflaps Short - Leader', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1293, N'8-012-113', N'Perspex mudflaps - Izusa', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1294, N'8-020-113', N'Perspex mudflaps - Kego', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1295, N'8-000-112', N'Straps', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1296, N'8-000-114', N'Tyre Brackets Rampie', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1297, N'8-000-105', N'Shock cord for tarps', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1298, N'8-000-106', N'Feruls', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1299, N'8-000-107', N'Tarps - Dumbo - Swart 7,4m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1300, N'8-010-107', N'Tarps - Dumbo - Swart 7,1m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1301, N'8-000-108', N'Tarps - E-Line Gekleur', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1302, N'8-000-109', N'Tarps - E-Line Swart', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1303, N'8-000-110', N'Tarps - Ratel Swart 5,8m F-line', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1304, N'8-010-110', N'Tarps - Worshond - swart HK', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1305, N'8-000-111', N'Tarps - Worshond - swart', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1306, N'8-000-115', N'Tarps - Izusa Blou 45m3', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1307, N'8-010-115', N'Tarps - E-Line Blou', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1308, N'8-000-116', N'Tarps - E-Line Swart - "GRAINTRANS"', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1309, N'8-000-117', N'Tarps - End Tipper 11,6m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1310, N'8-000-118', N'Tarps - E-Line Rooi', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1311, N'8-000-119', N'Tarps - Ratel Gekleur', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1312, N'8-000-120', N'Tarps - Ratel Lig groen', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1313, N'8-000-121', N'Tarps - Ratel Blou', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1314, N'8-000-122', N'Tarps Black as per spec - PBS 9,15m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1315, N'8-010-123', N'Tarps Black E-Line 8,8m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1316, N'8-020-123', N'Tarps Black E-Line 8,5m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1317, N'8-021-123', N'Tarps Black F-Line 8,7m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1318, N'8-020-124', N'HWP4 Black tarps 9,26m', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1319, N'8-000-123', N'Chassis Sticker Kit', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1320, N'8-000-131', N'80km sticker for Pedatals', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1321, N'8-000-132', N'Bin Elephants Yellow LHS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1322, N'8-010-132', N'Bin Elephants Yellow RHS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1323, N'8-000-133', N'Bin Elephants Red LHS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1324, N'8-010-133', N'Bin Elephants Red RHS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1325, N'8-000-134', N'Bin Elephants Black LHS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1326, N'8-010-134', N'Bin Elephants Black RHS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1327, N'8-000-135', N'Bin Elephants Silver LHS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1328, N'8-010-135', N'Bin Elephants Silver RHS', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1329, N'8-010-136', N'C.O.F Sticker', 15, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1330, N'9-000-001', N'M8 Speednut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 28)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1331, N'9-000-002', N'Pop rivits Large Flange', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1332, N'9-000-003', N'Pop rivits Blind flange 4,8mm', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 1)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1333, N'9-000-004', N'M8 x 90', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1334, N'9-000-005', N'M8 x 75', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1335, N'9-000-006', N'M8 x 60', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1336, N'9-000-007', N'M8 x 40', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1337, N'9-000-008', N'M8 x 35', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1338, N'9-000-009', N'M8 x 25', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1339, N'9-000-010', N'M8 x 20', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1340, N'9-000-011', N'M8 Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1341, N'9-000-012', N'M8 Loc Nut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1342, N'9-000-013', N'M6 X 50', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1343, N'9-010-013', N'M6 Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1344, N'9-000-014', N'M6 Speed nut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1345, N'9-000-015', N'M6 Fender Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1346, N'9-000-016', N'M5 X 50', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1347, N'9-010-016', N'M5 X 15', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1348, N'9-000-017', N'M5 speednut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1349, N'9-010-017', N'M5 Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1350, N'9-000-018', N'M5 Fender Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1351, N'9-000-019', N'M16 x 60', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1352, N'9-000-020', N'M16 x 50', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1353, N'9-000-021', N'M16 x 40', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1354, N'9-000-022', N'M16 Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1355, N'9-000-022', N'M16 Speed Nut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1356, N'9-000-024', N'M16 Loc Nut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1357, N'9-000-025', N'M14 x 40', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1358, N'9-000-026', N'M14 Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1359, N'9-000-027', N'M14 Loc Nut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1360, N'9-000-028', N'M12 x 40', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1361, N'9-000-029', N'M12 Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1362, N'9-000-030', N'M12 Loc Nut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1363, N'9-000-031', N'M10 x 90', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1364, N'9-000-032', N'M10 x 75', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1365, N'9-000-033', N'M10 x 40', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1366, N'9-000-034', N'M10 x 25', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1367, N'9-000-035', N'M10 Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1368, N'9-000-036', N'M10 Loc Nut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1369, N'9-000-037', N'M10 Fender Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1370, N'9-000-038', N'M10 Speed Nuts - Lightboxes', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1371, N'9-000-039', N'M12 Speed Nuts', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1372, N'9-000-040', N'M12 x 90', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1373, N'9-000-041', N'M5 Loc Nut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1374, N'9-000-042', N'M6 x 100', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1375, N'9-000-043', N'M6 x 40', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1376, N'9-000-044', N'M6 x 30', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1377, N'9-000-045', N'M6 Loc nut', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
GO
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1378, N'9-000-046', N'M22 Washers - Huck Bolts', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1379, N'9-000-047', N'M12 x 120 - Flatdeck Container Locks', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1380, N'9-000-048', N'M8 Fender Washer', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1381, N'9-000-049', N'M10 Spring Washer - Nuwe Light boxes', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1382, N'9-000-050', N'M16 x 100', 16, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1383, N'9-001-001', N'ABS Socket - Repairs', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1384, N'9-001-002', N'Double Check Valve - Knorr', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1385, N'9-001-003', N'Double Check Valve - Wabco', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1386, N'9-001-004', N'Hydraulic Cylinders - Spare', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1387, N'9-001-005', N'Female Hydraulic Coupling Ball Type - Repairs', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1388, N'9-001-006', N'Hydraulic Bulkhead', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1389, N'9-001-007', N'Male Hydraulic Coupling Ball Type - Repairs', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1390, N'9-301-007', N'Male to Male Elbow fitting', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1391, N'9-001-008', N'Non return valve', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1392, N'9-001-009', N'Swivel T', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1393, N'9-001-010', N'Fifth Wheel Liner - Fabriek', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1394, N'9-111-010', N'Fifth Wheel Liner - City', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1395, N'9-001-011', N'Band Saw Blade 24mm', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1396, N'9-001-012', N'Band Saw Blade 34mm', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1397, N'9-001-013', N'2 Meter Steel Ruler', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1398, N'9-001-014', N'CNC Timing Belts for Lathe Paul ( 3/Stel)', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1399, N'9-001-015', N'CNC Timing Belts for Lathe Eric (4/Stel)', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1400, N'9-001-016', N'Toilet paper', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1401, N'9-001-020', N'Blue Air Pipe - Paint Shop', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1402, N'9-001-021', N'¼" Male Coupler', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1403, N'9-001-022', N'¼" Female Coupler', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1404, N'9-001-023', N'Female Air Hose Coupling', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1405, N'9-001-024', N'¼" Male Quick Coupler', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1406, N'9-001-026', N'¼" Female Quick Coupler', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1407, N'9-001-027', N'¼" Male Coupler', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1408, N'9-001-034', N'Jost Vesconite skids', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1409, N'9-001-036', N'Multi purpose air hose - 8mm', 17, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1410, N'9-002-001', N'12mm Click In Fitting', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1411, N'9-002-002', N'8mm Click In Fitting', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1412, N'9-002-003', N'8mm Line Connectors', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1413, N'9-002-004', N'Air Tank Stopper', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1414, N'9-002-005', N'Charge Valve', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1415, N'9-002-006', N'F Piece', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1416, N'9-002-007', N'Leveling Valve', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1417, N'9-002-008', N'Lifting Axle valve', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1418, N'9-012-008', N'Diff Lock Switch', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1419, N'9-112-008', N'T Piece', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1420, N'9-002-010', N'Electrical Suzy', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1421, N'9-012-010', N'ABS Suzy', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1422, N'9-019-010', N'Scania Suzy - 101-403', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1423, N'9-002-011', N'Flux', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1424, N'9-002-012', N'LCG Box', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1425, N'9-002-013', N'Max Lamp Lights', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1426, N'9-002-014', N'Reverse Lights', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1427, N'9-002-016', N'Trailink Extention', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1428, N'9-002-017', N'Tommy Bar Wheel Spanner - Silver without Bar', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1429, N'9-002-018', N'Tommy Bar Wheel Spanner - Black with Bar', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1430, N'9-002-019', N'Tommy Bar Wheel Spanner - Black without Bar', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1431, N'9-002-020', N'Warning Triangles', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1432, N'9-002-022', N'Large Hose Clamp', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1433, N'9-002-023', N'Medium Hose Clamp', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1434, N'9-002-024', N'Small Hose Clamp Dia 10-12mm', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1435, N'9-002-025', N'Anti Freeze - Litres', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1436, N'9-002-026', N'Distilled Water - 5L', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1437, N'9-002-027', N'Tool in a Can - Q20', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1438, N'9-002-028', N'Blue Oxygen Hose', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1439, N'9-002-029', N'Bubble Wrap', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1440, N'9-002-030', N'Hinges', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1441, N'9-002-032', N'Graphite Grease 20 kg', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1442, N'9-002-033', N'Window Leen', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1443, N'9-002-034', N'Sunlight soap', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1444, N'9-002-036', N'Hand Sanitizer', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1445, N'9-002-037', N'Engin Oil - 15W-40 (Diesel)', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1446, N'9-002-038', N'Degreaser', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1447, N'9-002-039', N'Black Dip', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1448, N'9-002-040', N'Plastic Wrap', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1449, N'9-002-041', N'4.5kg Fire exstinguisher Bracket', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1450, N'9-002-042', N'Lithium Grease', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1451, N'9-002-043', N'Lithium Grease - RIL', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1452, N'9-002-044', N'Soluable oil', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1453, N'9-002-045', N'15 to 7 Pin Cable', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1454, N'9-002-046', N'7 SA TO 7 Euro Cable', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1455, N'9-002-047', N'Hand grit soap', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1456, N'9-002-048', N'Short Green Welding Gloves', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1457, N'9-012-048', N'Long Green Welding Gloves', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1458, N'9-013-048', N'Extra Long Green Welding Gloves', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1459, N'9-002-049', N'Leather yoke', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1460, N'9-002-050', N'Leather apron', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1461, N'9-002-062', N'Recovery Microdots', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1462, N'9-002-066', N'Domestos/Bleach', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1463, N'9-002-067', N'Car Shampoo', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1464, N'9-012-067', N'Tile Cleaner', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1465, N'9-012-068', N'Broom', 18, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1466, N'9-003-000', N'Lifting Axle Bracket - SAF', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1467, N'9-003-001', N'Park Shunt valve', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1468, N'9-003-002', N'Daken Toolbox - 130L - Rudwes', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1469, N'9-013-002', N'Daken Toolbox - Tautliner', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1470, N'9-003-003', N'Mondo Axle hangers', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1471, N'9-003-004', N'Anti Loose - Hazchem', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1472, N'9-003-005', N'Tyre valve for Rims', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1473, N'9-003-006', N'Tyre valve for Rims - 45 Deg', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1474, N'9-003-007', N'Henred brake Booster - Service exchange', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1475, N'9-003-008', N'Tyre Valve extentions Long 245', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1476, N'9-003-009', N'Tyre Valve extentions Short 175', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1477, N'9-003-010', N'Tyre Valve extentions Short 100', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
GO
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1478, N'9-003-011', N'Tyre Valve inserts', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1479, N'9-003-012', N'License plate holder - Large', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1480, N'9-003-013', N'License plate holder - Standard', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1481, N'9-003-014', N'Small Trailer Hook', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1482, N'9-003-016', N'SAF Wheel Spring', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1483, N'9-003-017', N'Trailing arm Henred - Factory Shop', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1484, N'9-003-018', N'Back up Alarm', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1485, N'9-003-019', N'Fuses 10 AMP', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1486, N'9-003-020', N'Fuses 10 AMP - small blade', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1487, N'9-003-021', N'Fuses 15 AMP', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1488, N'9-003-022', N'Fuses 15 AMP - small blade', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1489, N'9-003-023', N'Doom', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1490, N'9-003-024', N'Copper Compound', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1491, N'9-003-025', N'Funnel', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1492, N'9-003-026', N'Small Hand brush', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1493, N'9-003-027', N'Cleaning Thinners', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1494, N'9-003-028', N'Parafin', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1495, N'9-003-029', N'First Aid Box', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1496, N'9-003-030', N'First Aid Box - Refil', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1497, N'9-003-031', N'Quick Fitting Suzi Suspension spring', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1498, N'9-003-032', N'Water Bottle 10L - Tanvicor', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1499, N'9-003-033', N'Air Test point fitting', 19, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1500, N'9-004-000', N'150 Pipe Bender', 20, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1501, N'9-004-001', N'125 Press Brake - Arrived', 20, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1502, N'9-004-002', N'Huck Bolt Guns - Arrived', 20, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1503, N'9-004-003', N'Spray Booth - Arrived', 20, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1504, N'9-005-001', N'Allminium Truck Fender', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1505, N'9-005-003', N'Bridgestone 225/60 R18 Tyre Only', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1506, N'9-005-004', N'Brown Earth Cable', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1507, N'9-005-005', N'SAF Sub Pumping Kit', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1508, N'9-005-006', N'Conveyor Rubber', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1509, N'9-005-007', N'Salsa 100L Container', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1510, N'9-005-008', N'Hydraulic clamp press', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1511, N'9-005-009', N'Connector blocks small - Black', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1512, N'9-005-010', N'Connector blocks small - White', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1513, N'9-005-011', N'Sample Cable', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1514, N'9-005-012', N'Toilet', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1515, N'9-005-013', N'Toilet flush system', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1516, N'9-005-014', N'Toilet seat', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1517, N'9-005-015', N'4 Bar Quart Heaters', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1518, N'9-005-016', N'Red Toolbox', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1519, N'9-005-017', N'Blue Storage box', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1520, N'9-005-018', N'Stand Drill', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1521, N'9-005-019', N'Hack saw', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1522, N' 	', N'Torque wrench - Factory Shop', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1523, N'9-005-025', N'Painters tray', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1524, N'9-005-026', N'Grease gun', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1525, N'9-005-027', N'Forklift exshaut Tip', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1526, N'9-005-028', N'Waterproofing Membrane', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1527, N'9-005-029', N'Huckbolt gun replacment hoses and power cable set', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1528, N'9-005-030', N'BPW Airbags - Damaged Base Plates', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1529, N'9-005-031', N'Airbags Vectors V940 C', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1530, N'9-005-032', N'Wewler TQ24392', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1531, N'9-005-033', N'Airbag Vector V810', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1532, N'9-005-034', N'Tyre Cage', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1533, N'9-005-035', N'Orange Junction Boxes - DB Board Type', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1534, N'9-005-036', N'Ampco 3 Phase Wall plug 63V', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1535, N'9-005-037', N'Old Mig welding wire - Mixed type - Factory Shop', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1536, N'9-005-038', N'Old Stainless Steel welding wire - Mixed type', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1537, N'9-005-039', N'Graphite Spray', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1538, N'9-005-040', N'Springs - For Tankers - As per Edward Phiri', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1539, N'9-005-041', N'Spare Wheel plates - Factory Shop', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1540, N'9-005-042', N'SAF Lifting Bellows - 2nd Hand', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1541, N'9-005-043', N'1m Steel cable off cuts', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1542, N'9-005-044', N'Draw Compound', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1543, N'9-005-045', N'Blue Pickling Paste', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1544, N'9-005-046', N'Tape Dispenser', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1545, N'9-005-047', N'Sanitizing Spray stand', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1546, N'9-005-048', N'15 Ton Hydraulic Pipe Bender', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1547, N'9-005-049', N'Jost Fifth Wheel Mounts', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1548, N'9-005-050', N'SAF Spacer Plates - Flats', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1549, N'9-005-051', N'SAF Spacer Plates - Big', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1550, N'9-005-052', N'Snap Boards', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1551, N'9-005-053', N'Interpump - Hydraulic Test Kit', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1552, N'9-005-054', N'Lock nut Keys - Self made - Factory Shop', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1553, N'9-005-055', N'SAF King Pin - Retention Plate', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1554, N'9-005-056', N'30m Tape', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1555, N'9-005-057', N'Replacement Fuel Cap', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
INSERT [dbo].[parts] ([id], [partNumber], [name], [partsCategoryID], [description], [price], [expectedStock], [stockOnHand]) VALUES (1556, N'11-000-000', N'Current value of Stock at City', 21, N'', CAST(150.0000 AS Decimal(19, 4)), 110, 30)
SET IDENTITY_INSERT [dbo].[parts] OFF
GO
SET IDENTITY_INSERT [dbo].[partsCategory] ON 

INSERT [dbo].[partsCategory] ([id], [name]) VALUES (1, N'Paintshop - Consumables')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (2, N'Paintshop - Mixing Room')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (3, N'Diesel')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (4, N'Tyres and Rims  LTB')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (5, N'Tyres and Rims  Rubber 2 Metal')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (6, N'Steel')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (7, N'Hollow Bar / Pins and bushes')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (8, N'Gas  Welding and Abrasives')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (9, N'Axles')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (10, N'BPW Parts')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (11, N'Henred')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (12, N'HF  Axles Complete Sets For a Link')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (13, N'SAF')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (14, N'Saf Parts at LTF')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (15, N'Kits')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (16, N'Nuts & Bolts and Spares')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (17, N'Stoor Spares')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (18, N'Stoor - Misc')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (19, N'New Added parts')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (20, N'In Transit Stock')
INSERT [dbo].[partsCategory] ([id], [name]) VALUES (21, N'Groot Stoor')
SET IDENTITY_INSERT [dbo].[partsCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[partsMovement] ON 

INSERT [dbo].[partsMovement] ([id], [price], [stockOnHand], [partsID], [dateAltered]) VALUES (1, CAST(150.0000 AS Decimal(19, 4)), 50, 779, CAST(N'2025-01-24T21:15:16.373' AS DateTime))
INSERT [dbo].[partsMovement] ([id], [price], [stockOnHand], [partsID], [dateAltered]) VALUES (2, CAST(150.0000 AS Decimal(19, 4)), 49, 779, CAST(N'2025-01-24T21:15:26.200' AS DateTime))
INSERT [dbo].[partsMovement] ([id], [price], [stockOnHand], [partsID], [dateAltered]) VALUES (3, CAST(150.0000 AS Decimal(19, 4)), 29, 780, CAST(N'2025-01-24T22:04:45.083' AS DateTime))
INSERT [dbo].[partsMovement] ([id], [price], [stockOnHand], [partsID], [dateAltered]) VALUES (4, CAST(150.0000 AS Decimal(19, 4)), 29, 1330, CAST(N'2025-01-24T22:06:33.077' AS DateTime))
INSERT [dbo].[partsMovement] ([id], [price], [stockOnHand], [partsID], [dateAltered]) VALUES (5, CAST(150.0000 AS Decimal(19, 4)), 28, 1330, CAST(N'2025-01-24T22:06:39.517' AS DateTime))
INSERT [dbo].[partsMovement] ([id], [price], [stockOnHand], [partsID], [dateAltered]) VALUES (9, CAST(150.0000 AS Decimal(19, 4)), 29, 779, CAST(N'2025-01-24T22:41:47.330' AS DateTime))
INSERT [dbo].[partsMovement] ([id], [price], [stockOnHand], [partsID], [dateAltered]) VALUES (6, CAST(150.0000 AS Decimal(19, 4)), 1, 1332, CAST(N'2025-01-24T22:06:48.467' AS DateTime))
INSERT [dbo].[partsMovement] ([id], [price], [stockOnHand], [partsID], [dateAltered]) VALUES (7, CAST(150.0000 AS Decimal(19, 4)), 45, 779, CAST(N'2025-01-24T22:26:30.367' AS DateTime))
INSERT [dbo].[partsMovement] ([id], [price], [stockOnHand], [partsID], [dateAltered]) VALUES (8, CAST(150.0000 AS Decimal(19, 4)), 30, 796, CAST(N'2025-01-24T22:27:22.870' AS DateTime))
SET IDENTITY_INSERT [dbo].[partsMovement] OFF
GO
INSERT [dbo].[Roles] ([id], [description]) VALUES (N'649b9982-c825-4f35-b57f-f53776af4fc4', N'test')
GO
INSERT [dbo].[Users] ([id], [username], [password], [roleID]) VALUES (N'ccd5df15-7fc7-42a5-ae97-d5aa8a79a74f', N'123', N'$2a$11$lsnNurxIPQ6bYiopyub9mOVbz1Nbg8zyAIBWVrovgUPb0qRuzauFG', N'649b9982-c825-4f35-b57f-f53776af4fc4')
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
/****** Object:  StoredProcedure [dbo].[sp_create_user]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_delete_user]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_userPassword]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_users]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_usersMaxPaging]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_insert_audit]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_insert_partsMovement]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_update_parts]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_update_userDetails]    Script Date: 2025/01/27 22:03:43 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_update_userPassword]    Script Date: 2025/01/27 22:03:43 ******/
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
