CREATE DATABASE DariusInternship
go

USE DariusInternship
go

CREATE TABLE [Users](
	[id] [uniqueidentifier] NOT NULL,
	[username] VARCHAR(255),
	[password] VARCHAR(MAX)
)


ALTER TABLE [Users] ADD  DEFAULT (newid()) FOR [id]
GO


-- soos dit.
insert into Users
(username, [password])
values
('Darius','tmpPassword')




GO

CREATE procedure sp_create_user
	@usernameVar varchar(255)
	, @encryptedPassword varchar(max) 
as
begin
	insert into Users 
	(username, [password])
	values
	(@usernameVar,@encryptedPassword)
end
go
--exec sp_create_user 'storedProcedureUser', 'storedProcedurePassword'

CREATE procedure sp_update_userDetails
	@id [uniqueidentifier],
	@usernameVar varchar(255)
as
begin
	update Users
	set username = @usernameVar
	where id = @id
end
go

CREATE procedure sp_update_userPassword
	@id [uniqueidentifier],
	@encryptedPassword varchar(MAX)
as
begin
	update Users
	set [password] = @encryptedPassword
	where id = @id
end
go

CREATE procedure sp_delete_user
	@id [uniqueidentifier]
as
begin
	delete from Users
	where id = @id
end
go


CREATE procedure sp_get_usersMaxPaging
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
go

CREATE procedure sp_get_users
	@pageNumber int, -- page number variable/parameter
	@pageSize int, -- rows per page variable/parameter
	@pageFilters varchar(max)
as
begin
	SELECT
	*
	FROM Users 
	ORDER BY id 
	OFFSET 
	@pageNumber -- Page Number
	ROWS FETCH NEXT 
	@pageSize -- Rows Per Page
	ROWS ONLY;
end
go




	
