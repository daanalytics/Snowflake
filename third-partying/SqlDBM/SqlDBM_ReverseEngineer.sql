create or replace schema SQLDBM;

create or replace TRANSIENT TABLE "Dim_Customer" (
	"CustomerId" NUMBER(38,0) NOT NULL,
	"CustomerName" VARCHAR(16777216) NOT NULL,
	"Phone" VARCHAR(16777216),
	constraint PK_table_2 primary key ("CustomerId")
);
create or replace TABLE "Dim_Date" (
	"DateId" NUMBER(38,0) NOT NULL,
	"Date" TIMESTAMP_NTZ(9) NOT NULL,
	"Day" NUMBER(38,0) NOT NULL,
	"Week" NUMBER(38,0) NOT NULL,
	"Month" NUMBER(38,0) NOT NULL,
	"Year" NUMBER(38,0) NOT NULL,
	constraint PK_Dim_Date primary key ("DateId")
);
create or replace TABLE "Dim_Order" (
	"OrderId" NUMBER(38,0) NOT NULL,
	"OrderNumber" VARCHAR(16777216) NOT NULL,
	constraint PK_DIm_Oreder primary key ("OrderId")
);
create or replace TABLE "Dim_Product" (
	"ProductId" NUMBER(38,0) NOT NULL,
	"ProductName" VARCHAR(16777216) NOT NULL,
	"IsDiscontinued" BOOLEAN NOT NULL,
	constraint PK_Product primary key ("ProductId")
);
create or replace TABLE "Dim_Supplier" (
	"SupplierId" NUMBER(38,0) NOT NULL,
	"CompanyName" VARCHAR(16777216) NOT NULL,
	"Phone" VARCHAR(16777216),
	constraint PK_Dim_Supplier primary key ("SupplierId")
);
create or replace TABLE "Fact_Customer_Orders" (
	"CustomerId" NUMBER(38,0) NOT NULL,
	"OrderId" NUMBER(38,0) NOT NULL,
	"DateId" NUMBER(38,0) NOT NULL,
	"SupplierId" NUMBER(38,0) NOT NULL,
	"ProductId" NUMBER(38,0) NOT NULL,
	"Price" NUMBER(38,0) NOT NULL,
	"Quantity" NUMBER(38,0) NOT NULL,
	"Profit" NUMBER(38,0) NOT NULL,
	constraint PK_Fact_Customer_Orders primary key ("CustomerId", "OrderId", "DateId", "SupplierId", "ProductId"),
	constraint FK_Fact_Customer_Orders_CustomerId foreign key ("CustomerId") references DAANALYTICS.SQLDBM."Dim_Customer"(CustomerId),
	constraint FK_Fact_Customer_Orders_DateId foreign key ("DateId") references DAANALYTICS.SQLDBM."Dim_Date"(DateId),
	constraint FK_Fact_Customer_Orders_OrderId foreign key ("OrderId") references DAANALYTICS.SQLDBM."Dim_Order"(OrderId),
	constraint FK_Fact_Customer_Orders_ProductId foreign key ("ProductId") references DAANALYTICS.SQLDBM."Dim_Product"(ProductId),
	constraint FK_Fact_Customer_Orders_SupplierId foreign key ("SupplierId") references DAANALYTICS.SQLDBM."Dim_Supplier"(SupplierId)
);
CREATE OR REPLACE FILE FORMAT CSVFILEFORMAT
	COMPRESSION = BROTLI
;