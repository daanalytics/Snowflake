import streamlit as st
from snowflake.snowpark.context import get_active_session 
from snowflake.snowpark.functions import col, call_udf
from snowflake.snowpark.types import StringType, StructType, StructField

# Set AI Model Engine
ai_model_engine = 'gpt-3.5-turbo'

# Set Page Config
st.set_page_config(layout="wide")
st.title('Chatting with ChatGPT using the 5W1H Method')

# Set Side-bar
st.sidebar.image("https://github.com/daanalytics/Snowflake/blob/master/pictures/5W1H_ChatGPT_Blackbox.png?raw=true", use_column_width=True)
st.sidebar.title('5W1H Method')

st.sidebar.markdown(
"""
- **Who?**
    - Understanding "who" can help in tailoring the language and complexity of the response.
- **What?**
    - Specifying "what" ensures that the AI provides the type and format of information you desire.
- **Where?**
    - Defining "where" can help in receiving region or context-specific answers.
- **Why?**
    - Knowing "why" can help in determining the depth and angle of the AI's response.
- **When?**
    - Framing "when" can help narrow down the context of the information provided.
- **How?**
    - Clarifying "how" can guide the AI in structuring its answer in the most useful way.            
"""
)

def main():

    # Get the current credentials
    session = get_active_session()

    # 1. Collecting user input according to the 5W1H Method
    # 2. Sending user input to ChatGPT function
    # 3. Display the ChatGPT response

    # 1. Collecting user input according to the 5W1H Method
    
    # Variable Who --> audience?
    who = st.text_area('Who', help='Are you aiming the prompt for a software developer, a student, a researcher, or a layperson?')

    # Variable What --> what should be done?
    what = st.text_area('What', help='Are you looking for a detailed explanation, a summary, code, or maybe a list??')

    # Variable Where --> where will the output be used?
    where = st.text_area('Where', help='Are you asking about a concept''s application in a specific country, industry, or environment?')

    # Variable Why --> what's the goal?
    why = st.text_area('Why', help='Are you asking because you want a deep understanding, or are you trying to compare concepts?')

    # Variable When --> when will 'it' happen?
    when = st.text_area('When', help='Are you asking about historical events, contemporary issues, or future predictions?')

    # Variable How --> style, structure, length, use of language, etc.
    how = st.text_area('How', help='Are you seeking a step-by-step guide, an overview, or perhaps a methodological explanation?')

    prompt_output = who + ' ' + what + ' ' + where + ' ' + why + ' ' + when + ' ' + how
    
    # Submit Button

    form = st.form(key='5W1H_form')

    submit = form.form_submit_button(label='Submit')

    if submit:

        # Create a DataFrame and specify a schema 
        get_openai_schema = StructType([StructField("prompt_output", StringType()), StructField("ai_model_engine", StringType())])
        df_openai_get_response = session.create_dataframe([[prompt_output, ai_model_engine]], get_openai_schema)

        # 2. Sending user input to ChatGPT function
        df_openai_response = df_openai_get_response.select(call_udf("get_openai_response", col("prompt_output"), col("ai_model_engine")).alias("openai_response")).to_pandas()
        
        # Extract the response text from the DataFrame
        response_text = df_openai_response.iloc[0, 0] 

        # 3. Display the ChatGPT response
        st.write (response_text)
        
# Execute the main function
main() 