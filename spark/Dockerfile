# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

# Base Image
FROM openjdk:9-jre-slim

# Define Spark and Hadoop Verson
ENV HADOOP_VERSION 3.2.0
ENV HADOOP_SHORT_VERSION 3.2
ENV SPARK_VERSION 3.0.0
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native

# Update Environment
RUN set -ex && \
    sed -i 's/http:/https:/g' /etc/apt/sources.list && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt-get upgrade -y && \
    apt install -y bash tini libc6 libpam-modules krb5-user libnss3 curl && \
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

# add scripts and update spark default config
ADD start-common.sh common.sh start-master start-worker /opt/
ADD spark-defaults.conf /opt/spark/conf/spark-defaults.conf
ADD core-site.xml /opt/spark/conf/core-site.xml
ENV PATH $PATH:/opt/spark/bin
RUN chmod +x /opt/start-common.sh /opt/start-master /opt/start-worker