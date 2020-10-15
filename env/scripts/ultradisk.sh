#!/bin/bash

# Set variables
RESOURCE_GROUP=sparkOnAks
AKS_CLUSTER=sparkOnAks-k8s
VM_SIZE=Standard_L8s_v2
NODE_COUNT=5

# This script will require logging into and selecting the subscription where the main cluster is deployed

# Ultra disks are still in preview and this preview this needs to be enabled before an Ultradisk nodepool can be deployed

az feature register --namespace "Microsoft.ContainerService" --name "EnableUltraSSD"

az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/EnableUltraSSD')].{Name:name,State:properties.state}"

az provider register --namespace Microsoft.ContainerService

# Install the aks-preview extension
az extension add --name aks-preview

# Update the extension to make sure you have the latest version installed
az extension update --name aks-preview

# Add Ultra disk  to an existing cluster
az aks nodepool add \
    --name ultradisk \
    --cluster-name $AKS_CLUSTER \
    --resource-group $RESOURCE_GROUP \
    --node-vm-size $VM_SIZE \
    --zones 1 2 3\
    --node-count $NODE_COUNT \
    --aks-custom-headers EnableUltraSSD=true