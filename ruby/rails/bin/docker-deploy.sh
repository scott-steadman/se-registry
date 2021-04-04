#!/bin/sh

# turn on debugging
#set -x

DOCKER_IMAGE=se-registry
DOCKER_NAME=prod-registry
DOCKER_ARGS="--restart=unless-stopped"

docker stop ${DOCKER_NAME}
docker rm   ${DOCKER_NAME}

docker run ${DOCKER_ARGS} -itd --name ${DOCKER_NAME} ${DOCKER_IMAGE}

docker logs -f ${DOCKER_NAME} 
