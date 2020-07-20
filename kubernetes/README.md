# Configuring AKS

## About

There are two ways about submitting Spark jobs to a cluster:

    1. Interacting with the Kubernetes plane through the use of Spark operators
    2. Submittimg jobs directly through the Spark CLI

This documentation addresses setup and configuration through #2. #1 is also available and usable.

## Credentials

Setup your Kubectl by below:

    az aks get-credentials --resource-group default-sparkOnAks --name default-sparkOnAks-k8s

## Setup Cluster

Create the necessary RBAC role bindings:

    kubectl apply -f spark-rbac.yaml

Create the necessary YAML for service account citation:

    export KUBECONTEXT=sparkOnAks
    export SASECRET=`kubectl get sa spark-on-k8s-sa -o jsonpath='{.secrets[0].name}' -n spark`
    export TOKEN=`kubectl -n spark get secret/$SASECRET -o jsonpath='{.data.token}' | base64 --decode`
    export KUBEMASTERAPI=`kubectl config view -o jsonpath='{.clusters[-1].cluster.server}'`
    echo """apiVersion: v1
    kind: Config
    clusters:
    - name: $KUBECONTEXT
    cluster:
        insecure-skip-tls-verify: true
        server: $KUBEMASTERAPI
    contexts:
    - name: $KUBECONTEXT
    context:
        cluster: $KUBECONTEXT
        namespace: spark
        user: default-user
    current-context: $KUBECONTEXT
    users:
    - name: default-user
    user:
        token: $TOKEN""" >> spark.yaml

## Validation (Hello World)

The below assumes DRIVER IP is fetched from a Mac OS. Please adjust the command for your OS.

    DRIVERIP=`ipconfig getifaddr en0`
    ./bin/pyspark --master $KUBEMASTERAPI \
    --deploy-mode client \
    --name pyspark-shell \
    --conf spark.security.credentials.hadoopfs.enabled=false \
    --conf spark.security.credentials.hive.enabled=false \
    --conf spark.yarn.security.credentials.hadoopfs.enabled=false \
    --conf spark.yarn.security.tokens.hive.enabled=false \
    --conf spark.kubernetes.namespace=spark \
    --conf spark.kubernetes.container.image.pullSecrets=regcred \ 
    --conf spark.executor.instances=5 \
    --conf spark.kubernetes.container.image=spark-on-aks:stable \
    --conf spark.yarn.security.tokens.hive.enabled=false \
    --conf spark.yarn.security.credentials.hadoopfs.enabled=false \
    --conf spark.security.credentials.hive.enabled=false \
    --conf spark.security.credentials.hadoopfs.enabled=false \
    --conf spark.kubernetes.container.image.pullPolicy=Always \
    --conf spark.driver.host=$DRIVERIP \
    --conf spark.kubernetes.pyspark.pythonVersion=3 