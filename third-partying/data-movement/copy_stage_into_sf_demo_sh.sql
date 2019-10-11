LIST @SH_STAGE
;

TRUNCATE CHANNELS
;

COPY INTO CHANNELS FROM @SH_STAGE
FILES = ( 'CHANNELS_DATA_TABLE.dsv' )
FILE_FORMAT = ( FORMAT_NAME = PIPE_DSV_FILE );

TRUNCATE COUNTRIES
;

COPY INTO COUNTRIES FROM @SH_STAGE
FILES = ( 'COUNTRIES_DATA_TABLE.dsv' )
FILE_FORMAT = ( FORMAT_NAME = PIPE_DSV_FILE );

TRUNCATE PRODUCTS
;

COPY INTO PRODUCTS 
FROM (
SELECT t.$1
,      t.$2
,      t.$3      
,      t.$4
,      t.$5
,      t.$6
,      t.$7
,      t.$8
,      t.$9
,      t.$10
,      t.$11 
,      t.$12
,      t.$13      
,      t.$14
,      TO_NUMBER(REPLACE(t.$15,',','.'),8,2)
,      TO_NUMBER(REPLACE(t.$16,',','.'),8,2)
,      t.$17
,      t.$18
,      t.$19
,      TO_DATE(t.$20, 'DD-MM-YY') 
,      t.$21
,      t.$22  
FROM @SH_STAGE/PRODUCTS_DATA_TABLE.dsv t)
FILE_FORMAT = ( FORMAT_NAME = PIPE_DSV_FILE );

TRUNCATE PROMOTIONS
;

COPY INTO PROMOTIONS 
FROM (
SELECT t.$1
,      t.$2
,      t.$3      
,      t.$4
,      t.$5
,      t.$6
,      t.$7
,      TO_DATE(t.$8, 'DD-MM-YY') 
,      TO_DATE(t.$9, 'DD-MM-YY') 
,      t.$10
,      t.$11 
FROM @SH_STAGE/PROMOTIONS_DATA_TABLE.dsv t)
FILE_FORMAT = ( FORMAT_NAME = PIPE_DSV_FILE );

TRUNCATE SUPPLEMENTARY_DEMOGRAPHICS
;

COPY INTO SUPPLEMENTARY_DEMOGRAPHICS FROM @SH_STAGE
FILES = ( 'SUPPLEMENTARY_DEMOGRAPHICS_DATA_TABLE.dsv' )
FILE_FORMAT = ( FORMAT_NAME = PIPE_DSV_FILE );

TRUNCATE COSTS
;

COPY INTO COSTS 
FROM (
SELECT t.$1
,      TO_DATE(t.$2, 'DD-MM-YY')
,      t.$3      
,      t.$4
,      TO_NUMBER(REPLACE(t.$5,',','.'),8,2)
,      TO_NUMBER(REPLACE(t.$6,',','.'),8,2)
FROM @SH_STAGE/COSTS_DATA_TABLE.dsv t)
FILE_FORMAT = ( FORMAT_NAME = PIPE_DSV_FILE );

TRUNCATE SALES
;

COPY INTO SALES 
FROM (
SELECT t.$1
,      t.$2
,      TO_DATE(t.$3, 'DD-MM-YY')    
,      t.$4
,      t.$5  
,      TO_NUMBER(REPLACE(t.$6,',','.'),8,2)
,      TO_NUMBER(REPLACE(t.$7,',','.'),8,2)
FROM @SH_STAGE/SALES_DATA_TABLE.dsv t)
FILE_FORMAT = ( FORMAT_NAME = PIPE_DSV_FILE );

TRUNCATE SALESTEMP
;

COPY INTO SALESTEMP 
FROM (
SELECT t.$1
,      t.$2
,      TO_DATE(t.$3, 'DD-MM-YY')    
,      t.$4
,      t.$5  
,      TO_NUMBER(REPLACE(t.$6,',','.'),8,2)
,      TO_NUMBER(REPLACE(t.$7,',','.'),8,2)
,      TO_NUMBER(REPLACE(t.$8,',','.'),8,2)
,      TO_NUMBER(REPLACE(t.$9,',','.'),8,2)  
FROM @SH_STAGE/SALESTEMP_DATA_TABLE.dsv t)
FILE_FORMAT = ( FORMAT_NAME = PIPE_DSV_FILE );

TRUNCATE TIMES
;

COPY INTO TIMES 
FROM (
SELECT TO_DATE(SUBSTR(t.$1,1,10), 'DD-MM-YY')
,      t.$2
,      t.$3      
,      t.$4
,      t.$5
,      t.$6
,      TO_DATE(SUBSTR(t.$7,1,10), 'DD-MM-YY')
,      t.$8
,      t.$9
,      t.$10
,      t.$11 
,      t.$12
,      t.$13      
,      t.$14
,      t.$15
,      t.$16
,      TO_DATE(SUBSTR(t.$17,1,10), 'DD-MM-YY')
,      TO_DATE(SUBSTR(t.$18,1,10), 'DD-MM-YY')
,      t.$19
,      t.$20 
,      t.$21
,      t.$22
,      t.$23
,      t.$24
,      t.$25      
,      t.$26
,      TO_DATE(SUBSTR(t.$27,1,10), 'DD-MM-YY')
,      TO_DATE(SUBSTR(t.$28,1,10), 'DD-MM-YY')
,      t.$29
,      t.$30
,      t.$31 
,      t.$32
,      t.$33      
,      t.$34
,      t.$35
,      t.$36
,      TO_DATE(SUBSTR(t.$37,1,10), 'DD-MM-YY')
,      TO_DATE(SUBSTR(t.$38,1,10), 'DD-MM-YY')
FROM @SH_STAGE/TIMES_DATA_TABLE.dsv t)
FILE_FORMAT = ( FORMAT_NAME = PIPE_DSV_FILE );
