
export JAVA_IMAGE_TAG="11-jre-slim"
export SPARK_VERSION="3.0.0"
export OPENSSL_VERSION="1.1.0"
export HADOOP_VERSION="3.2.0"
export HADOOP_MAJOR="3.2"
export TAG="3.0.0"

SCRIPT_ROOT=${PWD}
mkdir -p spark_base
cd spark_base
SPARK_BASE=${PWD}

# download spark
wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}.tgz
tar xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}.tgz

# Add environment variables and tpcds-toolkit to the docker file
# TODO, can we can point the files from ABFS later? i.e. remove tpcds-kit-tools copy
cd $SPARK_BASE/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/kubernetes/dockerfiles/spark
cp -r $SCRIPT_ROOT/tpcds-kit $SPARK_BASE/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}
sed -i "/COPY jars/ i COPY tpcds-kit /opt/tpcds-kit" Dockerfile
sed -i "/COPY jars/ i ENV HADOOP_OPTIONAL_TOOLS=hadoop-azure" Dockerfile

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

# https fails now and again to fetch
sed -i 's|http:/https|http:/http|g' spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/kubernetes/dockerfiles/spark/Dockerfile

# create the docker image
cd $SPARK_BASE/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_MAJOR}/bin
./docker-image-tool.sh -t $TAG -b java_image_tag=${JAVA_IMAGE_TAG} build

# clean up
cd $SCRIPT_ROOT
rm -r $SPARK_BASE

