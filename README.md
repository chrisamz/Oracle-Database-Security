# Oracle Database Security

## Overview

This project focuses on securing an Oracle database by implementing advanced security measures. The goal is to ensure the database is securely configured and managed, incorporating data encryption, user roles and privileges, Virtual Private Database (VPD), and auditing.

## Technologies

- Oracle Database

## Key Features

- Data encryption
- User roles and privileges
- Virtual Private Database (VPD)
- Auditing

## Project Structure

```
oracle-database-security/
├── scripts/
│   ├── data_encryption.sql
│   ├── user_roles_privileges.sql
│   ├── vpd_configuration.sql
│   ├── auditing.sql
├── configs/
│   ├── sqlnet.ora
│   ├── listener.ora
├── reports/
│   ├── encryption_report.md
│   ├── roles_privileges_report.md
│   ├── vpd_report.md
│   ├── auditing_report.md
├── README.md
└── LICENSE
```

## Instructions

### 1. Clone the Repository

Start by cloning the repository to your local machine:

```bash
git clone https://github.com/your-username/oracle-database-security.git
cd oracle-database-security
```

### 2. Set Up Oracle Environment

Ensure you have an Oracle Database instance installed and running. You will need administrative access to configure security settings.

### 3. Data Encryption

Use the `data_encryption.sql` script to set up data encryption for sensitive data.

```sql
-- data_encryption.sql
-- This script sets up data encryption for sensitive data

-- Step 1: Create a Wallet for Encryption
-- Modify the following command with your wallet directory
ADMINISTER KEY MANAGEMENT CREATE KEYSTORE '/path/to/keystore' IDENTIFIED BY "your_password";

-- Step 2: Open the Wallet
ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "your_password";

-- Step 3: Set the TDE Master Encryption Key
ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY "your_password" WITH BACKUP;

-- Step 4: Encrypt Sensitive Columns
ALTER TABLE hr.employees MODIFY (salary ENCRYPT USING 'AES256');

-- Verify encryption
SELECT column_name, encryption_alg, encryption_length FROM dba_encrypted_columns WHERE table_name = 'EMPLOYEES';
```

### 4. Configure User Roles and Privileges

Use the `user_roles_privileges.sql` script to set up user roles and privileges.

```sql
-- user_roles_privileges.sql
-- This script sets up user roles and privileges

-- Create roles
CREATE ROLE read_only;
CREATE ROLE read_write;
CREATE ROLE admin;

-- Grant privileges to roles
GRANT SELECT ON hr.employees TO read_only;
GRANT SELECT, INSERT, UPDATE, DELETE ON hr.employees TO read_write;
GRANT ALL PRIVILEGES TO admin;

-- Create users and assign roles
CREATE USER readonly_user IDENTIFIED BY readonly_password;
GRANT read_only TO readonly_user;

CREATE USER readwrite_user IDENTIFIED BY readwrite_password;
GRANT read_write TO readwrite_user;

CREATE USER admin_user IDENTIFIED BY admin_password;
GRANT admin TO admin_user;
```

### 5. Configure Virtual Private Database (VPD)

Use the `vpd_configuration.sql` script to set up VPD to enforce fine-grained access control.

```sql
-- vpd_configuration.sql
-- This script sets up Virtual Private Database (VPD)

-- Create a policy function
CREATE OR REPLACE FUNCTION hr.vpd_policy (schema_name VARCHAR2, table_name VARCHAR2)
RETURN VARCHAR2 IS
BEGIN
  RETURN 'department_id = 10'; -- Example policy: restrict access to department_id = 10
END;

-- Add the VPD policy to the table
BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'HR',
    object_name     => 'EMPLOYEES',
    policy_name     => 'employees_policy',
    function_schema => 'HR',
    policy_function => 'vpd_policy'
  );
END;
```

### 6. Configure Auditing

Use the `auditing.sql` script to set up auditing to monitor database activities.

```sql
-- auditing.sql
-- This script sets up auditing

-- Enable unified auditing
AUDIT CREATE SESSION BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY hr;

-- View audit trail
SELECT username, action_name, timestamp FROM dba_audit_trail WHERE username = 'HR';
```

### 7. Configure Oracle Network Encryption

Use the `sqlnet.ora` and `listener.ora` configuration files to set up Oracle Network Encryption.

#### `configs/sqlnet.ora`

```ini
# sqlnet.ora
SQLNET.ENCRYPTION_SERVER = REQUIRED
SQLNET.ENCRYPTION_TYPES_SERVER = (AES256)
```

#### `configs/listener.ora`

```ini
# listener.ora
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = your_db_name)
      (ORACLE_HOME = /path/to/oracle_home)
      (SID_NAME = your_sid)
    )
  )

LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = your_host)(PORT = 1521))
    )
  )
```

### 8. Generate Reports

Document the configuration and results in the `reports` directory.

#### `reports/encryption_report.md`

```markdown
# Data Encryption Report

## Encryption Configuration

- Wallet Directory: /path/to/keystore
- Encryption Algorithm: AES256

## Encrypted Columns

| Table      | Column   | Encryption Algorithm | Key Length |
|------------|----------|----------------------|------------|
| EMPLOYEES  | SALARY   | AES256               | 256 bits   |

## Observations

- Data encryption successfully implemented for sensitive columns.
```

#### `reports/roles_privileges_report.md`

```markdown
# Roles and Privileges Report

## Roles and Privileges Configuration

### Roles

- read_only: SELECT on hr.employees
- read_write: SELECT, INSERT, UPDATE, DELETE on hr.employees
- admin: ALL PRIVILEGES

### Users

| User            | Role       |
|-----------------|------------|
| readonly_user   | read_only  |
| readwrite_user  | read_write |
| admin_user      | admin      |

## Observations

- User roles and privileges successfully configured.
```

#### `reports/vpd_report.md`

```markdown
# VPD Configuration Report

## VPD Policy Configuration

### Policy Function

```sql
CREATE OR REPLACE FUNCTION hr.vpd_policy (schema_name VARCHAR2, table_name VARCHAR2)
RETURN VARCHAR2 IS
BEGIN
  RETURN 'department_id = 10';
END;
```

### Applied Policies

| Table      | Policy Name       | Policy Function | Condition            |
|------------|-------------------|-----------------|----------------------|
| EMPLOYEES  | employees_policy  | hr.vpd_policy   | department_id = 10   |

## Observations

- VPD policy successfully implemented to restrict access based on department_id.
```

#### `reports/auditing_report.md`

```markdown
# Auditing Configuration Report

## Auditing Configuration

### Enabled Audits

- CREATE SESSION
- SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY hr

### Audit Trail

| Username | Action Name    | Timestamp           |
|----------|----------------|---------------------|
| HR       | CREATE SESSION | 2023-01-01 00:00:00 |
| HR       | SELECT TABLE   | 2023-01-01 00:01:00 |
| HR       | INSERT TABLE   | 2023-01-01 00:02:00 |

## Observations

- Auditing successfully implemented to monitor database activities.
```

### Conclusion

By following these steps, you can secure your Oracle database using advanced security measures, including data encryption, user roles and privileges, Virtual Private Database (VPD), and auditing.

## Contributing

We welcome contributions to improve this project. If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Contact

For questions or issues, please open an issue in the repository or contact the project maintainers at [your-email@example.com].

---

Thank you for using our Oracle Database Security project! We hope this guide helps you securely configure and manage your Oracle database effectively.
