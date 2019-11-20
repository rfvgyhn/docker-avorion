.PHONY: build release

default: build

CHANNEL = stable
DOCKER_IMAGE ?= rfvgyhn/avorion
VERSION ?= $(shell grep '$(CHANNEL):' version.txt | cut -d ' ' -f2)
INSTALL_ARGS = 
BUILD_ARGS =

ifneq ($(CHANNEL), stable)
	DOCKER_TAG = $(VERSION)-$(CHANNEL)
	INSTALL_ARGS = -beta beta
else
	DOCKER_TAG = $(VERSION)
endif

build: info
	# Build Docker image
	docker build \
		--build-arg INSTALL_ARGS=" ${INSTALL_ARGS}" \
		--build-arg VERSION=$(VERSION) \
		--build-arg CREATED=`date -u -Iseconds` \
		--build-arg SOURCE=`git config --get remote.origin.url` \
		--build-arg REVISION=`git rev-parse --short HEAD` \
		${BUILD_ARGS} \
		-t $(DOCKER_IMAGE):$(DOCKER_TAG) .

release: build info
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest
	
ifeq ($(CHANNEL), stable)
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):$(CHANNEL)
	docker push $(DOCKER_IMAGE):$(CHANNEL)
endif

	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):latest

info:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)
