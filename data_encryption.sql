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
-- Example: Encrypt the 'salary' column in the 'hr.employees' table
ALTER TABLE hr.employees MODIFY (salary ENCRYPT USING 'AES256' NO SALT);

-- Encrypt other sensitive columns as needed
-- Example: Encrypt the 'ssn' column in the 'hr.employees' table
ALTER TABLE hr.employees MODIFY (ssn ENCRYPT USING 'AES256' NO SALT);

-- Verify encryption
SELECT table_name, column_name, encryption_alg, salt, integrity_alg 
FROM dba_encrypted_columns 
WHERE table_name = 'EMPLOYEES';

-- Step 5: Close the Wallet (Optional, for security purposes)
ADMINISTER KEY MANAGEMENT SET KEYSTORE CLOSE IDENTIFIED BY "your_password";
