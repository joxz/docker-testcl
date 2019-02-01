# docker-testcl

Docker container for testing iRules with [TesTcl](https://testcl.com/)

The docker image uses [adoptopenjdk/openjdk11:alpine-slim](https://hub.docker.com/r/adoptopenjdk/openjdk11)

## Usage

### Build image

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

### Run container

When running TesTcl against an iRule, a host directory containing irule and test has to be mounted into `/mnt` at the container.

```bash
$ docker run -it --rm -v /hostdir/myirule:/mnt docker-testcl jtcl /mnt/test_myirule.tcl
```

Note: The container directory **HAS** to be `/mnt`, because it's the location where the dockerfile `WORKDIR`is set, and 'jtcl' doesn't handle being called from another path very well.
e.g. `jtcl /opt/tests/test_my_irule` doesn't work correctly unless you `cd /opt/tests` first

Builtin test for the jtcl irule extension:

```bash
$ docker run -it --rm docker-testcl test
Picked up JAVA_TOOL_OPTIONS: -XX:+UseContainerSupport
The jtcl-irule extension has successfully been installed
```

Builtin test for an iRule:

```bash
$ docker run -it --rm docker-testcl test_irule
Picked up JAVA_TOOL_OPTIONS: -XX:+UseContainerSupport

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

## TODO

- Fix path issues when calling files with `jtcl` without changing directory first