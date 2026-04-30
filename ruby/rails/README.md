# Overview

This is the ruby on rails implementation of my gift registry

## Setup

### Install Ruby

```sh
rbenv install <version>
```

### Checkout code

```sh
git clone git@github.com:scott-steadman/se-registry.git
```

### Install bundled gems

```sh
cd se-registry/ruby/rails
yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-6-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install postgresql12-devel
bundle config build.pg --with-pg-config=/usr/pgsql-12/bin/pg_config
bundle install --path vendor/bundle
```

### Setup VSCode

I used [this](https://dev.to/abstractart/easy-way-to-setup-debugger-and-autocomplete-for-ruby-in-visual-studio-code-2gcc)
tutorial to get me started.

```sh
bundle binstubs bundler bundler ruby-debug-ide solargraph --force
```

### Create the development database

```sh
POSTGRES_PASSWORD=changem3 rails db:create db:migrate
```


### Run the test suite

```sh
POSTGRES_PASSWORD=changem3 rails test:coverage
```

## Common Tasks

### Run the development server

```sh
rails server -b 0.0.0.0
```

### Create a controller and test

```sh
rails generate controller <name>
```

### Create a model, migration, and test

```sh
rails generate model <name> --no-fixture
```

### Check code coverage

```sh
# Output will be in public/coverage
rails test:coverage
```

### Audit bundled gems

```sh
bundle exec bundle auit
```

### Audit code with brakeman

```sh
bundle exec brakeman
```

### Annotate model classes

```sh
bundle exec annotate --models --exclude
```

### Deploy to production

```sh
bundle exec cap production deploy (--dry-run)
```

### Create docker image

```sh
bin/docker-build.sh
```

### Inspect docker image

This will run a bash shell in the container.
Enabling you to look around.
```sh
bin/docker-inspect.sh
```


### Start docker image

    This will start the image with RAILS_ENV=development
```sh
bin/docker-run.sh <RAILS_ENV>
```

### Deploy docker image

```sh
bin/docker-deploy.sh
```

### Upgrade rails

First, update ruby.
Then update the rails gem in-place.
Then re-create the app from scratch and copy the source files over.

[Rails Upgrade Guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html)

#### Update ruby
  See agent-docs/upgrading-ruby-version.md

#### Update rails gem in-place
  See agent-docs/update-rails-gem.md

#### Re-create app and copy source over
  See agent-docs/recreate-app.md
