<!-- TODO: Add instructions on building Dockerfile -->
# spark

Working repository for running spark TPCSDS benchmark on AKS

## Contents

| File/folder       | Description                                  |
| ----------------- | ---------------------------------------------|
| `Dockerfile`      | Dockerfile to build environment              |
| `tpcds_jar`       | Folder contains jar files to tpcds execution |
| `tpcds-kit`       | Spark Docker containers and config           |


Dockerfile is to create a container for spark TPCDS. This container will install the necessary tools (tpcds-toolkit, Databricks tpcds library, spark 3.0, sbt) to build an application that generate TPCDS data. This container will be used to execute a benchmark upon this data.

Dockerfile copies tpcds_jars to /opt/spark/jars in the container.

# Spark env lib folder
The folder also contains two jar files under tpcds_jars

| File                                  | Description                                                                            |
| ------------------------------------  | ---------------------------------------------------------------------------------------|
| `spark-sql=perf_2.12_latest.jar`      | This jar file is compatible with version Spark 3.0.0                                   |
| `tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar`| The jar file is contains the wrapper class com.microsoftazure.aks.tpcds.TPCDSBenchmark.|

# Arguments for the com.microsoftazure.aks.tpcds.TPCDSBenchmark
| File                 | Description                                                                        |
| -------------------- | -----------------------------------------------------------------------------------|
| `tpcdsDataDir`       | Folder path to store the generated dataset                                         |
| `resultLocation`     | Output location for the TPCSDSBenchmark execution results                          |
| `format`             | As of now we are supporting only parquet.                                          |
| `iterations`         | Specify the number of iterations for each query                                    |
| `queryFilter`        | Specify the name of the queries to run. Leave blank to run all                     |

