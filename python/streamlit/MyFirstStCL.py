#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar  2 15:17:57 2022

@author: daanalytics
"""

import streamlit as st
import snowflake.connector

# Initialize connection.
# Uses st.experimental_singleton to only run once.
@st.experimental_singleton
def init_connection():
    return snowflake.connector.connect(**st.secrets["snowflake"])

conn = init_connection()

# Connect to DEMO_DB database
conn.cursor().execute("USE DATABASE demo_db")

# Connect to PETS schema
conn.cursor().execute("USE SCHEMA pets")

# Perform query.
# Uses st.cache to only rerun when the query changes or after 10 min.
@st.cache(ttl=600)
def run_query(query):
    with conn.cursor() as cur:
        cur.execute(query)
        return cur.fetchall()

rows = run_query("SELECT * FROM pets;")

# Print results.
for row in rows:
    st.write(f"{row[0]} has a :{row[1]}:")
