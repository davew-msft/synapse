IF NOT EXISTS (select * from sys.schemas where schema_id = schema_id('warehouse'))
    EXEC('CREATE SCHEMA warehouse;');
GO
IF NOT EXISTS (select * from sys.tables where object_id = object_id('warehouse.factSales'))
BEGIN
CREATE TABLE [warehouse].[factSales]
  (
    [TransactionId] [uniqueidentifier]  NOT NULL,
    [CustomerId] [int]  NOT NULL,
    [ProductId] [smallint]  NOT NULL,
    [Quantity] [tinyint]  NOT NULL,
    [Price] [decimal](9,2)  NOT NULL,
    [TotalAmount] [decimal](9,2)  NOT NULL,
    [TransactionDateId] [int]  NOT NULL,
    [ProfitAmount] [decimal](9,2)  NOT NULL,
    [Hour] [tinyint]  NOT NULL,
    [Minute] [tinyint]  NOT NULL,
    [StoreId] [smallint]  NOT NULL
  )
  WITH
  (
    DISTRIBUTION = HASH ( [CustomerId] ),
    CLUSTERED COLUMNSTORE INDEX,
    PARTITION
    (
      [TransactionDateId] RANGE RIGHT FOR VALUES (
        20180101, 20180201, 20180301, 20180401, 20180501, 20180601, 20180701, 20180801, 20180901, 20181001, 20181101, 20181201,
        20190101, 20190201, 20190301, 20190401, 20190501, 20190601, 20190701, 20190801, 20190901, 20191001, 20191101, 20191201)
    )
  );
END;
GO

IF NOT EXISTS (select * from sys.tables where object_id = object_id('warehouse.dimCustomer'))
BEGIN
 CREATE TABLE [warehouse].[dimCustomer]
 (
   [UserName] [nvarchar](100)  NULL,
   [Gender] [nvarchar](10)  NULL,
   [Phone] [nvarchar](50)  NULL,
   [Email] [nvarchar](150)  NULL,
   [CreditCard] [nvarchar](21)  NULL
 )
 WITH
 (
   DISTRIBUTION = REPLICATE,
   CLUSTERED COLUMNSTORE INDEX
 )
 END;
 GO