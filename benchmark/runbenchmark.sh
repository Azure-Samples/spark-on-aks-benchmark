#!/bin/bash

# Parameters for TPCDSBenchmark
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
        --master k8s://https://testing-sparkonaks-k8s-4aa37c36.hcp.eastus2.azmk8s.io:443 \
        --deploy-mode cluster \
        --class com.microsoftazure.aks.tpcds.TPCDSBenchmark \
        --conf spark.driver.cores=4 \
        --conf spark.driver.memory=8000m \
        --conf spark.driver.memoryOverhead=2G \
        --conf spark.executor.cores=2 \
        --conf spark.executor.instances=10 \
        --conf spark.executor.memory=8000m \
        --conf spark.executor.memoryOverhead=2G \
        --conf spark.sql.broadcastTimeout=7200 \
        --conf spark.sql.crossJoin.enabled=true \
        --conf spark.sql.cbo.enabled=true \
        --conf spark.sql.parquet.mergeSchema=false \
        --conf spark.sql.parquet.filterPushdown=true \
        --conf spark.app.name=tpcds \
        --conf spark.network.timeout=900s \
        --conf spark.kubernetes.container.image=sparkacr4c58.azurecr.io/spark-on-aks:stable \
        --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
        --conf spark.authenticate=false \
        --conf spark.eventLog.enabled=true \
        --conf spark.eventLog.dir=abfss://tpcds@tpcds1tb.dfs.core.windows.net/logs \
        --conf spark.kubernetes.node.selector.agentpool=ephemeral \
        --conf spark.shuffle.compress=true \
        --conf spark.shuffle.spill.compress=true \
        --conf spark.yarn.submit.waitAppCompletion=false \
        --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
        --conf spark.local.dir=/tmp/mnt-1 \
        --conf spark.kubernetes.executor.volumes.hostPath.spark-local-dir-1.mount.path=/tmp/mnt-1 \
        --conf spark.kubernetes.executor.volumes.hostPath.spark-local-dir-1.options.path=/tmp/mnt-1 \
        --conf spark.kubernetes.container.image.pullPolicy=Always \
        --conf spark.kubernetes.file.upload.path=/opt/spark/work-dir \
        --conf spark.hadoop.fs.azure.account.auth.type.tpcds1tb.dfs.core.windows.net=SharedKey \
        --conf spark.hadoop.fs.azure.account.key.tpcds1tb.dfs.core.windows.net=$ReplaceWithKey \
         "local:///opt/spark/jars/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar" \
         "abfss://tpcds@tpcds1tb.dfs.core.windows.net/data" \
         "abfss://tpcds@tpcds1tb.dfs.core.windows.net/results" \
         "/opt/tpcds-kit/tools" parquet 1000 5 false q64-v2.4
