#!/bin/sh

# enable debugging
set -x

cp -n registry.logrotate /etc/logrotate.d/registry

docker run -itd \
	--restart=unless-stopped \
  --health-cmd='wget -q -O /dev/null  http://localhost:8000/ || exit 1' \
  --env-file .env \
  --workdir /app/gifts/current \
  -u "99:1000" \
	-v "/srv/gifts.stdmn.com:/app/gifts" \
  --name gifts-ruby-2.5 \
  ss:ruby-2.5 \
  bin/rails server --pid=/tmp/gifts.pid --binding=0.0.0.0 --port=8000
#  irb
#  /bin/bash

docker logs -f gifts-ruby-2.5
