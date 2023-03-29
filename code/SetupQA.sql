-- Setup Quality Assurance

-- Create Quality Assurance Objects
USE ROLE SYSADMIN
;

CREATE WAREHOUSE IF NOT EXISTS QUALITY_ASS_WH
   WAREHOUSE_SIZE = XSMALL
   WAREHOUSE_TYPE = STANDARD
   AUTO_SUSPEND = 60
   AUTO_RESUME = TRUE
   INITIALLY_SUSPENDED = TRUE;

USE ROLE SECURITYADMIN
;

CREATE ROLE IF NOT EXISTS QUALITY_ASS_RL
;

USE ROLE USERADMIN
;

CREATE USER IF NOT EXISTS QUALITY_ASS 
PASSWORD = '<PASSWORD>' 
COMMENT = 'User for Quality Assurance' 
LOGIN_NAME = 'QUALITY_ASS' 
DISPLAY_NAME = 'Quality Assurance user' 
FIRST_NAME = 'Quality' 
LAST_NAME = 'Assurance' 
DEFAULT_ROLE = 'QUALITY_ASS_RL' 
DEFAULT_WAREHOUSE = 'QUALITY_ASS_WH' 
DEFAULT_NAMESPACE = 'QUALITY_ASSURANCE' 
MUST_CHANGE_PASSWORD = FALSE
;

USE ROLE SECURITYADMIN
;

GRANT ROLE QUALITY_ASS_RL TO USER QUALITY_ASS
;

USE ROLE SYSADMIN
;

CREATE DATABASE IF NOT EXISTS QUALITY_ASSURANCE
;

CREATE SCHEMA IF NOT EXISTS QUALITY_ASSURANCE.QUALITY_CHECK
;

-- Grant usage and create on Quality Assurance Objects 

GRANT USAGE ON WAREHOUSE QUALITY_ASS_WH TO ROLE QUALITY_ASS_RL
;

GRANT USAGE ON DATABASE QUALITY_ASSURANCE TO ROLE QUALITY_ASS_RL
;

GRANT USAGE, CREATE SCHEMA ON DATABASE QUALITY_ASSURANCE TO ROLE QUALITY_ASS_RL
;

GRANT USAGE, CREATE TABLE, CREATE PROCEDURE ON SCHEMA QUALITY_ASSURANCE.QUALITY_CHECK TO ROLE QUALITY_ASS_RL
;

-- Grant usage on Schema(s) containg the tables to be checked

GRANT USAGE ON SCHEMA <SCHEMA_NAME> TO ROLE QUALITY_ASS_RL
;

-- Grant usage on Table(s) to be checked

GRANT SELECT ON TABLE <TABLE_NAME> TO ROLE QUALITY_ASS_RL;
