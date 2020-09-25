#!/bin/bash

$SPARK_HOME/bin/spark-submit \
        --master k8s://https://default-sparkonaks-k8s-79607165.hcp.westus2.azmk8s.io:443 \
        --deploy-mode cluster \
        --class com.microsoftazure.aks.tpcds.DataGenerator \
        --conf spark.executor.instances=10\
        --conf spark.driver.cores=2 \
        --conf spark.executor.cores=2 \
        --conf spark.executor.memory=8000m \
        --conf spark.driver.memory=8000m \
        --conf spark.app.name=tpcds \
        --conf spark.kubernetes.container.image=sparkacrbacf.azurecr.io/spark:prod1 \
        --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
        --conf spark.authenticate=false \
        --conf spark.kubernetes.node.selector.app=spark \
        --conf spark.kubernetes.container.image.pullPolicy=Always \
        --conf spark.kubernetes.file.upload.path=/opt/spark/work-dir \
        --conf spark.hadoop.fs.azure.account.auth.type.sparkonakstpcdsdataset.dfs.core.windows.net=SharedKey \
        --conf spark.hadoop.fs.azure.account.key.sparkonakstpcdsdataset.dfs.core.windows.net=$ReplaceWithKey \
         "local:///opt/spark/jars/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar" "abfss://tpcds@sparkonakstpcdsdataset.dfs.core.windows.net/data/data" "/opt/tpcds-kit/tools" "parquet" "1000"
