# Importing the required libraries
import streamlit as st
import pandas as pd
import numpy as np
import snowflake.connector
import folium
from streamlit_folium import st_folium
import pycountry_convert as pc

# Setup web page - App Title, Page Title and Page Layout
APP_TITLE = 'Plotting F1 Circuit Locations into a map using Folium'
st.set_page_config(
    page_title='F1 Circuits', 
    layout='wide',
    menu_items={'Get Help': 'https://www.linkedin.com/in/daanbakboord',
                'About': "This app is powered by Snowflake, Streamlit and Folium | Developed by DaAnalytics (Daan Bakboord)"
    }
)

# Create context 
def create_sf_session_object():

    if "snowflake_context" not in st.session_state:
    
        # Setting up Snowflake connection 

        username    = st.secrets["user"]
        password    = st.secrets["password"]
        account     = st.secrets["account"]
        role        = st.secrets["role"]

        # Connect to Snowflake

        ctx = snowflake.connector.connect(
            user        = username,
            password    = password,
            account     = account,
            role        = role
        )
        st.session_state['snowflake_context'] = ctx

    else: 

        ctx = st.session_state['snowflake_context']

    return ctx

# Get Continent based on Country
def country_convert(country_name):
    
    try:

        country_code = pc.country_name_to_country_alpha2(country_name, cn_name_format='default')
  
        continent_name = pc.country_alpha2_to_continent_code(country_code)

        return pc.convert_continent_code_to_continent_name(continent_name)

    except (KeyError, TypeError):    
    
        return (country_name)

# Base color on Continent 
# 'darkblue', 'white', 'lightblue', 'pink', 'gray', 'green', 'orange', 'darkred', 'black', 'blue', 'cadetblue'
#, 'lightgreen', 'purple', 'darkgreen', 'red', 'beige', 'lightred', 'darkpurple', 'lightgray'

## 'Oceania', 'Asia', 'Europe', 'North America', 'UK', 'South America', 'UAE',
## 'Africa', 'Korea'

def marker_color(continent_name):
    if continent_name == 'Asia':   
        color = 'pink'
    elif continent_name == 'Africa':   
        color = 'green'
    elif continent_name == 'Europe':   
        color = 'blue'
    elif continent_name == 'North America':   
        color = 'red'
    elif continent_name == 'South America':   
        color = 'orange'
    elif continent_name == 'Oceania':   
        color = 'purple' 
    elif  continent_name == 'UK':   
        color = 'beige'     
    elif  continent_name == 'UAE':   
        color = 'lightgreen'      
    elif  continent_name == 'Korea':   
        color = 'cadetblue'       
    else:
        color = 'grey'
    return color    

def load_data(cur, map_type):

    global df_f1_con_circuits 

    global df_f1_cou_circuits 

    global df_qo_f1_circuits
    
    # Connect to DEMO_DB database
    cur.execute("USE DATABASE DEMO_DB")

    # Connect to PRE_F1PY schema
    f1_pre_schema = 'PRE_F1PY'

    cur.execute("USE SCHEMA " + f1_pre_schema)

    # Select Query F1 Circuits

    sql_f1_circuits = """select replace(name, '"','') as name
                     ,      lat
                     ,      lng
                     ,      replace(country, '"','') as country
                     ,      replace(url, '"','') as url
                     from   demo_db.pre_f1py.pre_f1py_circuits
                  """

    # Query F1 Circuits
    cur.execute(sql_f1_circuits)

    # Convert Query output to a DataFrame
    df_qo_f1_circuits = cur.fetch_pandas_all()

    # Add Continent to df_f1_circuits DataFrame
    df_qo_f1_circuits['CONTINENT'] = df_qo_f1_circuits['COUNTRY'].apply(country_convert)

    # Create Continents DataFrame
    df_f1_con_circuits = df_qo_f1_circuits['CONTINENT'].unique()

    # Create Country DataFrame
    df_f1_cou_circuits = df_qo_f1_circuits['COUNTRY'].unique()

def filter_data(map_type, detail):

    global df_f1_circuits

    if map_type == 'World':

        df_f1_circuits = df_qo_f1_circuits

    elif map_type == 'Continent':  

        # Filter df_f1_circuits DataFrame on 'Europe' Continent
        df_f1_circuits = df_qo_f1_circuits.loc[df_qo_f1_circuits['CONTINENT'] == detail]

    elif map_type == 'Country':

        # Filter df_f1_circuits DataFrame on Country
        df_f1_circuits = df_qo_f1_circuits.loc[df_qo_f1_circuits['COUNTRY'] == detail]   

    # Draw the Folium Map
    draw_folium_map(map_type)   

def draw_folium_map(map_type):
    
    global CircuitsMap
    
    # Creating the Folium Map 
    CircuitsMap = folium.Map(location=[df_f1_circuits.LAT.mean()
                                        , df_f1_circuits.LNG.mean()]
                                        , zoom_start=5
                                        , control_scale=True
                                        , tiles='openstreetmap')

    # Adding Tile Layers
    folium.TileLayer('openstreetmap').add_to(CircuitsMap)
    folium.TileLayer('cartodb positron').add_to(CircuitsMap)
    folium.TileLayer('stamenterrain').add_to(CircuitsMap)
    folium.TileLayer('stamentoner').add_to(CircuitsMap)
    folium.TileLayer('stamenwatercolor').add_to(CircuitsMap)
    folium.TileLayer('cartodbdark_matter').add_to(CircuitsMap)

    # Other mapping code (e.g. lines, markers etc.)
    folium.LayerControl().add_to(CircuitsMap)

    # Add Markers to the map
    if map_type == 'World':

        for index, location_info in df_f1_circuits.iterrows():
            folium.Marker([location_info["LAT"], location_info["LNG"]], popup='<a href=' + location_info["URL"] + ' target="_blank">' + location_info["NAME"] + '</a>', icon=folium.Icon(icon_color='white', icon="car", prefix='fa', color=marker_color(location_info["CONTINENT"]))).add_to(CircuitsMap)   

    elif map_type == 'Continent':  

        for index, location_info in df_f1_circuits.iterrows():
            folium.Marker([location_info["LAT"], location_info["LNG"]], popup='<a href=' + location_info["URL"] + ' target="_blank">' + location_info["NAME"] + '</a>', icon=folium.Icon(icon_color='white', icon="car", prefix='fa', color=marker_color(location_info["CONTINENT"]))).add_to(CircuitsMap)
    
    elif map_type == 'Country':

        for index, location_info in df_f1_circuits.iterrows():
            folium.Marker([location_info["LAT"], location_info["LNG"]], popup='<a href=' + location_info["URL"] + ' target="_blank">' + location_info["NAME"] + '</a>', icon=folium.Icon(icon_color='white', icon="car", prefix='fa', color='darkgreen')).add_to(CircuitsMap)   

    # Zoom to LAT, LONG bounds
    lft_dwn = df_f1_circuits[['LAT', 'LNG']].min().values.tolist() # Left Down
    top_rgt = df_f1_circuits[['LAT', 'LNG']].max().values.tolist() # Top Right
    
    CircuitsMap.fit_bounds([lft_dwn, top_rgt]) 

# Main code
if __name__ == "__main__":
    
    # Connect to Snowflake
    ctx = create_sf_session_object()
    cur = ctx.cursor()

    # Select Map type to show
    st.sidebar.title("Select Map Type")

    map_type = st.sidebar.radio(
    "Which map would you like to show?",
    ('World', 'Continent', 'Country'))

    # Load Data into a DataFrame
    load_data(cur, map_type)

    if map_type == 'World':

        detail = map_type

        st.sidebar.write('You selected:', detail)

    elif map_type == 'Continent':
        
        idx = int(np.where(df_f1_con_circuits == "Europe")[0][0])
        
        continent = st.sidebar.selectbox(
            'Which continent would you like to see?',
            (df_f1_con_circuits)
             , index = idx)

        detail = continent    

        st.sidebar.write('You selected:', detail)
    
    elif map_type == 'Country':
               
        idx = int(np.where(df_f1_cou_circuits == "France")[0][0])
        
        country = st.sidebar.selectbox(
            'Which country would you like to see?',
            (df_f1_cou_circuits)
             , index = idx)

        detail = country    

        st.sidebar.write('You selected:', detail)

    # Filter Data based on Map Type
    filter_data(map_type, detail)

    # Draw the 'World' folium Map
    # draw_folium_map(map_type)

    st.title('Plotting F1 Circuit Locations into a map using Folium')
    
    if map_type == 'World':
     
        st.subheader('Map of the ' + map_type )

    else:
        
        st.subheader('Map of ' + map_type + ' ' + detail)
  

    # Render Folium Map in Streamlit
    st_data = st_folium(CircuitsMap, width = 1250)
