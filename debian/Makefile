#//////////////////////////////////////////////////////////////
#//   ____                                                   //
#//  | __ )  ___ _ __  ___ _   _ _ __   ___ _ __ _ __   ___  //
#//  |  _ \ / _ \ '_ \/ __| | | | '_ \ / _ \ '__| '_ \ / __| //
#//  | |_) |  __/ | | \__ \ |_| | |_) |  __/ |  | |_) | (__  //
#//  |____/ \___|_| |_|___/\__,_| .__/ \___|_|  | .__/ \___| //
#//                             |_|             |_|          //
#//////////////////////////////////////////////////////////////
#//                                                          //
#//  Script, 2021                                            //
#//  Created: 27, June, 2021                                 //
#//  Modified: 27, June, 2021                                //
#//  file: -                                                 //
#//  -                                                       //
#//  Source: https://github.com/crosstool-ng/crosstool-ng                                               //
#//          https://www.docker.com/blog/getting-started-with-docker-for-arm-on-linux/
#//          https://schinckel.net/2021/02/12/docker-%2B-makefile/
#//          https://www.padok.fr/en/blog/multi-architectures-docker-iot
#//  OS: ALL                                                 //
#//  CPU: ALL                                                //
#//                                                          //
#//////////////////////////////////////////////////////////////
BASE_OS    := debian
BASE_IMAGE := $(BASE_OS):bullseye-slim
IMAGE_NAME := bensuperpc/crosstool-ng
DOCKERFILE := Dockerfile
CROSSTOOL_VERSION := master

DOCKER := docker

TAG := $(shell date '+%Y%m%d')-$(shell git rev-parse --short HEAD)
DATE_FULL := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
UUID := $(shell cat /proc/sys/kernel/random/uuid)
VERSION := 1.0.0
# Disable: linux/arm64 linux/386 linux/arm/v7 linux/arm/v6 linux/s390x linux/ppc64le
ARCH_LIST := linux/amd64

comma:= ,
COM_ARCH_LIST:= $(subst $() $(),$(comma),$(ARCH_LIST))

$(ARCH_LIST): $(DOCKERFILE)
	$(DOCKER) buildx build . -f $(DOCKERFILE) -t $(IMAGE_NAME):$(BASE_OS)-$(TAG) \
	-t $(IMAGE_NAME):$(BASE_OS)-$(CROSSTOOL_VERSION) --build-arg BUILD_DATE=$(DATE_FULL) --build-arg DOCKER_IMAGE=$(BASE_IMAGE) \
	-t $(IMAGE_NAME):$(BASE_OS)-latest --build-arg CT_VERSION_GIT=$(CROSSTOOL_VERSION) --platform $@ \
	--build-arg VERSION=$(VERSION) --progress=plain --load

$(BASE_OS): all

all: $(DOCKERFILE)
	$(DOCKER) buildx build . -f $(DOCKERFILE) -t $(IMAGE_NAME):$(BASE_OS)-$(TAG) -t $(IMAGE_NAME):$(BASE_OS) \
	-t $(IMAGE_NAME):$(BASE_OS)-$(CROSSTOOL_VERSION)  --build-arg BUILD_DATE=$(DATE_FULL) --build-arg DOCKER_IMAGE=$(BASE_IMAGE) --platform $(COM_ARCH_LIST) \
	-t $(IMAGE_NAME):$(BASE_OS)-latest --build-arg VERSION=$(VERSION) --build-arg CT_VERSION_GIT=$(CROSSTOOL_VERSION) --progress=plain --push

push: all

# https://github.com/linuxkit/linuxkit/tree/master/pkg/binfmt
qemu:
	export DOCKER_CLI_EXPERIMENTAL=enabled
	$(DOCKER) run --rm --privileged multiarch/qemu-user-static --reset -p yes
	$(DOCKER) buildx create --name qemu_builder --driver docker-container \
		--driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=100000000,env.BUILDKIT_STEP_LOG_MAX_SPEED=100000000 --use 
	$(DOCKER) buildx inspect --bootstrap

clean:
	$(DOCKER) images --filter='reference=$(IMAGE_NAME)' --format='{{.Repository}}:{{.Tag}}' | xargs -r $(DOCKER) rmi -f

.PHONY: build push clean qemu $(ARCH_LIST)
