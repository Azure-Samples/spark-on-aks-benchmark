# Configuring AKS

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