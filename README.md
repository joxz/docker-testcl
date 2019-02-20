# docker-testcl

[![Build Status](https://travis-ci.org/joxz/docker-testcl.svg?branch=master)](https://travis-ci.org/joxz/docker-testcl)
[![docker Hub Pulls](https://img.shields.io/docker/pulls/jones2748/docker-testcl.svg?style=popout)](https://img.shields.io/docker/pulls/jones2748/docker-testcl.svg?style=popout)

Docker container for testing iRules with [TesTcl](https://testcl.com/)

The docker image uses [adoptopenjdk/openjdk11-openj9:alpine-slim](https://hub.docker.com/r/adoptopenjdk/openjdk11-openj9)

Docker Hub Link: [https://hub.docker.com/r/jones2748/docker-testcl](https://hub.docker.com/r/jones2748/docker-testcl)

## Build image

```bash
$ git clone https://github.com/joxz/docker-testcl

$ cd docker-testcl

$ docker build -t docker-testcl .

# check docker images

$ docker images
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
docker-testcl                   latest              8f42d87ed70b        3 minutes ago       248MB
<none>                          <none>              6da68286e681        3 minutes ago       21.9MB
<none>                          <none>              45ce6affa404        45 minutes ago      248MB
```

Leftover images (those named `<none>`) from the multistage build process can be deleted with `docker image prune`

## Pull from Docker Hub

```bash
$ docker pull jones2748/docker-testcl:latest
```

## Run container

When running TesTcl against an iRule, a host directory containing irule and test has to be mounted into `/app` at the container.

```bash
$ docker run -it --rm -v /hostdir/myirule:/app docker-testcl jtcl /app/test_myirule.tcl
```

Note: The container directory **HAS** to be `/app`, because it's the location where the dockerfile `WORKDIR`is set, and 'jtcl' doesn't handle being called from another path very well.
e.g. `jtcl /app/tests/test_my_irule` doesn't work correctly unless you `cd /app/tests` first

Builtin test for the jtcl irule extension:

```bash
$ docker run -it --rm docker-testcl test
The jtcl-irule extension has successfully been installed
```

### Builtin test for an iRule:

```bash
$ docker run -it --rm docker-testcl test_irule

**************************************************************************
* it should handle request using pool bar
**************************************************************************
-> Test ok

**************************************************************************
* it should handle request using pool foo
**************************************************************************
-> Test ok

**************************************************************************
* it should replace existing Vary http response headers with Accept-Encoding value
**************************************************************************
verification of 'there should be only one Vary header' done.
verification of 'there should be Accept-Encoding value in Vary header' done.
-> Test ok
```

### Shell access to the container (user):

```bash
$ docker run -it --rm docker-testcl
/app $ whoami
testcl
```

### Shell access to the container (root):

```bash
$ docker run -it --rm docker-testcl makemeroot
/app # whoami
root
```

## Makefile

```
$ make
build                          build container
build-no-cache                 build container without cache
clean                          remove images
help                           this help
inspect                        inspect container properties
logs                           show docker logs for container (ONLY possible while container is running)
run                            run container
test                           test container with builtin tests
```

## TODO

- Fix path issues when calling files with `jtcl` without changing directory first