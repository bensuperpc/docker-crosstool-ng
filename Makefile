SUBDIRS := debian alpine ubuntu

DOCKER := docker


.PHONY: all clean qemu $(SUBDIRS)

all: $(SUBDIRS)

clean: $(SUBDIRS)
	$(DOCKER) images --filter=reference='bensuperpc/*' --format='{{.Repository}}:{{.Tag}}' | xargs -r $(DOCKER) rmi -f

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

qemu:
	export DOCKER_CLI_EXPERIMENTAL=enabled
	$(DOCKER) run --rm --privileged multiarch/qemu-user-static --reset -p yes
	$(DOCKER) buildx create --name qemu_builder --driver docker-container \
		--driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=100000000,env.BUILDKIT_STEP_LOG_MAX_SPEED=100000000 --use 
	$(DOCKER) buildx inspect --bootstrap
