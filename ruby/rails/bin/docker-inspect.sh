#!/bin/sh

# turn on debugging
#set -x

PROJECT=registry
RAILS_ENV=${1:-development}

docker -H ssh://scott.steadman@stdmn-001 run \
  --network host \
  --env RAILS_ENV=${RAILS_ENV} \
  --env RAILS_MASTER_KEY=$(cat config/credentials/${RAILS_ENV}.key) \
  --publish 3000:3000 \
  --entrypoint /bin/bash \
  -it ${PROJECT}:latest
