# Makefile for shipping and testing the container image.

MAKEFLAGS += --warn-undefined-variables
.DEFAULT_GOAL := build
.PHONY: *

# we get these from CI environment if available, otherwise from git
GIT_COMMIT ?= $(shell git rev-parse --short HEAD)
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

namespace ?= smithx10
tag := branch-$(shell basename $(GIT_BRANCH))
image := $(namespace)/etcd

## Display this help message
help:
	@awk '/^##.*$$/,/[a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

# ------------------------------------------------
# Container builds

local-build: local-etcd-build local-k8s-api-build local-consul-build local-vault-build
## Builds the application container image locally
local-etcd-build:
	docker build -f ./etcd/Dockerfile -t=$(image):latest .

local-k8s-api-build:
	docker build -f ./api/Dockerfile -t=$(namespace)/api:latest .

local-consul-build:
	docker build -f ./consul/Dockerfile -t=$(namespace)/consul:latest .

local-vault-build:
	docker build -f ./vault/Dockerfile -t=$(namespace)/vault:latest .

## This Process would be taken care of in CI to make sure the application is cleanly deployed.  For now, I'm just going to show operability.


# ------------------------------------------------
# Test running


# ------------------------------------------------
# Up / Down / Clean Locally
local-up:
	docker-compose -f examples/compose/docker-compose.yml -p k8s up -d

local-down:
	docker-compose -f examples/compose/docker-compose.yml -p k8s down

local-scale-etcd-up:
	docker-compose -f examples/compose/docker-compose.yml -p k8s scale etcd=3

local-scale-etcd-down:
	docker-compose -f examples/compose/docker-compose.yml -p k8s scale etcd=1

local-remove-bootstrap:
	docker-compose -f examples/compose/docker-compose.yml -p k8s scale etcd-bootstrap=0

local-scale-vault-up:
	docker-compose -f examples/compose/docker-compose.yml -p k8s scale vault=3

local-scale-vault-down:
	docker-compose -f examples/compose/docker-compose.yml -p k8s scale vault=1


# ------------------------------------------------

create-pgp-key:
	./vault/bin/create-key.sh

## Print environment for build debugging
debug:
	@echo GIT_COMMIT=$(GIT_COMMIT)
	@echo GIT_BRANCH=$(GIT_BRANCH)
	@echo namespace=$(namespace)
	@echo tag=$(tag)
	@echo image=$(image)
	@echo testImage=$(testImage)

check_var = $(foreach 1,$1,$(__check_var))
__check_var = $(if $(value $1),,\
	$(error Missing $1 $(if $(value 2),$(strip $2))))
