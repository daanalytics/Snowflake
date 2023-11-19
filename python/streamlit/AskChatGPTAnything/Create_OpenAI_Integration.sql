USE DATABASE <STREAMLIT_DB_NAME>
;

USE SCHEMA <STREAMLIT_DB_SCHEMA_NAME>
;

 -- // Change role to sysadmin as required to create the External Network Integration
USE ROLE sysadmin
;

--// Create a network rule to represent the external network location.
CREATE OR REPLACE NETWORK RULE <NETWORK_RULE_NAME>
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('api.openai.com')
;

--// Create a secret to hold credentials.
CREATE OR REPLACE SECRET <SECRET_NAME>
  TYPE = GENERIC_STRING
  SECRET_STRING = '<OPENAI_API_KEY>'
;

GRANT READ ON SECRET <SECRET_NAME> TO sysadmin
;

-- // Change role to accountadmin as required to create the EXTERNAL ACCESS INTEGRATION
USE ROLE accountadmin
;
  
--// Create an external access integration.
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION <EXTERNAL_ACCESS_INTEGRATION_NAME>
  ALLOWED_NETWORK_RULES = (<NETWORK_RULE_NAME>)
  ALLOWED_AUTHENTICATION_SECRETS = (<SECRET_NAME>)
  ENABLED = true
;

GRANT USAGE ON INTEGRATION openai_external_access_integration TO sysadmin
;

-- // Change role to sysadmin as required to create the External Network Integration
USE ROLE sysadmin
;

--// Create the UDF
CREATE OR REPLACE FUNCTION get_openai_response(prompt_output text, ai_model_engine text)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.8
HANDLER = 'return_openai_response'
EXTERNAL_ACCESS_INTEGRATIONS = (<EXTERNAL_ACCESS_INTEGRATION_NAME>)
PACKAGES = ('openai')
SECRETS = ('secret' = <SECRET_NAME>)
AS
$$

# Use this function to generate a ChatGPT response
# 1. Submit the prompt_output to the OpenAI API
# 2. Return the chat response

import openai
import _snowflake

openai.api_key  = _snowflake.get_generic_secret_string('secret')

def return_openai_response(prompt_output, ai_model_engine):

    # This endpoint might change depending on OpenAI's updates
    endpoint = "https://api.openai.com/v1/chat/completions"  
    headers = {
            "Authorization": f"Bearer + openai.api_key",
            "Content-Type": "application/json",
        }
    
    # ChatCompletion OpenAI Library
    chat_completion = openai.ChatCompletion.create(
            model=ai_model_engine,
            messages=[
                {"role": "system", "content": "<System Role>"},
                {"role": "user", "content": prompt_output}
            ]
        )

    openai_response = chat_completion['choices'][0]['message']['content']

    return openai_response

$$;    

GRANT USAGE ON FUNCTION get_openai_response(text, text ) TO ROLE streamlit_role