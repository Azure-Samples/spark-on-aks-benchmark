#!/bin/bash

# Set variables
RESOURCE_GROUP=sparkOnAks
AKS_CLUSTER=sparkOnAks-k8s
VM_SIZE=Standard_L8s_v2
NODE_COUNT=5

az aks nodepool add \
    --name nvme \
    --cluster-name $AKS_CLUSTER \
    --resource-group $RESOURCE_GROUP \
    -s $VM_SIZE \
    --node-count $NODE_COUNT \
