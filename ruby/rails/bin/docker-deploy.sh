#!/bin/sh

# turn on debugging
#set -x

PROJECT=registry
DOCKER_NAME=prod-${PROJECT}
RAILS_ENV=${1:-production}
DOCKER_OPTS="-H ssh://scott.steadman@stdmn-001"

docker ${DOCKER_OPTS} stop ${DOCKER_NAME}
docker ${DOCKER_OPTS} rm   ${DOCKER_NAME}

docker ${DOCKER_OPTS} run \
  --network host \
  --restart unless-stopped \
  --name ${DOCKER_NAME} \
  --env RAILS_ENV=${RAILS_ENV} \
  --env RAILS_MASTER_KEY=$(cat config/credentials/${RAILS_ENV}.key) \
  --publish 3000:3000 \
  -itd ${PROJECT}:latest ./bin/rails server -b 0.0.0.0

docker ${DOCKER_OPTS} image prune --all

docker ${DOCKER_OPTS} logs -f ${DOCKER_NAME}


