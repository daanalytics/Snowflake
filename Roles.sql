/*
Create various Custom Roles to get started
 */

-- Use SECURITYADMIN role (SECURITYADMIN owns all roles)
USE ROLE SECURITYADMIN
;

----
-- Create Custom Roles
----
--
 -- CDWA - Cloud Data Warehouse Administrator 
CREATE ROLE CDWA
;

--
-- DEVELOPER - Developer role to load data into Snowflake
CREATE ROLE DEVELOPER
;

--
-- ANALYTST - Analyst role to query and view the data
CREATE ROLE ANALYTST
;

--
-- ELT_TOOL - Data Integration role to load data into Snowflake
CREATE ROLE ELT_TOOL
;

--
-- BI_TOOL - BI Tool role to visualize the data
CREATE ROLE BI_TOOL
;


