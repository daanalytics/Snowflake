USE ROLE QUALITY_ASS_RL
;

USE DATABASE QUALITY_ASSURANCE
;

USE SCHEMA QUALITY_CHECK
;

CREATE TABLE IF NOT EXISTS DATA_QUALITY_METRICS
( DATABASE_NAME VARCHAR
, SCHEMA_NAME VARCHAR
, TABLE_NAME VARCHAR
, FULL_QUAL_TABLE_NAME VARCHAR
, COLUMN_NAME VARCHAR
, TOTAL_COUNT INTEGER
, NOT_NULL_COUNT INTEGER
, NULL_COUNT INTEGER
, BLANK_COUNT INTEGER
, DISTINCT_VALUES_COUNT INTEGER
, MAX_LENGTH VARCHAR
, MIN_LENGTH VARCHAR
, MAX_VALUE VARCHAR
, MIN_VALUE VARCHAR
, NUMERIC_ONLY_VALUES_COUNT INTEGER
, ALPHABETS_ONLY_VALUES_COUNT INTEGER
, ALPHANUMERIC_ONLY_VALUES_COUNT INTEGER
, CONTAINS_SPECIAL_CHAR_COUNT INTEGER
, TOP_TEN_DISTINCT_VALUES VARCHAR
)
;

DROP PROCEDURE DATA_QUALITY(VARCHAR , VARCHAR , VARCHAR )
;

CREATE PROCEDURE IF NOT EXISTS DATA_QUALITY(databaseName VARCHAR, schemaName VARCHAR, tableName VARCHAR)
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$

BEGIN

BEGIN TRANSACTION;

let database_name := databaseName;

let schema_name := schemaName;

let table_name := tableName;

let fully_qual_table_name varchar := databaseName || '.' || schemaName || '.' || tableName;

let info_schema_columns_view varchar := databaseName || '.INFORMATION_SCHEMA.COLUMNS';

let res resultset := (select COLUMN_NAME from identifier(:info_schema_columns_view) where TABLE_CATALOG = :databaseName and TABLE_SCHEMA = :schemaName and TABLE_NAME = :tableName);

execute immediate 'DELETE FROM QUALITY_ASSURANCE.QUALITY_CHECK.DATA_QUALITY_METRICS WHERE DATABASE_NAME = '''||:database_name||'''
                                                                                    AND SCHEMA_NAME = '''||:schema_name||'''
                                                                                    AND TABLE_NAME = '''||:table_name ||'''';

let c1 cursor for res;
for i in c1 do

LET TOTAL_CNT NUMBER;
execute immediate 'SELECT COUNT(*) FROM '||:fully_qual_table_name;
select $1 into :TOTAL_CNT from table(result_scan(last_query_id()));

LET CNT NUMBER;
execute immediate 'SELECT COUNT(*) FROM '||:fully_qual_table_name||' where '||i.COLUMN_NAME||' is not null';
select $1 into :CNT from table(result_scan(last_query_id()));

LET NULL_CNT NUMBER;
execute immediate 'SELECT COUNT(*) FROM '||:fully_qual_table_name||' where '||i.COLUMN_NAME||' is null';
select $1 into :NULL_CNT from table(result_scan(last_query_id()));

LET BLANK_CNT NUMBER;
execute immediate 'SELECT COUNT(*) FROM '||:fully_qual_table_name||' where trim(to_varchar(' || i.COLUMN_NAME || ')) = '''' ';
select $1 into :BLANK_CNT from table(result_scan(last_query_id()));

LET DISTINCT_VALUES_CNT NUMBER;
execute immediate 'SELECT COUNT(DISTINCT ' || i.COLUMN_NAME || ') FROM '||:fully_qual_table_name;
select $1 into :DISTINCT_VALUES_CNT from table(result_scan(last_query_id()));

LET MAX_LENGTH VARCHAR;
execute immediate 'SELECT IFF(MAX(LENGTH('||i.COLUMN_NAME||')) IS NULL,''NULL'',TO_VARCHAR(MAX(LENGTH('||i.COLUMN_NAME||')))) FROM '||:fully_qual_table_name;
select $1 into :MAX_LENGTH from table(result_scan(last_query_id()));

LET MIN_LENGTH VARCHAR;
execute immediate 'SELECT IFF(MIN(LENGTH('||i.COLUMN_NAME||')) IS NULL,''NULL'',TO_VARCHAR(MIN(LENGTH('||i.COLUMN_NAME||')))) FROM '||:fully_qual_table_name;
select $1 into :MIN_LENGTH from table(result_scan(last_query_id()));

LET MAX_VALUE VARCHAR;
execute immediate 'SELECT IFF(MAX('||i.COLUMN_NAME||') IS NULL,''NULL'',TO_VARCHAR(MAX('||i.COLUMN_NAME||'))) FROM '||:fully_qual_table_name;
select $1 into :MAX_VALUE from table(result_scan(last_query_id()));

LET MIN_VALUE VARCHAR;
execute immediate 'SELECT IFF(MIN('||i.COLUMN_NAME||') IS NULL,''NULL'',TO_VARCHAR(MIN('||i.COLUMN_NAME||'))) FROM '||:fully_qual_table_name;
select $1 into :MIN_VALUE from table(result_scan(last_query_id()));

LET NUMERIC_ONLY_VALUES_CNT INTEGER;
execute immediate 'SELECT COUNT(*) FROM '||:fully_qual_table_name||' WHERE RLIKE(TRIM('||i.COLUMN_NAME||'),''^[0–9]+$'') ';
select $1 into :NUMERIC_ONLY_VALUES_CNT from table(result_scan(last_query_id()));

LET ALPHABETS_ONLY_VALUES_CNT INTEGER;
execute immediate 'SELECT COUNT(*) FROM '||:fully_qual_table_name||' WHERE RLIKE(TRIM('||i.COLUMN_NAME||'),''^[a-zA-Z ]+$'')';
select $1 into :ALPHABETS_ONLY_VALUES_CNT from table(result_scan(last_query_id()));

LET ALPHANUMERIC_ONLY_VALUES_CNT INTEGER;
execute immediate 'SELECT COUNT(*) FROM '||:fully_qual_table_name||' WHERE UPPER(TO_VARCHAR(rlike(trim('||i.COLUMN_NAME||'),''.*[0–9].*''))) and UPPER(TO_VARCHAR(rlike(trim('||i.COLUMN_NAME||'),''.*[a-zA-Z].*''))) ';
select $1 into :ALPHANUMERIC_ONLY_VALUES_CNT from table(result_scan(last_query_id()));

LET CONTAINS_SPECIAL_CHAR_CNT INTEGER;
execute immediate 'SELECT COUNT(*) FROM '||:fully_qual_table_name||' WHERE RLIKE(TRIM('||i.COLUMN_NAME||'),''.*[^A-Za-z0–9 ].*'') ';
select $1 into :CONTAINS_SPECIAL_CHAR_CNT from table(result_scan(last_query_id()));

LET TOP_TEN_DISTINCT_VALUES VARCHAR;
execute immediate 'SELECT array_to_string(array_agg(distinct '||i.COLUMN_NAME||') within group (order by '||i.COLUMN_NAME||' asc), '','') FROM (select top 10 '||i.COLUMN_NAME||' from ( select distinct '||i.COLUMN_NAME||' from '||:fully_qual_table_name||'))';
select $1 into :TOP_TEN_DISTINCT_VALUES from table(result_scan(last_query_id()));

execute immediate 'INSERT INTO QUALITY_ASSURANCE.QUALITY_CHECK.DATA_QUALITY_METRICS
(DATABASE_NAME, SCHEMA_NAME, TABLE_NAME, FULL_QUAL_TABLE_NAME, COLUMN_NAME,TOTAL_COUNT,NOT_NULL_COUNT,NULL_COUNT,BLANK_COUNT,DISTINCT_VALUES_COUNT,MAX_LENGTH,MIN_LENGTH,MAX_VALUE,
MIN_VALUE,NUMERIC_ONLY_VALUES_COUNT,ALPHABETS_ONLY_VALUES_COUNT,ALPHANUMERIC_ONLY_VALUES_COUNT,CONTAINS_SPECIAL_CHAR_COUNT,TOP_TEN_DISTINCT_VALUES)
VALUES('''||:database_name||''','''||:schema_name||''','''||:table_name||''','''||:fully_qual_table_name||''','''||i.COLUMN_NAME||''','|| :TOTAL_CNT||','|| :CNT||','|| :NULL_CNT||','|| :BLANK_CNT||','|| :DISTINCT_VALUES_CNT||','''|| :MAX_LENGTH||''','''|| :MIN_LENGTH||''','''|| :MAX_VALUE||''','''|| :MIN_VALUE||''','|| :NUMERIC_ONLY_VALUES_CNT ||','|| :ALPHABETS_ONLY_VALUES_CNT ||','|| :ALPHANUMERIC_ONLY_VALUES_CNT ||','|| :CONTAINS_SPECIAL_CHAR_CNT ||','''|| :TOP_TEN_DISTINCT_VALUES||''')' ;
end for;

COMMIT;

RETURN 'success';

EXCEPTION

WHEN OTHER THEN
ROLLBACK;
RAISE;
END;
$$;