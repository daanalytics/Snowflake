# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col, call_udf
from snowflake.snowpark.types import StringType, StructType, StructField
from snowflake import cortex as cx

# Function to format text
def format_text(text, max_line_length=80):
    """
    Formats the input text to have line breaks after a specified number of characters
    or at sentence boundaries.
    """
    import re

    # Split text into sentences
    sentences = re.split(r'(?<=[.!?]) +', text)
    formatted_text = ""
    current_line = ""

    for sentence in sentences:
        if len(current_line) + len(sentence) <= max_line_length:
            current_line += sentence + " "
        else:
            if current_line:
                formatted_text += current_line.strip() + "\n"
            current_line = sentence + " "

    if current_line:
        formatted_text += current_line.strip()

    return formatted_text

#Page Config
st.set_page_config(page_title='Cortex Yahoo Summarizer', page_icon=None, layout="wide")

# Write directly to the app
st.title("Cortex Yahoo Summarizer")
st.write(
    """Fill in the Yahoo URL you want to summarize!
    **And if you're new to Snowflake Cortex,** check
    out the documents in the
    [Documentation](https://docs.snowflake.com/en/user-guide/snowflake-cortex/overview).
    """
)

# Get the current credentials
session = get_active_session()

# Yahoo URL input
url_input = st.text_input("Yahoo URL input", "https://finance.yahoo.com")

# Execute Cortex Summarize function
submit = st.button("Summarize", type="primary")

if submit:
    # 1. Create a DataFrame and specify a schema 
    get_url_input_schema = StructType([StructField("yahoo_response", StringType())])
    df_get_cx_yahoo_response = session.create_dataframe([[url_input]], get_url_input_schema)

    # 2. Sending user input to Cortex Yahoo Summarizer function
    df_cx_yahoo_response = df_get_cx_yahoo_response.select(
        call_udf("cortex_r_and_d.webscrape_summary.webscrape_yahoo", col("yahoo_response")).alias("yahoo_summary")
    )

    # Display the intermediate response
    st.write("Yahoo Summary Response from: " + url_input)
    #st.dataframe(df_cx_yahoo_response)

    # 3. Summarize the response text from the DataFrame
    df_cx_yahoo_summary = df_cx_yahoo_response.select(
        cx.Summarize(col("yahoo_summary")).alias("summary")
    )

    # 4. Display the final summary as plain text in a text area
    summary_text = df_cx_yahoo_summary.collect()[0]['SUMMARY']
    formatted_summary = format_text(summary_text)
    
    st.text_area("Final Summary", formatted_summary, height=300)
