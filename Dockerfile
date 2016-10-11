##
# tjun/gdal-go
#
# This creates an debian derived base image that installs the latest GDAL
# subversion checkout compiled with a broad range of drivers.  The build process
# is based on that defined in
# <https://github.com/OSGeo/gdal/blob/trunk/.travis.yml>
#

FROM debian:jessie

MAINTAINER Junichiro Takagi <t.junichiro@gmail.com>

ENV GO_VERSION 1.7.1
ENV GO_WRAPPER_COMMIT 53424cae6af3b17e93057698496c95d026bd65b2

# Install the application.
ADD . /usr/local/src/gdal-docker/
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    make \
    git \
    ca-certificates \
    wget \
    curl \
    && make -C /usr/local/src/gdal-docker install clean \
    && apt-get purge -y apt-utils make git \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sSL https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz -o /tmp/go.tar.gz \
    && curl -sSL https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz.sha256 -o /tmp/go.tar.gz.sha256 \
    && echo "$(cat /tmp/go.tar.gz.sha256)  /tmp/go.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -vxzf /tmp/go.tar.gz \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go:/go/src/app/_gopath

RUN mkdir -p /go/src/app /go/bin && chmod -R 777 /go

RUN curl https://raw.githubusercontent.com/docker-library/golang/${GO_WRAPPER_COMMIT}/1.7/go-wrapper \
    -o /usr/local/bin/go-wrapper \
    && chmod 755 /usr/local/bin/go-wrapper

RUN ln -s /go/src/app /app

# Externally accessible data is by default put in /app
WORKDIR /app
VOLUME ["/app"]


# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats && go version
