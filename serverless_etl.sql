/*
Goal:  Show how to do basic ETL and data engineering using nothing but SQL Serverless
and TSQL

To do that we are going to load up covid 19 dataset. 
We will do that directly from my data lake.  

You can view this data using Storage Explorer:  https://davewdemoblobs.blob.core.windows.net/covid?sv=2020-04-08&st=2020-07-12T19%3A36%3A00Z&se=2026-07-13T19%3A36%3A00Z&sr=c&sp=rl&sig=xVcusZsNwsTtvfty1xVthRNLpF6ASylmKezwYACVXT8%3D
SASKey:  sv=2020-04-08&st=2020-07-12T19%3A36%3A00Z&se=2026-07-13T19%3A36%3A00Z&sr=c&sp=rl&sig=xVcusZsNwsTtvfty1xVthRNLpF6ASylmKezwYACVXT8%3D

*/

--best to start with a new SQL SERVERLESS db
CREATE DATABASE etl_with_serverless
GO
USE etl_with_serverless
GO

--we need to set sandbox to utf-8 so parquet works properly
ALTER DATABASE etl_with_serverless 
    COLLATE Latin1_General_100_BIN2_UTF8;

--we need to setup some security and credentials
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password01!!' ;

--this is MY datalake's sas credential
CREATE DATABASE SCOPED CREDENTIAL [SasToken]
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
     SECRET = 'sv=2020-04-08&st=2020-07-12T19%3A36%3A00Z&se=2026-07-13T19%3A36%3A00Z&sr=c&sp=rl&sig=xVcusZsNwsTtvfty1xVthRNLpF6ASylmKezwYACVXT8%3D';
GO

CREATE EXTERNAL DATA SOURCE dave_covid
WITH (    LOCATION   = 'https://davewdemoblobs.blob.core.windows.net/covid',
          CREDENTIAL = SasToken
)

--to save you some time determining the schema, I've done it for you
--DROP VIEW covidview
CREATE VIEW covidview AS
SELECT
    *
FROM
    OPENROWSET(
        BULK '/covid_19_data.csv',
        FORMAT = 'CSV',
        PARSER_VERSION='2.0',
        DATA_SOURCE = 'dave_covid',
        FIRSTROW = 2
    ) WITH (
      SNo int,
      ObservationDate varchar(50),
      ProvinceState varchar(200),
      CountryRegion varchar(200),
      LastUpdate varchar(50),
      Confirmed decimal(18,2),
      Deaths decimal(18,2),
      Recovered decimal(18,2)
) AS [result]


--now we can do some basic EDA
select top 10 * from covidview;
select count(*) from covidview;


/*

first thing we should do is land this data to YOUR datalake
remember, my datalake is only "rl" for you, and you need to be able to write
so, we need to determine where to write this "bronze" data in your lake
In the "Data" pane in Synapse workspace, choose "Linked" then find your datalake
Now create a folder called "bronze"

Now we need to do some "one-time" setup stuff
*/

--file format definition
CREATE EXTERNAL FILE FORMAT [ParquetFF] WITH (
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);
GO

/*
You need a SAS token to your datalake container.
Do that now.

*/
 
-- create credentials for your lake container
--if you need help, let me know.  
--change the vars accordingly
CREATE DATABASE SCOPED CREDENTIAL lakeCred
WITH IDENTITY='SHARED ACCESS SIGNATURE',  
SECRET = '?sv=2020-02-10&st=2020-07-12T20%3A14%3A00Z&se=2031-07-13T20%3A14%3A00Z&sr=c&sp=racwdlmeop&sig=80q0VmCbj9cCHBVhgRGIa5%2FlBrfSgnZdTsxTHdcefbo%3D'
GO
CREATE EXTERNAL DATA SOURCE lake WITH (
    LOCATION = 'https://asadatalakedavew891.blob.core.windows.net/wwi-02',
    CREDENTIAL = lakeCred
);


/*
This usually takes me a few tries to get the path right, so let's just write out
one sample row first to see if it works.  

This is the basic CETAS syntax and is the key to doing TSQL based ETL with Synapse Serverless.
*/


CREATE EXTERNAL TABLE foobar WITH (
    --adjust your pathing accordingly
    LOCATION = '/bronze/covid',
    DATA_SOURCE = [lake] ,
    FILE_FORMAT = [ParquetFF]
) AS 
SELECT 'HelloWorld' as test

--doublecheck that the parquet file was written correctly, then delete it
--now we want to write out ALL rows from MY datalake to yours.
CREATE EXTERNAL TABLE landing_covid WITH (
    --adjust your pathing accordingly
    LOCATION = '/bronze/covid',
    DATA_SOURCE = [lake] ,
    FILE_FORMAT = [ParquetFF]
) AS 
SELECT * FROM covidview;

--check the size of the file in your lake
--there should be a significant reduction in space with parquet

--let's do some basic queries to check things
SELECT TOP 100 * from landing_covid;
select count(*) from landing_covid;
Select CountryRegion, sum(Confirmed) as Confirmed, sum(Deaths) as Deaths, sum(Recovered) as Recovered
 from landing_covid 
group by CountryRegion

--don't forget, we can chart this data
Select datepart(YEAR, ObservationDate) as year, datepart(MONTH, ObservationDate) as month, 
CountryRegion, 
sum(Confirmed) as Confirmed, sum(Deaths) as Deaths, sum(Recovered) as Recovered
 from covidview 
group by datepart(YEAR, ObservationDate), datepart(MONTH, ObservationDate),CountryRegion

--now, let's say that data you know everyone will want to see on a dashboard, let's
--persist that query to the SILVER area of the lake with CETAS
CREATE EXTERNAL TABLE silver_covid_summaries WITH (
    --adjust your pathing accordingly
    LOCATION = '/silver/covid_summaries',
    DATA_SOURCE = [lake] ,
    FILE_FORMAT = [ParquetFF]
) AS 
Select datepart(YEAR, ObservationDate) as year, datepart(MONTH, ObservationDate) as month, 
CountryRegion, 
sum(Confirmed) as Confirmed, sum(Deaths) as Deaths, sum(Recovered) as Recovered
 from covidview 
group by datepart(YEAR, ObservationDate), datepart(MONTH, ObservationDate),CountryRegion

--check that the data hit the lake correctly and also your new table is working
select top 100 * from silver_covid_summaries

--congrats, you just did ETL using TSQL, your datalake, and Synapse Serverless
