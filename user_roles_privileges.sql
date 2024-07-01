-- user_roles_privileges.sql
-- This script sets up user roles and privileges

-- Step 1: Create Roles
-- Create a read-only role
CREATE ROLE read_only;

-- Create a read-write role
CREATE ROLE read_write;

-- Create an admin role
CREATE ROLE admin;

-- Step 2: Grant Privileges to Roles
-- Grant SELECT privilege to read_only role on hr.employees table
GRANT SELECT ON hr.employees TO read_only;

-- Grant SELECT, INSERT, UPDATE, DELETE privileges to read_write role on hr.employees table
GRANT SELECT, INSERT, UPDATE, DELETE ON hr.employees TO read_write;

-- Grant all privileges to admin role
GRANT ALL PRIVILEGES TO admin;

-- Step 3: Create Users and Assign Roles
-- Create a read-only user and assign the read_only role
CREATE USER readonly_user IDENTIFIED BY readonly_password;
GRANT read_only TO readonly_user;

-- Create a read-write user and assign the read_write role
CREATE USER readwrite_user IDENTIFIED BY readwrite_password;
GRANT read_write TO readwrite_user;

-- Create an admin user and assign the admin role
CREATE USER admin_user IDENTIFIED BY admin_password;
GRANT admin TO admin_user;

-- Step 4: Set Default Roles for Users
-- Set the default role for readonly_user
ALTER USER readonly_user DEFAULT ROLE read_only;

-- Set the default role for readwrite_user
ALTER USER readwrite_user DEFAULT ROLE read_write;

-- Set the default role for admin_user
ALTER USER admin_user DEFAULT ROLE admin;

-- Step 5: Verify Roles and Privileges
-- Verify the privileges granted to the read_only role
SELECT * FROM dba_tab_privs WHERE grantee = 'READ_ONLY';

-- Verify the privileges granted to the read_write role
SELECT * FROM dba_tab_privs WHERE grantee = 'READ_WRITE';

-- Verify the privileges granted to the admin role
SELECT * FROM dba_sys_privs WHERE grantee = 'ADMIN';

-- Verify the roles assigned to the users
SELECT * FROM dba_role_privs WHERE grantee = 'READONLY_USER';
SELECT * FROM dba_role_privs WHERE grantee = 'READWRITE_USER';
SELECT * FROM dba_role_privs WHERE grantee = 'ADMIN_USER';
