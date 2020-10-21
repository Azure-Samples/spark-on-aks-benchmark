# Quick Start Guide #

## Table of Contents ##
- Introduction
- Prerequisite
- AKS
- Spark Operator
- Generate the TPC-DS Test Data Set
- Running Benchmarks
___
## Introduction
This repository  is designed to be self contained with all of the resources necessary to deploy Spark on AKS. It leverages a Docker image that will be built and deployed to an Azure Container registry in your subscription. The [Readme file](../spark/Readme.md) contains more information about the Docker manifest. You can make any modifications to to the image here.

If you already have an AKS Cluster where you want to deploy the Spark Operator, skip to the [deployment section](#deploy-spark-operator).
## Prerequisite
<!-- TODO: Create pre-req script that can create the needed resources that are not controlled by Terraform -->

[Azure CLI]()
[Terraform]()

## Azure CLI
The [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) will be required to run the scripts and examples in this repo. These commands can be completed in PowerShell but will need to be converted and those conversions are not provided at this time.

Once installed the login process for the CLI is initiated through the following command:
```bash
az login
```

The output will display the subscriptions that this login has access to. If the login has access to more than one subscription the target subscription for the deployment needs to be selected by running the following command:

```bash
az account set --subscription <subscription name>
```
## Azure Resources
There are some Azure Resources that are leveraged during this deployment and need to be created before the environment can be deployed.

### Service Principal
A Service Principal with contributor access to the deployment subscription is required to run these scripts as-is.

```bash
az ad sp create-for-rbac --sdk-auth --name mySparkSp
```

The output will be something similar to below. Make a note of this information as will be needed in later steps.

```json
{
  "appId": "559513bd-0c19-4c1a-87cd-851a26afd5fc",
  "displayName": "mySparkSp",
  "name": "http://mySparkSp",
  "password": "e763725a-5eee-40e8-a466-dc88d980f415",
  "tenant": "72f988bf-86f1-41af-91ab-2d7cd011db48"
}
```

### Azure Storage Account
There are two storage accounts one is a standard storage account that is used for managing the state of the Terraform environment. The second is an Azure Data Lake Storage Gen2 account. These are created by running the following commands:

```bash
LOCATION=westus2
SHARED_RESOURCES_NAME=shared
STORAGE_NAME=$NAME$RANDOM
TPCDS_STORAGE=tpcds$RANDOM

az group create \
    --name $SHARED_RESOURCES_NAME \
    --location $LOCATION

az account account create \
    --name $STORAGE_NAME \
    --resource-group $SHARED_RESOURCES_NAME \
    --location $LOCATION \
    --kind Storagev2

az storage container create \
    --name tfstate \
    --account-name $STORAGE_NAME

az storage account create \
    --name $TPCDS_STORAGE \
    --resource-group $SHARED_RESOURCES_NAME \
    --kind StorageV2 \
    --enable-hierarchical-namespace true

az storage fs create \
    --name tpcds \
    --account-name $TPCDS_STORAGE \
    --auth-mode login
```

## Terraform
The environment is deployed using [Terraform](https://www.terraform.io/downloads.html) and uses Azure Storage to manage the state of the environment. If you have run the script amove there will be some reused variables. If you already have a storage container for the state, you will need to add `STORAGE_NAME=<your_storage_account>` and `SHARED_RESOURCES_NAME=<your shared resource group>` to the variables block below.

```bash
# Variables
CONTAINER_NAME=tstate
KEY=sparkonaks.tfstate
ACCESS_KEY=$(az storage account keys list -g $SHARED_RESOURCES_NAME -n $STORAGE_NAME -q '[0].value' -o tsv)
SUB=<subscription-used-in-the-sp-step> #This needs to be updated
CLIENT_ID=<client-id-created-in-the-sp-step> #This needs to be updated
CLIENT_SECRET=<client-secret-created-in-the-sp-step> #This needs to be updated
TENANT_ID=<tenate-id-used-in-the-sp-step> #This needs to be updated

# These commands need to be run from the `env/base-cluster/` folder

## This command initiates the Terraform environment and sets up the state
terraform init \
  -reconfigure \
  -backend-config="resource_group_name=${SHARED_RESOURCES_NAME}" \
  -backend-config="storage_account_name=${STORAGE_NAME}" \
  -backend-config="container_name=${CONTAINER_NAME}" \
  -backend-config="key=${KEY}" \
  -backend-config="access_key=${ACCESS_KEY}"

## This will plan the deployment. For multiple deployments this will show any changes that are made to the environment
terraform plan -var="sub=${SUB}" \
  -var="client_id=${CLIENT_ID}" \
  -var="client_secret=${CLIENT_SECRET}" \
  -var="tenant_id=${TENANT_ID}"

# This command will apply the plan created in the above step. If no plan has been created, this command will create the plan and execute it.
terraform apply \
  -auto-approve \
  -var="sub=${SUB}" \
  -var="client_id=${CLIENT_ID}" \
  -var="client_secret=${CLIENT_SECRET}" \
  -var="tenant_id=${TENANT_ID}"

# This will destroy and clean up the environment
terraform destroy \
  -auto-approve \
  -auto-approve \
  -var="sub=${SUB}" \
  -var="client_id=${CLIENT_ID}" \
  -var="client_secret=${CLIENT_SECRET}" \
  -var="tenant_id=${TENANT_ID}"

```

### Helm
The deployment of the Spark Operator leverages [Helm](https://helm.sh/docs/intro/install/)

___
## Generate the TPC-DS Test Data Set

___
## Running Benchmarks

___