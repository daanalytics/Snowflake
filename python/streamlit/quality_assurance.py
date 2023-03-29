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

st.title('Snowflake database objects Quality Assurance')

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
    st.sidebar.title("Select a table to examine")

    # Set Variables for Snowflake Procedure
    database_name = st.sidebar.text_input('Database Name')
    schema_name = st.sidebar.text_input('Schema Name')
    table_name = st.sidebar.text_input('Table Name')

    # Call Snowflake Procedure when button is clicked
    if st.sidebar.button('Run Quality Assurance'):
        cursor = ctx.cursor()
        cursor.execute(f"CALL QUALITY_ASSURANCE.QUALITY_CHECK.DATA_QUALITY('{database_name}', '{schema_name}', '{table_name}')")
        st.sidebar.success('Procedure has been executed successfully.')
        cursor.close()    

        # Where clause for the Fully Qualified Table Name
        wc_full_qual_table_name = database_name + '.' + schema_name + '.' + table_name
        
        sql_quality_metrics = f"""SELECT *
                                FROM   QUALITY_ASSURANCE.QUALITY_CHECK.DATA_QUALITY_METRICS
                                WHERE  FULL_QUAL_TABLE_NAME = '{wc_full_qual_table_name}'
                                ; """
     
        st.write("Data Quality Metrics for table: " + table_name)

        df_quality_metrics = pd.read_sql_query(sql_quality_metrics, ctx)

        st.table(df_quality_metrics)

        st.markdown('**Data Quality Checks**')

        st.markdown('**Total Count:** Total number of rows present in a table.')
        st.markdown('**Not Null Count:** The number of rows in the column with a non-null value.')
        st.markdown('**Null Count:** The number of rows in the column with a null value.')
        st.markdown('**Blank Count:** The number of rows in the column with a blank value.')
        st.markdown('**Distinct Values Count:** The number of distinct values in the column.')
        st.markdown('**Max Value:** The maximum value in the column.')
        st.markdown('**Min Value:** The minimum value in the column.')
        st.markdown('**Max Length:** The maximum length of the values in the column.')
        st.markdown('**Min Length:** The minimum length of the values in the column.')
        st.markdown('**Numeric Values Count** The number of rows in the column with a numeric value.')
        st.markdown('**Alphabetic Values Count:** The number of rows in the column with an alphabetic value.')
        st.markdown('**Alphanumeric Values Count:** The number of rows in the column with an alphanumeric value.')
        st.markdown('**Special Characters Values Count:** The number of rows in the column which contains special characters.')
        st.markdown('**Top 10 Distinct Values:** The top 10 most common distinct values in the column.')

