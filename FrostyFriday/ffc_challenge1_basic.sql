use database frosty_friday
;

use schema weekly_challenges
;

-- Create stage 

create stage ffc_c1_stage
  url = 's3://frostyfridaychallenges/challenge_1/'
;

-- Check stage contents
list @ffc_c1_stage
;

-- Found a few .csv files. Not sure how '.csv' these files are.
create file format ffc_c1_file_format
type = csv
;

-- Trying to find out which columns are available. 
-- If the exact structure is unknown, it will be trial and error
select t.metadata$filename
,      t.metadata$file_row_number
,      t.$1
,      t.$2
,      t.$3
from   @ffc_c1_stage (file_format => 'ffc_c1_file_format', pattern=>'challenge_1/3.csv') t
;

-- Create table based on the query above. The fact that only one column ($2 and $3 are empty) is filled with a varchar,
-- makes the following one column table
create table ffc_c1_table
(c1 varchar)
;

-- Load data into table from stage
copy into ffc_c1_table from @ffc_c1_stage;

-- Check result
select *
from   ffc_c1_table
