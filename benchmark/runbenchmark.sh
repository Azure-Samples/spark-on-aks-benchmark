#!/bin/bash

# Assumption is that spark master and slave is already started.
# This script will call spark_submit with the build jar file to generrated 1GB of data.
# data is generated into the ../tpcds_data folder

export SPARK_MASTER=spark://https://default-sparkonaks-k8s-79607165.hcp.westus2.azmk8s.io:443:7077
#export CLASS=com.databricks.spark.sql.perf.tpcds.TPCDSTables
export DATA_DIR="abfs://tpcds@sparkonakstpcdsdataset.dfs.core.windows.net/data/"
export TOOL_DIR="/opt/tpcds-kit/tools"
#export JARS="abfss://tpcds@sparkonakstpcdsdataset.blob.core.windows.net/benchmark/spark-sql-perf_2.12_latest.jar"
#export BENCHMARK="abfss://tpcds@sparkonakstpcdsdataset.blob.core.windows.net/benchmark/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar"

export JARS="//opt/spark/jars/spark-sql-perf_2.12_latest.jar"
export BENCHMARK="//opt/spark/jars/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar"

echo $JARS
echo $BENCHMARK

read -p "Enter Shared Key : " $key

#object TPCDSBenchmark {
#  def main(args: Array[String]) {
#    val tpcdsDataDir = args(0)
#    val resultLocation = args(1)
#    val dsdgenDir = args(2)
#    val format = Try(args(3).toString).getOrElse("parquet")
#    val scaleFactor = Try(args(4).toString).getOrElse("1")
#    val iterations = Try(args(5).toString).getOrElse("1").toInt
#    // val iterations = args(5).toInt
#    val optimizeQueries = Try(args(6).toBoolean).getOrElse(false)
#    val filterQueries = Try(args(7).toString).getOrElse("")
#    val onlyWarn = Try(args(8).toBoolean).getOrElse(false)

./bin/spark-submit \
        --master k8s://https://default-sparkonaks-k8s-79607165.hcp.westus2.azmk8s.io:443 \
        --deploy-mode cluster \
        --class com.microsoftazure.aks.tpcds.TPCDSBenchmark \
        --conf spark.executor.instances=10 \
        --conf spark.driver.cores=4 \
        --conf spark.executor.cores=2 \
        --conf spark.executor.memory=8000m \
        --conf spark.driver.memory=8000m \
        --conf spark.speculation=false \
        --conf spark.speculation.multiplier=3 \
        --conf spark.speculation.quantile=0.9 \
        --conf spark.sql.broadcastTimeout=7200 \
        --conf spark.sql.crossJoin.enabled=true \
        --conf spark.sql.parquet.mergeSchema=false \
        --conf spark.sql.parquet.filterPushdown=true \
        --conf spark.app.name=tpcds \
        --conf spark.kubernetes.container.image=sparkacrbacf.azurecr.io/spark:prod1 \
        --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
        --conf spark.authenticate=false \
        --conf spark.kubernetes.node.selector.app=spark \
        --conf spark.kubernetes.container.image.pullPolicy=Always \
        --conf spark.kubernetes.file.upload.path=/opt/spark/work-dir \
        --conf spark.kubernetes.appKillPodDeletionGracePeriod=30 \
        --conf spark.hadoop.fs.azure.account.auth.type.sparkonakstpcdsdataset.dfs.core.windows.net=SharedKey \
        --conf spark.hadoop.fs.azure.account.key.sparkonakstpcdsdataset.dfs.core.windows.net=$key \
         "local:///opt/spark/jars/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar" \
         "abfss://tpcds@sparkonakstpcdsdataset.dfs.core.windows.net/data/data" \
         "abfss://tpcds@sparkonakstpcdsdataset.dfs.core.windows.net/data/results" \
         "/opt/tpcds-kit/tools" parquet 1000 1 false q70-v2.4,q71-v2.4


