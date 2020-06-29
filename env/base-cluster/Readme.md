# Setting up the Base Cluster

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

The Terraform state file will be stored in Azure. This requires a Storage Account and Storage Container to be created.

```bash
LOCATION=westus
RESOURCE_GROUP_NAME=shared
STORAGE_ACCOUNT_NAME=mytfstate$RANDOM
STATE_CONTAINER_NAME=tfstate

az group create \
  --location $LOCATION \
  --name $RESOURCE_GROUP_NAME

az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP_NAME

$STORAGE_ACCOUNT_KEY=$(az storage account keys list \
  --account-name $STORAGE_ACCOUNT_NAME \
  -resource-group $RESOURCE_GROUP_NAME \
  --query '[0].{Value:value}' \
  --output tsv)

az storage container create \
  --name $STATE_CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --account-key $STORAGE_ACCOUNT_KEY
```

## Deploy terraform locally

```bash
terraform init \
  -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" \
  -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" \
  -backend-config="container_name=$STATE_CONTAINER_NAME" \
  -backend-config="key=sparkonaks.tfstate" \
  -backend-config="access_key=$STORAGE_ACCOUNT_KEY"

terraform plan

terraform apply -auto-approve
```
