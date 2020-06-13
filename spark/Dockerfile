# Base Image
FROM java:openjdk-9-jdk

# Define Spark and Hadoop Verson
ENV HADOOP_VERSION 2.9.2
ENV SPARK_VERSION 2.4.6

# Download and install haddop
RUN mkdir -p /opt && \
  cd /opt && \
  curl http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | \
  tar -zx hadoop-${HADOOP_VERSION}/lib/native && \
  ln -s hadoop-${HADOOP_VERSION} hadoop && \
  echo Hadoop ${HADOOP_VERSION} native libraries installed in /opt/hadoop/lib/native

# Download and install spark
RUN mkdir -p /opt && \
  cd /opt && \
  curl http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz | \
  tar -zx && \
  ln -s spark-${SPARK_VERSION}-bin-hadoop2.7 spark && \
  echo Spark ${SPARK_VERSION} installed in /opt

# add scripts and update spark default config
ADD common.sh spark-master spark-worker /
ADD spark-defaults.conf /opt/spark/conf/spark-defaults.conf
ENV PATH $PATH:/opt/spark/bin
