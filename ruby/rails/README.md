# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Setup:

### Install Ruby 2.5.9
    rbenv install 2.5.9

### Checkout code
    git clone git@github.com:scott-steadman/se-registry.git

### Install bundled gems
    cd se-registry/ruby/rails
    yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-6-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    yum install postgresql12-devel
    bundle config build.pg --with-pg-config=/usr/pgsql-12/bin/pg_config
    bundle install --path vendor/bundle

### Create the development database
    POSTGRES_PASSWORD=changem3 rails db:create db:migrate

### Run the test suite
    POSTGRES_PASSWORD=changem3 rails test

## Common Tasks:

### Run the development server
    rails server -b 0.0.0.0

### Create a controller and test
    rails generate controller <name>

### Create a model, migration, and test
    rails generate model <name> --no-fixture

### Check code coverage
    rails test:coverage
  Output will be in public/coverage

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

