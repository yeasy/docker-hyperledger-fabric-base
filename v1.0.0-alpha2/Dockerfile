# Dockerfile for Hyperledger fabric base image.
# If you need a peer node to run, please see the yeasy/hyperledger-peer image.
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

# Currently, the binary will look for config files at corresponding path.

FROM golang:1.8
LABEL maintainer "Baohua Yang <yangbaohua@gmail.com>"

# Reused in all children images
ENV FABRIC_CFG_PATH /etc/hyperledger/fabric

ENV DEBIAN_FRONTEND noninteractive

# Only useful for this Dockerfile
ENV FABRIC_ROOT $GOPATH/src/github.com/hyperledger/fabric
ENV ARCH x86_64
# version for the base images, e.g., fabric-ccenv, fabric-baseos
ENV BASE_VERSION 0.3.0
# version for the peer/orderer binaries, the community version tracks the hash value like 1.0.0-snapshot-51b7e85
ENV PROJECT_VERSION 1.0.0-preview
# generic builder environment: builder: $(DOCKER_NS)/fabric-ccenv:$(ARCH)-$(PROJECT_VERSION)
ENV DOCKER_NS hyperledger
# for golang or car's baseos: $(BASE_DOCKER_NS)/fabric-baseos:$(ARCH)-$(BASE_VERSION)
ENV BASE_DOCKER_NS hyperledger
ENV LD_FLAGS="-X github.com/hyperledger/fabric/common/metadata.Version=${PROJECT_VERSION} \
             -X github.com/hyperledger/fabric/common/metadata.BaseVersion=${BASE_VERSION} \
             -X github.com/hyperledger/fabric/common/metadata.BaseDockerLabel=org.hyperledger.fabric \
             -X github.com/hyperledger/fabric/common/metadata.DockerNamespace=hyperledger \
             -X github.com/hyperledger/fabric/common/metadata.BaseDockerNamespace=hyperledger"
        

# The data and config dir, can map external one with -v
VOLUME /var/hyperledger
#VOLUME /etc/hyperledger/fabric

RUN mkdir -p /var/hyperledger/db \
        /var/hyperledger/production \
# only useful when use as a ccenv image
        /chaincode/input \
        /chaincode/output \
        $FABRIC_CFG_PATH

RUN apt-get update \
        && apt-get install -y libsnappy-dev zlib1g-dev libbz2-dev libltdl-dev \
        && rm -rf /var/cache/apt

# install chaintool
RUN curl -L https://github.com/hyperledger/fabric-chaintool/releases/download/v0.10.3/chaintool > /usr/local/bin/chaintool \
        && chmod a+x /usr/local/bin/chaintool

# install gotools
RUN go get github.com/golang/lint/golint \
        && go get github.com/kardianos/govendor \
        && go get golang.org/x/tools/cmd/goimports \
        && go get github.com/golang/protobuf/protoc-gen-go \
        && go get github.com/onsi/ginkgo/ginkgo \
        && go get github.com/axw/gocov/... \
        && go get github.com/AlekSi/gocov-xml

# clone hyperledger fabric code and add configuration files
RUN mkdir -p $GOPATH/src/github.com/hyperledger \
        && cd $GOPATH/src/github.com/hyperledger \
        && git clone --single-branch -b v1.0.0-alpha2 --depth 1 http://gerrit.hyperledger.org/r/fabric \
        && cp $FABRIC_ROOT/devenv/limits.conf /etc/security/limits.conf \
        && cp -r $FABRIC_ROOT/sampleconfig/* $FABRIC_CFG_PATH

# install configtxgen and cryptogen
RUN cd $FABRIC_ROOT/ \
        && CGO_CFLAGS=" " go install -tags "nopkcs11" -ldflags "$LD_FLAGS" github.com/hyperledger/fabric/common/configtx/tool/configtxgen \
        && CGO_CFLAGS=" " go install -tags "nopkcs11" -ldflags "$LD_FLAGS" github.com/hyperledger/fabric/common/tools/cryptogen

# this is only a workaround for current hard-coded problem when using as fabric-baseimage.
RUN ln -s $GOPATH /opt/gopath

WORKDIR $FABRIC_ROOT

LABEL org.hyperledger.fabric.version=${PROJECT_VERSION} \
      org.hyperledger.fabric.base.version=${BASE_VERSION}
