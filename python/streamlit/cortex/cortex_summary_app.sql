-- Switch to sysadmin role
USE ROLE sysadmin;

-- Create a Database and a Schema to create your objects
CREATE database cortex_r_and_d;

CREATE schema webscrape_summary;

USE schema cortex_r_and_d.webscrape_summary;

-- Enable the integration with an external site. In this case the Yahoo Finance Site

-- Switch to accountadmin role
USE ROLE accountadmin;

-- Create NETWORK firewall rule to access Yahoo Finance Site

CREATE OR REPLACE NETWORK RULE network_rule_for_yahoo_access
 MODE = EGRESS
 TYPE = HOST_PORT
 VALUE_LIST = ('finance.yahoo.com');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION access_integration_for_yahoo
 ALLOWED_NETWORK_RULES = (network_rule_for_yahoo_access)
 ENABLED = true;

GRANT USAGE ON INTEGRATION access_integration_for_yahoo TO ROLE sysadmin;

-- Create a native Python function to scrape HTML code 
-- and cleanup & remove HTML using BeautifulSoup library from Anaconda.

-- Switch to sysadmin role
USE ROLE sysadmin;

CREATE OR REPLACE FUNCTION webscrape_yahoo (weburl STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.8
HANDLER = 'get_page'
EXTERNAL_ACCESS_INTEGRATIONS = (access_integration_for_yahoo)
PACKAGES = ('requests', 'beautifulsoup4')
AS
$$
import _snowflake
import requests
from bs4 import BeautifulSoup

def get_page(weburl):
 url = f"{weburl}"
 response = requests.get(url)
 soup = BeautifulSoup(response.text)
 return soup.get_text()
$$;

-- If you want specific roles to execute the webscrape_yahoo function, run
GRANT USAGE ON DATABASE cortex_r_and_d TO ROLE data_analyst;
GRANT USAGE ON DATABASE cortex_r_and_d TO ROLE data_engineer;

GRANT USAGE ON SCHEMA cortex_r_and_d.webscrape_summary TO ROLE data_analyst;
GRANT USAGE ON SCHEMA cortex_r_and_d.webscrape_summary TO ROLE data_engineer;

GRANT USAGE ON FUNCTION cortex_r_and_d.webscrape_summary.webscrape_yahoo(VARCHAR) TO data_analyst;
GRANT USAGE ON FUNCTION cortex_r_and_d.webscrape_summary.webscrape_yahoo(VARCHAR) TO data_engineer;

-- Use the Cortex Summarize and pass in text scraped from the Yahoo Finance Site.
SELECT 
 snowflake.cortex.summarize(
 webscrape_yahoo('https://finance.yahoo.com/news/snowflake-reports-financial-results-first-200500958.html')) as summary;

-- Create objects for the Streamlit App
-- Switch to sysadmin role
USE ROLE sysadmin;

-- Create a Schema to create your Streamlit objects
USE DATABASE cortex_r_and_d;

CREATE schema streamlit_app;

USE schema cortex_r_and_d.streamlit_app;

-- If you want specific roles to create Streamlit apps in the STREAMLIT_APP schema, run
GRANT USAGE ON SCHEMA cortex_r_and_d.streamlit_app TO ROLE data_analyst;
GRANT USAGE ON SCHEMA cortex_r_and_d.streamlit_app TO ROLE data_engineer;

GRANT CREATE STREAMLIT ON SCHEMA cortex_r_and_d.streamlit_app TO ROLE data_engineer;
GRANT CREATE STAGE ON SCHEMA cortex_r_and_d.streamlit_app TO ROLE data_engineer;

-- Switch to data_engineer role
USE ROLE data_engineer;
USE WAREHOUSE compute_wh;

SELECT 
 snowflake.cortex.summarize(
 cortex_r_and_d.webscrape_summary.webscrape_yahoo('https://finance.yahoo.com/news/snowflake-reports-financial-results-first-200500958.html')) as summary;
