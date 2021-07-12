/*

This demo creates a Logical Data Warehouse using the contoso DW using data sourced 
in MY data lake.  

You can look at my data using Storage Explorer here:  https://davewdemoblobs.blob.core.windows.net/contosoretaildw-tables?sv=2020-04-08&st=2020-07-12T19%3A04%3A00Z&se=2031-07-13T19%3A04%3A00Z&sr=c&sp=rl&sig=82oXyOImJpl2MvJzBrUdhlECZvEvY4CwH9%2B6isoNty8%3D
This is the SAS token: sv=2020-04-08&st=2020-07-12T19%3A04%3A00Z&se=2031-07-13T19%3A04%3A00Z&sr=c&sp=rl&sig=82oXyOImJpl2MvJzBrUdhlECZvEvY4CwH9%2B6isoNty8%3D

*/

--build a SERVERLESS db to "store" the data
CREATE DATABASE LDW;
GO
USE LDW;
GO

--we need to setup some security and credentials
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password01!!' ;

CREATE DATABASE SCOPED CREDENTIAL [SasToken]
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
     SECRET = 'sv=2020-04-08&st=2020-07-12T19%3A04%3A00Z&se=2031-07-13T19%3A04%3A00Z&sr=c&sp=rl&sig=82oXyOImJpl2MvJzBrUdhlECZvEvY4CwH9%2B6isoNty8%3D';
GO

-- drop CREDENTIAL [https://davewdemoblobs.blob.core.windows.net/contosoretaildw-tables]
-- CREATE CREDENTIAL [https://davewdemoblobs.blob.core.windows.net/contosoretaildw-tables]
-- WITH IDENTITY='SHARED ACCESS SIGNATURE'
-- , SECRET = 'sv=2020-04-08&st=2020-07-12T19%3A04%3A00Z&se=2031-07-13T19%3A04%3A00Z&sr=c&sp=rl&sig=82oXyOImJpl2MvJzBrUdhlECZvEvY4CwH9%2B6isoNty8%3D';
-- GO

-- Create an external data source with CREDENTIAL option.
CREATE EXTERNAL DATA SOURCE dave_contoso
WITH (    LOCATION   = 'https://davewdemoblobs.blob.core.windows.net/contosoretaildw-tables',
          CREDENTIAL = SasToken
)

-- CREATE EXTERNAL DATA SOURCE MyAzureStorage
-- WITH
--   ( LOCATION = 'wasbs://daily@logs.blob.core.windows.net/' ,
--     CREDENTIAL = AzureStorageCredential ,
--     TYPE = HADOOP
--   ) ;



--create an external data source to MY data lake/contoso data
--DROP EXTERNAL DATA SOURCE dave_contoso
--DROP EXTERNAL TABLE [contoso].DimAccount 
-- CREATE EXTERNAL DATA SOURCE dave_contoso
-- WITH 
-- (  
--     --this is the location with the SAS key from above
--     LOCATION = 'https://davewdemoblobs.blob.core.windows.net/contosoretaildw-tables?sv=2020-04-08&st=2020-07-12T19%3A04%3A00Z&se=2031-07-13T19%3A04%3A00Z&sr=c&sp=rl&sig=82oXyOImJpl2MvJzBrUdhlECZvEvY4CwH9%2B6isoNty8%3D'
-- ); 
-- GO

--all data is stored in text files (yuk)
--this is the file format
CREATE EXTERNAL FILE FORMAT TextFileFormat 
WITH 
(   FORMAT_TYPE = DELIMITEDTEXT
,	FORMAT_OPTIONS	(   FIELD_TERMINATOR = '|'
					,	STRING_DELIMITER = ''
					,	USE_TYPE_DEFAULT = FALSE 
					)
);
GO

CREATE SCHEMA contoso;
GO

--now let's create each table
--we need to declare colnames and types because we are using delimited files
--the location is the folder under the root directory I gave to you above

CREATE EXTERNAL TABLE [contoso].DimAccount 
(
	[AccountKey] [int],
	[ParentAccountKey] [int],
	[AccountLabel] [nvarchar](100),
	[AccountName] [nvarchar](50),
	[AccountDescription] [nvarchar](50),
	[AccountType] [nvarchar](50),
	[Operator] [nvarchar](50),
	[CustomMembers] [nvarchar](300),
	[ValueType] [nvarchar](50),
	[CustomMemberOptions] [nvarchar](200),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH 
(
    LOCATION='/DimAccount/' 
,   DATA_SOURCE = dave_contoso
,   FILE_FORMAT = TextFileFormat
)

--make sure it worked
select top 10 * from [contoso].DimAccount;

--DimChannel
CREATE EXTERNAL TABLE [contoso].DimChannel 
(
	[ChannelKey] [int],
	[ChannelLabel] [nvarchar](100),
	[ChannelName] [nvarchar](20),
	[ChannelDescription] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimChannel/' 
,   DATA_SOURCE = dave_contoso
,   FILE_FORMAT = TextFileFormat
)
;

select top 10 * from contoso.DimChannel;
 
--DimCurrency
CREATE EXTERNAL TABLE [contoso].DimCurrency 
(
	[CurrencyKey] [int],
	[CurrencyLabel] [nvarchar](10),
	[CurrencyName] [nvarchar](20),
	[CurrencyDescription] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimCurrency/' 
,   DATA_SOURCE = dave_contoso
,   FILE_FORMAT = TextFileFormat
)
;

--DimCustomer
CREATE EXTERNAL TABLE [contoso].DimCustomer 
(
	[CustomerKey] [int] ,
	[GeographyKey] [int],
	[CustomerLabel] [nvarchar](100),
	[Title] [nvarchar](8),
	[FirstName] [nvarchar](50),
	[MiddleName] [nvarchar](50),
	[LastName] [nvarchar](50),
	[NameStyle] [bit],
	[BirthDate] [datetime],
	[MaritalStatus] [nchar](1),
	[Suffix] [nvarchar](10),
	[Gender] [nvarchar](1),
	[EmailAddress] [nvarchar](50),
	[YearlyIncome] [money],
	[TotalChildren] [tinyint],
	[NumberChildrenAtHome] [tinyint],
	[Education] [nvarchar](40),
	[Occupation] [nvarchar](100),
	[HouseOwnerFlag] [nchar](1),
	[NumberCarsOwned] [tinyint],
	[AddressLine1] [nvarchar](120),
	[AddressLine2] [nvarchar](120),
	[Phone] [nvarchar](20),
	[DateFirstPurchase] [datetime],
	[CustomerType] [nvarchar](15),
	[CompanyName] [nvarchar](100),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimCustomer/' 
,   DATA_SOURCE = dave_contoso
,   FILE_FORMAT = TextFileFormat
)
;

--DimDate
CREATE EXTERNAL TABLE [contoso].DimDate
(
	[Datekey] [datetime],
	[FullDateLabel] [nvarchar](20),
	[DateDescription] [nvarchar](20),
	[CalendarYear] [int],
	[CalendarYearLabel] [nvarchar](20),
	[CalendarHalfYear] [int],
	[CalendarHalfYearLabel] [nvarchar](20),
	[CalendarQuarter] [int],
	[CalendarQuarterLabel] [nvarchar](20),
	[CalendarMonth] [int],
	[CalendarMonthLabel] [nvarchar](20),
	[CalendarWeek] [int],
	[CalendarWeekLabel] [nvarchar](20),
	[CalendarDayOfWeek] [int],
	[CalendarDayOfWeekLabel] [nvarchar](10),
	[FiscalYear] [int],
	[FiscalYearLabel] [nvarchar](20),
	[FiscalHalfYear] [int],
	[FiscalHalfYearLabel] [nvarchar](20),
	[FiscalQuarter] [int],
	[FiscalQuarterLabel] [nvarchar](20),
	[FiscalMonth] [int],
	[FiscalMonthLabel] [nvarchar](20),
	[IsWorkDay] [nvarchar](20),
	[IsHoliday] [int],
	[HolidayName] [nvarchar](20),
	[EuropeSeason] [nvarchar](50),
	[NorthAmericaSeason] [nvarchar](50),
	[AsiaSeason] [nvarchar](50)
)
WITH
(
    LOCATION='/DimDate/' 
,   DATA_SOURCE = dave_contoso
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimEmployee
CREATE EXTERNAL TABLE [contoso].DimEmployee 
(
	[EmployeeKey] [int] ,
	[ParentEmployeeKey] [int],
	[FirstName] [nvarchar](50),
	[LastName] [nvarchar](50),
	[MiddleName] [nvarchar](50),
	[Title] [nvarchar](50),
	[HireDate] [datetime],
	[BirthDate] [datetime],
	[EmailAddress] [nvarchar](50),
	[Phone] [nvarchar](25),
	[MaritalStatus] [nchar](1),
	[EmergencyContactName] [nvarchar](50),
	[EmergencyContactPhone] [nvarchar](25),
	[SalariedFlag] [bit],
	[Gender] [nchar](1),
	[PayFrequency] [tinyint],
	[BaseRate] [money],
	[VacationHours] [smallint],
	[CurrentFlag] [bit],
	[SalesPersonFlag] [bit],
	[DepartmentName] [nvarchar](50),
	[StartDate] [datetime],
	[EndDate] [datetime],
	[Status] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimEmployee/' 
,   DATA_SOURCE = dave_contoso
,   FILE_FORMAT = TextFileFormat
)
;

select * from [contoso].DimEmployee
 
--DimEntity
CREATE EXTERNAL TABLE [contoso].DimEntity 
(
	[EntityKey] [int],
	[EntityLabel] [nvarchar](100),
	[ParentEntityKey] [int],
	[ParentEntityLabel] [nvarchar](100),
	[EntityName] [nvarchar](50),
	[EntityDescription] [nvarchar](100),
	[EntityType] [nvarchar](100),
	[StartDate] [datetime],
	[EndDate] [datetime],
	[Status] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimEntity/' 
,   DATA_SOURCE = dave_contoso
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimGeography
CREATE EXTERNAL TABLE [contoso].DimGeography 
(
	[GeographyKey] [int],
	[GeographyType] [nvarchar](50),
	[ContinentName] [nvarchar](50),
	[CityName] [nvarchar](100),
	[StateProvinceName] [nvarchar](100),
	[RegionCountryName] [nvarchar](100),
--	[Geometry] [geometry],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimGeography/' 
,   DATA_SOURCE = dave_contoso
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimMachine
CREATE EXTERNAL TABLE [contoso].DimMachine 
(
	[MachineKey] [int],
	[MachineLabel] [nvarchar](100),
	[StoreKey] [int],
	[MachineType] [nvarchar](50),
	[MachineName] [nvarchar](100),
	[MachineDescription] [nvarchar](200),
	[VendorName] [nvarchar](50),
	[MachineOS] [nvarchar](50),
	[MachineSource] [nvarchar](100),
	[MachineHardware] [nvarchar](100),
	[MachineSoftware] [nvarchar](100),
	[Status] [nvarchar](50),
	[ServiceStartDate] [datetime],
	[DecommissionDate] [datetime],
	[LastModifiedDate] [datetime],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimMachine/' 
,   DATA_SOURCE = dave_contoso
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimOutage
CREATE EXTERNAL TABLE [contoso].DimOutage (
	[OutageKey] [int] ,
	[OutageLabel] [nvarchar](100),
	[OutageName] [nvarchar](50),
	[OutageDescription] [nvarchar](200),
	[OutageType] [nvarchar](50),
	[OutageTypeDescription] [nvarchar](200),
	[OutageSubType] [nvarchar](50),
	[OutageSubTypeDescription] [nvarchar](200),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimOutage/' 
,   DATA_SOURCE = dave_contoso
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimProduct
CREATE EXTERNAL TABLE [asb].DimProduct (
	[ProductKey] [int],
	[ProductLabel] [nvarchar](255),
	[ProductName] [nvarchar](500),
	[ProductDescription] [nvarchar](400),
	[ProductSubcategoryKey] [int],
	[Manufacturer] [nvarchar](50),
	[BrandName] [nvarchar](50),
	[ClassID] [nvarchar](10),
	[ClassName] [nvarchar](20),
	[StyleID] [nvarchar](10),
	[StyleName] [nvarchar](20),
	[ColorID] [nvarchar](10),
	[ColorName] [nvarchar](20),
	[Size] [nvarchar](50),
	[SizeRange] [nvarchar](50),
	[SizeUnitMeasureID] [nvarchar](20),
	[Weight] [float],
	[WeightUnitMeasureID] [nvarchar](20),
	[UnitOfMeasureID] [nvarchar](10),
	[UnitOfMeasureName] [nvarchar](40),
	[StockTypeID] [nvarchar](10),
	[StockTypeName] [nvarchar](40),
	[UnitCost] [money],
	[UnitPrice] [money],
	[AvailableForSaleDate] [datetime],
	[StopSaleDate] [datetime],
	[Status] [nvarchar](7),
	[ImageURL] [nvarchar](150),
	[ProductURL] [nvarchar](150),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimProduct/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimProductCategory
CREATE EXTERNAL TABLE [asb].DimProductCategory (
	[ProductCategoryKey] [int] ,
	[ProductCategoryLabel] [nvarchar](100),
	[ProductCategoryName] [nvarchar](30),
	[ProductCategoryDescription] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimProductCategory/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimProductSubcategory
CREATE EXTERNAL TABLE [asb].DimProductSubcategory (
	[ProductSubcategoryKey] [int] ,
	[ProductSubcategoryLabel] [nvarchar](100),
	[ProductSubcategoryName] [nvarchar](50),
	[ProductSubcategoryDescription] [nvarchar](100),
	[ProductCategoryKey] [int],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimProductSubcategory/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimPromotion
CREATE EXTERNAL TABLE [asb].DimPromotion (
	[PromotionKey] [int] ,
	[PromotionLabel] [nvarchar](100),
	[PromotionName] [nvarchar](100),
	[PromotionDescription] [nvarchar](255),
	[DiscountPercent] [float],
	[PromotionType] [nvarchar](50),
	[PromotionCategory] [nvarchar](50),
	[StartDate] [datetime],
	[EndDate] [datetime],
	[MinQuantity] [int],
	[MaxQuantity] [int],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimPromotion/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
 
--DimSalesTerritory
CREATE EXTERNAL TABLE [asb].DimSalesTerritory (
	[SalesTerritoryKey] [int] ,
	[GeographyKey] [int],
	[SalesTerritoryLabel] [nvarchar](100),
	[SalesTerritoryName] [nvarchar](50),
	[SalesTerritoryRegion] [nvarchar](50),
	[SalesTerritoryCountry] [nvarchar](50),
	[SalesTerritoryGroup] [nvarchar](50),
	[SalesTerritoryLevel] [nvarchar](10),
	[SalesTerritoryManager] [int],
	[StartDate] [datetime],
	[EndDate] [datetime],
	[Status] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimSalesTerritory/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--DimScenario
CREATE EXTERNAL TABLE [asb].DimScenario (
	[ScenarioKey] [int],
	[ScenarioLabel] [nvarchar](100),
	[ScenarioName] [nvarchar](20),
	[ScenarioDescription] [nvarchar](50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimScenario/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--DimStore
CREATE EXTERNAL TABLE [asb].DimStore 
(
	[StoreKey] [int],
	[GeographyKey] [int],
	[StoreManager] [int],
	[StoreType] [nvarchar](15),
	[StoreName] [nvarchar](100),
	[StoreDescription] [nvarchar](300),
	[Status] [nvarchar](20),
	[OpenDate] [datetime],
	[CloseDate] [datetime],
	[EntityKey] [int],
	[ZipCode] [nvarchar](20),
	[ZipCodeExtension] [nvarchar](10),
	[StorePhone] [nvarchar](15),
	[StoreFax] [nvarchar](14),
	[AddressLine1] [nvarchar](100),
	[AddressLine2] [nvarchar](100),
	[CloseReason] [nvarchar](20),
	[EmployeeCount] [int],
	[SellingAreaSize] [float],
	[LastRemodelDate] [datetime],
	[GeoLocation]	NVARCHAR(50) ,
	[Geometry]		NVARCHAR(50),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/DimStore/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--FactExchangeRate
CREATE EXTERNAL TABLE [asb].FactExchangeRate 
(
	[ExchangeRateKey] [int] ,
	[CurrencyKey] [int],
	[DateKey] [datetime],
	[AverageRate] [float],
	[EndOfDayRate] [float],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactExchangeRate/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--FactInventory
CREATE EXTERNAL TABLE [asb].FactInventory (
	[InventoryKey] [int] ,
	[DateKey] [datetime],
	[StoreKey] [int],
	[ProductKey] [int],
	[CurrencyKey] [int],
	[OnHandQuantity] [int],
	[OnOrderQuantity] [int],
	[SafetyStockQuantity] [int],
	[UnitCost] [money],
	[DaysInStock] [int],
	[MinDayInStock] [int],
	[MaxDayInStock] [int],
	[Aging] [int],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactInventory/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--FactITMachine
CREATE EXTERNAL TABLE [asb].FactITMachine (
	[ITMachinekey] [int],
	[MachineKey] [int],
	[Datekey] [datetime],
	[CostAmount] [money],
	[CostType] [nvarchar](200),
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactITMachine/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;


--FactITSLA
CREATE EXTERNAL TABLE [asb].FactITSLA 
(
	[ITSLAkey] [int] ,
	[DateKey] [datetime],
	[StoreKey] [int],
	[MachineKey] [int],
	[OutageKey] [int],
	[OutageStartTime] [datetime],
	[OutageEndTime] [datetime],
	[DownTime] [int],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactITSLA/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--FactOnlineSales
CREATE EXTERNAL TABLE [asb].FactOnlineSales 
(
	[OnlineSalesKey] [int] ,
	[DateKey] [datetime],
	[StoreKey] [int],
	[ProductKey] [int],
	[PromotionKey] [int],
	[CurrencyKey] [int],
	[CustomerKey] [int],
	[SalesOrderNumber] [nvarchar](20),
	[SalesOrderLineNumber] [int],
	[SalesQuantity] [int],
	[SalesAmount] [money],
	[ReturnQuantity] [int],
	[ReturnAmount] [money],
	[DiscountQuantity] [int],
	[DiscountAmount] [money],
	[TotalCost] [money],
	[UnitCost] [money],
	[UnitPrice] [money],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactOnlineSales/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--FactSales
CREATE EXTERNAL TABLE [asb].FactSales 
(
	[SalesKey] [int] ,
	[DateKey] [datetime],
	[channelKey] [int],
	[StoreKey] [int],
	[ProductKey] [int],
	[PromotionKey] [int],
	[CurrencyKey] [int],
	[UnitCost] [money],
	[UnitPrice] [money],
	[SalesQuantity] [int],
	[ReturnQuantity] [int],
	[ReturnAmount] [money],
	[DiscountQuantity] [int],
	[DiscountAmount] [money],
	[TotalCost] [money],
	[SalesAmount] [money],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactSales/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;

--FactSalesQuota
CREATE EXTERNAL TABLE [asb].FactSalesQuota (
	[SalesQuotaKey] [int] ,
	[ChannelKey] [int],
	[StoreKey] [int],
	[ProductKey] [int],
	[DateKey] [datetime],
	[CurrencyKey] [int],
	[ScenarioKey] [int],
	[SalesQuantityQuota] [money],
	[SalesAmountQuota] [money],
	[GrossMarginQuota] [money],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactSalesQuota/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
 
--FactStrategyPlan
CREATE EXTERNAL TABLE [asb].FactStrategyPlan 
(
	[StrategyPlanKey] [int] ,
	[Datekey] [datetime],
	[EntityKey] [int],
	[ScenarioKey] [int],
	[AccountKey] [int],
	[CurrencyKey] [int],
	[ProductCategoryKey] [int],
	[Amount] [money],
	[ETLLoadID] [int],
	[LoadDate] [datetime],
	[UpdateDate] [datetime]
)
WITH
(
    LOCATION='/FactStrategyPlan/' 
,   DATA_SOURCE = AzureStorage_west_public
,   FILE_FORMAT = TextFileFormat
)
;
