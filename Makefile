BUILD_TARGETS=example-service-cli example-service

include Makefile.const

# Variables
BIN=$(CURDIR)/bin

# Obtain the last commit hash
COMMIT=$(shell git log -1 --pretty=format:"%H")

# Tools
GO_CMD=go
GO_BUILD=$(GO_CMD) build
GO_LDFLAGS=-ldflags "-X main.Version=$(VERSION) -X=main.Commit=$(COMMIT)"

# Docker options
TARGET_DOCKER_REGISTRY ?= $$USER

# Kubernetes options
TARGET_K8S_NAMESPACE ?= default

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
	@$(GO_BUILD) $(GO_LDFLAGS) -o bin/darwin/$(basename $@) ./cmd/$(basename $@)/main.go

# Trigger the build operation for linux. Notice that the suffix is removed as it is only used for Makefile expansion purposes.
%.linux:
	@ echo "Building linux binary $@"
	@GOOS=linux GOARCH=amd64 CGO_ENABLED=0 $(GO_BUILD) $(GO_LDFLAGS) -o bin/linux/$(basename $@) ./cmd/$(basename $@)/main.go

.PHONY: docker
docker: $(addsuffix .docker, $(BUILD_TARGETS))

%.docker: %.linux
	@if [ -f docker/$(basename $@)/Dockerfile ]; then\
		echo "Building docker image for "$(basename $@);\
		rm -r bin/docker || true;\
		mkdir -p bin/docker;\
		cp docker/$(basename $@)/* bin/docker/.;\
		cp bin/linux/$(basename $@) bin/docker/.;\
		docker build bin/docker -t $(TARGET_DOCKER_REGISTRY)/$(basename $@):$(VERSION);\
	fi

k8s:
	@rm -r bin/k8s || true
	@mkdir -p bin/k8s
	@cp deployments/*.yaml bin/k8s/.
	@sed -i -e 's/TARGET_K8S_NAMESPACE/$(TARGET_K8S_NAMESPACE)/' bin/k8s/*.yaml
	@sed -i -e 's/TARGET_DOCKER_REGISTRY/'$(TARGET_DOCKER_REGISTRY)'/' bin/k8s/*.yaml
	@sed -i -e 's/VERSION/$(VERSION)/' bin/k8s/*.yaml
	@echo "Kubernetes files ready at bin/k8s/"
