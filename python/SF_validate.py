#!/usr/bin/env python
import snowflake.connector
import json


config_location = '<path to credentials-file>'

config = json.loads(open(str(config_location+'/cred.json')).read())

username = config['secrets']['username']
password = config['secrets']['password']
account = config['secrets']['account']

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