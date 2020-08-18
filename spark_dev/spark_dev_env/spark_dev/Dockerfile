

ARG TAG=spark:3_base
FROM $TAG

ENV HADOOP_OPTIONAL_TOOLS=hadoop-azure

RUN apt update

# imnstall some tools
RUN apt-get install -y vim tmux bash git 
    
## needed for start-master.sh (spark), curl to validate web portal is available, procps for ps (start-master.sh and start-slave.sh dependencies)
RUN apt-get install -y procps curl wget

# build benchmark dependencies

# build tpcds-kit
RUN apt-get install -y gcc make flex bison byacc git 
RUN mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/databricks/tpcds-kit.git && \
    cd tpcds-kit/tools && \
    make OS=LINUX
# end build tpcds-kit

RUN mkdir -p /opt
ADD https://piccolo.link/sbt-1.3.13.tgz /opt
RUN cd /opt && \
    tar -zxf sbt-1.3.13.tgz && \
    rm sbt-1.3.13.tgz 
ENV PATH=$PATH:/opt/sbt/bin
#end install sbt

#end build benchmark dependencies

# build spark-sql-perf jar
RUN cd /opt && \
    git clone https://github.com/databricks/spark-sql-perf 
RUN cd /opt/spark-sql-perf
#   sbt +package
# end build spark-sql-perf jar

# include IBM TPCDS

#RUN cd /opt && \
#   git clone https://github.com/IBM/spark-tpc-ds-performance-test.git

# end include IBM TPCDS

COPY entrypoint.sh /opt/entrypoint.sh
COPY start-spark.sh start-spark.sh
ENTRYPOINT [ "/opt/entrypoint.sh" ]
