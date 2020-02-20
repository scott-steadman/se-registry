FROM centos/ruby-22-centos7

LABEL maintainer="Scott Steadman <docker-gifts@stdmn.com>"

EXPOSE 8000

#HEALTHCHECK CMD wget -q -O /dev/null  http://localhost:8000/ || exit 1

RUN mkdir -p /app/gifts/current

WORKDIR /app/gifts/current

#CMD [ "bin/server", "--pid", "/tmp/gifts.pid", "--binding", "0.0.0.0", "--port", "8000" ]
CMD [ "/bin/bash" ]
