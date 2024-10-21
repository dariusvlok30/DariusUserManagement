-- create a database called "DariusInternship"

-- use this database to create the following list of tables, stored procedures and views.

-- ################################################################
-- create a [users] table with the following fields

-- ***************************
-- field details:  
-- ** name - id
-- ** relationship - primary key
-- ** datatype - uuid 
-- -- why this datatype? - int identity (1,1) is just not good enough for a massive system, especially something insurance related
-- notes: serves as the unique identifier for a user
-- ***************************

-- ***************************
-- field details:  
-- ** name - username
-- ** relationship - none
-- ** datatype - varchar(255)  
-- -- This is prettymuch the company standard for username lengths, usually its the users email address.
-- notes: This field needs to be unique, but we can cater for that using either a stored procedures for CRUD, or we can create it as a 
-- ***************************

-- ***************************
-- field details:  
-- ** name - password
-- ** relationship - none
-- ** datatype - varchar(max) 
-- -- why this datatype? - we are going to hash this password with a library called bCrypt on the application level.
-- notes: hashing is one-way, much safer than encryption. bCrypt is an  amazing hashing library.
-- ***************************

-- +++++++++++++++++++++++++++
-- create the following stored procedure for the [users] table.
-- name: sp_create_user
-- parameters:
-- ** name and datatype - @usernameVar varchar(255)
-- ** name and datatype - @encryptedPassword varchar(max) 
-- function of stored procedure
-- ** create users. ensure that the username is unique. inserts the two parameters into the 2 columns of the table.
-- +++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++
-- create the following stored procedure for the [users] table.
-- name: sp_update_userDetails
-- parameters:
-- ** name and datatype - @id uuid
-- ** name and datatype - @usernameVar varchar(255)
-- function of stored procedure
-- ** change username. ensure that the username is unique.
-- +++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++
-- create the following stored procedure for the [users] table.
-- name: sp_update_userPassword
-- parameters:
-- ** name and datatype - @id uuid
-- ** name and datatype - @encryptedPassword varchar(max) 
-- function of stored procedure
-- ** change user password.
-- +++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++
-- create the following stored procedure for the [users] table.
-- name: sp_update_userPassword
-- parameters:
-- ** name and datatype - @id uuid
-- ** name and datatype - @encryptedPassword varchar(max) 
-- function of stored procedure
-- ** change user password.
-- +++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++
-- create the following stored procedure for the [users] table.
-- name: sp_delete_user
-- parameters:
-- ** name and datatype - @id uuid
-- function of stored procedure
-- ** deletes a user.
-- +++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++
-- create the following stored procedure for the [users] table.
-- name: sp_get_userPassword
-- parameters:
-- ** name and datatype - @id uuid
-- function of stored procedure
-- ** returns the users encrypted password. This is for bCrypt to use for comparison in the backend, once the hashes match, log the user in.
-- +++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++
-- create the following stored procedure for the [users] table.
-- name: sp_get_usersMaxPaging
-- parameters:
-- ** name and datatype - @pageSize int
-- ** name and datatype - @pageFilters varchar(max)
-- function of stored procedure
-- ** returns the number of users to the frontend. return a count(*) with paging taken into account (thus the pageSize parameter).
-- for now just focus on the pageNumber and pageSize parameters, I will help you with the pageFilters and dynamic SQL later on, once you are ready, and I am happy with the frontend.
-- +++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++
-- create the following stored procedure for the [users] table.
-- name: sp_get_users
-- parameters:
-- ** name and datatype - @pageNumber int
-- ** name and datatype - @pageSize int
-- ** name and datatype - @pageFilters varchar(max)
-- function of stored procedure
-- ** returns the user details to the frontend. return the id and the username.
-- for now just focus on the pageNumber and pageSize parameters, I will help you with the pageFilters and dynamic SQL later on, once you are ready, and I am happy with the frontend.
-- +++++++++++++++++++++++++++

-- ################################################################

-- I will monitor development done on this and progress. once you are done, we can focus on user roles.


