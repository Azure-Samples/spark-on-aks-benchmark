#!/bin/bash
export JAVA_IMAGE_TAG="11-jdk-slim"
export SPARK_VERSION="3.0.0"
export OPENSSL_VERSION="1.1.0"
export HADOOP_VERSION="3.2.0"
export HADOOP_MAJOR="3.2"
export TAG="3.0.0d"


SCRIPT_ROOT=${PWD}
mkdir -p spark_base
cd spark_base
SPARK_BASE=${PWD}

# wget http://apache.cs.utah.edu/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}.tgz
wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}.tgz
tar xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}.tgz

sed -i 's/USER ${spark_uid}/#USER ${spark_uid}/g' spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/kubernetes/dockerfiles/spark/Dockerfile
sed -i 's/ENTRYPOINT/#ENTRYPOINT/g' spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/kubernetes/dockerfiles/spark/Dockerfile
sed -i 's|http:/https|http:/http|g' spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/kubernetes/dockerfiles/spark/Dockerfile

# Add in the core-site.xml file
cd $SPARK_BASE
cp  $SCRIPT_ROOT/core-site.xml $SPARK_BASE/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}
sed -i "/COPY jars/ i RUN mkdir -p /opt/spark/conf" spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/kubernetes/dockerfiles/spark/Dockerfile
sed -i "/COPY jars/ i COPY core-site.xml /opt/spark/conf" spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/kubernetes/dockerfiles/spark/Dockerfile

# add the Azure jars
cd $SPARK_BASE
wget --output-document=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/jars/hadoop-azure-${HADOOP_VERSION}.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/${HADOOP_VERSION}/hadoop-azure-${HADOOP_VERSION}.jar 
wget --output-document=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/jars/hadoop-azure-datalake-${HADOOP_VERSION}.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure-datalake/${HADOOP_VERSION}/hadoop-azure-datalake-${HADOOP_VERSION}.jar

# add openssl
cd $SPARK_BASE
wget --output-document=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/jars/wildfly-openssl-${OPENSSL_VERSION}.Final.jar https://repo1.maven.org/maven2/org/wildfly/openssl/wildfly-openssl/${OPENSSL_VERSION}.Final/wildfly-openssl-${OPENSSL_VERSION}.Final.jar

cd $SPARK_BASE
cd spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/bin
./docker-image-tool.sh -t $TAG -b java_image_tag=${JAVA_IMAGE_TAG} build

cd $SCRIPT_ROOT
cd spark_dev

docker build -t spark_dev:1.0 --build-arg TAG=spark:$TAG .

cd $SCRIPT_ROOT
rm -r $SPARK_BASE
