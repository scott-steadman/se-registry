#!/bin/sh

# turn on debugging
#set -x

PROJECT=registry
TIMESTAMP=$(date +"%Y%m%d-%H%M")

docker -H ssh://scott.steadman@stdmn-001 build \
  --pull \
  --tag ${PROJECT}:${TIMESTAMP} \
  --tag ${PROJECT}:latest \
  . 2>&1  | tee /tmp/${PROJECT}-${TIMESTAMP}-build.log

git tag docker-build-${TIMESTAMP}
