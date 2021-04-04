#!/bin/sh

# turn on debugging
#set -x

RAILS_ENV=${1:-development}

DOCKER_IMAGE=se-registry
DOCKER_ARGS="--net=host"

docker run -e RAILS_ENV=${RAILS_ENV} -e HOSTNAME=${HOSTNAME} ${DOCKER_ARGS} -it ${DOCKER_IMAGE}
