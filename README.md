# Synapse End to End Workshop

https://github.com/davew-msft/synapse

(this repo has branches.  master is currently set to `fb`)

## What Technologies are Covered

* Synapse workspaces
* Synapse Spark

## Target audience

-   Data Engineers/DBAs/Data Professionals
-   Data Scientists
-   App Developers

## Workshop Agenda & Objectives

**This is a tentative schedule. We may have to adjust given timelines, desires, etc**
### Day 1

* Introductions/Objectives/Level-Setting
* Synapse Navigation
  * [What is Synapse?](./Lab001.md)
  * Source control integration (do we need to set this up?)
* Overview and Basic Setup
  * what is a notebook?  navigation, etc
  * [Let's make sure you can connect to my sample data lake](./fb-labs/Lab01.md)

* Data Lake organization
  * How is your data lake structured?  Connecting to it from a notebook.  
* Data Sandboxing/Data Engineering
  * Querying data with SQL and pySpark, data pipelining principles
* Basic ETL
  * Extract, Transform, Loading.  Delta-formatted tables

### Day 2

* Continuation of topics from Day 1
* Streaming Data
  * Real-time streaming data pipelines with Spark Structured Streaming.  Take a batch process and make it stream.  We start with the data already in Bronze
* Streaming data from Kafka/Event Hubs
  * Streaming data using Event Hubs and Kafka.  

### Day 3

* Continuation of topics from Day 1 & 2
* Orchestrating and Administering Jobs
  * Streaming and Batch orchestration with Jupyter Notebooks and ADF
* Data Science with Spark
* Performance Tuning and administration
  * What are the common performance issues we see and what are the patterns to fix them?  


| Topic | Lab Name | Description|
|------|------|------|
|Setup|[Lab 002: import sample data into Synapse](./Lab002.md) |get familiar with the workspace UI.  |
|Setup|[Lab 003 (Optional): Configure additional users to access a Synapse workspace](./Lab003.md)|You do not need to do this unless everyone in the workshop wants to share access to a single Synapse workspace.  |

### Working with Linked Services
* [Lab 005: creating a linked service to another storage account](./Lab005.md) 
  * skip this lab for now.  

### Data Discovery and Sandboxing

Understanding data through data exploration is the biggest challenge faced today by data professionals.  Generally I do data exploration using either:
* Synapse serverless SQL pool
  * I'm good at SQL so I want to use this to start my analysis, plus, it has a wicked-cool UI for exploring data lake files
* Spark (databricks or Synapse Spark)
  * If I realize I need something more complex for analysis like python or pandas, or I need to do some ML.  

| Lab Name | Description|
|------|------|
|[Lab 010: Understanding Data Lakes](./Lab010.md) |An overview of the structure and purpose of a data lake|
|[Lab 011: Data Discovery and Sandboxing with SQL Serverless](./Lab011.md) |we also look at querying CSV and JSON data|
|[Lab 012: Data Discovery and Sandboxing with Spark](./Lab012.md) |<li>we do basic data lake queries using Spark<li>we will use Lab 052 for a much deeper dive later|
|[Lab 020: Shared Metadata](./Lab020.md)|the 3 components of a Synapse Workspace share much of their metadata to aid in reuse.  We explore that in this lab.  |
|[Lab 030:  Logical Datawarehousing with Synapse Serverless and your Data Lake](./Lab030.sql)|open the sql file on the link in Synapse workspace and follow along|
|[**Thinking about how to leverage your data lake to do ETL with TSQL and Serverless**](./etl_patterns.md)||
|[Lab 031: ETL with Synapse Serverless, your data lake, and TSQL](./serverless_etl.sql)||
### ETL/ELT Options

There are a lot of different ways to do ELT/ETL using Synapse.  We'll explore each way in this section:  

| Topic | Lab Name | Description|
|------|------|------|
|General Setup|[Lab 050: Understanding Data Factory (Integrate) Best Practices](./Lab050.md)|Even if you are not planning to use ADF/Synapse "Integrate" experience, you will likely want to version control your notebooks and SQL files.  We cover things like gitflow as well.|
|General Setup|[Lab 051: Best Practices for source controlling SQL scripts](./Lab051.md)|We'll also cover how to handle deployments and database objects.  |
|Spark|[Lab 052:  Manipulating a Data Lake with Spark](./notebooks/Lab052.ipynb)|  <li> Import `./notebooks/Lab052.ipynb` directly in your Synapse workspace under Notebooks. <li> Read the instructions and complete the lab|
|Spark|[Lab 053:  Understanding Delta Tables with Spark](./notebooks/Lab053.ipynb)|We'll explore using Delta tables from Synapse Spark pools TODO|
|Spark|[Lab 054: Sharing Data Between SparkSQL, Scala, and pySpark](./notebooks/Lab054.ipynb)|Using multiple languages in Spark is the key to solving problems, but sharing variables and dataframes isn't always intuitive.  We'll also look at how to persist data so Serverless Pools can access it. WIP/TODO...see version in workspace|
||||

#### Using SQL Serverless
* [Lab 055: Writing a SQL Script to copy data from one data lake zone to another](./Lab055.md)  
  * we use Serverless as a SQL-based ELT tool

### Spark to Synapse Dedicated Pools
* [Lab 056: Using Spark to write data into Synapse SQL Pools (Dedicated)](./Lab056.md)
* [Lab 056a: Using Spark to write data into Synapse SQL Pools - .NET version](./Lab056a.md)

### The ADF (Integrate) box-and-line tools
* [Lab 057: Loading Data from a Data Lake into Synapse SQL Pool using the "Integrate" box-and-line experience (ADF Copy Activity)](./Lab057.md) 
* [Lab 058: Loading Data from a Data Lake into Synapse SQL Pool using the "Integrate" box-and-line experience (ADF Dataflows)](./Lab058.md) 

TODO:  load campaign analytics table, might be good for ADF data flows.  

### Power BI Integration

* [Lab 100: Create and Use a Power BI dataset](./Lab100.md)

### Security Topics

* [Lab 300: Column Level Security in Synapse](./Lab300.md)
* [Lab 301: Row Level Security](./Lab301.md)
* [Lab 302: Dynamic Data Masking](./Lab302.md)

### ML/AI in Synapse

* [Lab 400: Consuming a Model in Synapse](./Lab400.md) TODO
* [Lab 410: Using Cognitive Search with Synapse](./Lab410.md) TODO
* [Lab 420: Basic ML lifecycle using Spark and Synapse Dedicated Pools](./Lab420.md)  
* [Lab 421: Train an automl model against an existing Spark dataset](./Lab421.md)
  * this requires you to complete Lab420.
* [Lab 422: Use an existing model to batch inference against Synapse Dedicated Pool data](./Lab422.md)
  * this requires you to complete Lab 420 and Lab 421

### Monitoring

* [Lab 600: Workload Management](./Lab600.md)


## Wrap Up

You should probably delete the resource group we created today to control costs.  

If you'd rather keep the resources for future reference you can simply PAUSE the dedicated SQL Pool and the charges should be minimal.  


## Other Notes

* [templates folder](./templates) has a bunch of my patterns that you may be able to leverage