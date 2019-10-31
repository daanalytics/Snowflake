//-- https://docs.snowflake.net/manuals/user-guide/script-data-load-transform-parquet.html


/* Create a target relational table for the Parquet data. The table is temporary, meaning it persists only for the duration
of the user session and is not visible to other users. */
CREATE OR REPLACE TEMPORARY TABLE PRQT_USERDATA
(registration_dttm 	DATETIME default null,
		id 								INT default null,
		first_name 			VARCHAR default null,
		last_name 			VARCHAR default null,
		email 						VARCHAR default null,
		gender 					VARCHAR default null,
		ip_address 			VARCHAR default null,
		cc 			    				VARCHAR default null,
		country 					VARCHAR default null,
		birthdate 				VARCHAR default null,
		salary 						DOUBLE default null,
		title 							VARCHAR default null,
		comments 			VARCHAR default null)
;        
        
-- Create a file format object that specifies the Parquet file format type.
CREATE OR REPLACE FILE FORMAT PARQUET_FILE_FORMAT
  TYPE = PARQUET, COMPRESSION = AUTO;   
 
 -- Create a temporary internal stage that references the file format object.
CREATE OR REPLACE TEMPORARY STAGE TMP_PRQT_USERDATA_STAGE
  FILE_FORMAT = PARQUET_FILE_FORMAT
  URL = 's3://<bucket_name>' 
  CREDENTIALS=(AWS_KEY_ID='xxxxxxx'AWS_SECRET_KEY='xxxxxxxxxxxxxx')
  COMMENT = 'Parquet files Stage'
  ;
 
-- List the data file. 
LIST @TMP_PRQT_USERDATA_STAGE  
;

-- Select those records from Stage where the First Name is justin
SELECT $1:first_name::varchar
FROM   @TMP_PRQT_USERDATA_STAGE/userdata1.parquet t
WHERE  $1:first_name::varchar = 'Justin'
;

--Copy into Table
COPY INTO TMP_PRQT_USERDATA
  FROM (SELECT $1:registration_dttm::datetime,
	   $1:id::int,
	   $1:first_name::varchar,
	   $1:last_name::varchar,
	   $1:email::varchar,
	   $1:gender::varchar,
	   $1:ip_address::varchar,
	   $1:cc::varchar,
	   $1:country::varchar,
	   $1:birthdate::varchar,
	   $1:salary::varchar,
	   $1:title::varchar,
	   $1:comments::varchar
FROM   @TMP_PRQT_USERDATA_STAGE/userdata1.parquet t
--WHERE  $1:first_name::varchar = 'Justin' --> "SQL compilation error: COPY statement only supports simple SELECT from stage statements for import."
       )
;
