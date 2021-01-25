# Quick Start Guide #

## Table of Contents ##

- Introduction
- Deployment

___
## Introduction

This repository  is designed to be self contained with all of the resources necessary to deploy Spark on AKS. It leverages a Docker image that will be built and deployed to an Azure Container registry in your subscription. The [Readme file](../spark/Readme.md) contains more information about the Docker manifest. You can make any modifications to to the image here.

If you already have an AKS Cluster where you want to deploy the Spark Operator, skip to the [deployment section](#deploy-spark-operator).

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

### Azure Storage Account
An Azure Data Lake Storage Gen2 account. These are created by running the following commands:

```bash
LOCATION=westus2
SHARED_RESOURCES_NAME=shared
TPCDS_STORAGE=tpcds$RANDOM

az group create \
    --name $SHARED_RESOURCES_NAME \
    --location $LOCATION

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

## Deployment
A [Makefile](https://www.gnu.org/software/make/manual/html_node/Simple-Makefile.html) has been created to help simplify deployment. Some pre-reqs are required and can be found below:

* [Terraform](https://www.terraform.io/downloads.html)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/docs/intro/install/)
* [Docker](https://www.docker.com/get-started)

With these tools install, simply run the following command:

```bash
make dev
```
The Makefile containers additional commands and a full list can be found in the [Makefile documentation](./makefile.md)

## Cleanup
Once you are finished running the benchmark simply run
```bash
make cleanup
```

This will remove the environment created by `make dev` It will not clean up the shared resources in the event that you want to change the configuration and run it again.