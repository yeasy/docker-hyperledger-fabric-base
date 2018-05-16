# https://github.com/yeasy/docker-hyperledger-fabric-base
#
# Dockerfile for Hyperledger fabric base image.
# If you only need quickly deploy a fabric network, please see
# * yeasy/hyperledger-fabric-peer
# * yeasy/hyperledger-fabric-orderer
# * yeasy/hyperledger-fabric-ca
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric
# Data is stored under /var/hyperledger/db and /var/hyperledger/production


FROM golang:1.10
LABEL maintainer "Baohua Yang <yangbaohua@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Only useful for this Dockerfile
ENV FABRIC_ROOT=$GOPATH/src/github.com/hyperledger/fabric
ENV CHAINTOOL_VERSION=1.1.1

# Architecture of the node
ENV ARCH=amd64
# version for the base images (baseos, baseimage, ccenv, etc.), used in core.yaml as BaseVersion
ENV BASEIMAGE_RELEASE=0.4.8
# BASE_VERSION is required in makefile as the base release number
ENV BASE_VERSION=1.2.0
# version for the peer/orderer binaries, the community version tracks the hash value like 1.0.0-snapshot-51b7e85
# PROJECT_VERSION is required in core.yaml to build image for cc container
ENV PROJECT_VERSION=1.2.0
# generic golang cc builder environment (core.yaml): builder: $(DOCKER_NS)/fabric-ccenv:$(ARCH)-$(PROJECT_VERSION)
ENV DOCKER_NS=hyperledger
# for golang or car's baseos for cc runtime: $(BASE_DOCKER_NS)/fabric-baseos:$(ARCH)-$(BASEIMAGE_RELEASE)
ENV BASE_DOCKER_NS=hyperledger
ENV LD_FLAGS="-X github.com/hyperledger/fabric/common/metadata.Version=${PROJECT_VERSION} \
             -X github.com/hyperledger/fabric/common/metadata.BaseVersion=${BASEIMAGE_RELEASE} \
             -X github.com/hyperledger/fabric/common/metadata.BaseDockerLabel=org.hyperledger.fabric \
             -X github.com/hyperledger/fabric/common/metadata.DockerNamespace=hyperledger \
             -X github.com/hyperledger/fabric/common/metadata.BaseDockerNamespace=hyperledger \
             -X github.com/hyperledger/fabric/common/metadata.Experimental=true \
             -linkmode external -extldflags '-static -lpthread'"

# Peer config path
ENV FABRIC_CFG_PATH=/etc/hyperledger/fabric
RUN mkdir -p /var/hyperledger/db \
        /var/hyperledger/production \
	$GOPATH/src/github.com/hyperledger \
	$FABRIC_CFG_PATH \
        /chaincode/input \
        /chaincode/output

# Install development dependencies
RUN apt-get update \
        && apt-get install -y apt-utils python-dev \
        && apt-get install -y libsnappy-dev zlib1g-dev libbz2-dev libyaml-dev libltdl-dev libtool \
        && apt-get install -y python-pip \
        && apt-get install -y tree jq unzip\
        && rm -rf /var/cache/apt

# install chaintool
#RUN curl -L https://github.com/hyperledger/fabric-chaintool/releases/download/v0.10.3/chaintool > /usr/local/bin/chaintool \
RUN curl -fL https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/chaintool-${CHAINTOOL_VERSION}/hyperledger-fabric-chaintool-${CHAINTOOL_VERSION}.jar > /usr/local/bin/chaintool \
        && chmod a+x /usr/local/bin/chaintool

# install gotools
RUN go get github.com/golang/protobuf/protoc-gen-go \
        && go get github.com/kardianos/govendor \
        && go get github.com/golang/lint/golint \
        && go get golang.org/x/tools/cmd/goimports \
        && go get github.com/onsi/ginkgo/ginkgo \
        && go get github.com/axw/gocov/... \
        && go get github.com/client9/misspell/cmd/misspell \
        && go get github.com/AlekSi/gocov-xml

# Clone the Hyperledger Fabric code and cp sample config files
RUN cd $GOPATH/src/github.com/hyperledger \
        && git clone --single-branch -b master --depth 1 http://gerrit.hyperledger.org/r/fabric \
        && cp $FABRIC_ROOT/devenv/limits.conf /etc/security/limits.conf \
        && cp -r $FABRIC_ROOT/sampleconfig/* $FABRIC_CFG_PATH/ \
        && cp $FABRIC_ROOT/examples/e2e_cli/configtx.yaml $FABRIC_CFG_PATH/ \
        && cp $FABRIC_ROOT/examples/e2e_cli/crypto-config.yaml $FABRIC_CFG_PATH/

# install configtxgen, cryptogen and configtxlator
RUN cd $FABRIC_ROOT/ \
        && go install -tags "experimental" -ldflags "${LD_FLAGS}" github.com/hyperledger/fabric/common/tools/configtxgen \
        && go install -tags "experimental" -ldflags "${LD_FLAGS}" github.com/hyperledger/fabric/common/tools/cryptogen \
        && go install -tags "experimental" -ldflags "${LD_FLAGS}" github.com/hyperledger/fabric/common/tools/configtxlator


# Install block-listener
RUN cd $FABRIC_ROOT/examples/events/block-listener \
        && go install \
        && go clean



# The data and config dir, can map external one with -v
VOLUME /var/hyperledger
#VOLUME /etc/hyperledger/fabric


# temporarily fix the `go list` complain problem, which is required in chaincode packaging, see core/chaincode/platforms/golang/platform.go#GetDepoymentPayload
ENV GOROOT=/usr/local/go

WORKDIR $FABRIC_ROOT

# This is only a workaround for current hard-coded problem when using as fabric-baseimage.
RUN ln -s $GOPATH /opt/gopath
LABEL org.hyperledger.fabric.version=${PROJECT_VERSION} \
      org.hyperledger.fabric.base.version=${BASEIMAGE_RELEASE}
