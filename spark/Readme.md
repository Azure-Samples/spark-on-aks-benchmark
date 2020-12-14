<!-- TODO: Add instructions on building Dockerfile -->
# Spark Image

Instructions to prepare the Spark container image.

## Contents

| File/folder       | Description                                  |
| ----------------- | ---------------------------------------------|
| `Dockerfile`      | Dockerfile to build environment              |
| `tpcds_jar`       | Folder contains jar files to tpcds execution |
| `tpcds-kit`       | Spark Docker containers and config           |


## Spark Dockerfile 

This Dockerfile is to create the container for Spark with required tools to run the benchmark.

The Spark image requires

- TPC-DS toolkit
- Databricks SQL perf library
- Spark 3.0
- Hadoop 3.3
- Hadoop Azure library  
## Build Databricks Spark SQL perf library

- Clone the Databricks Spark SQL perf library.

````
git clone https://github.com/databricks/spark-sql-perf && \ cd spark-sql-perf && \
sbt package 
````

- Copy the jar file generated in `/spark-sql-perf/target/scala-x.xx/spark-sql-perf_x.xx-0.x.x-SNAPSHOT.jar` to tpcds_jars
  
- Download the TPC-DS toolkit from [www.tpc.org](http://www.tpc.org/tpcds/)

- Compile the toolkit

      ````
      sudo apt-get install gcc make flex bison byacc git
      cd tpcds-kit/tools
      make OS=LINUX
      ````

- Copy the TPC-DS toolkit to tpcds-kit folder on the Spark container image.

## Build and publish the Docker image

      ````
      docker build . -t <acrName>.azurecr.io/<imageName>:<tag> 

      docker push <acrName>.azurecr.io/<imageName>:<tag> 
      ````

To run the benchmark follow [these](./../benchmark/README.md) instructions