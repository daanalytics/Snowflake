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
CREATE OR REPLACE ROLE CDWA
COMMENT = ' Cloud Data Warehouse Administrator' 
;

GRANT ROLE CDWA TO ROLE SYSADMIN
;

--
-- DEVELOPER - Developer role to load data into Snowflake
CREATE OR REPLACE ROLE DEVELOPER
COMMENT = 'Developer role to load data into SnowflakeDeveloper role to load data into Snowflake'
;

GRANT ROLE DEVELOPER TO ROLE SYSADMIN
;

--
-- ANALYST - Analyst role to query and view the data
CREATE OR REPLACE ROLE ANALYST
COMMENT = 'Analyst role to query and view the dataAnalyst role to query and view the data'
;

GRANT ROLE ANALYST TO ROLE SYSADMIN
;

--
-- ELT_TOOL - Data Integration role to load data into Snowflake
CREATE OR REPLACE ROLE ELT_TOOL
COMMENT = 'Data Integration role to load data into SnowflakeData Integration role to load data into Snowflake'
;

GRANT ROLE ELT_TOOL TO ROLE SYSADMIN
;

--
-- BI_TOOL - BI Tool role to visualize the data
CREATE OR REPLACE ROLE BI_TOOL
COMMENT = 'BI Tool role to visualize the dataBI Tool role to visualize the data'
;

GRANT ROLE BI_TOOL TO ROLE SYSADMIN
;



