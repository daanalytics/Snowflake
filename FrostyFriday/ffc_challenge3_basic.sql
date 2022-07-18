use database frosty_friday
;

use schema weekly_challenges
;

-- Create stage 

create stage ffc_c3_stage
  url = 's3://frostyfridaychallenges/challenge_3/'
;

-- Check stage contents
list @ffc_c3_stage
;

-- Found a few .csv files. Not sure how '.csv' these files are.
create file format ffc_c3_file_format
type = csv
;

-- Trying to find out which columns are available. 
-- If the exact structure is unknown, it will be trial and error
select t.metadata$filename
,      t.metadata$file_row_number
,      t.$1
,      t.$2
,      t.$3
from   @ffc_c3_stage (file_format => 'ffc_c3_file_format', pattern=>'challenge_3/keywords.csv') t
;

-- Create table based on the query above
create table ffc_c3_table_keywords
(keyword varchar
, added_by varchar
, nonsense varchar)
;

-- Load data into table from stage
insert into ffc_c3_table_keywords 
(select t.$1
,    t.$2
,    t.$3
from @ffc_c3_stage 
 (file_format => 'ffc_c3_file_format', pattern=>'challenge_3/keywords.csv') t
 where t.metadata$file_row_number > 1
 );

-- Check result
select *
from   ffc_c3_table_keywords
;

-- Trying to select files from stage with specific keywords in the file_name
select distinct t.metadata$filename
from   @ffc_c3_stage (file_format => 'ffc_c3_file_format') t
where  t.metadata$filename like any (select '%' || keyword || '%'
                                    from   ffc_c3_table_keywords)
;

-- Create table to store the file names
create table ffc_c3_table_results
(file_name varchar)
;

insert into ffc_c3_table_results
(select distinct t.metadata$filename
from   @ffc_c3_stage (file_format => 'ffc_c3_file_format') t
where  t.metadata$filename like any (select '%' || keyword || '%'
                                    from   ffc_c3_table_keywords)
)
;

-- Check result
select *
from   ffc_c3_table_results
;
