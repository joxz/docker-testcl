FROM alpine:latest as build

ENV JTCL_VERSION 2.8.0
ENV TESTCL_VERSION 1.0.13

RUN apk add --no-cache --update unzip

ADD https://github.com/jtcl-project/jtcl/releases/download/${JTCL_VERSION}-release/jtcl-${JTCL_VERSION}-bin.zip /tmp
RUN unzip /tmp/jtcl-${JTCL_VERSION}-bin.zip -d /opt/

ADD https://dl.bintray.com/landro/maven/com/testcl/jtcl-irule/0.9/jtcl-irule-0.9.jar /opt/jtcl-${JTCL_VERSION}
RUN sed -i -e 's/export CLASSPATH/export CLASSPATH=\$dir\/jtcl-irule-0.9.jar:\$CLASSPATH/g' /opt/jtcl-${JTCL_VERSION}/jtcl
RUN mv /opt/jtcl-${JTCL_VERSION}/ /opt/jtcl

ADD https://github.com/landro/TesTcl/archive/v${TESTCL_VERSION}.zip /tmp
RUN unzip /tmp/v${TESTCL_VERSION}.zip -d /opt/
RUN mv /opt/TesTcl-${TESTCL_VERSION} /opt/TesTcl

COPY ./entrypoint.sh /opt
RUN ["chmod", "+x", "/opt/entrypoint.sh"]

COPY ./test/ /opt/test


FROM adoptopenjdk/openjdk11-openj9:alpine-slim

LABEL maintainer="https://hub.docker.com/u/jones2748"

ENV TCLLIBPATH=/opt/TesTcl
ENV PATH /opt/jtcl:/opt/test:/mnt:$PATH

COPY --from=build /opt/ /opt/

RUN set -euxo pipefail ;\
    apk add --no-cache --update dumb-init ;\
    mv /opt/entrypoint.sh /usr/local/bin ;\
    mkdir /app

WORKDIR /app

ENTRYPOINT ["/usr/bin/dumb-init","--","entrypoint.sh"]

CMD ["/bin/sh"]