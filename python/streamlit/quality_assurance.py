import snowflake.connector
import streamlit as st
import pandas as pd

# Setup web page - App Title, Page Title and Page Layout
APP_TITLE = 'Snowflake database objects Quality Assurance'
st.set_page_config(
    page_title='Quality Assurance', 
    layout='wide',
    menu_items={'Get Help': 'https://www.linkedin.com/in/daanbakboord',
                'About': "This app is powered by Snowflake and Streamlit | Developed by DaAnalytics (Daan Bakboord)"
    }
)

# Initialize connection.
# Uses st.experimental_singleton to only run once.
@st.experimental_singleton
def init_connection():
    return snowflake.connector.connect(**st.secrets["snowflake"])

# Create context 
def create_sf_session_object():

    if "snowflake_context" not in st.session_state:
    
        ctx = init_connection()
        
        st.session_state['snowflake_context'] = ctx

    else: 

        ctx = st.session_state['snowflake_context']

    return ctx


#Main code
if __name__ == "__main__":
    
    # Connect to Snowflake
    ctx = create_sf_session_object()
    cur = ctx.cursor()

    # Select Map type to show
    st.sidebar.title("Select Database Object to examine")

    # Set Variables for Snowflake Procedure
    database_name = st.sidebar.text_input('Database Name')
    schema_name = st.sidebar.text_input('Schema Name')
    table_name = st.sidebar.text_input('Schema Name')

    # Snowflake Procedure aanroepen wanneer de gebruiker op de knop klikt
    if st.button('Run Quality Assurance'):
        cursor = ctx.cursor()
        cursor.execute(f"CALLQUALITY_ASSURANCE.QUALITY_CHECK.DATA_QUALITY('{database_name}', '{schema_name}', '{table_name}')")
        st.sidebar.success('Procedure has been executed successfully.')
        cursor.close()    

    sql_quality_metrics = pd.read_sql("""SELECT *
                                        FROM   QUALITY_ASSURANCE.QUALITY_CHECK.DATA_QUALITY_METRICS
                                        WHERE  FULL_QUAL_TABLE_NAME = """ + database_name + '.' + schema_name + '.' + table_name, ctx)
    
    st.write("Data Quality Metrics for table: " + table_name)

    df_quality_metrics = pd.DataFrame(sql_quality_metrics, columns=['DATABASE_NAME', 'SCHEMA_NAME', 'TABLE_NAME', 'FULL_QUAL_TABLE_NAME', 'COLUMN_NAME', 'TOTAL_COUNT', 'NOT_NULL_COUNT', 'NULL_COUNT', 'BLANK_COUNT', 'DISTINCT_VALUES_COUNT'
    , 'MAX_LENGTH', 'MIN_LENGTH', 'MAX_VALUE', 'MIN_VALUE', 'NUMERIC_ONLY_VALUES_COUNT', 'ALPHABETS_ONLY_VALUES_COUNT', 'ALPHANUMERIC_ONLY_VALUES_COUNT'
    , 'CONTAINS_SPECIAL_CHAR_COUNT', 'TOP_TEN_DISTINCT_VALUES'])

    st.table(df_quality_metrics)

    

