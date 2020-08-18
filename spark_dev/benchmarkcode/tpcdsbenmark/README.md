# Benchmark code using databricks TPCDS jar

## Setup
1. Copy lib/spark-sql-perf_2.12_latest.jar to /opt/spark/jars
2. Start the spark master and slave first.
  
        `./start-spark.sh`

2. build the project
   
        `./sbt package`
        
3. Note that the scripts and launch.json hardcode paths (data dir, jar location, results dir).  Until they are made path relative, edit appropriately.

## DataGenerator

   * Generate 1gb data set, run the spark job listed below.
  
        `./generatedata.sh`

     
```
        ${SPARK_HOME}/bin/spark-submit \
        --deploy-mode cluster \
        --master $SPARK_MASTER \
        --class com.microsoftazure.aks.tpcds.DataGenerator \
        target/scala-2.12/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar \
        /opt/app/spark_dev/benchmarkcode/tpcds_data /opt/tpcds-kit/tools

```       

## TPC-DS Execution

        `./tpcdsbenchmark.sh`

```
        ${SPARK_HOME}/bin/spark-submit \
        --deploy-mode cluster \
        --master $SPARK_MASTER \
        --class com.microsoftazure.aks.tpcds.TPCDSBenchmark \
        target/scala-2.12/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar \
        /opt/app/spark_dev/benchmarkcode/tpcds_data /opt/app/spark_dev/benchmarkcode/results /opt/tpcds-kit/tools
```