-- vpd_configuration.sql
-- This script sets up Virtual Private Database (VPD) to enforce fine-grained access control

-- Step 1: Create a Policy Function
-- This function returns a predicate to be applied to the specified table
-- Example: Restrict access to rows where department_id = 10
CREATE OR REPLACE FUNCTION hr.vpd_policy (
  schema_name IN VARCHAR2,
  table_name  IN VARCHAR2
) RETURN VARCHAR2 AS
  predicate VARCHAR2(4000);
BEGIN
  -- Example policy: restrict access to rows where department_id = 10
  predicate := 'department_id = 10';
  RETURN predicate;
END;
/

-- Step 2: Add the VPD Policy to the Table
BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'HR',
    object_name     => 'EMPLOYEES',
    policy_name     => 'employees_policy',
    function_schema => 'HR',
    policy_function => 'vpd_policy',
    statement_types => 'SELECT, INSERT, UPDATE, DELETE'
  );
END;
/

-- Step 3: Verify the VPD Policy
-- Check the policies applied to the table
SELECT object_schema, object_name, policy_name, function_schema, policy_function
FROM dba_policies
WHERE object_name = 'EMPLOYEES';

-- Test the VPD Policy
-- Example: Connect as a user and verify the policy
-- Connect as a user with read access
-- SQL> CONNECT readonly_user/readonly_password
-- Run a query to verify the policy
-- SQL> SELECT * FROM hr.employees;

-- Expected result: Only rows where department_id = 10 should be returned

-- Step 4: Modify or Remove the VPD Policy (if needed)
-- Modify the VPD Policy
-- Example: Change the predicate to restrict access to rows where job_id = 'IT_PROG'
CREATE OR REPLACE FUNCTION hr.vpd_policy (
  schema_name IN VARCHAR2,
  table_name  IN VARCHAR2
) RETURN VARCHAR2 AS
  predicate VARCHAR2(4000);
BEGIN
  predicate := 'job_id = ''IT_PROG''';
  RETURN predicate;
END;
/

-- Remove the VPD Policy
BEGIN
  DBMS_RLS.DROP_POLICY(
    object_schema => 'HR',
    object_name   => 'EMPLOYEES',
    policy_name   => 'employees_policy'
  );
END;
/

-- Verify removal of the policy
SELECT object_schema, object_name, policy_name, function_schema, policy_function
FROM dba_policies
WHERE object_name = 'EMPLOYEES';
