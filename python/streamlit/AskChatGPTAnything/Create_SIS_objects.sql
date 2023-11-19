-- // Streamlit Snowflake Objects Create Script
BEGIN TRANSACTION;

    SET role_name = '<STREAMLIT_ROLE>';
    SET user_name = '<STREAMLIT_USER>';
    SET user_password = '<STREAMLIT_USER_PWD>'; -- change to a unique password
    SET warehouse_name = '<STREAMLIT_WH>';
    SET database_name = '<STREAMLIT_DB>';
    SET schema_name = '<STREAMLIT_DB_SCHEMA>';
    SET database_schema_name = concat(concat($database_name,'.'), $schema_name);
    SET stage_name = '<STREAMLIT_DB_SCHEMA_STAGE>';

    -- // Change role to useradmin as required for user controls
    USE ROLE useradmin
    ;

    -- // Create a new user for Streamlit, run
    CREATE USER IF NOT EXISTS identifier($user_name)
    password = $user_password
    must_change_password = FALSE
    default_role = $role_name
    default_warehouse = $warehouse_name
    comment = 'Streamlit user'
    ;

    -- // Change role to securityadmin as required for role controls
    USE ROLE securityadmin
    ;
    
    -- // Create role for Streamlit, run
    CREATE ROLE IF NOT EXISTS identifier($role_name)
    ;

    -- // Change role to securityadmin as required for role controls, run
    USE ROLE securityadmin
    ;    

    -- // Grant the created Streamlit Role to the user, run
    GRANT ROLE identifier($role_name) to user identifier($user_name)
    ;

    -- // Change role to sysadmin as required for db and wh controls
    USE ROLE sysadmin
    ;

    -- // Create a warehouse for Streamlit separate compute, run
    CREATE WAREHOUSE IF NOT EXISTS identifier($warehouse_name)
    warehouse_size = xsmall
    warehouse_type = standard
    auto_suspend = 60
    auto_resume = true
    initially_suspended = true
    comment = 'Streamlit Warehouse to separate compute.';

    GRANT USAGE ON WAREHOUSE identifier($warehouse_name)
    TO ROLE identifier($role_name)
    ;
    
    -- // Streamlit apps are schema-level objects in Snowflake. 
    -- Therefore, they are located in a schema under a database.
    -- They also rely on virtual warehouses to provide the compute resource.
    
    -- // If you want to create a new database for Streamlit Apps, run
    CREATE DATABASE IF NOT EXISTS identifier($database_name)
    ;

    -- // If you want to create a specific schema under the database, run
    CREATE SCHEMA IF NOT EXISTS identifier($schema_name)
    ;

    -- // Create a stage under the schema, run
    CREATE STAGE  IF NOT EXISTS identifier($stage_name)
	DIRECTORY = ( ENABLE = true )
    ;

    -- // Execute grants on te various Snowflake objects, run
    GRANT USAGE ON DATABASE identifier($database_name) TO ROLE identifier($role_name)
    ;
    
    GRANT USAGE ON SCHEMA identifier($database_schema_name) TO ROLE identifier($role_name)
    ;
    
    GRANT CREATE STREAMLIT ON SCHEMA identifier($database_schema_name) TO ROLE identifier($role_name)
    ;
    
    GRANT CREATE STAGE ON SCHEMA identifier($database_schema_name) TO ROLE identifier($role_name)
    ;

    -- // Don't forget to grant USAGE on the warehouse.
    GRANT USAGE ON WAREHOUSE identifier($warehouse_name) TO ROLE identifier($role_name)
    ;

    -- // Don't forget to grant READ, WRITE on the stage.
    GRANT READ, WRITE ON STAGE identifier($stage_name) TO ROLE identifier($role_name)
    ;
    
--// Finally commit the transaction of creating the above objects
COMMIT;