USE DATABASE <STREAMLIT_DB_NAME>
;

USE SCHEMA <STREAMLIT_DB_SCHEMA_NAME>
;

-- // Change role to <STREAMLIT_ROLE> as required to create the Streamlit Application
USE ROLE <STREAMLIT_ROLE>
;

-- // ROOT_LOCATION = '<STREAMLIT_DB>.<STREAMLIT_DB_SCHEMA>.<STREAMLIT_DB_SCHEMA_STAGE>' (stage_path_and_root_directory )
-- // MAIN_FILE = '/<MAIN_FILE_NAME>.py' (path_to_main_file_in_root_directory)

CREATE STREAMLIT IF NOT EXISTS ask_chatgpt_anything
  ROOT_LOCATION = '@<STREAMLIT_DB>.<STREAMLIT_DB_SCHEMA>.<STREAMLIT_DB_SCHEMA_STAGE>'
  MAIN_FILE = ' /<MAIN_FILE_NAME>.py'
  QUERY_WAREHOUSE = <STREAMLIT_WH> -- warehouse_name (optional)
  TITLE = '<TITLE>' -- (optional)
  COMMENT = '<COMMENT>' --string_literal (optional)
;