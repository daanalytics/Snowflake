<p><a target="_blank" href="https://app.eraser.io/workspace/V5ofv8gIMVVuJfAvHTgm" id="edit-in-eraser-github-link"><img alt="Edit in Eraser" src="https://firebasestorage.googleapis.com/v0/b/second-petal-295822.appspot.com/o/images%2Fgithub%2FOpen%20in%20Eraser.svg?alt=media&amp;token=968381c8-a7e7-472a-8ed6-4a6626da5501"></a></p>

# Ask ChatGPT Anything
These scripts will support you in creating the Snowflake in Streamlit (SiS) application; **"Ask ChatGPT Anything"**. The goal of this blog is to take the previous blog and go for Streamlit in Snowflake (SiS, currently in Public Preview on AWS), still using the OpenAI API to send prompts, constructed using the 5W1H Method, to ChatGPT.

The creation of this application is outlined on my [﻿DaAnalytics blog](https://medium.daanalytics.nl/asking-chatgpt-anything-using-streamlit-in-snowflake-and-the-5w1h-method-54ac8db5d333) 

![Snowflake in Streamlit](https://github.com/daanalytics/snowflake/blob/master/pictures/Streamlit%20in%20Snowflake.webp "")

## Table of contents
To create this application we need to perfom a series of steps. First we need to create Snowflake in Streamlit objects. Next, we setup the OpenAI integration, after which we can need to setup Streamlit in Snowflake. When all this is in place, we can finally create the 'Ask ChatGPT Anything' application in Streamlit in Snowflake.

1. [﻿Create Snowflake in Streamlit objects](https://github.com/daanalytics/Snowflake/blob/master/python/streamlit/AskChatGPTAnything/Create_SIS_objects.sql) 
2. [﻿Setup the OpenAI Integration](https://github.com/daanalytics/Snowflake/blob/master/python/streamlit/AskChatGPTAnything/Create_OpenAI_Integration.sql) 
3. [﻿Building the Streamlit Application](https://github.com/daanalytics/Snowflake/blob/master/python/streamlit/AskChatGPTAnything/ask_chatgpt_anything.py) 
4. [﻿Setup Snowflake in Streamlit](https://github.com/daanalytics/Snowflake/blob/master/python/streamlit/AskChatGPTAnything/Create_SIS_application.sql) 
    1. [﻿environment.yml](https://github.com/daanalytics/Snowflake/blob/master/python/streamlit/AskChatGPTAnything/environment.yml) 



<!--- Eraser file: https://app.eraser.io/workspace/V5ofv8gIMVVuJfAvHTgm --->