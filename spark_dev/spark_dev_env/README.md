This folder will create a Spark 3.0.0 development environment for TPCDS.  The readme is a work in progress.

1A. Apparently +x permissions were/are not saved on git push. Thus run,   

chmod +x spark_dev/entrypoint.sh
chmod +x spark_dev/start-spark.sh

1.  create_spark_dev_env.sh

    Run this from the root directory of this folder.    This will create two docker containers, spark:3.0.0d and spark_dev:1.0

2. start_dev_containers.sh

Run this from the root directory of this folder.  It will start the spark_dev container.

3.  Within the spark_dev container, run the start-spark.sh script.  This will start a spark master and slave on the container.

4.  Dev away.  Recommendation, create a docker volume for your project.

TODO: push the containers to ACR.
