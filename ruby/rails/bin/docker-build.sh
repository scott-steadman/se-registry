#!/bin/sh

# turn on debugging
#set -x

DOCKER_TAG=se-registry

echo git tag

docker build --pull -t ${DOCKER_TAG} .   | tee log/build.log 2>&1
