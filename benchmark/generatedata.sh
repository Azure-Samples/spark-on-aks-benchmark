#!/bin/bash

# Assumption is that spark master and slave is already started.
# This script will call spark_submit with the build jar file to generrated 1GB of data.
# data is generated into the ../tpcds_data folder

$SPARK_HOME/bin/spark-submit \
        --master k8s://https://sparkonaks-k8s-985e3fc0.hcp.westus2.azmk8s.io:443 \
        --deploy-mode cluster \
        --class com.microsoftazure.aks.tpcds.DataGenerator \
        --conf spark.executor.instances=15\
        --conf spark.driver.cores=4 \
        --conf spark.executor.cores=2 \
        --conf spark.executor.memory=8000m \
        --conf spark.driver.memory=8000m \
        --conf spark.app.name=tpcds \
        --conf spark.kubernetes.container.image=sparkacr3ad5.azurecr.io/spark-on-aks:stable \
        --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
        --conf spark.authenticate=false \
        --conf spark.kubernetes.container.image.pullPolicy=Always \
        --conf spark.kubernetes.file.upload.path=/opt/spark/work-dir \
        --conf spark.hadoop.fs.azure.account.auth.type.tpcdsdata.dfs.core.windows.net=SharedKey \
        --conf spark.hadoop.fs.azure.account.key.tpcdsdata.dfs.core.windows.net=$ReplaceKey \
        "local:///opt/spark/jars/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar" "abfss://tpcds@tpcdsdata.dfs.core.windows.net/data" "/opt/tpcds-kit/tools" "parquet" "1000"
