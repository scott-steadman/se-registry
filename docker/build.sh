#!/bin/sh

# turn on debugging
set -x

#docker pull centos/ruby-22-centos7

docker rmi gifts

docker build -t gifts -f Dockerfile .   | tee log/build.log 2>&1
