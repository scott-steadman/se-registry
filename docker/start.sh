#!/bin/sh

# enable debugging
set -x

docker run -it -d \
	--restart=unless-stopped \
  --health-cmd='wget -q -O /dev/null  http://localhost:8000/ || exit 1' \
  --env-file .env \
	-u "nobody:nobody" \
	-v "/srv/gifts.stdmn.com:/app/gifts" \
	--name gifts \
	gifts \
  bundle exec rails server --pid=/tmp/gifts.pid --binding=0.0.0.0 --port=8000
