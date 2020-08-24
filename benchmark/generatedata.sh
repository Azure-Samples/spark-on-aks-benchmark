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


./bin/spark-submit \
        --master k8s://https://default-sparkonaks-k8s-79607165.hcp.westus2.azmk8s.io:443 \
        --deploy-mode cluster \
        --class com.microsoftazure.aks.tpcds.DataGenerator \
        --conf spark.executor.instances=10\
        --conf spark.app.name=tpcds \
        --conf spark.kubernetes.container.image=sparkacrbacf.azurecr.io/spark:prod1 \
        --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
        --conf spark.authenticate=false \
        --conf spark.kubernetes.node.selector.app=spark \
        --conf spark.kubernetes.container.image.pullPolicy=Always \
        --conf spark.kubernetes.file.upload.path=/opt/spark/work-dir \
        --conf spark.hadoop.fs.azure.account.auth.type.sparkonakstpcdsdataset.dfs.core.windows.net=SharedKey \
        --conf spark.hadoop.fs.azure.account.key.sparkonakstpcdsdataset.dfs.core.windows.net=cqeElafHqmbkG7nymkHQLIfvGKglGSBzZOaal06n25IGGttYw1JJdl9Y58jr0Xs47TGAUXhafdP6+hVQ1nLj3w== \
         "local:///opt/spark/jars/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar" "abfss://tpcds@sparkonakstpcdsdataset.dfs.core.windows.net/data/data" "/opt/tpcds-kit/tools" "parquet" "1000"

