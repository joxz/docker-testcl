DOCKERHUB_USER = jones2748
REPONAME = docker-testcl
DOCKERHUB = $(DOCKERHUB_USER)/$(REPONAME)
GITHUB_USER = joxz
GITHUB = https://github.com/$(GITHUB_USER)/$(REPONAME)
VER = $(shell git rev-parse --short HEAD)
CONTAINERNAME = $(DOCKERHUB):$(VER)

BUILDFLAGS = \
  --compress \
  --force-rm \
  --label org.label-schema.schema-version="1.0" \
  --label org.label-schema.description="Docker container for testing iRules with TesTcl" \
  --label org.label-schema.vcs-url="$(GITHUB)" \
  --label org.label-schema.vcs-ref="$(VER)" \
  --label org.label-schema.docker.cmd="docker run -it --rm $(CONTAINERNAME)" \
  --label org.label-schema.name="$(DOCKERHUB)" \
  --label org.label-schema.build-date="$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")"


default: help


build:  ## build container
	@docker build $(BUILDFLAGS) -t $(CONTAINERNAME) .

build-no-cache:  ## build container without cache
	@docker build --no-cache $(BUILDFLAGS) -t $(CONTAINERNAME) .

run:  ## run container
	@docker run -it --rm $(CONTAINERNAME)

clean:  ## remove images
	@docker rmi $(CONTAINERNAME)

.PHONY: inspect
inspect:  ## inspect container properties - pretty: 'make inspect | jq .' requires jq
	@docker inspect -f "{{json .ContainerConfig }}" $(CONTAINERNAME)

.PHONY: test
test:  ## test container with builtin tests
	docker run -it --rm $(CONTAINERNAME) test
	docker run -it --rm $(CONTAINERNAME) test_irule

.PHONY: logs
logs: ## show docker logs for container (ONLY possible while container is running)
	@docker logs -f $(CONTAINERNAME)

.PHONY: history
history:  ## show docker history for container
	@docker history $(CONTAINERNAME)

.PHONY: help
help:  ## this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'