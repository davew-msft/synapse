/*
    data
    browse gallery
    Covid Tracking Project
    select top 100

    now CREATE EXTERNAL TABLE on the context menu to load into our datalake
    see below
*/

USE sandbox
GO
--we need to set sandbox to utf-8 so parquet works properly
ALTER DATABASE sandbox 
    COLLATE Latin1_General_100_BIN2_UTF8;
GO
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseParquetFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] 
	WITH ( FORMAT_TYPE = PARQUET)
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'public_pandemicdatalake_blob_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [public_pandemicdatalake_blob_core_windows_net] 
	WITH (
		LOCATION   = 'https://pandemicdatalake.blob.core.windows.net/public', 
	)
Go

IF NOT EXISTS (select * from sys.schemas where name = 'samples')
	EXEC('CREATE SCHEMA samples;')
GO

CREATE EXTERNAL TABLE samples.covid (
	[date] date,
	[state] nvarchar(4000),
	[positive] int,
	[negative] int,
	[pending] smallint,
	[hospitalized_currently] smallint,
	[hospitalized_cumulative] int,
	[in_icu_currently] smallint,
	[in_icu_cumulative] smallint,
	[on_ventilator_currently] smallint,
	[on_ventilator_cumulative] smallint,
	[recovered] int,
	[data_quality_grade] varchar(4000),
	[last_update_et] datetime2(7),
	[hash] nvarchar(4000),
	[date_checked] varchar(4000),
	[death] smallint,
	[hospitalized] int,
	[total] int,
	[total_test_results] int,
	[pos_neg] int,
	[fips] smallint,
	[death_increase] smallint,
	[hospitalized_increase] smallint,
	[negative_increase] int,
	[positive_increase] smallint,
	[total_test_results_increase] int,
	[fips_code] nvarchar(4000),
	[iso_subdivision] varchar(4000),
	[load_time] datetime2(7),
	[iso_country] nvarchar(4000)
	)
	WITH (
	LOCATION = 'curated/covid-19/covid_tracking/latest/covid_tracking.parquet',
	DATA_SOURCE = [public_pandemicdatalake_blob_core_windows_net],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

SELECT TOP 100 * FROM samples.covid
GO

--now I want to make a copy of this data in my datalake.  
--I want to put this in the raw area of my dl
IF NOT EXISTS (select * from sys.schemas where name = 'raw')
	EXEC('CREATE SCHEMA raw;')
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'wwi02') 
	CREATE EXTERNAL DATA SOURCE [wwi02] 
	WITH (
		LOCATION   = 'https://asadatalakedavew891.dfs.core.windows.net/wwi-02', 
	)
GO

CREATE EXTERNAL TABLE raw.covid_data
    WITH (
        LOCATION = 'raw/covid_data',  
        DATA_SOURCE = wwi02,  
        FILE_FORMAT = SynapseParquetFormat  
    )
AS
SELECT TOP 100 * FROM samples.covid;
GO

--now I can query that external table in my data lake
select * from raw.covid_data;


