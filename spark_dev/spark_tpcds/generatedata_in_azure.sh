#!/bin/bash

# Assumption is that spark master and slave is already started.
# This script will call spark_submit with the build jar file to generrated 1GB of data.
# data is generated into the ../tpcds_data folder

export SPARK_MASTER=spark://$(hostname):7077
export CLASS="com.microsoftazure.aks.tpcds.DataGenerator"
export DATA_DIR="abfss://tpcds@jamesposparkdata.dfs.core.windows.net/data"
export TOOL_DIR="/opt/tpcds-kit/tools"
export JARS="abfss://tpcds@jamesposparkdata.dfs.core.windows.net/benchmarkjars/spark-sql-perf_2.12_latest.jar"
export BENCHMARK="abfss://tpcds@jamesposparkdata.dfs.core.windows.net/benchmarkjars/spark-sql-perf_2.12_latest.jar"


/opt/spark/bin/spark-submit \
        --deploy-mode cluster \
        --master $SPARK_MASTER \
        --class $CLASS \
        --jars $JARS \
        $BENCHMARK \
        $DATA_DIR $TOOL_DIR