#!/bin/sh
echo "This vm name is: ${vmname}"

# Azure Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install AzCopy
curl -O curl -O https://azcopyvnext.azureedge.net/release20200724/azcopy_linux_amd64_10.5.1.tar.gz
tar xvf azcopy_linux_amd64_10.5.1.tar.gz
mv azcopy_linux_amd64_10.5.1/azcopy /usr/bin
rm -rf azcopy_linux_amd64_10.5.1
rm azcopy_linux_amd64_10.5.1.tar.gz

# Add Kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Install Maven
curl -O https://mirrors.gigenet.com/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar xvf apache-maven-3.6.3-bin.tar.gz
export PATH=/opt/apache-maven-3.6.3./bin:$PATH

# Install Java
#curl -O https://repos.azul.com/azure-only/zulu/packages/zulu-11/11.0.3/zulu-11-azure-jdk_11.31.11-11.0.3-linux_x64.tar.gz
#tar xvf zulu-11-azure-jdk_11.31.11-11.0.3-linux_x64.tar.gz

sudo apt install openjdk-8-jre -y
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
echo "Java installed"

# Install Scala Build Tool
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
sudo apt-get update
sudo apt-get install sbt

# Build the Spark Source
git clone -b branch-2.4 https://github.com/apache/spark
cd spark
sparkdir=$(pwd)
#export JAVA_HOME=`/usr/libexec/java_home -d 64 -v "1.8*"`
./build/mvn -Pkubernetes -DskipTests clean package

exit 0