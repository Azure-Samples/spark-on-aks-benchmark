# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license
#!/bin/bash

# Set variables
RESOURCE_GROUP=sparkOnAks
AKS_CLUSTER=sparkOnAks-k8s
VM_SIZE=Standard_DS13_v2
NODE_COUNT=5

az extension add --name aks-preview
az feature register --name EnableEphemeralOSDiskPreview --namespace Microsoft.ContainerService
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/EnableEphemeralOSDiskPreview')].{Name:name,State:properties.state}"
az provider register --namespace Microsoft.ContainerService
az extension update --name aks-preview

az aks nodepool add \
    --name ephemeral \
    --cluster-name $AKS_CLUSTER \
    --resource-group $RESOURCE_GROUP \
    -s $VM_SIZE \
    --node-osdisk-type Ephemeral