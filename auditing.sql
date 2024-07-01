-- auditing.sql
-- This script sets up auditing to monitor database activities

-- Step 1: Enable Unified Auditing (if not already enabled)
-- Unified Auditing is recommended for Oracle Database 12c and later
-- Check if Unified Auditing is enabled
SELECT * FROM v$option WHERE parameter = 'Unified Auditing';

-- If Unified Auditing is not enabled, follow the Oracle documentation to enable it
-- Refer to: https://docs.oracle.com/en/database/oracle/oracle-database/19/dbseg/introduction-to-unified-auditing.html

-- Step 2: Enable Specific Auditing Policies
-- Enable audit for user sessions
AUDIT SESSION BY ACCESS;

-- Enable audit for SELECT statements on specific tables
AUDIT SELECT ON hr.employees BY ACCESS;
AUDIT SELECT ON hr.departments BY ACCESS;

-- Enable audit for DML operations (INSERT, UPDATE, DELETE) on specific tables
AUDIT INSERT ON hr.employees BY ACCESS;
AUDIT UPDATE ON hr.employees BY ACCESS;
AUDIT DELETE ON hr.employees BY ACCESS;

-- Enable audit for DDL operations (CREATE, ALTER, DROP) on all objects
AUDIT CREATE TABLE BY ACCESS;
AUDIT ALTER TABLE BY ACCESS;
AUDIT DROP TABLE BY ACCESS;

-- Step 3: Verify Audit Settings
-- Check the audit settings for specific tables
SELECT audit_option, user_name, success, failure
FROM dba_stmt_audit_opts
WHERE user_name = 'HR';

-- Step 4: View Audit Trails
-- View the audit trail for all activities
SELECT username, action_name, object_name, logoff_time
FROM dba_audit_trail
ORDER BY timestamp DESC;

-- View the audit trail for specific activities
-- Example: View SELECT operations on hr.employees table
SELECT username, action_name, object_name, logoff_time
FROM dba_audit_trail
WHERE object_name = 'EMPLOYEES' AND action_name = 'SELECT'
ORDER BY timestamp DESC;

-- Step 5: Set Up Fine-Grained Auditing (FGA)
-- Create an FGA policy to audit specific conditions
-- Example: Audit SELECT statements on hr.employees table where salary > 10000
BEGIN
  DBMS_FGA.ADD_POLICY(
    object_schema   => 'HR',
    object_name     => 'EMPLOYEES',
    policy_name     => 'audit_high_salary',
    audit_condition => 'SALARY > 10000',
    audit_column    => 'SALARY'
  );
END;
/

-- Verify the FGA policy
SELECT policy_name, object_schema, object_name, audit_condition
FROM dba_audit_policies
WHERE object_name = 'EMPLOYEES';

-- View FGA audit trail
SELECT policy_name, object_schema, object_name, sql_text, timestamp
FROM dba_fga_audit_trail
WHERE object_name = 'EMPLOYEES';

-- Step 6: Manage and Maintain Audit Data
-- Archive old audit data to a backup table
CREATE TABLE audit_trail_backup AS
SELECT * FROM dba_audit_trail
WHERE timestamp < SYSDATE - 30; -- Adjust retention period as needed

-- Delete old audit data from the main audit trail
DELETE FROM dba_audit_trail
WHERE timestamp < SYSDATE - 30; -- Adjust retention period as needed
