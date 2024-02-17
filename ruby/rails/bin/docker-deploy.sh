#!/bin/sh

# turn on debugging
#set -x

PROJECT=registry
DOCKER_NAME=prod-${PROJECT}
RAILS_ENV=${1:-production}

docker stop ${DOCKER_NAME}
docker rm   ${DOCKER_NAME}

docker run \
  --restart unless-stopped \
  --name ${DOCKER_NAME} \
  --env HOSTNAME=${HOSTNAME} \
  --env RAILS_ENV=${RAILS_ENV} \
  --env RAILS_MASTER_KEY=$(cat config/credentials/${RAILS_ENV}.key) \
  -itd ${PROJECT}:latest

docker image prune --all

docker logs -f ${DOCKER_NAME}


