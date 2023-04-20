-- 
-- *********************** SqlDBM: Snowflake ************************
-- ******************************************************************

CREATE FILE FORMAT IF NOT EXISTS CsvFileFormat
 TYPE = CSV
 COMPRESSION = BROTLI;

-- ************************************** "Dim_Date"
CREATE TABLE "Dim_Date"
(
 "DateId" int NOT NULL,
 "Date"   datetime NOT NULL,
 "Day"    int NOT NULL,
 "Week"   int NOT NULL,
 "Month"  int NOT NULL,
 "Year"   int NOT NULL,
 CONSTRAINT "PK_Dim_Date" PRIMARY KEY ( "DateId" )
)
STAGE_FILE_FORMAT = 
(
 FORMAT_NAME = 'CsvFileFormat'
);

-- ************************************** "Dim_Customer"
CREATE TRANSIENT TABLE "Dim_Customer"
(
 "CustomerId"   int NOT NULL,
 "CustomerName" string NOT NULL,
 "Phone"        string,
 CONSTRAINT "PK_table_2" PRIMARY KEY ( "CustomerId" )
)
STAGE_FILE_FORMAT = 
(
 FORMAT_NAME = 'CsvFileFormat'
)
STAGE_COPY_OPTIONS = 
( 
 ON_ERROR = CONTINUE
 PURGE = TRUE
 TRUNCATECOLUMNS = TRUE
 FORCE = TRUE
);

-- ************************************** "Dim_Product"
CREATE TABLE IF NOT EXISTS "Dim_Product"
(
 "ProductId"      int NOT NULL,
 "ProductName"    string NOT NULL,
 "IsDiscontinued" boolean NOT NULL,
 CONSTRAINT "PK_Product" PRIMARY KEY ( "ProductId" )
)
STAGE_FILE_FORMAT = 
(
 FORMAT_NAME = 'CsvFileFormat'
);

-- ************************************** "Dim_Order"
CREATE TABLE IF NOT EXISTS "Dim_Order"
(
 "OrderId"     int NOT NULL,
 "OrderNumber" string NOT NULL,
 CONSTRAINT "PK_DIm_Oreder" PRIMARY KEY ( "OrderId" )
)
STAGE_FILE_FORMAT = 
(
 FORMAT_NAME = 'CsvFileFormat'
);

-- ************************************** "Dim_Supplier"
CREATE TABLE IF NOT EXISTS "Dim_Supplier"
(
 "SupplierId"  int NOT NULL,
 "CompanyName" string NOT NULL,
 "Phone"       string,
 CONSTRAINT "PK_Dim_Supplier" PRIMARY KEY ( "SupplierId" )
)
STAGE_FILE_FORMAT = 
(
 FORMAT_NAME = 'CsvFileFormat'
);

-- ************************************** "Fact_Customer_Orders"
CREATE TABLE IF NOT EXISTS "Fact_Customer_Orders"
(
 "CustomerId" int NOT NULL,
 "OrderId"    int NOT NULL,
 "DateId"     int NOT NULL,
 "SupplierId" int NOT NULL,
 "ProductId"  int NOT NULL,
 "Price"      decimal NOT NULL,
 "Quantity"   int NOT NULL,
 "Profit"     decimal NOT NULL,
 CONSTRAINT "PK_Fact_Customer_Orders" PRIMARY KEY ( "CustomerId", "OrderId", "DateId", "SupplierId", "ProductId" ),
 CONSTRAINT "FK_Fact_Customer_Orders_CustomerId" FOREIGN KEY ( "CustomerId" ) REFERENCES "Dim_Customer" ( "CustomerId" ),
 CONSTRAINT "FK_Fact_Customer_Orders_DateId" FOREIGN KEY ( "DateId" ) REFERENCES "Dim_Date" ( "DateId" ),
 CONSTRAINT "FK_Fact_Customer_Orders_OrderId" FOREIGN KEY ( "OrderId" ) REFERENCES "Dim_Order" ( "OrderId" ),
 CONSTRAINT "FK_Fact_Customer_Orders_ProductId" FOREIGN KEY ( "ProductId" ) REFERENCES "Dim_Product" ( "ProductId" ),
 CONSTRAINT "FK_Fact_Customer_Orders_SupplierId" FOREIGN KEY ( "SupplierId" ) REFERENCES "Dim_Supplier" ( "SupplierId" )
)
STAGE_FILE_FORMAT = 
(
 FORMAT_NAME = 'CsvFileFormat'
);


