FROM ruby:2.5
LABEL maintainer="Scott Steadman <registry@stdmn.com>"

ARG builder
LABEL com.stdmn.builder=$builder

ARG git_sha
LABEL com.stdmn.git-sha=$git_sha

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN addgroup --gid $GROUP_ID app_group
RUN adduser  --disabled-password --gecos 'Application User' --uid $USER_ID --gid $GROUP_ID app_user

# Add Tini
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /tini
RUN chmod +x /tini

# Copy code
ARG INSTALL_PATH=/opt/app
WORKDIR $INSTALL_PATH
COPY . $INSTALL_PATH
RUN mkdir log tmp \
    && chown $USER_ID:$GROUP_ID -R $INSTALL_PATH

# Setup app
ARG RAILS_ENV=production
ENV RAILS_ENV $RAILS_ENV
ARG RAILS_SERVER_STATIC_FILES=true
ENV RAILS_SERVE_STATIC_FILES $RAILS_SERVER_STATIC_FILES
ARG SMTP_HOST=aspmx.l.google.com
ENV SMTP_HOST $SMTP_HOST
ARG RAILS_PORT=3000
ENV RAILS_PORT $RAILS_PORT

ENV RAILS_LOG_TO_STDOUT=true
ENV TZ=America/Los_Angeles

USER $USER_ID:$GROUP_ID
RUN gem install bundler -v$(tail -1 Gemfile.lock | sed -e 's/ //g') \
    && gem cleanup bundler \
    && bundle config set --local path 'vendor/bundle' \
    && bundle config set --local without 'development test' \
    && bundle install \
    && bundle exec rails assets:precompile

# Check results
#RUN find . -ls

EXPOSE $RAILS_PORT
ENTRYPOINT ["/tini", "--", "bin/container-entrypoint"]
HEALTHCHECK CMD wget -q -O /dev/null  http://localhost:$RAILS_PORT/ || exit 1
