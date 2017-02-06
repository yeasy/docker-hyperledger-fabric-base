# Dockerfile for Hyperledger fabric base image.
# If you need a peer node to run, please see the yeasy/hyperledger-peer image.
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

# Currently, the binary will look for config files at corresponding path.

FROM golang:1.7
MAINTAINER Baohua Yang <yangbaohua@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
        && apt-get install -y libsnappy-dev zlib1g-dev libbz2-dev libltdl-dev \
        && rm -rf /var/cache/apt

# install some dev tools, optionally
RUN curl -L https://github.com/hyperledger/fabric-chaintool/releases/download/v0.10.1/chaintool > /usr/local/bin \
        && chmod a+x /usr/local/bin/chaintool

# install rocksdb
#RUN cd /tmp \
#        && git clone --single-branch -b v4.1 --depth 1 https://github.com/facebook/rocksdb.git \
#        && cd rocksdb \
#        && PORTABLE=1 make shared_lib \
#        && INSTALL_PATH=/usr/local make install-shared \
#        && ldconfig \
#        && rm -rf /tmp/rocksdb

RUN mkdir -p /var/hyperledger/db /var/hyperledger/production

# clone fabric master code to local
RUN mkdir -p $GOPATH/src/github.com/hyperledger \
        && cd $GOPATH/src/github.com/hyperledger \
        && git clone --single-branch -b master --depth 1 http://gerrit.hyperledger.org/r/fabric \
        && cp $GOPATH/src/github.com/hyperledger/fabric/devenv/limits.conf /etc/security/limits.conf

WORKDIR $GOPATH/src/github.com/hyperledger/fabric

# this is only a workaround for current hard-coded problem when using as fabric-baseimage.
RUN ln -s $GOPATH /opt/gopath
