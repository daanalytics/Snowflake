use database frosty_friday
;

use schema weekly_challenges
;

--Create Python UDF
create or replace function ffc_c5_udf(start_int integer)
returns int
language python
runtime_version = '3.8'
handler = 'timesthree_py'
as
$$
def timesthree_py(start_int):
  return start_int*3
$$;

-- Check Python UDF
select ffc_c5_udf(6)
;
