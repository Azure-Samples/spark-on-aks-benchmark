# Makefile

This Makefile was created to enable quick deployment and testing of the Spark on AKS solution. Each command is outlined below.

## Porcelain Commands

These commands are designed to perform multiple sub-commands to make the solution easier to operate. 

__dev__ This command deploys the Terraform environment found in the `env/base-cluster` folder and updates the permissions to ensure the proper permissions between AKS and ACR

## Commands

__int__ This runs the `terraform init` command on the environment. It is set to use the `reconfigure` flag and does not accept input.

__plan__ This command runs the `init` command prior to running. This runs the `terraform plan` command. It sets the workspace to the computer username. It outputs the plan as a file.

__apply__ This command runs the `plan` command prior to running. This runs the `terraform apply` command. It uses the plan output file.

__post-apply__ This command runs the `apply` command prior to running. This command updates updates the permissions for the ACR created in the apply so that AKS can access it.

__workspace__  This command sets the Terraform workspace based off the username of the logged in machine. This command is designed for users in a shared subscription model where more than one developer may be sharing a single subscription.

__acr-login__ This command logs the current user into the Azure Container Registry. This is needed to push the container image to the registry.

__docker-build__ This command executes the Docker `buildx` command to build the image. It uses the ACR name created by the infrastructure deployment.

__docker-push__ This pushes the image to the container registry.

__aks-login__ This command gets the AKS admin credentials and merges them into the local kubctl config file by running the `az aks get-credentials` command

__helm-deploy__ This command runs quite a few commands to deploy the spark repo. It does the following:

* Ensures that any existing kubernetes secret for the tcpdsdata-key is deleted.
* Creates a secret for the tcpdsdata-key
* Adds the helm repo for the spark-operator and the loki stack
* Updates the dependencies of the chart
* Deploys the Helm chart.

__generate-data__ This command will be used to run the spark job that generates the standard test data expected by the benchmark test.

__run-benchmark__ Use this command to actually run the benchmark test.

__cleanup__ When the the environment is no longer needed, run this command to delete the Azure resources created. This command does _NOT_ wait for the command to complete before returning.

__cleanup-v__ Like the `clean-up` command, it can be used to delete Azure resources. This command will wait for all cloud resources to be deleted.
