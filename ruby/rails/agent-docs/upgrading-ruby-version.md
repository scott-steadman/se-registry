# How to upgrade to a new version of ruby

- create a branch so we can revert to master if things go awry
- install desired ruby version
- update .ruby-version file
- remove ruby line from Gemfile if present
- remove Gemfile.lock
- run bundle install
- run bundle exec rails test
- fix warnings, deprecations, and broken tests
- change RUBY_VERSION in Dockerfile
- have human review code
- commit changes
- merge into master
- git push master
- delete branch

## Example

  ```sh
  git co -b upgrade_ruby

  rbenv install --list
  rbenv install {latest}

  # update .ruby-version

  # remove ruby line from Gemfile

  rm Gemfile.lock
  bundle install

  bundle exec rails test

  # Change RUBY_VERSION line in Dockerfile

  git add -p
  git commit -v
  git co master
  git merge upgrade_ruby
  git push
  git branch -d upgrade_ruby
  ```