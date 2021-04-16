#!/bin/sh

# turn on debugging
#set -x

PROJECT=registry
RAILS_ENV=${1:-development}

docker run \
  --net host \
  --env RAILS_ENV=${RAILS_ENV} \
  --env HOSTNAME=${HOSTNAME} \
   -it ${PROJECT}:latest
