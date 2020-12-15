# Spark Image

Instructions to prepare the Spark container image.

## Contents

| File/folder       | Description                                  |
| ----------------- | ---------------------------------------------|
| `Dockerfile`      | Dockerfile to build environment              |

## Spark Dockerfile 

Dockerfile to create the Spark container image with required tools to run the benchmark.

The Spark container contains

- TPC-DS toolkit
- Databricks SQL perf library
- Spark 3.0
- Hadoop 3.3
- Hadoop Azure library  
## Build Databricks Spark SQL perf library

- Clone the Databricks Spark SQL perf library
````
git clone https://github.com/databricks/spark-sql-perf && \ 
cd spark-sql-perf && \
sbt package 
````

- Copy the following jar file to /opt/sparks/jars
````
/spark-sql-perf/target/scala-x.xx/spark-sql-perf_x.xx-0.x.x-SNAPSHOT.jar 
````
  
- Download the TPC-DS toolkit from [www.tpc.org](http://www.tpc.org/tpcds/) and compile for target platform

````
sudo apt-get install gcc make flex bison byacc git
cd tpcds-kit/tools
make OS=LINUX
````

- Copy the tpc-ds/tools to /opt/tpcds-kit/tools

## Build and publish the Docker image

````
docker build . -t <acrName>.azurecr.io/<imageName>:<tag> 

docker push <acrName>.azurecr.io/<imageName>:<tag> 
````

To run the benchmark follow [these](./../benchmark/README.md) instructions