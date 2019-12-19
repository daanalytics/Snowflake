-- Use SECURITYADMIN role
USE ROLE SECURITYADMIN
;

-- Grant role SECURITYADMIN
GRANT ROLE SECURITYADMIN TO USER RMATCHED
;

ALTER USER RMATCHED SET DEFAULT_ROLE = SECURITYADMIN
;

-- Grant role CDWA
GRANT ROLE CDWA TO USER MARTINI
;

ALTER USER MARTINI SET DEFAULT_ROLE = CDWA
;

-- Grant role DEVELOPER
GRANT ROLE DEVELOPER TO USER HARDING
;

ALTER USER HARDING SET DEFAULT_ROLE = DEVELOPER
;

-- Grant role ANALYST
GRANT ROLE ANALYST TO USER TABER
;

ALTER USER TABER SET DEFAULT_ROLE = ANALYST
;
