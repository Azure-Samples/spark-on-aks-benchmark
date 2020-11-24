#!/bin/bash

# Set variables
RESOURCE_GROUP=sparkOnAks
AKS_CLUSTER=sparkOnAks-k8s
ACR_NAME=$(az acr list --query '[].name' -o tsv | grep '$RESOURCE_GROUP*')
TCPDSDATA_KEY=$()

az acr login \
    --name $ACR_NAME

az aks update \
    --name AKS_CLUSTER \
    --resource-group $RESOURCE_GROUP \
    --attach-acr $acr_name

az aks get-credentials \
    --name $AKS_CLUSTER
    --resource-group $RESOURCE_GROUP
    --admin

kubectl create secret generic tcpdsdata-key \
    --from-literal=key=$TCPDSDATA_KEY