# How to recreate the app

- create a branch so we can revert to master if things go awry
- cd ..
- rename rails to rails-old
- create a gemset called new-rails
- install rails
- create a new version of the app: bundle exec rails new registry --database postgresql --skip-bundle --skip-keeps --skip-git
- move rename the registry to rails
- touch rails/vendor.keep and rails/log/.keep
- copy the old configs and docs over: .bundle, .vscode, agent-docs, README.md, AGENTS.md
- copy credentials files over
- resolve diffs
- run bundle exec rails test
- fix warnings, deprecations, and broken tests (there shouldn't be any)
- have human review code
- commit changes
- merge into master
- git push master
- delete branch
- delete rbenv gemset and remove .rbenv-gemsets

## Why

To ensure that rails files we haven't touched are up to date,
and to remove cruft that accumulates with each upgrade.

## Resolving diffs

Try to keep the new rails boilerplate and put
app-specific updates after the boilerplate if possible.

## Example

  ```sh
  git co -b recreate_app

  # In the same directory as rails
  rbenv local {version}
  mv rails rails-old
  rbenv gemset init new-rails
  gem install rails
  bundle exec rails new registry --database postgresql --skip-bundle --skip-keeps --skip-git
  mv registry rails
  touch rails/vendor/.keep rails/log/.keep

  # copy old bundle config
  mkdir rails/.bundle
  cp rails-old/.bundle/config rails/.bundle

  # copy old vscode config
  mkdir rails/.vscode
  cp rails-old/.vscode/* rails/.vscode

  # copy old credentials
  mkdir rails/config/redentials
  cp rails-old/config/credentials/* rails/config/credentials/

  # git checkout deleted files
  git co `git st | grep deleted | sed -e 's/.*deleted://'`

  # resolve diffs

  rm Gemfile.lock
  bundle config set --local clean 'true'
  bundle config set --local path 'vendor/bundle'
  bundle install

  bundle exec rails test

  git add -p
  git commit -v
  git co master
  git merge recreate_app
  git push
  git branch -d recreate_app
  ```
