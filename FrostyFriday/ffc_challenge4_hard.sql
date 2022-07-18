use database frosty_friday
;

use schema weekly_challenges
;

-- Create stage 
create stage ffc_c4_stage
  url = 's3://frostyfridaychallenges/challenge_4/'
;

-- Check stage contents
list @ffc_c4_stage
;

drop file format ffc_c4_file_format
; 

-- Found a .json file. Investigate the JSON.
create file format ffc_c4_file_format
type = json
strip_outer_array = true
;

-- Check the structure of the table for the VARIANT-column to be created
select t.metadata$filename
,      t.metadata$file_row_number
,      t.$1
from   @ffc_c4_stage (file_format => 'ffc_c4_file_format', pattern=>'challenge_4/Spanish_Monarchs.json') t
;

-- Create table with parsed JSON
create table ffc_c4_table_raw_json
(c1 variant)
;

truncate table ffc_c4_table_raw_json
;

copy into ffc_c4_table_raw_json
from
(select parse_json(t.$1)
from   @ffc_c4_stage (file_format => 'ffc_c4_file_format', pattern=>'challenge_4/Spanish_Monarchs.json') t
)
;

-- Check result
select *
from   ffc_c4_table_raw_json
; 

-- Flatten JSON
select row_number() over (order by m.value:Birth::date) as id
,      m.index +1 as inter_house_id
,      t.c1:Era::varchar as era
,      h.value:House::varchar as house
,      m.value:Name::varchar as name
,      m.value:Nickname[0]::varchar as nickname_1
,      m.value:Nickname[1]::varchar as nickname_2
,      m.value:Nickname[2]::varchar as nickname_3
,      m.value:Birth::date as birth
,      m.value:"Start of Reign"::date as start_of_reign
,      m.value:"End of Reign"::date as end_of_reign
,      m.value:Duration::varchar as duration
,      m.value:Death::date as death
,      m.value:"Consort\/Queen Consort"[0]::varchar as consort_or_queen_consort_1
,      m.value:"Consort\/Queen Consort"[1]::varchar as consort_or_queen_consort_2
,      m.value:"Consort\/Queen Consort"[2]::varchar as consort_or_queen_consort_3
,      m.value:"Place of Birth"::varchar as place_of_birth
,      m.value:"Place of Death"::varchar as place_of_death
,      m.value:"Age at Time of Death"::varchar as age_at_time_of_death
,      m.value:"Burial Place"::varchar as burial_place
from   ffc_c4_table_raw_json t
,      table(flatten( t.c1,'Houses' )) h
,      table(flatten(h.value:Monarchs, '')) m
;
