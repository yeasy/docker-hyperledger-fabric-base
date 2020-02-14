# https://github.com/yeasy/docker-hyperledger-fabric-base
#
# Dockerfile for Hyperledger fabric base image.
# If you only need quickly deploy a fabric network, please see
# * yeasy/hyperledger-fabric-peer
# * yeasy/hyperledger-fabric-orderer
# * yeasy/hyperledger-fabric-ca
#
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric
# Data is stored under /var/hyperledger/production

FROM golang:1.12
LABEL maintainer "Baohua Yang <yeasy.github.com>"

ENV DEBIAN_FRONTEND noninteractive

# Only useful for this Dockerfile
ENV FABRIC_ROOT=$GOPATH/src/github.com/hyperledger/fabric
ENV CHAINTOOL_RELEASE=1.1.3

# Architecture of the node
ENV ARCH=amd64
# version for the base images (baseos, baseimage, ccenv, etc.), used in core.yaml as BaseVersion
ENV BASEIMAGE_RELEASE=0.4.18
# BASE_VERSION is required in core.yaml for the Go and Node cc runtime 
ENV BASE_VERSION=1.4.4
# PROJECT_VERSION is required in core.yaml to build image for cc container
ENV PROJECT_VERSION=1.4.4
# generic Go cc builder environment (core.yaml): builder: $(DOCKER_NS)/fabric-ccenv:latest
ENV DOCKER_NS=hyperledger
# for Go cc runtime: $(BASE_DOCKER_NS)/fabric-baseos:$(ARCH)-$(BASEIMAGE_RELEASE)
ENV BASE_DOCKER_NS=hyperledger
ENV LD_FLAGS="-X github.com/hyperledger/fabric/common/metadata.Version=${BASE_VERSION} \
             -X github.com/hyperledger/fabric/common/metadata.BaseVersion=${BASEIMAGE_RELEASE} \
             -X github.com/hyperledger/fabric/common/metadata.BaseDockerLabel=org.hyperledger.fabric \
             -X github.com/hyperledger/fabric/common/metadata.DockerNamespace=hyperledger \
             -X github.com/hyperledger/fabric/common/metadata.BaseDockerNamespace=hyperledger"

# -X github.com/hyperledger/fabric/common/metadata.Experimental=true \
# -linkmode external -extldflags '-static -lpthread'"

# Peer config path
ENV FABRIC_CFG_PATH=/etc/hyperledger/fabric
RUN mkdir -p /var/hyperledger/production \
        $GOPATH/src/github.com/hyperledger \
        $FABRIC_CFG_PATH \
        /chaincode/input \
        /chaincode/output

# Install development dependencies
RUN apt-get update \
        && apt-get install -y apt-utils python-dev \
        && apt-get install -y libsnappy-dev zlib1g-dev libbz2-dev libyaml-dev libltdl-dev libtool \
        && apt-get install -y python-pip \
        && apt-get install -y vim tree jq unzip \
        && rm -rf /var/cache/apt

# Install gotools
RUN go get github.com/golang/protobuf/protoc-gen-go \
        && go get github.com/maxbrunsfeld/counterfeiter \
        && go get github.com/axw/gocov/... \
        && go get github.com/AlekSi/gocov-xml \
        && go get golang.org/x/tools/cmd/goimports \
        && go get golang.org/x/lint/golint \
        && go get github.com/estesp/manifest-tool \
        && go get github.com/client9/misspell/cmd/misspell \
        && go get github.com/estesp/manifest-tool \
        && go get github.com/onsi/ginkgo/ginkgo

# Clone the Hyperledger Fabric code and cp sample config files
RUN cd $GOPATH/src/github.com/hyperledger \
        && wget https://github.com/hyperledger/fabric/archive/v${PROJECT_VERSION}.zip \
        && unzip v${PROJECT_VERSION}.zip \
        && rm v${PROJECT_VERSION}.zip \
        && mv fabric-${PROJECT_VERSION} fabric \
        && cp $FABRIC_ROOT/devenv/limits.conf /etc/security/limits.conf \
        && cp -r $FABRIC_ROOT/sampleconfig/* $FABRIC_CFG_PATH/ \
        && cp $FABRIC_ROOT/examples/cluster/config/configtx.yaml $FABRIC_CFG_PATH/ \
        && cp $FABRIC_ROOT/examples/cluster/config/cryptogen.yaml $FABRIC_CFG_PATH/

# Install configtxgen, cryptogen, configtxlator and discover
RUN cd $FABRIC_ROOT/ \
        && CGO_CFLAGS=" " go install -tags "" -ldflags "" github.com/hyperledger/fabric/common/tools/configtxgen \
        && CGO_CFLAGS=" " go install -tags "" -ldflags "" github.com/hyperledger/fabric/common/tools/cryptogen \
        && CGO_CFLAGS=" " go install -tags "" -ldflags "" github.com/hyperledger/fabric/common/tools/configtxlator \
	&& CGO_CFLAGS=" " go install -tags "" -ldflags "-X github.com/hyperledger/fabric/cmd/discover/metadata.Version=${BASE_VERSION}" github.com/hyperledger/fabric/cmd/discover

# Install chaintool
RUN curl -fL https://hyperledger.jfrog.io/hyperledger/fabric-maven/org/hyperledger/fabric-chaintool/${CHAINTOOL_RELEASE}/fabric-chaintool-${CHAINTOOL_RELEASE}.jar > /usr/local/bin/chaintool \
        && chmod a+x /usr/local/bin/chaintool

# Install eventsclient
RUN cd $FABRIC_ROOT/examples/events/eventsclient \
        && go install \
        && go clean

# The data and config dir, can map external one with -v
VOLUME /var/hyperledger

# Temporarily fix the `go list` complain problem, which is required in chaincode packaging, see core/chaincode/platforms/golang/platform.go#GetDepoymentPayload
ENV GOROOT=/usr/local/go

WORKDIR $FABRIC_ROOT

# This is only a workaround for current hard-coded problem when using as fabric-baseimage.
RUN ln -s $GOPATH /opt/gopath

LABEL org.hyperledger.fabric.version=${PROJECT_VERSION} \
      org.hyperledger.fabric.base.version=${BASEIMAGE_RELEASE}
