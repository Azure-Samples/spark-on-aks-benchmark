# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

# Base Image
FROM openjdk:8-jre-slim as builder

# Update environment & install dev tools
RUN apt update -y && apt upgrade -y && \
    apt install curl gcc make flex bison byacc git gnupg2 -y

# Install sbt
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
  curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
  apt-get update -y && \
  apt-get install sbt -y

# add TPCDS code
RUN git clone https://github.com/databricks/tpcds-kit.git && \
    cd tpcds-kit/tools && \
    make clean && \
    make OS=LINUX

#Build a Sql Perf Library
RUN git clone https://github.com/databricks/spark-sql-perf && \
    cd spark-sql-perf && \
    sbt package

RUN cd / && \
    git clone https://github.com/Azure-Samples/spark-on-aks-benchmark && \
    cp /spark-sql-perf/target/scala-2.12/spark-sql-perf_*.jar /spark-on-aks-benchmark/benchmark/lib && \  
    cd /spark-on-aks-benchmark/benchmark && \
    sbt package

# Base Image
FROM openjdk:8-jre-slim

# Define Spark and Hadoop Verson
ENV HADOOP_VERSION 3.3.0
ENV HADOOP_SHORT_VERSION 3.2
ENV SPARK_VERSION 3.0.0
ENV OPENSSL_VERSION 1.1.0
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin

# Set path
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native
ENV HADOOP_OPTIONAL_TOOLS="hadoop-azure,hadoop-azure-datalake"

# Update Environment
RUN set -ex && \
    sed -i 's/http:/https:/g' /etc/apt/sources.list && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt-get upgrade -y && \
    apt-get install -q -y bash tini curl && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    rm -rf /var/cache/apt/*

# Download and install haddop
RUN mkdir -p /opt && \
    cd /opt && \
    curl -O http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -zxf hadoop-${HADOOP_VERSION}.tar.gz && \
    ln -s hadoop-${HADOOP_VERSION} hadoop && \
    rm hadoop-${HADOOP_VERSION}.tar.gz && \
    echo Hadoop ${HADOOP_VERSION} native libraries installed in /opt/hadoop/lib/native

# Download and install spark
RUN mkdir -p /opt && \
    cd /opt && \
    curl -O http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SHORT_VERSION}.tgz && \
    tar -zxf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SHORT_VERSION}.tgz && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SHORT_VERSION}.tgz && \
    ln -s spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SHORT_VERSION} spark && \
    echo Spark ${SPARK_VERSION} installed in /opt && \
    chmod g+w /opt/spark

# Download and install Hadoop Azure library
RUN curl https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/${HADOOP_VERSION}/hadoop-azure-${HADOOP_VERSION}.jar -o /opt/spark/jars/hadoop-azure-${HADOOP_VERSION}.jar
RUN curl https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure-datalake/${HADOOP_VERSION}/hadoop-azure-datalake-${HADOOP_VERSION}.jar -o /opt/spark/jars/hadoop-azure-datalake-${HADOOP_VERSION}.jar

# Download and install OpenSSL library
RUN curl https://repo1.maven.org/maven2/org/wildfly/openssl/wildfly-openssl/${OPENSSL_VERSION}.Final/wildfly-openssl-${OPENSSL_VERSION}.Final.jar -o /opt/spark/jars/wildfly-openssl-${OPENSSL_VERSION}.Final.jar

# copy libraries from builder
COPY --from=builder /tpcds-kit/tools /opt/tpcds-kit/tools
COPY --from=builder /spark-sql-perf/target/scala-2.12/spark-sql-perf_*.jar /opt/spark/jars

RUN mkdir /opt/spark/work-dir

# add scripts and update spark default config
ADD spark-defaults.conf /opt/spark/conf/spark-defaults.conf
ADD core-site.xml /opt/spark/conf/core-site.xml

ENV PATH $PATH:/opt/spark/bin

COPY entrypoint.sh /opt/entrypoint.sh
COPY start-spark.sh start-spark.sh
ENTRYPOINT [ "/opt/entrypoint.sh" ]