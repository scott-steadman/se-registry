# Overview

This is the ruby on rails implementation of my gift registry

## Setup

### Install Ruby

    rbenv install <version>

### Checkout code

    git clone git@github.com:scott-steadman/se-registry.git

### Install bundled gems

    cd se-registry/ruby/rails
    yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-6-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    yum install postgresql12-devel
    bundle config build.pg --with-pg-config=/usr/pgsql-12/bin/pg_config
    bundle install --path vendor/bundle

### Setup VSCode

I used [this](https://dev.to/abstractart/easy-way-to-setup-debugger-and-autocomplete-for-ruby-in-visual-studio-code-2gcc)
tutorial to get me started.

    bundle binstubs bundler bundler ruby-debug-ide solargraph --force

### Create the development database

    POSTGRES_PASSWORD=changem3 rails db:create db:migrate

### Run the test suite

    POSTGRES_PASSWORD=changem3 rails test:coverage

## Common Tasks

### Upgrading rails

    git co -b rails-x.y
    # update rails version in Gemfile
    bundle update
    bundle exec rails test:coverage
    bundle exec rails app:update
    # check updates
    bundle exec rails test:coverage
    # fix deprecations

### Rebuild from scratch

I like to do this after every in-place upgrade to make sure all the files
I didn't change from rails defaults are changed.

    # in ruby subdirectory
    cleanup-upgrade.sh
    upgrade-rails.sh
    # reconcile files

### Run the development server

    rails server -b 0.0.0.0

### Create a controller and test

    rails generate controller <name>

### Create a model, migration, and test

    rails generate model <name> --no-fixture

### Check code coverage

    rails test:coverage
  Output will be in public/coverage

### Audit bundled gems

    bundle exec bundle auit

### Annotate model classes

    bundle exec annotate --models --exclude

### Deploy to production

    bundle exec cap production deploy (--dry-run)

### Create docker image

    bin/docker-build.sh

### Inspect docker image

    bin/docker-inspect.sh

    This will run a bash shell in the container.
    Enabling you to look around.

### Start docker image

    bin/docker-run.sh <RAILS_ENV>

    This will start the image with RAILS_ENV=development

### Deploy docker image

    bin/docker-deploy.sh
