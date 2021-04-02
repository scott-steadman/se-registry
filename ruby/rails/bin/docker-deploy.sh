#!/bin/sh

# turn on debugging
set -x

DOCKER_TAG=se-registry
DOCKER_NAME=rails
#DOCKER_ARGS="--net=host --restart=unless-stopped"
DOCKER_ARGS="--restart=unless-stopped"

docker run ${DOCKER_ARGS} -itd --name ${DOCKER_NAME} ${DOCKER_TAG}

docker logs -f ${DOCKER_NAME} 
