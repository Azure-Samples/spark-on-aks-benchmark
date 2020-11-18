# Setting up the Base Cluster

## Prerequisites

This project requires [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) and the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

## Create the Service Principal

Testing the base cluster locally requires an Azure AD Service Principal

```bash
az ad sp create-for-rbac \
  --role Contributor \
  --sdk-auth
```

The output will look similar to:

```json
{
  "clientId": "xxxx6ddc-xxxx-xxxx-xxx-ef78a99dxxxx",
  "clientSecret": "xxxx79dc-xxxx-xxxx-xxxx-aaaaaec5xxxx",
  "subscriptionId": "xxxx251c-xxxx-xxxx-xxxx-bf99a306xxxx",
  "tenantId": "xxxx88bf-xxxx-xxxx-xxxx-2d7cd011xxxx",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

Save the JSON output because it will be used later.

## Create a Storage Account for Terraform State

The Terraform state file will be stored in Azure. This requires a Storage Account and Storage Container to be created. The deployment of the VM will also require an ssh key

**NOTE: These variables will be used through the example code below**

### Storage Scale

Increase Storage throughput limits via support ticket in the Azure Portal:

1. In the portal, open the storage account, scroll down in the menu on the left and select "New support request"
1. Select "Service and subscription limits (quotas)" as Issue type and for Quota type "Storage: Per account limits"
1. In the request details, select your storage account, and enter the possible allowed maximum according to [this document](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#storage-limits) The documented limits are soft limits, it is important to know that it is possible to increase these limits beyond what is described there if you discuss thoroughly with support.

It is recommended to use a locally-redundant (LRS) storage account as the performancee is slightly better compared to other redundancy types, though the other types may have different advantages. More on this topic [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy).

## Terraform Workspace

Terraform has a workspace concept and when creating a development environment some variables in the deployment will use this workspace information to limit the number of items deployed to control resources in lower environments.

```bash
terraform workspace new $(whoami) #This will create a workspace based on the computer username. This can be replaced with any value other than default
```

## Variables

```bash
LOCATION=westus
RESOURCE_GROUP_NAME=shared
STORAGE_ACCOUNT_NAME=mytfstate$RANDOM
STATE_CONTAINER_NAME=tfstate
SSH_KEY_NAME=spark-on-azure

#These variables are set from the JSON output above
# TODO: Script and parse this output from above
DEV_CLIENT_ID=xxxx6ddc-xxxx-xxxx-xxx-ef78a99dxxxx
DEV_CLIENT_SECRET=xxxx79dc-xxxx-xxxx-xxxx-aaaaaec5xxxx
DEV_SUB_ID=xxxx251c-xxxx-xxxx-xxxx-bf99a306xxxx
DEV_TENANT_ID=xxxx88bf-xxxx-xxxx-xxxx-2d7cd011xxxx
```

## Create the Azure Resources

```bash
az group create \
  --location $LOCATION \
  --name $RESOURCE_GROUP_NAME

az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP_NAME

STORAGE_ACCOUNT_KEY=$(az storage account keys list \
  --account-name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --query '[0].{Value:value}' \
  --output tsv)

az storage container create \
  --name $STATE_CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --account-key $STORAGE_ACCOUNT_KEY
```

## Create an SSH Key

```bash
ssh-keygen \
  -b 4096 \
  -f ~/.ssh/$SSH_KEY_NAME
SSH_PUBLIC_KEY=$(cat ~/.ssh/$SSH_KEY_NAME)
```

## Deploy terraform locally

```bash
terraform init \
  -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" \
  -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" \
  -backend-config="container_name=$STATE_CONTAINER_NAME" \
  -backend-config="key=sparkonaks.tfstate" \
  -backend-config="access_key=$STORAGE_ACCOUNT_KEY"

terraform plan \
  -var="sub=$DEV_SUB_ID" \
  -var="client_id=$DEV_CLIENT_ID" \
  -var="client_secret=$DEV_CLIENT_SECRET" \
  -var="tenant_id=$DEV_TENANT_ID" \
  -var="public_key=$SSH_PUBLIC_KEY"

terraform apply \
  -auto-approve \
  -var="sub=$DEV_SUB_ID" \
  -var="client_id=$DEV_CLIENT_ID" \
  -var="client_secret=$DEV_CLIENT_SECRET" \
  -var="tenant_id=$DEV_TENANT_ID" \
  -var="public_key=$SSH_PUBLIC_KEY"
```

## Destroy the test environment

To cleanup the test environment run the following command

```bash
terraform destroy \
  -auto-approve \
  -var="sub=$DEV_SUB_ID" \
  -var="client_id=$DEV_CLIENT_ID" \
  -var="client_secret=$DEV_CLIENT_SECRET" \
  -var="tenant_id=$DEV_TENANT_ID" \
  -var="public_key=$SSH_PUBLIC_KEY"
```
