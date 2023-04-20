-- change role to ACCOUNTADMIN
use role ACCOUNTADMIN;

-- create role for Alteryx
create role if not exists alteryx_role;
grant role alteryx_role to role SYSADMIN;

-- Note that we are not making the alteryx_role a SYSADMIN,
-- but rather granting users with the SYSADMIN role to modify the alteryx_role

-- create a user for alteryx
create user if not exists alteryx_user
password = '<enter password here>';

grant role alteryx_role to user alteryx_user;

alter user alteryx_user
set default_role = alteryx_role
default_warehouse = 'alteryx_wh';

-- change role
use role SYSADMIN;

-- create a warehouse for alteryx 
create warehouse if not exists alteryx_wh

-- set the size based on your dataset
warehouse_size = small
warehouse_type = standard
auto_suspend = 1800
auto_resume = true
initially_suspended = true;

grant all privileges
on warehouse alteryx_wh
to role alteryx_role;

create database if not exists alteryx;
create schema if not exists alteryx.csv_files;

-- grant read only database access (repeat for all database/schemas)
grant usage on database alteryx to role alteryx_role;
grant usage on schema alteryx.csv_files to role alteryx_role;

-- rerun the following any time a table is added to the schema
grant select on all tables in schema alteryx.csv_files to role alteryx_role;
