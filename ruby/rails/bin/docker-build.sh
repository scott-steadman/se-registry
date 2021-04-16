#!/bin/sh

# turn on debugging
#set -x

PROJECT=registry
GIT_BRANCH=$(git branch --show-current)
GIT_SHA=$(git rev-parse HEAD)

TIMESTAMP=$(date +"%Y%m%d-%H%M")

git tag docker-build-${TIMESTAMP}

docker build \
  --pull \
  --tag ${PROJECT}:${TIMESTAMP} \
  --tag ${PROJECT}:latest \
  --build-arg git_sha=${GIT_SHA} \
  --build-arg builder=${USER} \
  . 2>&1  | tee /tmp/${PROJECT}-${TIMESTAMP}-build.log 
