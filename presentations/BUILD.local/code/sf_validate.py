#!/usr/bin/env python
import snowflake.connector
import json

# Get the credentials
config_location = '/Users/daanbakboord/Library/Mobile Documents/com~apple~CloudDocs/Seni_BV/Daanalytics/R&D/Snowflake/Presentations/BUILD.local 2022/credentials'
credential_file = 'sf_cred.json'

config = json.loads(open(str(config_location + '/' + credential_file)).read())

username    = config['secrets']['username']
password    = config['secrets']['password']
account     = config['secrets']['account']

# Gets the version
ctx = snowflake.connector.connect(
    user        = username,
    password    = password,
    account     = account
    )
cs = ctx.cursor()
try:
    cs.execute("SELECT current_version()")
    one_row = cs.fetchone()
    print(one_row[0])
finally:
    cs.close()
ctx.close()