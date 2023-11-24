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

### Audit code with brakeman

    bundle exec brakeman

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

### Upgrade rails

Here's what I do to upgrade rails.
First, I update ruby.
Then I update the rails gem in-place.
Then I re-create the app from scratch and copy the source files over.

[Rails Upgrade Guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html)

#### Update ruby

```sh
git co -b upgrade_ruby

rbenv install --list
rbenv install {latest}

# update .ruby-version
# remove ruby line from Gemfile
rm Gemfile.lock
bundle install

# Should be 100% coverage
bundle exec rails test:coverage

git add -p
git commit -v
git co master
git merge upgrade_ruby
git push
git branch -d upgrade_ruby
```

#### Update rails gem in-place

```sh
git co -b update_rails

# Update the rails line in Gemfile
rm Gemfile.lock
bundle install

bundle exec rails app:update
# resolve diffs

# Should be 100% coverage
bundle exec rails test:coverage

git add -p
git commit -v
git co master
git merge update_rails
git push
git branch -d update_rails
```

