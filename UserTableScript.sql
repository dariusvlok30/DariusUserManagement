USE [DariusInternship]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 23/10/2024 3:04:13 pm ******/
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
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'b5b77f81-4481-4f4e-a5fe-edc1154ae61d', N'Darius', N'$2a$11$5xaVl5b/GABz8dbUV.IX7ODkQe6/c6P5galinC0sxLwcT3ohpwaGG')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'd120b045-893c-4e2d-a8c5-e70afe7384c1', N'1', N'$2a$11$HJhuPAC5dOFliD/wKlKzG.cDR.3NcrfzlD5HqgNCARltjfEnng.we')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'2c31a860-e614-4e46-a4cc-9fe40e76e9f4', N'2', N'$2a$11$GFaaRaDM2owyqlQFWMKAAubgG.Y/mf0DHWsOVQvx2/9vSwkDUn0.e')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'bb76d142-73f0-4e0b-a07e-c115f0d7ec4e', N'123', N'$2a$11$1FrMGTTw9kkZ8ITX/qlAe.Wbm7G2Cwpnulspb.GysrsHzekge0/4C')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'523b8473-64d7-4c78-ab77-5364c5c7d84e', N'3', N'$2a$11$N1Jv67EGXOVbe/W.8XHkU.xOLdByhpr2Ng6oq4pmmH.Ztod1ynyPO')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'c7829524-f242-4cac-b9c3-59b36c584694', N'4', N'$2a$11$i9gVEaM165viknukoaTT9u9YYisxjcYfciiWDgKsMgGHMrfwDPi2G')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'9b72c2ff-4b7c-474b-95e7-b71ac4ae19ed', N'5', N'$2a$11$Pl5QgSFIjxDWD1EXmgBV2.jQqTnV12eryD/ZzEdXKktg0UUzMaSMq')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'bbec7b70-82ea-4e43-abd1-f446555d8f2b', N'6', N'$2a$11$K.S4O3DIPtm63NkoQzpPru4c5IXlVr/nUP1tSNlLtWuORGoa0gLcW')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'f070ad30-89ef-46c8-9f43-3058ea56046d', N'7', N'$2a$11$nFzTP0mJvfoJivDiODlupuxQdt2hFnLKtPkBhEOr9EpFumFbt1zt2')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'97c65bd9-4da1-4835-935c-1aa7db0f0643', N'8', N'$2a$11$ebRACdrE5zBmo8Tno5rqSeomozdamkPwvgNHLoKb8.pOGx9LYufwy')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'015bef62-aeb6-4a6a-af9a-9aad8477f5d4', N'9', N'$2a$11$seAK6bzIhMOiJ59XUChsueW3mY6/zX4DMBRArGEbeg22GAKUF1Nvu')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'6a856ba9-e017-4de2-80b1-b8c1d8702d2c', N'10', N'$2a$11$UzyWpiT8HfBCQwRdsXmow.te3leazU.PKYhFU8Tlf0MVKevJo9byu')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'fdb9ac70-d244-405d-b449-822436c558fa', N'11', N'$2a$11$Cfr9ZI/8.5ATv92NsJkOg.AvChfjndpOQ1HXtQKqEIWU4kRRz3gMy')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'2b38c42b-240b-4556-9f34-b3e85da186b3', N'12', N'$2a$11$j0Emw/R1jp7ORdHpmZc4herz5ncoXzNxs9H.GB4VHoTzZwWvQTCA.')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'2188ce16-66c4-4d95-983d-a0a09e74e4c9', N'13', N'$2a$11$eF2Uz.Hbj6LUTi/ujhoCfuUsn3o7.EEIjhKYGeLJwfNL98ZEbZEb2')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'856ec257-8103-43b9-bc55-41e80492db30', N'14', N'$2a$11$bMi7W2m4UDsWHs8MpM8vpuiWBOGTo2OeeEP2fs3qFAfkQxfnoS4Wq')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'2b62b8e8-e409-493b-8d42-9999e37ed6ae', N'15', N'$2a$11$eXvyBezS51DsKheOl2LLpu8yPPmlbcn4ZWCojDTWa6Ngxi7aYw7Va')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'a7bfd1db-2078-4b75-a04d-c2c3f3b188e8', N'16', N'$2a$11$oSLgYaMQJeY0HkD3F/2RluUw8rAVJBjI15wS94LZ7dafTn4aDaloK')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'ea4ca949-f7b0-40a9-9f31-f6acfc4165e3', N'17', N'$2a$11$mTwZewPGCidyVFRhgJsnkuNBHLfKeS/KdIM1kL/GHCNrDjGvyhWau')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'28b515ff-4437-4ece-97de-be55fe7c88ee', N'18', N'$2a$11$5qo7iB/cqz0Hf/gLiNxsBOVnWZl2kOljnQVFtb9/070dLj.Y.D8gS')
INSERT [dbo].[Users] ([id], [username], [password]) VALUES (N'5c5bd1ef-5f6b-4617-a4be-b4fe72a039b3', N'x', N'$2a$11$L1JOhQ2Tx6kb.aLLxPA9RO4PNTUc01/9xQ2tus4noBe9uTYTLUXta')
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (newid()) FOR [id]
GO
/****** Object:  StoredProcedure [dbo].[sp_create_user]    Script Date: 23/10/2024 3:04:13 pm ******/
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
/****** Object:  StoredProcedure [dbo].[sp_delete_user]    Script Date: 23/10/2024 3:04:13 pm ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_userPassword]    Script Date: 23/10/2024 3:04:13 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_get_userPassword] 
    @username VARCHAR(50)
AS
BEGIN
		SELECT 
		[Password]
		FROM Users u
		WHERE u.[username] = @username 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_users]    Script Date: 23/10/2024 3:04:13 pm ******/
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
/****** Object:  StoredProcedure [dbo].[sp_get_usersMaxPaging]    Script Date: 23/10/2024 3:04:13 pm ******/
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
/****** Object:  StoredProcedure [dbo].[sp_update_userDetails]    Script Date: 23/10/2024 3:04:13 pm ******/
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
/****** Object:  StoredProcedure [dbo].[sp_update_userPassword]    Script Date: 23/10/2024 3:04:13 pm ******/
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
