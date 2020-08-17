This folder will create a Spark 3.0.0 development environment for TPCDS.  The readme is a work in progress.

1A. Apparently +x permissions were/are not saved on git push. Thus run,   

chmod +x spark_dev/entrypoint.sh
chmod +x spark_dev/start-spark.sh

1.  create_spark_dev_env.sh

    Run this from the root directory of this folder.    This will create two docker containers, spark:3.0.0 and spark_dev:1.0

codespace:~/workspace/spark-on-aks/spark_dev_env$ docker images
REPOSITORY                                         TAG                 IMAGE ID            CREATED              SIZE
spark_dev      docker                                     1.0                 15f0bb9b8ad4        About a minute ago   972MB
spark                                              3.0.0               61e885093634        2 minutes ago        709MB
openjdk                                            11-jdk-slim         de8b1b4806af        8 days ago           402MB
mcr.microsoft.com/vscode/devcontainers/universal   0.12.0-linux        accb304a75cc        2 weeks ago          9.99GB

2.  cleanup.sh

Run this from the root directory of this folder.  It will clean up the left over Spark 3.0.0 files in spark_base.

3.  start_dev_containers.sh

Run this from the root directory of this folder.  It will start the spark_dev container.

4.  Within the spark_dev container, run the start-spark.sh script.  This will start a spark master and slave on the container.

5.  Dev away.  Recommendation, create a docker volume for your project.

TODO: push the containers to ACR.
