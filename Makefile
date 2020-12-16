# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

<<<<<<< HEAD
.PHONEY: init plan workspace acr-login aks-login docker-build
=======
.PHONEY: init plan workspace
>>>>>>> e732f05e44cd1503a1b2e76b0c40cb8932e04851

WHOAMI := $(shell whoami)
WORKSPACE_CHECK := $(shell terraform workspace list | grep $$(whoami) | sed 's/* //')
ACR_NAME := $(shell terraform -chdir=env/base-cluster output acr_name | sed 's/\"//g')
ACR_LOGIN := $(shell az acr login --name $(ACR_NAME))
RG_NAME := $(shell terraform -chdir=env/base-cluster output rg_name | sed 's/\"//g' )
AKS_NAME := $(shell terraform -chdir=env/base-cluster output aks_name | sed 's/\"//g' )
AKS_LOGIN := $(shell az aks get-credentials --name $(AKS_NAME) --resource-group $(RG_NAME) --admin)

all: help

dev:		## Create a development environment
	
help:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


# Terraform Targets
init: workspace 	## Initialize the repo.
	terraform -chdir=env/base-cluster init

plan: init		## Plan the changes to infra.
	terraform -chdir=env/base-cluster plan -var="workspace=$(WHOAMI)"

apply: plan ## Apply the changes to the infra
	terraform -chdir=env/base-cluster apply -auto-approve -var="workspace=$(WHOAMI)"

workspace:		## Set the terraform workspace
ifeq ($(WORKSPACE_CHECK), $(WHOAMI))
	terraform workspace select $(WHOAMI)
else
	terraform workspace new $(WHOAMI)
endif

# CLI Targets
acr-login:
	$(ACR_LOGIN)

aks-login:
	$(AKS_LOGIN)

# Docker Targets
docker-build:
	$(shell docker buildx build --platform=linux/amd64 --tag $(ACR_NAME).azurecr.io/spark-on-aks:stable ./spark/)

# Helm Targets

# Prereqs