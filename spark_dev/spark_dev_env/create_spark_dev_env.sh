#!/bin/bash

export JAVA_IMAGE_TAG="11-jdk-slim"
export SPARK_VERSION="3.0.0d"

SCRIPT_ROOT=${PWD}
cd spark_base
SPARK_BASE=${PWD}

# wget http://apache.cs.utah.edu/spark/spark-3.0.0/spark-3.0.0-bin-hadoop3.2.tgz
wget https://archive.apache.org/dist/spark/spark-3.0.0/spark-3.0.0-bin-hadoop3.2.tgz
tar xvf spark-3.0.0-bin-hadoop3.2.tgz
rm spark-3.0.0-bin-hadoop3.2.tgz

sed -i 's/USER ${spark_uid}/#USER ${spark_uid}/g' spark-3.0.0-bin-hadoop3.2/kubernetes/dockerfiles/spark/Dockerfile
sed -i 's/ENTRYPOINT/#ENTRYPOINT/g' spark-3.0.0-bin-hadoop3.2/kubernetes/dockerfiles/spark/Dockerfile
sed -i 's|http:/https|http:/http|g' spark-3.0.0-bin-hadoop3.2/kubernetes/dockerfiles/spark/Dockerfile
#sed -i 's|rm /bin/sh|#rm /bin/sh|g' spark-3.0.0-bin-hadoop3.2/kubernetes/dockerfiles/spark/Dockerfile

cd spark-3.0.0-bin-hadoop3.2/bin
./docker-image-tool.sh -t $SPARK_VERSION -b java_image_tag=${JAVA_IMAGE_TAG} build

cd $SPARK_BASE

sed -i 's/#USER ${spark_uid}/USER ${spark_uid}/g' spark-3.0.0-bin-hadoop3.2/kubernetes/dockerfiles/spark/Dockerfile
sed -i 's/#ENTRYPOINT/ENTRYPOINT/g' spark-3.0.0-bin-hadoop3.2/kubernetes/dockerfiles/spark/Dockerfile
sed -i 's|http:/http|http:/https|g' spark-3.0.0-bin-hadoop3.2/kubernetes/dockerfiles/spark/Dockerfile
#sed -i 's|#rm /bin/sh|rm /bin/sh|g' spark-3.0.0-bin-hadoop3.2/kubernetes/dockerfiles/spark/Dockerfile

cd $SCRIPT_ROOT
cd spark_dev

docker build -t spark_dev:1.0 .

cd $SCRIPT_ROOT

