/*
Create Role Hierarchy based on the created Custom Roles
 */

-- Use SECURITYADMIN role (SECURITYADMIN owns all roles)
USE ROLE SECURITYADMIN
;

----
-- Create Role Hierarchy
----
--
-- ELT_TOOL (Data Integration role) is inherited by DEVELOPER (Developer role) 
GRANT ROLE ELT_TOOL TO ROLE DEVELOPER;

-- 
-- DEVELOPER (Developer role) is inherited by CDWA (Cloud Data Warehouse Administrator)
GRANT ROLE DEVELOPER TO ROLE CDWA;

--
-- BI_TOOL ( BI Tool role) is inherited by ANALYST (Analyst role)
GRANT ROLE BI_TOOL TO ROLE ANALYST;

--
-- ANALYST (Analyst role) is inherited by CDWA (Cloud Data Warehouse Administrator)
GRANT ROLE ANALYST TO ROLE CDWA;

-- CDWA (Cloud Data Warehouse Administrator) is inherited by SYSADMIN (System Administrator)
GRANT ROLE CDWA TO ROLE SYSADMIN;

----
-- Give Base privileges to CDWA (Cloud Data Warehouse Administrator)
----

-- Use SYSADMIN role (System Administrator)
USE ROLE SYSADMIN
;

--
-- Grant Create Database to CDWA (Cloud Data Warehouse Administrator)
GRANT CREATE DATABASE ON ACCOUNT TO ROLE CDWA;

--
-- Grant Create Warehouse to CDWA (Cloud Data Warehouse Administrator)
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE CDWA;

