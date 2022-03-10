#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 10 22:27:46 2022

@author: daanalytics
"""

import pandas as pd 
import glob 
import os
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
import json

# Setting up Snowflake connection 
conn_location = '<Credential file location>'

connect = json.loads(open(str(conn_location+'<Credential file>')).read())

username    = connect['secrets']['username']
password    = connect['secrets']['password']
account     = connect['secrets']['account']
role        = connect['secrets']['role']

# Connect to Snowflake

conn = snowflake.connector.connect(
    user        = username,
    password    = password,
    account     = account,
    role        = role
    )

# Location with the F1-demo files from Kaggle
file_location = '<Local file location>'

# Connect to DEMO_DB database
demo_db = connect['secrets']['database'].upper()
conn.cursor().execute("USE DATABASE " + demo_db)

# Connect to PRE_F1PY schema
f1_pre_schema = 'PRE_F1PY'
conn.cursor().execute("CREATE SCHEMA IF NOT EXISTS " + f1_pre_schema)

conn.cursor().execute("USE SCHEMA " + f1_pre_schema)

# Read all the .csv-files 
f1_demo_files = glob.glob(file_location + "/*.csv") 

# Creating the F1-tables
for file in f1_demo_files:
    
    # Getting filename in UPPERCASE and removing .csv
    filename = os.path.splitext(os.path.basename(file))[0].upper()
    
    f1_pre_table = 'PRE_F1PY_' + filename
    
    # Create a CREATE TABLE SQL-statement
    create_tbl_sql = "CREATE TABLE IF NOT EXISTS " + demo_db + "." + f1_pre_schema + "." + f1_pre_table + " (\n"
    
    # Making a data frame to read the columns from 
    dfF1 = pd.read_csv(file) 
    
    dfF1.rename(columns=str.upper, inplace=True)
    dfF1.columns
    
    # Iterating trough the columns
    for col in dfF1.columns:
        column_name = col.upper()
        
        if (dfF1[col].dtype.name == "int" or dfF1[col].dtype.name == "int64"):
            create_tbl_sql = create_tbl_sql + column_name + " int"
        elif dfF1[col].dtype.name == "object":
            create_tbl_sql = create_tbl_sql + column_name + " varchar(16777216)"
        elif dfF1[col].dtype.name == "datetime64[ns]":
            create_tbl_sql = create_tbl_sql + column_name + " datetime"
        elif dfF1[col].dtype.name == "float64":
            create_tbl_sql = create_tbl_sql + column_name + " float8"
        elif dfF1[col].dtype.name == "bool":
            create_tbl_sql = create_tbl_sql + column_name + " boolean"
        else:
            create_tbl_sql = create_tbl_sql + column_name + " varchar(16777216)"
        
        # Deciding next steps. Either column is not the last column (add comma) else end create_tbl_statement
        if dfF1[col].name != dfF1.columns[-1]:
            create_tbl_sql = create_tbl_sql + ",\n"
        else:
            create_tbl_sql = create_tbl_sql + ")"
        
            #Execute the SQL statement to create the table
            conn.cursor().execute(create_tbl_sql)  
        
    conn.cursor().execute('TRUNCATE TABLE IF EXISTS ' + f1_pre_table)    
    
    # Write the data from the DataFrame to the f1_pre_table.
    write_pandas(
            conn=conn,
            df=dfF1,
            table_name=f1_pre_table,
            database=demo_db,
            schema=f1_pre_schema
        )   
        
