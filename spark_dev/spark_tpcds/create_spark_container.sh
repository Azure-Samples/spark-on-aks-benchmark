
export JAVA_IMAGE_TAG="11-jre-slim"
export SPARK_VERSION="3.0.0k"

SCRIPT_ROOT=${PWD}
mkdir -p spark_base
cd spark_base
SPARK_BASE=${PWD}

# wget http://apache.cs.utah.edu/spark/spark-3.0.0/spark-3.0.0-bin-hadoop3.2.tgz
wget https://archive.apache.org/dist/spark/spark-3.0.0/spark-3.0.0-bin-hadoop3.2.tgz
tar xvf spark-3.0.0-bin-hadoop3.2.tgz
rm spark-3.0.0-bin-hadoop3.2.tgz

cd spark-3.0.0-bin-hadoop3.2/bin
./docker-image-tool.sh -t $SPARK_VERSION -b java_image_tag=${JAVA_IMAGE_TAG} build

cd $SCRIPT_ROOT
rm -r ${SPARK_BASE}
