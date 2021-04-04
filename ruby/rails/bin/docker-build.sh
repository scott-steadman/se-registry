#!/bin/sh

# turn on debugging
#set -x

DOCKER_IMAGE=se-registry

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

git tag docker-build-${TIMESTAMP}

docker build --pull -t ${DOCKER_IMAGE} .   | tee log/build.log 2>&1
