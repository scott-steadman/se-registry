#!/bin/sh

# enable debugging
set -x

docker run -it -d \
	--restart=unless-stopped \
  --env-file .env \
	-u "nobody:nobody" \
	-p 8000:8000 \
	-v "/srv/gifts.stdmn.com:/app/gifts" \
	--name gifts \
	gifts \
  bundle exec rails server -b 0.0.0.0 -p 8000
