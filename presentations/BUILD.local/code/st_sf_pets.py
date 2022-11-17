# Importing the required libraries

import streamlit as st #Streamlit Library
import snowflake.connector # Connect to Snowflake
import json # Read Snowflake Credential File

# Get the credentials
config_location = '/Users/daanbakboord/Library/Mobile Documents/com~apple~CloudDocs/Seni_BV/Daanalytics/R&D/Snowflake/Presentations/BUILD.local 2022/credentials'
credential_file = 'sf_cred.json'

config = json.loads(open(str(config_location + '/' + credential_file)).read())
username    = config['secrets']['username']
password    = config['secrets']['password']
account     = config['secrets']['account']
role        = config['secrets']['role']

# Connect to Snowflake

conn = snowflake.connector.connect(
    user        = username,
    password    = password,
    account     = account,
    role        = role
    )

# Create the BUILD_LOCAL database
conn.cursor().execute("CREATE DATABASE IF NOT EXISTS build_local")

# Use the BUILD_LOCAL database
conn.cursor().execute("USE DATABASE build_local")

# Create the SCH_PETS schema
conn.cursor().execute("CREATE SCHEMA IF NOT EXISTS sch_pets")

# Use the SCH_PETS schema
conn.cursor().execute("USE SCHEMA sch_pets")

# Create table PETS_TBL
conn.cursor().execute(
    "CREATE OR REPLACE TABLE "
    "PETS_TBL (NAME            varchar(80),"
    "     PET             varchar(80)"
    "    )")

# Insert into table PETS
conn.cursor().execute(
    "INSERT INTO PETS_TBL VALUES ('Mary', 'dog'), ('John', 'cat'), ('Robert', 'bird'), ('Daan', 'chicken')")

# Perform query.
# Uses st.cache to only rerun when the query changes or after 10 min.
@st.cache(ttl=600)
def run_query(query):
    with conn.cursor() as cur:
        cur.execute(query)
        return cur.fetchall()

rows = run_query("SELECT * FROM pets_tbl;")

# Add a 'Pets App'-header
st.header('PETS APP')

# Print results.
for row in rows:
    st.write(f"{row[0]} has a :{row[1]}:")

    