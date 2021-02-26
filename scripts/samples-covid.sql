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

CREATE SCHEMA samples;
GO

CREATE EXTERNAL TABLE samples.covid (
	[date] date,
	[state] varchar(8000),
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
	[data_quality_grade] varchar(8000),
	[last_update_et] datetime2(7),
	[hash] varchar(8000),
	[date_checked] varchar(8000),
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
	[fips_code] varchar(8000),
	[iso_subdivision] varchar(8000),
	[load_time] datetime2(7),
	[iso_country] varchar(8000)
	)
	WITH (
	LOCATION = 'curated/covid-19/covid_tracking/latest/covid_tracking.parquet',
	DATA_SOURCE = [public_pandemicdatalake_blob_core_windows_net],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

SELECT TOP 100 * FROM samples.covid
GO

