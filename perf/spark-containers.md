## Running Databricks Workloads in Docker Containers

> Disclaimer:  I'm not an expert in any of this.  What I'm about to describe I've done myself with customers and it was wildly successful.  However, it may not be right for you.  There are certainly better ways to do all of this, I'm not the expert.  

### What is Databricks really good for?
* Primarily, a development tool
  * Example:  MLOps...great for training, not for inferencing (_inferencing_ assumes _streaming_).  Databricks may not be a great choice for streaming (see below).  
* If cost is not a problem then use it to avoid having to manage Spark clusters/HDInsight/etc
* If cost is a problem then consider containerized Spark solutions when you go to production
* Notebooks, with their lack of monitoring and debugging and difficulties with scheduling, version control, unit testing, etc etc etc are not _really_ a good choice for production workloads?  **Wouldn't you agree?**
* It seems like the better choice is using the notebook for development and then something else for production.  

> Notebooks are meant for data scientists.  While a Jupyter notebook can be scheduled with things like Papermill or by containerizing the ipynb file and then calling it within a Docker container, this doesn't feel right.  And databricks giving you the ability to schedule a notebook that could constantly render needless graphics and `display` dataframes needlessly in a scheduled and headless environment, seems like we are encouraging bad behaviors.  Data scientists and notebooks are not meant to be production code.  They are for data discovery.  Maybe it's time we admit that fact.  Production data engineering pipelines maybe shouldn't be scheduled notebooks.  

### So, should I even be doing development in a databricks notebook?  Seems like I'm going to regret it later

Jupyter (and databricks notebooks) are excellent ways to _move fast_.  However, many data scientists and engineers _hate_ notebook environments.  Next, databricks notebooks only provide a small subset of the features of a standard JupyterLab installation.  

So, if you want to use JupyterLab, or you'd prefer to just use Jupyter notebooks in vscode or just plain .py files in your IDE of choice, consider researching [Databricks Connect](https://docs.databricks.com/dev-tools/databricks-connect.html).  

In a nutshell, many of the concepts that Databricks Connect employs we are going to use to containerize our workloads.  

### Why containerize a databricks workload?

Cost.  

### What are good databricks workload candidates for containerization if cost containment is our issue?
* Kafka-based streaming applications
  * especially those that tend not to scale out well on Spark executors.  
  * in this case I build the application using containers where each container is a consumer in a consumer group
* SQL-based data sandboxing
  * you have a team of analysts that primarily use SQL and not necessarily against BIG DATA.  
  * in this case I use something like (soon) Synapse Serverless or Presto.  Presto is much cheaper.  
* Any workload where databricks is a mere _convenience_ but doesn't manipulate big data and thus doesn't need scale-out.  
  * data engineers love the notebook experience.  But if you are only ingesting a few gigabytes of data per run, do you need scale-out?  Instead, consider a spark container.  

> Remember, databricks allows a developer to move _**fast**_ using a notebook experience that can scale from small to big data with some config settings.  But it will cost you if you want to take a development tool and scale it for production workloads.  

### How can I ensure that in the future my databricks workloads can be easily migrated to a container?  

Avoid:
* `dbutils` or `dbfs` in your notebooks.  Those won't be available in a Spark container.  
* Unfortunately, if you use my Seven Notebooks System you are going to have to reassemble the .py or .scala.  I still think my System helps developers learn databricks quickly, just know that it will cause you some grief.  This means things like the following need to be refactored:
  * `%run` 
  * widgets to parameterize notebooks

> Never fear, there are creative ways to overcome these limitations using python and scala.  You'll quickly figure it out when you need to.  

## The Basic Spark Containerization Pattern

For a given workload:

1. Download your notebook(s) to .py or .scala files.  I don't know how to do SparkR, sorry.  
1. We need to figure out how to build a Spark container with all of the dependencies for our workload.  More on that in the next section.
1. We issue a `spark-submit` as part of `docker run`

    * .py files:  `spark-submit something.py --py-files <search-path> --files <other files>`
    * .scala files:  use maven/sbt to build a jar with all dependencies.  `spark-submit something.jar`
1. We can monitor our container with the SparkUI if our container exposes it (it should).  

> The above basic pattern is _exactly_ what a data engineer would do prior to the advent of databricks and notebook-based development.  The only difference is we are issuing `spark-submit` against a container instead of a Spark cluster or HD Insight.  

## Running Spark Jobs in a Container

There are many ways to do this.  

1. We can start by just getting a single docker container to work

--or--
1. we can go right to Kubernetes and deploy a full-blown, horizontally-scalable Spark cluster.  

...or any method in between.  



### Spark in simple containers

There is no such thing as "Spark running on a single container".  Spark runs on clusters.  Applications are submitted to clusters.  `SparkContext` in your driver program is how a Spark cluster doles out work to the worker nodes.  Spark needs a cluster and cluster manager to do this.  There are 4 supported cluster managers:

* Mesos
* YARN
* Spark's standalone cluster manager (standalone does _not_ mean it's a single container though)
* Kubernetes (this is experimental as of this writing)


![](./spark-clus.pngspark-clus.png)

* Each application you submit gets its own executer, which gives you process isolation.  You submit via `spark-submit` or other ways (zeppelin).  
* Each driver program (your application) has a webUI usually on 4040.  
* If you need to schedule jobs, consider using an enterprise scheduler.  

> Note that if you aren't a Docker or Kubernetes shop that this is starting to get complicated.  This is why databricks charges what they charge.  This is not for the faint-of-heart.  

### Lab

To understand the concepts and start small, let's build a simple Docker container that runs locally and can execute some small pySpark tasks.    

[See Lab300](../Lab300/README.md).  

## WIP

[Spark on Kubernetes](https://spark.apache.org/docs/latest/running-on-kubernetes.html)  

* one problem is this requires a Spark cluster on kubernetes
* utilizes `spark-submit`

https://hub.helm.sh/charts/microsoft/spark
 
[Spark container](https://github.com/big-data-europe/docker-spark)  
* this is the container I generally use.  
* [instructions to run a py program](https://github.com/big-data-europe/docker-spark/tree/master/template/python)

https://dzone.com/articles/running-apache-spark-applications-in-docker-contai

https://docs.microsoft.com/en-us/azure/aks/spark-job

https://medium.com/@marcovillarreal_40011/creating-a-spark-standalone-cluster-with-docker-and-docker-compose-ba9d743a157f

https://grzegorzgajda.gitbooks.io/spark-examples/content/basics/docker.html

https://docs.microsoft.com/en-us/azure/aks/spark-job#create-an-aks-cluster

from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()


