# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

### SET THESE VARIABLES ###
SHARED_RG = shared
TPCDS_DATA = tpcds1tb
LOCATION = westus2
TPCDS_STORAGE = sparktpcds
###

# Dynamic Variables
WHOAMI := $(shell whoami)
WORKSPACE_CHECK := $(shell terraform workspace list | grep $$(whoami) | sed 's/* //')
RG_NAME = $(WHOAMI)-sparkOnAks
AKS_NAME = $(WHOAMI)-sparkOnAks-k8s
ADLS2_KEY = $(eval ADLS2_KEY := $(shell az storage account keys list -n $(TPCDS_DATA) -g $(SHARED_RG) --query '[0].value' -o tsv))$(ADLS2_KEY)
ACR_NAME = $(eval ACR_NAME := $(shell az acr list -g $(WHOAMI)-sparkOnAks --query '[].name' -o tsv))$(ACR_NAME)

# Porcelain Commands
dev: post-apply docker-push helm-deploy
new-image: docker-push helm-deploy
new-chart: helm-deploy
	
# Terraform Targets
init: workspace
	terraform -chdir=env/base-cluster init -reconfigure -input=false

plan: init
	terraform -chdir=env/base-cluster plan -var="workspace=$(WHOAMI)" -out=tfplan -input=false

apply: plan
	terraform -chdir=env/base-cluster apply -auto-approve -input=false tfplan

post-apply: apply
	az aks update --name $(AKS_NAME) --resource-group $(RG_NAME) --attach-acr $(ACR_NAME)

workspace:
ifeq ($(WORKSPACE_CHECK), $(WHOAMI))
	terraform workspace select $(WHOAMI)
else
	terraform workspace new $(WHOAMI)
endif

# CLI Targets
acr-login:
	az acr login --name $(ACR_NAME)

# Docker Targets
docker-build:
	docker buildx build \
		--platform=linux/amd64 \
		--tag $(ACR_NAME).azurecr.io/spark-on-aks:stable \
		.

docker-push: docker-build acr-login
	docker push $(ACR_NAME).azurecr.io/spark-on-aks:stable

# Helm Targets
aks-login:
	az aks get-credentials \
		--name $(AKS_NAME) \
		--resource-group $(RG_NAME) \
		--admin \
		--overwrite-existing

helm-deploy: aks-login
	kubectl delete secret tcpdsdata-key --ignore-not-found
	kubectl create secret generic tcpdsdata-key \
    --from-literal=key=$(ADLS2_KEY)
	helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator
	helm repo add loki-stack https://grafana.github.io/loki/charts
	helm dep update ./aks-spark-chart
	helm upgrade --install spark ./aks-spark-chart

# Testing Targets
generate-data:
	sed -i '' -e 's/sparkacrc40d/$(ACR_NAME)/' ./benchmark/spark-benchmark-generate-data.yaml
	kubectl apply -f ./benchmark/spark-benchmark-generate-data.yaml

run-benchmark:
	sed -i '' -e 's/sparkacrc40d/$(ACR_NAME)/' ./benchmark/spark-benchmark-test.yaml
	kubectl apply -f ./benchmark/spark-benchmark-test.yaml

# Cleanup
cleanup:
	az group delete \
		--name $(RG_NAME) \
		--no-wait \
		--yes
	@echo This command is issued with a no-wait. It will delete the resource group in the background.

cleanup-v:
	az group delete \
		--name $(RG_NAME) \
		--yes

# Admin
.PHONEY: all dev init plan apply post-apply workspace acr-login docker-build docker-push aks-login helm-deploy new-image new-chart cleanup cleanup-v
