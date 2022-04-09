search for TODO in this repo

based on:  https://github.com/microsoft/MCW-Azure-Synapse-Analytics-and-AI



right click file, create external table

go through 52,53,54...not complete yet

from notebookutils import mssparkutils
mssparkuntils.fs.ls('')
notebook workflows
    mssparkutils.notebook.exit("Success")
    
cosmos?

https://github.com/Azure-Samples/Synapse/tree/main/Notebooks

spark etl example:
    https://www.mssqltips.com/sqlservertip/6657/azure-synapse-analytics-data-integration-and-orchestration/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+MSSQLTips-LatestSqlServerTips+%28MSSQLTips+-+Latest+SQL+Server+Tips%29

parameter cells in notebooks

Others:

- [ ] https://github.com/microsoft/WhatTheHack/tree/master/019-ThisOldDataWarehouse

* https://github.com/solliancenet/azure-synapse-analytics-day
  * data copied to davewdemodata/wwi-datalake/gold
  * 4 has a good perf lab




Performance  
    inferred data types:  https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-describe-first-result-set-transact-sql?view=sql-server-ver15&preserve-view=true  
    https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-sql-on-demand



spark tables are available in sql serverless too!!!!!

gh archive e2e.  wow
    https://msit.microsoftstream.com/video/2d1fa1ff-0400-b9eb-1050-f1eb2b7d1cd3?channelId=b32ca1ff-0400-b9eb-6539-f1eb28ecd264
    31 mins



-- A: Create a Database Master Key.
-- Only necessary if one does not already exist.
-- Required to encrypt the credential secret in the next step.
-- For more information on Master Key: https://docs.microsoft.com/sql/t-sql/statements/create-master-key-transact-sql?toc=/azure/synapse-analytics/sql-data-warehouse/toc.json&bc=/azure/synapse-analytics/sql-data-warehouse/breadcrumb/toc.json&view=azure-sqldw-latest

CREATE MASTER KEY;

-- B (for Gen2 storage key authentication): Create a database scoped credential
-- IDENTITY: Provide any string, it is not used for authentication to Azure storage.
-- SECRET: Provide your Azure storage account key.
--drop database scoped credential ADLSCredential
CREATE DATABASE SCOPED CREDENTIAL ADLSCredential
WITH
    IDENTITY = 'user',
    SECRET = '[secret]'
;

-- C (for Gen2): Create an external data source
-- TYPE: HADOOP - PolyBase uses Hadoop APIs to access data in Azure Data Lake Storage.
-- LOCATION: Provide Data Lake Storage Gen2 account name and URI
-- CREDENTIAL: Provide the credential created in the previous step.
--Drop External Data Source AzureDataLakeStorage
CREATE EXTERNAL DATA SOURCE AzureDataLakeStorage
WITH (
    TYPE = HADOOP,
    LOCATION='abfss://[container]@[storage account].dfs.core.windows.net/IN/WWIDB', -- Please note the abfss endpoint for when your account has secure transfer enabled
    CREDENTIAL = ADLSCredential
);

-- D: Create an external file format
-- FIELD_TERMINATOR: Marks the end of each field (column) in a delimited text file
-- STRING_DELIMITER: Specifies the field terminator for data of type string in the text-delimited file.
-- DATE_FORMAT: Specifies a custom format for all date and time data that might appear in a delimited text file.
-- Use_Type_Default: Store missing values as default for datatype.
--drop external file format textfileformat
CREATE EXTERNAL FILE FORMAT TextFileFormat
WITH
(   FORMAT_TYPE = DELIMITEDTEXT
,    FORMAT_OPTIONS    (   FIELD_TERMINATOR = '|'
                    ,    STRING_DELIMITER = ''
                    ,    DATE_FORMAT         = 'yyyy-MM-dd HH:mm:ss.fff'
                    ,    USE_TYPE_DEFAULT = FALSE
                    ,     First_Row = 2
                    )
);



------
-------
proserv-cdm-demo. https://github.com/nimar2/proserv-cdm-demo
Repo created for the demo of ERP (Professional Services Finance domain) to CDM Mapping using Azure Synapse



SQL scripts for Azure Synapse Analytics Serverless SQL Pools
https://github.com/datahai/serverlesssqlpooltools

pipeline integration testing:  https://medium.com/microsoftazure/integration-testing-azure-synapse-pipelines-and-beyond-876771e77bd7

serverless query perf monitoring:  https://www.linkedin.com/pulse/troubleshooting-performance-serverless-synapse-sql-pool-jovan-popovic/?trackingId=Gwl9NlMCuax6of1ZvmRe8g%3D%3D

vscode spark tools:  https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/vscode-tool-synapse#using-the-synapse-pyspark-interactive-command-in-py-file


viewgen:  https://www.serverlesssql.com/optimisation/dynamic-view-generation-in-serverless-sql-pools/

cetAS:  https://www.serverlesssql.com/optimisation/using-cetas-in-serverless-sql-pools-to-generate-pre-calculated-datasets-part-2-of-2/


LDW:  https://www.serverlesssql.com/logical-data-warehouse/creating-a-logical-data-warehouse-with-synapse-serverless-sql-part-2-of-3-creating-a-dimensional-model/

covid:  https://github.com/Azure-Samples/Synapse/blob/main/Notebooks/TSQL/Jupiter/content/tutorials/covid-ecdc.ipynb

mcw:  https://github.com/microsoft/MCW-Azure-Synapse-Analytics-and-AI/blob/main/Hands-on%20lab/HOL%20step-by%20step%20-%20Azure%20Synapse%20Analytics%20and%20AI.md

tweets:  https://github.com/Azure-Samples/Synapse/tree/main/Notebooks/Spark.NET%20C%23/Tweets


