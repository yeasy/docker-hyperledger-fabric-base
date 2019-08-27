Hyperledger Fabric Base
===
Docker images for [Hyperledger](https://www.hyperledger.org) Fabric base image.

# Supported tags and respective Dockerfile links

* [`latest` (latest/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/Dockerfile): Default to track latest master branch.
* [`release-v1.4` (release-v1.4/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/release-v1.4/Dockerfile): v1.4 LTS release.
* [`1.4.3` (v1.4.3/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.4.3/Dockerfile): 1.4.3 release.
* [`1.4.2` (v1.4.2/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.4.2/Dockerfile): 1.4.2 release.
* [`1.4.0` (v1.4.0/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.4.0/Dockerfile): 1.4.0 release.
* [`1.3.0` (v1.3.0/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.3.0/Dockerfile): 1.3.0 release.
* [`1.2.0` (v1.2.0/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.2.0/Dockerfile): 1.2.0 release.
* [`1.1.0` (v1.1.0/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.1.0/Dockerfile): 1.1.0 release.
* [`1.1.0-rc1` (v1.1.0-rc1/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.1.0-rc1/Dockerfile): 1.1.0-rc1 release.
* [`1.0.6` (v1.0.6/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.6/Dockerfile): 1.0.6 release.
* [`1.0.5` (v1.0.5/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.5/Dockerfile): 1.0.5 release.
* [`1.1.0-alpha` (v1.1.0-alpha/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.1.0-alpha/Dockerfile): 1.1.0-alpha release.
* [`1.1.0-preview` (v1.1.0-preview/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.1.0-preview/Dockerfile): 1.1.0-preview release.
* [`1.0.4` (v1.0.4/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.4/Dockerfile): 1.0.4 release.
* [`1.0.3` (v1.0.3/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.3/Dockerfile): 1.0.3 release.
* [`1.0.2` (v1.0.2/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.2/Dockerfile): 1.0.2 release.
* [`1.0.1` (v1.0.1/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.1/Dockerfile): 1.0.1 release.
* [`1.0.0` (v1.0.0/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.0/Dockerfile): 1.0.0 release.
* [`1.0.0-rc1` (v1.0.0-rc1/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.0-rc1/Dockerfile): 1.0.0-rc1 release.
* [`1.0.0-beta` (v1.0.0-beta/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.0-beta/Dockerfile): 1.0.0-beta release.
* [`1.0.0-alpha2` (v1.0.0-alpha2/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.0-alpha2/Dockerfile): 1.0.0-alpha2 release.
* [`1.0.0-alpha` (v1.0.0-alpha/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/v1.0.0-alpha/Dockerfile): 1.0.0-alpha release.
* [`0.6-dp` (0.6-dp/Dockerfile)](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/0.6-dp/Dockerfile): Use 0.6-developer-preview branch code.

For more information about this image and its history, please see the relevant manifest file in the [`yeasy/docker-hyperledger-fabric-base` GitHub repo](https://github.com/yeasy/docker-hyperledger-fabric-base).

If you want to quickly deploy a local cluster without any configuration and vagrant, please refer to [Start hyperledger cluster using compose](https://github.com/yeasy/docker-compose-files#hyperledger_fabric).

# What is hyperledger-fabric-base?
Docker image with hyperledger fabric base, which will be utilized as the base to build peer and orderer, and the chaincode running environment.

# How to use this image?
The docker image is auto built at [https://registry.hub.docker.com/u/yeasy/hyperledger-fabric-base/](https://registry.hub.docker.com/u/yeasy/hyperledger-fabric-base/).

## In Dockerfile
```sh
FROM yeasy/hyperledger-fabric-base:latest
```

# Which image is based on?
The image is built based on [golang](https://hub.docker.com/_/golang) 1.8 image.

# What has been changed?
## install dependencies
Install required  libsnappy-dev, zlib1g-dev, libbz2-dev.

## clone fabric code
Clone the fabric code from repo.

## install tools
Install required tools like chaintools, go tools, cryptogen, configtxgen, configtxlator.

# Supported Docker versions

This image is officially supported on Docker version 1.7.0+.

Support for older versions (down to 1.0) is provided on a best-effort basis.

# Known Issues
* N/A.

# User Feedback
## Documentation
Be sure to familiarize yourself with the [repository's `README.md`](https://github.com/yeasy/docker-hyperledger-fabric-base/blob/master/README.md) file before attempting a pull request.

## Issues
If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/yeasy/docker-hyperledger-fabric-base/issues).

You can also reach many of the official image maintainers via the email.

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/yeasy/docker-hyperledger-fabric-base/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
