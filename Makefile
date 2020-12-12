# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

.PHONEY: init plan workspace

WHOAMI := $(shell whoami)
WORKSPACE_CHECK := $(shell terraform workspace list | grep $$(whoami) | sed 's/* //')

all: help

dev:		## Create a development environment
	
help:		## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

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
