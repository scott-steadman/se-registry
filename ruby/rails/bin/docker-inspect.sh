#!/bin/sh

# turn on debugging
#set -x

RAILS_ENV=${1:-development}
DOCKER_IMAGE=se-registry

if [ $RAILS_ENV == development ]
then
  DOCKER_ARGS="--net=host"
fi

docker run -e RAILS_ENV=${RAILS_ENV} ${DOCKER_ARGS} -it --entrypoint /bin/bash ${DOCKER_IMAGE}
