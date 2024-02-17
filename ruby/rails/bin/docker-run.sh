#!/bin/sh

# turn on debugging
#set -x

PROJECT=registry
RAILS_ENV=${1:-development}

docker run \
  --env HOSTNAME=${HOSTNAME} \
  --env RAILS_ENV=${RAILS_ENV} \
  --env RAILS_MASTER_KEY=$(cat config/credentials/${RAILS_ENV}.key) \
  --publish 3000:3000 \
  -it ${PROJECT}:latest ./bin/rails server -b 0.0.0.0
