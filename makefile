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

## Builds the application container image locally
local-build:
	docker build -f Dockerfile -t=$(image):latest .

triton-build: 
	triton-docker build -f fibo/Dockerfile -t=$(image):latest .

## This Process would be taken care of in CI to make sure the application is cleanly deployed.  For now, I'm just going to show operability.


# ------------------------------------------------
# Test running


# ------------------------------------------------
# Up / Down / Clean Locally
local-up:
	docker-compose -f local-compose.yml -p etcd up -d

local-down:
	docker-compose -f local-compose.yml -p etcd down

local-scale-up:
	docker-compose -f local-compose.yml -p etcd scale etcd=3

local-scale-down:
	docker-compose -f local-compose.yml -p etcd scale etcd=1

local-remove-bootstrap:
	docker-compose -f local-compose.yml -p etcd scale etcd-bootstrap=0


# ------------------------------------------------
# Up / Down / Clean on Triton
triton-up:

triton-down:

int-tests:





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
