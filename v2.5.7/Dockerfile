# https://github.com/yeasy/docker-hyperledger-fabric-base
#
# Dockerfile for Hyperledger fabric base image.

# If you only need quickly deploy a fabric network, please see
# * yeasy/hyperledger-fabric-peer
# * yeasy/hyperledger-fabric-orderer
# * yeasy/hyperledger-fabric-ca

# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric
# Data is stored under /var/hyperledger/production

FROM golang:1.21
LABEL maintainer "Baohua Yang <yeasy.github.com>"

ENV DEBIAN_FRONTEND noninteractive

# Only useful for this Dockerfile
ENV FABRIC_ROOT=$GOPATH/src/github.com/hyperledger/fabric

# BASE_VERSION is used in metadata.Version as major version
ENV BASE_VERSION=2.5.7

# PROJECT_VERSION is required in core.yaml for fabric-baseos and fabric-ccenv
ENV PROJECT_VERSION=2.5.7

# generic environment (core.yaml) for builder and runtime: e.g., builder: $(DOCKER_NS)/fabric-ccenv:$(TWO_DIGIT_VERSION), golang, java, node
ENV DOCKER_NS=hyperledger
ENV TWO_DIGIT_VERSION=2.5

ENV BASE_DOCKER_NS=hyperledger
ENV LD_FLAGS="-X github.com/hyperledger/fabric/common/metadata.Version=${PROJECT_VERSION} \
              -X github.com/hyperledger/fabric/common/metadata.BaseDockerLabel=org.hyperledger.fabric \
              -X github.com/hyperledger/fabric/common/metadata.DockerNamespace=hyperledger \
              -X github.com/hyperledger/fabric/common/metadata.BaseDockerNamespace=hyperledger"

# -X github.com/hyperledger/fabric/common/metadata.Experimental=true \
# -linkmode external -extldflags '-static -lpthread'"

# peer envs. DONOT combine in one line as the former variable won't work on-the-fly
ENV FABRIC_CFG_PATH=/etc/hyperledger/fabric
RUN mkdir -p /var/hyperledger/production \
        $GOPATH/src/github.com/hyperledger \
        $FABRIC_CFG_PATH \
        /chaincode/input \
        /chaincode/output

# Install development dependencies
RUN apt-get update \
        && apt-get install -y apt-utils python3-dev \
        && apt-get install -y libsnappy-dev zlib1g-dev libbz2-dev libyaml-dev libltdl-dev libtool \
        && apt-get install -y python3-pip \
        && apt-get install -y vim tree jq unzip \
        && pip3 install behave nose docker-compose \
        && pip3 install pyinotify \
        && rm -rf /var/cache/apt

# Install gotools
RUN go install github.com/golang/protobuf/protoc-gen-go@latest \
        && go install github.com/maxbrunsfeld/counterfeiter/v6@latest \
        && go install github.com/axw/gocov/gocov@latest \
        && go install github.com/axw/gocov/gocov@latest \
        && go install golang.org/x/tools/cmd/goimports@latest \
        && go install github.com/onsi/ginkgo/ginkgo@latest

# Clone the Hyperledger Fabric code and cp sample config files
RUN cd $GOPATH/src/github.com/hyperledger \
        && wget https://github.com/hyperledger/fabric/archive/v${PROJECT_VERSION}.zip \
        && unzip v${PROJECT_VERSION}.zip \
        && rm v${PROJECT_VERSION}.zip \
        && mv fabric-${PROJECT_VERSION} fabric \
        && echo "*                hard    nofile          65536" >> /etc/security/limits.conf \
        && echo "*                soft    nofile          8192" >> /etc/security/limits.conf \
        && cp -r $FABRIC_ROOT/sampleconfig/* $FABRIC_CFG_PATH/

# Add external fabric chaincode dependencies
#RUN go get github.com/hyperledger/fabric-chaincode-go/shim \
#        && go get github.com/hyperledger/fabric-protos-go/peer

# Install configtxgen, cryptogen, configtxlator, discover, ledgerutil and osnadmin
RUN cd $FABRIC_ROOT \
        && CGO_CFLAGS=" " go install -tags "" -ldflags "${LD_FLAGS}" github.com/hyperledger/fabric/cmd/configtxgen \
        && CGO_CFLAGS=" " go install -tags "" -ldflags "${LD_FLAGS}" github.com/hyperledger/fabric/cmd/configtxlator \
        && CGO_CFLAGS=" " go install -tags "" -ldflags "${LD_FLAGS}" github.com/hyperledger/fabric/cmd/cryptogen \
        && CGO_CFLAGS=" " go install -tags "" -ldflags "${LD_FLAGS}" github.com/hyperledger/fabric/cmd/discover \
        && CGO_CFLAGS=" " go install -tags "" -ldflags "${LD_FLAGS}" github.com/hyperledger/fabric/cmd/ledgerutil \
        && CGO_CFLAGS=" " go install -tags "" -ldflags "${LD_FLAGS}" github.com/hyperledger/fabric/cmd/osnadmin \
	&& go clean

# Install ccaas_builder sample, since hlf v2.4.1
RUN cd $FABRIC_ROOT/ccaas_builder \
        && go build -o /opt/hyperledger/ccaas_builder/bin/ ./cmd/build \
        && go build -o /opt/hyperledger/ccaas_builder/bin/ ./cmd/detect \
        && go build -o /opt/hyperledger/ccaas_builder/bin/ ./cmd/release \
	&& go clean

# This is useful to debug local code with mapping inside
VOLUME $GOPATH/src/github.com/hyperledger
# The data and config dir, can map external one with -v
VOLUME /var/hyperledger
VOLUME $FABRIC_CFG_PATH

# Temporarily fix the `go list` complain problem, which is required in chaincode packaging, see core/chaincode/platforms/golang/platform.go#GetDepoymentPayload
ENV GOROOT=/usr/local/go

WORKDIR $FABRIC_ROOT

# This is only a workaround for current hard-coded problem when using as fabric-baseimage.
RUN ln -s $GOPATH /opt/gopath

LABEL org.hyperledger.fabric.version=${PROJECT_VERSION}
