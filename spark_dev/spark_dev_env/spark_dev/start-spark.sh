#!/bin/bash

export MASTER=spark://$(hostname):7077

${SPARK_HOME}/sbin/start-master.sh
${SPARK_HOME}/sbin/start-slave.sh $MASTER

# remember to use spark-shell to set the hive meta-store
# spark.conf
# spark.conf.get("spark.sql.catalogImplementation")