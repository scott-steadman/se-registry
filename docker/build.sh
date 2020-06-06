#!/bin/sh

# turn on debugging
set -x

docker rmi ss:ruby-2.5

docker build -t ss:ruby-2.5 --pull --no-cache -f Dockerfile .   | tee log/build.log 2>&1
