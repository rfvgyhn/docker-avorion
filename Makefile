.PHONY: build release

default: build

CHANNEL = stable
DOCKER_IMAGE ?= rfvgyhn/avorion
VERSION ?= $(shell grep '$(CHANNEL):' version.txt | cut -d ' ' -f2)


ifneq ($(CHANNEL), stable)
	DOCKER_TAG = $(VERSION)-$(CHANNEL)
else
	DOCKER_TAG = $(VERSION)
endif

build: info
	# Build Docker image
	docker build \
		--build-arg CHANNEL=$(CHANNEL) \
		--build-arg VERSION=$(VERSION) \
		--build-arg CREATED=`date -u -Iseconds` \
		--build-arg SOURCE=`git config --get remote.origin.url` \
		--build-arg REVISION=`git rev-parse --short HEAD` \
		-t $(DOCKER_IMAGE):$(DOCKER_TAG) .

release: build info
	# Tag image as latest
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest

	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):latest

	ifeq ($(CHANNEL), stable)
		docker push $(DOCKER_IMAGE):$(CHANNEL)
	endif

info:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)