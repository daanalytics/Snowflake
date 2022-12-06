README.md

# Using Python and Snowflake ❄️ together

Python and Snowflake go well together. Check various scripts and examples here.

Connecting Python to Snowflake is a recurring case in the examples here. How you can set a connection up is descrbed [*here*](https://github.com/daanalytics/Snowflake/blob/master/python/SF_connect_Py2SF.md).

- [Plotting F1 Circuit Locations into a map using Folium](https://github.com/daanalytics/Snowflake/blob/master/python/F1FoliumCircuits.ipynb), a continuation of the below example. Checkout some more on the [DaAnalytics blog](https://daanalytics.nl/plotting-f1-circuit-locations-into-a-map-using-folium/).

- [Loading F1 Historical Data into Snowflake using the Ergast Developer API](https://gist.github.com/daanalytics/56cc78a2e6b1b844529939504869b102) is using an API to load data into Snowflake earlier. Checkout the [*blogpost*](https://daanalytics.medium.com/loading-f1-historical-data-into-snowflake-using-the-ergast-developer-api-e94bc8c6ef51) for further details and code-snippets.  

- [*From Kaggle to Snowflake*](https://github.com/daanalytics/Snowflake/blob/master/python/F1DemoConnectKaggle.py) is an alternative solution for the previous example where we loaded .csv-files into Snowflake. This time we loaded the data directly from Kaggle. See the [*blogpost*](https://daanalytics.medium.com/from-kaggle-to-snowflake-feebae94ad2a) to see how things work.   

- [*From .csv to Snowflake*](https://github.com/daanalytics/Snowflake/blob/master/python/F1createDemo.py) is an example of how to read from .csv-files, create Snowflake objects an load Data into Snowflake. Maybe not the most obvious solution to load data into Snowflake. Still interesting to see how you can use Panda Data Frames in relation to Snowflake. The [*blogpost*](https://daanalytics.medium.com/from-csv-to-snowflake-46889eabbad6) explains things in a little bit more detail.

*Streamlit* is an interesting alternative for Power BI dashboards. Find some of the examples in the [*Streamlit-folder*](https://github.com/daanalytics/Snowflake/blob/master/python/streamlit/)
