#!/bin/sh

# turn on debugging
#set -x

PROJECT=registry
DOCKER_NAME=prod-${PROJECT}

docker stop ${DOCKER_NAME}
docker rm   ${DOCKER_NAME}

docker run \
  --restart unless-stopped \
  --name ${DOCKER_NAME} \
  -itd ${PROJECT}:latest

docker logs -f ${DOCKER_NAME} 
