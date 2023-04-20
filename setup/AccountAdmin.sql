/*
Make sure you have at least two users with the ACCOUNTADMIN role. The first user which gets created has the ACCOUNTADMIN role. 

Use the SECURITYADMIN role to grant ACCOUNTADMIN to another user of choosing
*/

-- Use SECURITYADMIN role
USE ROLE SECURITYADMIN
;

-- Create user
CREATE USER <ACCOUNTADMIN_USER2>
PASSWORD = ‘<password>’
EMAIL = ‘<EMAIL_ADRESS>’
MUST_CHANGE_PASSWORD = TRUE
EXT_AUTHN_DUO = TRUE
DISABLE_MFA = FALSE
;

-- Grant ACCOUNTADMIN role
GRANT ROLE ACCOUNTADMIN TO USER <ACCOUNTADMIN_USER2>
;