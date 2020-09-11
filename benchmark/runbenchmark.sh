#!/bin/bash

# Assumption is that spark master and slave is already started.
# This script will call spark_submit with the build jar file to generrated 1GB of data.
# data is generated into the ../tpcds_data folder


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

$SPARK_HOME/bin/spark-submit \
        --master k8s://https://sparkonaks-k8s-985e3fc0.hcp.westus2.azmk8s.io:443 \
        --deploy-mode cluster \
        --class com.microsoftazure.aks.tpcds.TPCDSBenchmark \
        --conf spark.driver.cores=4 \
        --conf spark.driver.memory=8000m \
        --conf spark.executor.cores=2 \
        --conf spark.executor.instances=10 \
        --conf spark.default.parallelism=50 \
        --conf spark.executor.memory=8000m \
        --conf spark.executor.memoryOverhead=4G \
        --conf spark.sql.broadcastTimeout=7200 \
        --conf spark.sql.crossJoin.enabled=true \
        --conf spark.sql.parquet.mergeSchema=false \
        --conf spark.sql.parquet.filterPushdown=true \
        --conf spark.app.name=tpcds \
        --conf spark.kubernetes.local.dirs.tmpfs=true \
        --conf spark.kubernetes.container.image=sparkacr3ad5.azurecr.io/spark-on-aks:stable \
        --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
        --conf spark.authenticate=false \
        --conf spark.eventLog.enabled=true \
        --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
        --conf spark.sql.inMemoryColumnarStorage.compressed=true \
        --conf spark.sql.adaptive.coalescePartitions.enabled=true \
        --conf spark.eventLog.dir=abfss://tpcds@tpcdsdata.dfs.core.windows.net/logs \
        --conf spark.kubernetes.container.image.pullPolicy=Always \
        --conf spark.kubernetes.file.upload.path=/opt/spark/work-dir \
        --conf spark.hadoop.fs.azure.account.auth.type.tpcdsdata.dfs.core.windows.net=SharedKey \
        --conf spark.hadoop.fs.azure.account.key.tpcdsdata.dfs.core.windows.net=$ReplaceKey \
         "local:///opt/spark/jars/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar" \
         "abfss://tpcds@tpcdsdata.dfs.core.windows.net/data" \
         "abfss://tpcds@tpcdsdata.dfs.core.windows.net/results" \
         "/opt/tpcds-kit/tools" parquet 1000 1 false q64-v2.4
