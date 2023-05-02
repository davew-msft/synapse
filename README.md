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


## Questions for Sean

1. Will they have SQLSvrless?
2. Can they hit opendatasets?  and my datalake?  
3. Should we use their data?

### Day 2

* [Let's make sure you can connect to my sample data lake](./fb-labs/Lab01.md)
* Data Sandboxing/Data Engineering
  * [exploration-sparkStarter.ipynb](./notebooks/exploration-sparkStarter.ipynb) 
    * Querying data with SQL and pySpark, data pipelining principles
    * cell magics
  * [Basic Aggregations and Visualizations](./fb-labs/BasicAggregationsAndVisualizationsStarter.ipynb)
    * we'll do this as an independent lab
    * now let's save it to YOUR datalake
  * mounts ... fb/mounts.ipynb in workspace.  This is conversational.  
```
whoami = 'davew'
path = something + '/something.parquet'
df.write.parquet(path, mode = 'overwrite')
df.write.csv(csv_path, mode = 'overwrite', header = 'true')

df_parquet = spark.read.parquet(parquet_path)
df_parquet.show(10)

```
  * [Delta Lake](./fb-labs/DeltaLake.ipynb)
    * what is it and how is it materialized in the lake?
    * what is a `managed` vs an `unmanaged` table.  



 
  * Using Requirements.txt and shared libraries
    * %run wasn't working for them???
    * Excel
  * variables and notbook pipelining
  * [Lab 020: Shared Metadata](./Lab020.md)
  
  
* Streaming Data
  * Real-time streaming data pipelines with Spark Structured Streaming.  Take a batch process and make it stream.  We start with the data already in Bronze


* Streaming data from Kafka/Event Hubs
  * Streaming data using Event Hubs and Kafka.  

### Day 3

* Continuation of topics from Day 1 & 2
* SHIR and Synapse pipelines to reach back on-prem
* Streaming data from Kafka/Event Hubs
  * Streaming data using Event Hubs and Kafka.  
* Orchestrating and Administering Jobs
  * Streaming and Batch orchestration with Jupyter Notebooks and ADF
  * what is the overhead of doing that?   (pipelining)
* Data Science with Spark  (YES)
  * 
* Performance Tuning and administration (they are their own DBAs)
  * Hyperspace
  * What are the common performance issues we see and what are the patterns to fix them?  
* Business Scenarios/Problem Solving
  * Tweet Analysis?
  * Cognitive Mistakes?
  * Social Media Analytics
  * Data Quality (automation and pipelining) do we have a set of notebooks/unit testing







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