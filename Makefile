BUILD_TARGETS=example-service-cli example-service

# Variables
BIN=$(CURDIR)/bin

# Tools
GO_CMD=go
GO_BUILD=$(GO_CMD) build

# Docker options
TARGET_DOCKER_REGISTRY ?= $$USER

.PHONY: clean

clean:
	rm -r bin
	mkdir -p bin/darwin/

# Build target for local environment default
build: $(addsuffix .local,$(BUILD_TARGETS))
# Build target for linux
build-linux: $(addsuffix .linux,$(BUILD_TARGETS))

# Trigger the build operation for the local environment. Notice that the suffix is removed.
%.local:
	@ echo "Build binary $@"
	$(GO_BUILD) -o bin/darwin/$(basename $@) ./cmd/$(basename $@)/main.go

# Trigger the build operation for linux. Notice that the suffix is removed as it is only used for Makefile expansion purposes.
%.linux:
	@ echo "Building linux binary $@"
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 $(GO_BUILD) -o bin/linux/$(basename $@) ./cmd/$(basename $@)/main.go

.PHONY: docker
docker: $(addsuffix .docker, $(BUILD_TARGETS))

%.docker: %.linux
	@if [ -f docker/$(basename $@)/Dockerfile ]; then\
		echo "Building docker image for "$(basename $@);\
		rm -r bin/docker || true;\
		mkdir -p bin/docker;\
		cp docker/$(basename $@)/Dockerfile bin/docker/.;\
		cp bin/linux/$(basename $@) bin/docker/.;\
		docker build bin/docker -t $(TARGET_DOCKER_REGISTRY)/$(basename $@);\
	fi
