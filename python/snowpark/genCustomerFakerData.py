# The Snowpark package is required for Python Worksheets. 
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col
from snowflake.snowpark.types import IntegerType, StringType, DateType, StructType, StructField

# You can add more packages by selecting them using the Packages control and then importing them.
import faker
import pandas as pd
from datetime import datetime

def main(session: snowpark.Session): 
    # Your code goes here, inside the "main" handler.

    # Create empty list
    faker_row_output = []

    # Generate fake Customers
    for i in range(10):
        faker_row_output.append(def_gen_fake_customers()) 
 
    pd_df_fake_customers = pd.DataFrame.from_dict(faker_row_output)

    # Schema for Customer Sample Data 
    schema_for_customers = StructType([
                          StructField("ID", IntegerType(), False),
                          StructField("FIRST_NAME", StringType(), False),
                          StructField("LAST_NAME", StringType(), False),
                          StructField("EMAIL", StringType(), False),     
                          StructField("PHONE_NUMBER", StringType(), False),
                          StructField("BSN_NUMBER", StringType(), False),
                          StructField("ADDRESS", StringType(), False),   
                          StructField("CITY", StringType(), False),
                          StructField("PROVINCE", StringType(), False),        
                          StructField("BIRTHDATE", DateType(), False)
                        ])

    # Create Snowpark DataFrame
    df_fake_customers = session.create_dataframe(pd_df_fake_customers, schema_for_customers)

    # Save table to Snowflake
    df_fake_customers.write.mode("overwrite").save_as_table('CUSTOMERS')

    # Return value will appear in the Results tab.
    return df_fake_customers

def def_gen_fake_customers():
    fake = faker.Faker('nl_NL')

    fake_customer = {}
    fake_customer['id'] = fake.unique.random_int()
    fake_customer['first_name'] = fake.first_name()
    fake_customer['last_name'] = fake.last_name()
    fake_customer['email'] = fake.email()
    fake_customer['phone_number'] = fake.phone_number()
    fake_customer['bsn_number'] = fake.ssn()
    fake_customer['address'] = fake.address()                                  
    fake_customer['city'] = fake.city()
    fake_customer['province'] = fake.province()
    fake_customer['birthdate'] = fake.date_between_dates(date_start=datetime(1965,1,1), date_end=datetime(2003,12,31))  

    return fake_customer