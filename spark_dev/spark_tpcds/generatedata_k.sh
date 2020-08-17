#!/bin/bash

# Assumption is that spark master and slave is already started.
# This script will call spark_submit with the build jar file to generrated 1GB of data.
# data is generated into the ../tpcds_data folder

SPARK_MASTER=spark://$(hostname):7077

DATA_DIR="../tpcds_data"
TOOL_DIR="/opt/tpcds-kit/tools"

# spark-submit \
# --master spark://${hostname}:7077 \
# --deploy-mode cluster \
# --class com.microsoftazure.aks.tpcds.DataGenerator \
# ./target/scala-2.12.jar/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar "../tpcds_data" "/opt/tpcds-kit/tools"

cp ./lib/spark-sql-perf_2.12_latest.jar $SPARK_HOME/jars/spark-sql-perf_2.12_latest.jar

${SPARK_HOME}/bin/spark-submit \
--deploy-mode cluster \
--master $SPARK_MASTER \
--class com.microsoftazure.aks.tpcds.DataGenerator \
target/scala-2.12/tpcdsbenmark_2.12-0.1.0-SNAPSHOT.jar \
/opt/app/spark_dev/benchmarkcode/tpcds_data /opt/tpcds-kit/tools

${SPARK_HOME}/bin/spark-submit \
    --master k8s://https://<k8s-apiserver-host>:<k8s-apiserver-port> \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.executor.instances=5 \
    --conf spark.kubernetes.container.image=<spark-image> \
    -- jars jarfile1.jar, jarfile2.jar...
    http://path/to/examples.jar parameter1 parameter2 etc...
     local:/opt/app/spark_dev/benchmarkcode/tpcds_data /opt/tpcds-kit/tools