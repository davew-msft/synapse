# Synapse End to End Workshop

https://git.davewentzel.com/workshops/synapse

## What Technologies are Covered

* Synapse workspaces
* Azure DevOps (AzDO) or GitHub (and gh actions)
* pretty much every other Azure data service

## Target audience

-   Data Engineers/DBAs/Data Professionals
-   Data Scientists
-   App Developers


## Business Case Background

Our company has hundreds of brick and mortar stores. Over their years of operation, they have amassed large amounts of historical data stored in disparate systems.  They wish to combine their historic data and tie it together with near real-time data streams to produce dashboard KPIs and machine learning models that enable them to make informed up to the minute decisions.

Our company has over 5 years and 30 billion rows of transactional sales data in Oracle, finance data stored in SAP Hana, and marketing data in Teradata. They also monitor the data coming in from their social media Twitter account.

They need a solution that allows them to query across and analyze the data from all these sources. Regardless of volume, they want these queries to return in seconds.

Our company has 100 stores each equipped with 50 IoT sensors that monitor customer behavior in the store aisles. They need to ingest sensor data in near real time to allow them to quickly identify patterns that can be shared between stores in an aim to improve sales with last minute offers and improved product placement.



## Workshop Objectives

we will try to build an end-to-end solution using Azure Synapse Analytics. The workshop will cover:
* data loading
* data preparation
* data transformation
* data serving
* machine learning
* batch data
* streaming data

We will try to do everything using the same datasets, but can't guarantee it.  

We want to build something like this:

![](./img/mdw.png)
... this is a "reference architecture" for a standard `corporate information factory` which focuses on a Synapse-based implementation (aka "SQL-focused" solution).  But this of course is not the only way to do things.  In fact, if you want to think of your data in terms of "streams" this may be a better way to think of your data:
![](./img/stream.png)
...note that here we are using other technologies to process the stream data before it "comes to rest".  These are not the ONLY technologies to process streaming data, in fact, they may not even be the best.  

## What is Synapse Data Warehouse?

See [Synapse Workspace](./synapse.md)

## Workshop Agenda

### Setup and Prep Labs

* [Lab 000: local development machine setup](./Lab000.md):  You will need some tools installed on your local machine. Let's get those setup.  
* [Lab 001: setup Synapse workspace](./Lab001.md) and understand a little more about what problems this service is trying to solve
  * todo:  explore the knowledge center in syn workspace
* [Lab 001a: Setup Source Control Integration](./Lab001a.md) TODO
* [Lab 002: import sample data into Synapse](./Lab002.md) to get familiar with the workspace UI.  

Working with Linked Services:
* [Lab 005: creating a linked service to another storage account](./Lab005.md)

### Loading Data from a Data Lake
* [Lab 010: Understanding Data Lakes](./Lab010.md) 
* [Lab 011: Data Discovery and Sandboxing with SQL Serverless](./Lab011.md) 
  * we also look at querying CSV and JSON data
* [Lab 012: Data Discovery and Sandboxing with Spark](./Lab012.md) 
* [Lab 013: Loading Data from a Data Lake into Synapse SQL Pool](./Lab013.md) 

### Using "Integrate" Features (ADF-like experience)

* [Lab 050: Understanding Data Factory Best Practices](./Lab050.md)
* [Lab 051: Best Practices for source controlling SQL scripts](./Lab051.md)

### Security Topics

* [Lab 300: Column Level Security in Synapse](./Lab300.md)
* [Lab 301: Row Level Security](./Lab301.md)
* [Lab 302: Dynamic Data Masking](./Lab302.md)

### ML/AI in Synapse

* [Lab 400: Consuming a Model in Synapse](./Lab400.md) TODO