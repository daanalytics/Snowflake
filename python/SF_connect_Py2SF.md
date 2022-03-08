SF_connect_Py2SF.md

# Connecting Python to Snowflake

When using th Snowflake ❄️ Data Cloud, it's interesting that you can connect to the Data Cloud from Python. Following the steps in the Snowflake Quikstart; [*"Getting Started with Python"*](https://quickstarts.snowflake.com/guide/getting_started_with_python/index.html#2) one can see how to connect Python to Snowflake. In the Quickstart you can see that the credentials are visible in the .py-file.

ctx = snowflake.connector.connect(
    user='<your_user_name>',
    password='<your_password>',
    account='<your_account_name>'
    )

If you do  not want that, there is an alternative solution with a separate file for the credentials and a reference to that file in the .py-file. I created a short example.

1. [*Credentials*](https://github.com/daanalytics/Snowflake/blob/master/python/SF_cred.json)
2. [*Validate*](https://github.com/daanalytics/Snowflake/blob/master/python/SF_validate.py)

In the *Credentials*-file you can register the various components necassary to connect to Snowflake:

 - account (mandatory)
 - user (mandatory)
 - warehouse
 - role
 - database
 - schema
 - password (mandatory)

 From within the *Validate*-file you can reference the *Credentials*-file. First you specify the location of the the *Credentials*-file. Then you make sure that the *Validate*-file can read from the *Credentials*-file. Then you create several variables (at least, username, password and account) with the information specified in the the *Credentials*-file.

If you use this setup and you use version control like Git, make sure to put the credentials file in [*.gitignore*](https://www.atlassian.com/git/tutorials/saving-changes/gitignore). 