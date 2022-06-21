import os
import streamlit as st
import json

workdir = os.getcwd()
#print (workdir)

conndir = workdir + '/.streamlit/'
#print(conndir)

connfile = conndir + 'cred.json'
print(connfile)

# Create Session object
def create_session():
    if "snowpark_session" not in st.session_state:
        connection_parameters = json.load(open(conndir + 'cred.json'))
        connection_parameters['database'] = 'ENVIRONMENT_DATA_ATLAS'
        connection_parameters['schema'] = 'ENVIRONMENT'
        session = session.builder.configs(connection_parameters).create()
        st.session_state['snowpark_session'] = session
    else:
        session = st.session_state['snowpark_session']

    return session
    print(session.sql('select current_warehouse(), current_database(), current_schema()').collect())
    #return session

st_session = create_session()

#print(session.sql('select current_warehouse(), current_database(), current_schema()').collect())