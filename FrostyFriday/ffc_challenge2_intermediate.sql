use database frosty_friday
;

use schema weekly_challenges
;

-- Create stage 
create stage ffc_c2_stage
  url = 's3://frostyfridaychallenges/challenge_2/'
;

-- Check stage contents
list @ffc_c2_stage
;

-- Found a .parquet file. Not sure how '.parquet' this file is.
create file format ffc_c2_file_format
type = parquet
;

-- Check the structure of the table for the VARIANT-column to be created
select t.metadata$filename
,      t.metadata$file_row_number
,      t.$1
from   @ffc_c2_stage (file_format => 'ffc_c2_file_format', pattern=>'challenge_2/employees.parquet') t
;

-- Create table with columnd from .parquet
create table ffc_c2_table
(city varchar
, country varchar
, country_code varchar
, dept varchar
, education varchar
, email varchar
, employee_id number
, first_name varchar
, job_title varchar
, last_name varchar
, payroll_iban varchar
, postcode varchar
, street_name varchar
, street_num number
, time_zone varchar
, title varchar)
;

-- Load data into table from stage
copy into ffc_c2_table 
from 
( select $1:city
, $1:country
, $1:country_code
, $1:dept
, $1:education
, $1:email
, $1:employee_id
, $1:first_name
, $1:job_title
, $1:last_name
, $1:payroll_iban
, $1:postcode
, $1:street_name
, $1:street_num
, $1:time_zone
 ,$1:title
from @ffc_c2_stage
(file_format => 'ffc_c2_file_format', pattern=>'challenge_2/employees.parquet')
 )
;

-- Check result
select *
from   ffc_c2_table
;

-- Create view to only track changes on columns; DEPT & JOB_TITLE
create view ffc_c2_view
(  dept
 , job_title)
as 
select dept
,      job_title
from   ffc_c2_table
;

-- Check result
select *
from   ffc_c2_view
;

-- Create stream on view
create stream ffc_c2_stream on view ffc_c2_view
;

-- execute the following commands
update ffc_c2_table set country = 'Japan' where employee_id = 8;
update ffc_c2_table set last_name = 'Forester' where employee_id = 22;
update ffc_c2_table set dept = 'Marketing' where employee_id = 25;
update ffc_c2_table set title = 'Ms' where employee_id = 32;
update ffc_c2_table set job_title = 'Senior Financial Analyst' where employee_id = 68;

-- Check result
select *
from   ffc_c2_stream
;


