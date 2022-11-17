# Importing the required libraries

import streamlit as st #Streamlit Library
import snowflake.connector # Connect to Snowflake
import json # Read Snowflake Credential File
import pandas as pd #Pandas Library
import altair as alt #Altair Library for Charts

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

# Create Datasets

## CO2 Emissions by Country

sql_emissions = """SELECT "Location Name"
,      SUM("Value") AS "Total CO2 Emissions"
FROM   EDGARED2019
WHERE  "Indicator Name" = 'Fossil CO2 Emissions'
AND    "Type Name" = 'All Type'
AND    "Location Name" != 'World'
GROUP BY "Location Name" 
--ORDER BY SUM("Value") DESC
ORDER BY "Location Name" 
;"""

## Forest Occupied Land Area by Country

sql_occupied = """SELECT "Country Name"
,      SUM("Value") AS "Total Share of Forest Land"
FROM   "WBWDI2019Jan"
WHERE  "Series Name" = 'Forest area (% of land area)'
GROUP BY "Country Name" 
ORDER BY SUM("Value") DESC
;"""

## Total Municipal Waste by Country

sql_municipal = """SELECT "Location Name"
,      SUM("Value") AS "Municipal waste collected"
FROM   UNENVDB2018
WHERE  "Variable Name" = 'Municipal waste collected'
GROUP BY "Location Name" 
ORDER BY SUM("Value") DESC
;"""

# Use the ENVIRONMENT_DATA_ATLAS database
conn.cursor().execute("USE DATABASE ENVIRONMENT_DATA_ATLAS")

# Use the ENVIRONMENT schema
conn.cursor().execute("USE SCHEMA ENVIRONMENT")

# Use the full page width
st.set_page_config(
     page_title="Environment Data Atlas",
     page_icon="🧊",
     layout="wide",
     initial_sidebar_state="expanded",
     menu_items={
         'Get Help': 'https://developers.snowflake.com',
         'About': "This is an *extremely* cool app powered by Streamlit, and Snowflake Data Marketplace"
     }
)

# Perform query.
# Uses st.cache to only rerun when the query changes or after 10 min.
@st.cache(ttl=600)
def run_query(query):
    with conn.cursor() as cur:
        cur.execute(query)
        return cur.fetchall()

# Creating a function to load the data into a Pandas Data Frame & setting Column Names

pd_df_emissions = run_query(sql_emissions)
pd_df_emissions = pd.DataFrame(pd_df_emissions, columns=("Location Name", "Total CO2 Emissions"))

pd_df_occupied = run_query(sql_occupied)
pd_df_occupied = pd.DataFrame(pd_df_occupied, columns=("Country Name", "Total Share of Forest Land"))

pd_df_municipal = run_query(sql_municipal)
pd_df_municipal = pd.DataFrame(pd_df_municipal, columns=("Location Name", "Municipal waste collected"))

# Add a 'Knoema Environment Data Atlas'-header
# Add header and a subheader
st.header("Knoema: Environment Data Atlas")
st.subheader("Powered by Snowflake Data Marketplace | Made with Streamlit | SQL version")

# Use columns to display the three dataframes side-by-side along with their headers
col1, col2, col3 = st.columns(3)
with st.container():
    with col1:
        st.subheader('CO2 Emissions by Country')
        st.dataframe(pd_df_emissions)
    with col2:
        st.subheader('Forest Occupied Land Area by Country')
        st.dataframe(pd_df_occupied)
    with col3:
        st.subheader('Total Municipal Waste by Country')
        st.dataframe(pd_df_municipal)

# Display an interactive chart to visualize CO2 Emissions by Top N Countries
with st.container():
    st.subheader('CO2 Emissions by Top N Countries')
    with st.expander(""):
        emissions_threshold = st.slider(label='Emissions Threshold',min_value=5000, value=20000, step=5000) # Displaying the Slider.
        
        pd_df_co2_top_n = pd_df_emissions[pd_df_emissions["Total CO2 Emissions"] > emissions_threshold] # Filtering the Dataframe based on the selected Slider value.

        display_chart = alt.Chart(pd_df_co2_top_n).mark_bar().encode(
            #x= alt.X("Location Name", sort='-y'),
            x= alt.X("Location Name"),
            y= alt.Y("Total CO2 Emissions")
        )       
        
        st.altair_chart(display_chart, use_container_width=True)