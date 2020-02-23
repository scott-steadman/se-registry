FROM ruby:2.5

LABEL maintainer="Scott Steadman <docker-gifts@stdmn.com>"

USER 99:1000

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

EXPOSE 8000

#HEALTHCHECK CMD wget -q -O /dev/null  http://localhost:8000/ || exit 1

RUN mkdir -p /app/gifts

WORKDIR /app/gifts

#CMD [ "bin/server", "--pid", "/tmp/gifts.pid", "--binding", "0.0.0.0", "--port", "8000" ]
CMD [ "/bin/bash" ]
